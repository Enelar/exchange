CREATE SCHEMA orders;

CREATE DOMAIN public.coin AS decimal(20, 10);

CREATE TYPE public.bitcoin AS
(
  currency int4,
  amount  coin
);

CREATE SCHEMA accounts;

CREATE TYPE public.invoice_status AS ENUM
(
  'LOCK'
  ,
  'UNLOCK'
  ,
  'CONVERT'
  ,
  'WITHDRAW'
  ,
  'DEPOSIT'
);

-- Execute orders.sql
-- Execute accounts.sql
