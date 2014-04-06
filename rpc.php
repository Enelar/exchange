<?php

error_reporting(E_ALL); ini_set('display_errors', 1);

include_once('pgsql_php/connect.php');
new db("dbname=exchange host=localhost user=postgres");

function phoxy_conf()
{
  $ret = phoxy_default_conf();
  $ret['global_cache'] = null;
  return $ret;
}

include_once('phoxy/index.php');
