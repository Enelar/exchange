<?php

// REFACTOR, that should be in core
class wallet
{
  private $wid;
  
  public function __construct( $wallet_id )
  {
    $this->wid = $wallet_id;
  }
  
  public function Lock( $amount, $transaction )
  {
    $tr = db::Begin();
    $ret = $this->Invoice('LOCK', $amount, $transaction);
    $tr->Commit();
    return $ret;
  }
  
  public function Unlock( $amount, $transaction )
  {
    return $this->Invoice('UNLOCK', $amount, $transaction);
  }
  
  public function Convert( $amount, $transaction )
  {
    return $this->Invoice('CONVERT', $amount, $transaction);
    
  }
  
  public function Deposit( $amount, $transaction )
  {
    return $this->Invoice('DEPOSIT', $amount, $transaction);
  }
  
  public function Withdraw( $amount, $transaction )
  {
    return $this->Invoice('WITHDRAW', $amount, $transaction);
  }  
    
  private function Invoice( $action, $amount, $transaction )
  {
    phoxy_protected_assert(!is_null($transaction), ["error" => "Unsafe money operation: transaction didnt stored"]);
    $res =
      db::Query("INSERT INTO accounts.receipt
      (wallet, amount, transaction, status)
      VALUES
      ($1, $2, $3, $4)
      RETURNING id",
      [$this->wid, $amount, $transaction, $action], true);
    phoxy_protected_assert(count($res), ["error" => "Invoice receipt store fault"]);
    return $res['id'];
  }
  
  private function Action( $action, $amount, $comment = '' )
  {
    proxy_protected_assert(false, ["error" => "TODO"]);
  }
}
