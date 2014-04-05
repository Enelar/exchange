<?php

function phoxy_conf()
{
  $ret = phoxy_default_conf();
  $ret['global_cache'] = null;
  return $ret;
}

include_once('phoxy/index.php');
