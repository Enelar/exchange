<?php

class orders extends api
{
  protected function Buy( $from, $to, $amount, $price )
  {
    $this->PreorderConstraits($from, $to, $amount, $price);
    return $this->Add($from, $to, $amount, $price, true);
  }
  
  protected function Sell( $from, $to, $amount, $price )
  {
    $this->PreorderConstraits($from, $to, $amount, $price);
    return $this->Add($from, $to, $amount, 1 / $price, false);
  }
  
  private function PreorderConstraits( $from, $to, $amount, $price )
  {
    phoxy_protected_assert($price > 0, ["error" => "Price should be positive"]);
    phoxy_protected_assert($amount > 0, ["error" => "Amount should be positive"]);
    phoxy_protected_assert($from != $to, ["error" => "Currency could not be equal"]);
  }
  
  private function Add( $from, $to, $amount, $price, $is_buy )
  {
    $res =
      db::Query("INSERT INTO orders.orders
      (is_buy, currency, amount, remain, price)
      VALUES
      ($1, $2, $3, $3, ROW($4, $5))
      RETURNING id",
      [$is_buy, $from, $amount, $to, $price],
      true);
    return ["data" => ["order_id" => $res['id']]];
  }
  
  protected function Cancel( $id )
  {
    db::Query("DELETE FROM orders.orders WHERE id=$1", [$id]);
  }
}
