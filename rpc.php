<?php

error_reporting(E_ALL); ini_set('display_errors', 1);

function phoxy_conf()
{
  $ret = phoxy_default_conf();
  $ret['global_cache'] = null;
  return $ret;
}

include_once('phoxy/index.php');
