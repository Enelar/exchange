<?php

class login extends api
{
  private static $logout_status = -1;
  
  private function SessionAccess()
  {
    if (session_status() == PHP_SESSION_ACTIVE)
      session_start();
    global $_SESSION;
    return $_SESSION;
  }

  public function IsLogined()
  {
    $_SESSION = $this->SessionAccess();

    return isset($_SESSION['uid']) && $_SESSION['uid'] != self::$logout_status;
  }

  public function UID()
  {
    phoxy_protected_assert($this->IsLogined());
    return $this->SessionAccess()['uid'];
  }
  
  public function MakeLogin( $uid )
  {
    $this->SessionAccess();
    global $_SESSION;
    return $_SESSION['uid'] = $uid;
  }
  
  public function MakeLogOut()
  {
    return $this->MakeLogin(-1);
  }
  
  protected function Login( $email, $password )
  {
    $res = db::Query("SELECT id as uid FROM accounts.logins WHERE email=$1 AND password=$2",
      [$email, $password], true);
    if (!$res)
      return false;
    $this->MakeLogin($res['uid']);
    return $res;
  }
  
  protected function Logout()
  {
    $this->MakeLogout();
    return ["uid" => self::$logout_status];
  }
  
  protected function Register()
  {
    global $_POST;

    $email = $_POST['email'];
    phoxy_protected_assert(strlen($email), ["error" => "Empty email."]);
    $email_hash = password_hash($email, PASSWORD_DEFAULT);
    $email_validation_hash = password_hash($email_hash, PASSWORD_DEFAULT);
    $hash = password_hash($_POST['password'], PASSWORD_DEFAULT);
    phoxy_protected_assert($hash, ["error" => "Password secure store failed."]);

    $found = count(db::Query("SELECT * FROM users.logins WHERE email=$1", [$email]));
    phoxy_protected_assert(!$found, ["error" => "User already exsists."]);

    $arg = [$email_hash, $hash];

    $row = db::Query("
    INSERT INTO 
      accounts.logins
      (email, password)
    VALUES
      ($1, $2)
      RETURNING id",
      $arg, true);

    phoxy_protected_assert(count($row), ["error" => "Record save failed."]);

    $accept_url = phoxy_conf()['site']."#login/ValidateEmail?id={$row['id']}&email={$email}&back={$_POST['back_url']}&hash={$email_validation_hash}";
    $decline_url = phoxy_conf()['site']."#login/CancelRegistration?id={$row['id']}&email={$email}&back={$_POST['back_url']}&hash={$email_validation_hash}";

    global $_SERVER;
    $site = $_SERVER['HTTP_HOST'];
    
    LoadModule('api', 'mail')->Send(
      $email,
      "Registration Guy <regbot@{$site}>",
      "Registration {$site}",
      "Thanks for registration.
Sorry for extremly ugliness, but here two links.

This one for activation:
{$accept_url}
And this will cancel registation:
{$decline_url}

What will you choose?

{$site} Team.
      ",
      "Support Team {$site} <support@{$site}>"
      );
  }

  public function AppproveEmailAccess( $id, $hash )
  {
    $row = db::Query("SELECT * FROM accounts.logins WHERE id=$1", [$id], true);
    phoxy_protected_assert($row, ["error" => "Record not found", "reset" => "/#"]);
    $email_hash = $row['email'];
    phoxy_protected_assert(
      password_verify($email_hash, $hash), 
      ["reset" => "/#", "error" => "Already confirmed or anything went wrong. Record not found"]);
    return true;
  }
  
  protected function CancelRegistration( $id, $email, $back_url, $hash )
  {
    $this->AppproveEmailAccess($id, $hash);
    db::Query("DELETE FROM accounts.logins WHERE id=$1", [$id]);
    return ["error" => "Registration success canceled", "reset" => '/#'];
  }
  
  protected function ValidateEmail( $id, $email, $back_url, $hash )
  {
    $this->AppproveEmailAccess($id, $hash);
    db::Query("UPDATE accounts.logins SET email=$2 WHERE id=$1", [$id, $email]);
    
    $this->MakeLogin($id);
    
    return ["reset" => "#".$back_url];
  }
}
