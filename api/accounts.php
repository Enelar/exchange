<?php

class accounts extends api
{
  protected function GetAccounts( )
  {
  }
  
  protected function GetWalletId( $currency )
  {
    // todo return $this->GetWallet($login->UID(), $currency);
  }
  
  public function GetWallet( $uid, $currency, $force = true )
  {
    include('wallet.php');
    $res = db::Query("SELECT id FROM accounts.wallets WHERE uid=$1 AND currency=$2",
      [$uid, $currency], true);
    if (count($res))
      return new wallet($res['id']);

    phoxy_protected_assert($force, ["error" => "Wallet didnt exsist"]);
    return $this->CreateWallet($uid, $currency);
  }
  
  private function CreateWallet( $uid, $currency )
  {
    include('wallet.php');
    $res = db::Query("
      INSERT INTO accounts.wallets
      (uid, currency)
      VALUES
      ($1, $2)
      RETURNING id",
      [$uid, $currency],
      true);
    phoxy_protected_assert(count($res), "Error at wallet create. Maybe already exsist?");
    return new wallet($res['id']);
  }
}
