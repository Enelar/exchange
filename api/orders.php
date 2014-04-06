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
    phoxy_protected_assert(0, ["error" => "TODO: Add order"]);
  }
}
