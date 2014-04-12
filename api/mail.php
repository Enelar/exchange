<?php

class mail extends api
{
  public function Send( $to, $from, $title, $body, $reply_to = NULL )
  {
    if ($reply_to == NULL)
      $reply_to = $from;

    $res =
      db::Query("INSERT INTO mail.send_tasks
      (\"to\", \"from\", \"reply\", subj, body)
      VALUES
      ($1, $2, $3, $4, $5) RETURNING id",
      [$to, $from, $reply_to, $title, $body], true);
    if (!$res)
      return false;
    return $res['id'];
  }
}

