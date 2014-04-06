CREATE SCHEMA orders;

CREATE DOMAIN public.coin AS decimal(20, 10);

CREATE TYPE public.bitcoin AS
(
  currency int4,
  amount  coin
);

CREATE SCHEMA accounts;

-- Execute orders.sql
-- Execute accounts.sql
