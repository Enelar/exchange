-- ----------------------------
-- Currencies
-- ----------------------------

DROP SEQUENCE IF EXISTS "orders"."currency_id_seq";
CREATE SEQUENCE "orders"."currency_id_seq"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 1
 CACHE 1;

DROP TABLE IF EXISTS "orders"."currency";
CREATE TABLE "orders"."currency" (
"id" int4 DEFAULT nextval('"orders".currency_id_seq'::regclass) NOT NULL,
"name" varchar(255) COLLATE "default" NOT NULL,
"code" varchar(255) COLLATE "default" NOT NULL,
"site" varchar(255) COLLATE "default"
)
WITH (OIDS=FALSE)
;

ALTER SEQUENCE "orders"."currency_id_seq" OWNED BY "currency"."id";
CREATE UNIQUE INDEX "currency_code_idx" ON "orders"."currency" USING btree (code);
CREATE UNIQUE INDEX "currency_id_idx" ON "orders"."currency" USING btree (id);
ALTER TABLE "orders"."currency" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Orders
-- ----------------------------


DROP SEQUENCE IF EXISTS "orders"."orders_id_seq";
CREATE SEQUENCE "orders"."orders_id_seq"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 1
 CACHE 1;


DROP TABLE IF EXISTS "orders"."orders";
CREATE TABLE "orders"."orders" (
"id" int8 DEFAULT nextval('"orders".orders_id_seq'::regclass) NOT NULL,
"is_buy" bool DEFAULT true NOT NULL,
"currency" int4,
"amount" "public"."coin" NOT NULL,
"remain" "public"."coin" NOT NULL,
"appear" timestamp(6) DEFAULT now() NOT NULL,
"price" "public"."coin" NOT NULL
CONSTRAINT "orders_remain_check" CHECK ((remain)::numeric <= (amount)::numeric),
CONSTRAINT "orders_check" CHECK ((remain)::numeric >= (0)::numeric),
CONSTRAINT "orders_amount_check" CHECK ((amount)::numeric > (0)::numeric)
)
WITH (OIDS=FALSE)
;

ALTER TABLE "orders"."orders" ADD FOREIGN KEY ("currency") REFERENCES "orders"."currency" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

CREATE INDEX "active_buy_orders" ON "orders"."orders" USING btree (currency, appear, price DESC) WHERE is_buy = true;
CREATE INDEX "active_sell_orders" ON "orders"."orders" USING btree (appear, currency, price) WHERE is_buy = false;
CREATE INDEX "orders_appear_idx" ON "orders"."orders" USING btree (appear, currency);

ALTER SEQUENCE "orders"."orders_id_seq" OWNED BY "orders"."id";
ALTER TABLE "orders"."orders" ADD UNIQUE ("id");
ALTER TABLE "orders"."orders" ADD PRIMARY KEY ("id");

-- -----------------
-- Order views
-- -----------------


CREATE OR REPLACE VIEW "orders"."active_buy" AS 
 SELECT orders.id,
    orders.is_buy,
    orders.currency,
    orders.amount,
    orders.remain,
    orders.appear,
    orders.price
   FROM orders.orders
  WHERE ((orders.is_buy = true) AND ((orders.remain)::numeric > (0)::numeric))
  ORDER BY orders.price DESC;

CREATE OR REPLACE VIEW "orders"."active_sell" AS 
 SELECT orders.id,
    orders.is_buy,
    orders.currency,
    orders.amount,
    orders.remain,
    orders.appear,
    orders.price
   FROM orders.orders
  WHERE ((orders.is_buy = false) AND ((orders.remain)::numeric > (0)::numeric))
  ORDER BY orders.price DESC;
  
-- ----------------------------
-- Transactions
-- ----------------------------

CREATE TABLE "orders"."transactions"
(
  "id" int8 NOT NULL,
  "donor" int4,
  "donor_money" bitcoin NOT NULL,
  "price" coin NOT NULL,
  "recipient" int4 NOT NULL,
  "recipient_money" bitcoin,
  PRIMARY KEY ("id"),

  CONSTRAINT "amounts_positive" 
    CHECK
    (
      (donor_money).amount > 0 AND
      (recipient_money).amount > 0
    ),
  CONSTRAINT "withdraw_or_replanisment_check" 
    CHECK
    (
      donor != recipient OR 
      (
        (
          (donor_money).currency = 0 OR 
          (recipient_money).currency = 0
        ) 
        AND
        (donor_money).amount = (recipient_money).amount
        AND price = 1
      )
    ),
  CONSTRAINT "forbid_gifts"
    CHECK
    (
      donor = recipient OR
      (donor_money).currency != (recipient_money).currency
    ),
  CONSTRAINT "foreign_transactions"
    CHECK
    (
      donor = recipient OR 
      (donor_money).currency != (recipient_money).currency
    )
)
WITH (OIDS=FALSE)
;

DROP SEQUENCE IF EXISTS "orders"."transactions_id_seq";
CREATE SEQUENCE "orders"."transactions_id_seq"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 1
 CACHE 1
 OWNED BY "transactions"."id";

ALTER TABLE "orders"."transactions"
ALTER COLUMN id SET DEFAULT nextval('"orders".transactions_id_seq'::regclass);
