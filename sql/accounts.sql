-- ----------------------------
-- Logins
-- ----------------------------

DROP TABLE IF EXISTS "accounts"."logins";
CREATE TABLE "accounts"."logins" (
"id" int4 NOT NULL,
"email" varchar(255) COLLATE "default" NOT NULL,
"password" varchar(255) COLLATE "default" NOT NULL,
"reg_time" timestamp(6) DEFAULT now(),
"login_time" timestamp(6),
PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

CREATE UNIQUE INDEX "email_unique" ON "accounts"."logins" USING btree (email) WHERE reg_time IS NOT NULL;

DROP SEQUENCE IF EXISTS "accounts"."logins_id_seq";
CREATE SEQUENCE "accounts"."logins_id_seq"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 1
 CACHE 1
 OWNED BY "logins"."id";

ALTER TABLE "accounts"."logins"
ALTER COLUMN id SET DEFAULT nextval('"accounts".logins_id_seq'::regclass);

-- ----------------------------
-- Wallets
-- ----------------------------
DROP TABLE IF EXISTS "accounts"."wallets";
CREATE TABLE "accounts"."wallets" (
"id" int4 NOT NULL,
"owner" int4 NOT NULL,
"currency" int4 NOT NULL,
"amount" "public"."coin" DEFAULT 0 NOT NULL,
PRIMARY KEY ("id"),

FOREIGN KEY ("owner") REFERENCES "accounts"."logins" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
FOREIGN KEY ("currency") REFERENCES "orders"."currency" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT,

CONSTRAINT "wallet_positive" CHECK ((amount)::numeric >= (0)::numeric)
)
WITH (OIDS=FALSE)
;

CREATE UNIQUE INDEX "search_index" ON "accounts"."wallets" USING btree (owner, currency);
ALTER TABLE "accounts"."wallets" CLUSTER ON "search_index";

DROP SEQUENCE IF EXISTS "accounts"."wallets_id_seq";
CREATE SEQUENCE "accounts"."wallets_id_seq"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 1
 CACHE 1
 OWNED BY "wallets"."id";

ALTER TABLE "accounts"."wallets"
ALTER COLUMN id SET DEFAULT nextval('"accounts".wallets_id_seq'::regclass);

-- ----------------------------
-- Invoice log
-- ----------------------------

CREATE TABLE "accounts"."receipt" (
"id" int8 NOT NULL,
"wallet" int4 NOT NULL,
"amount" "public"."bitcoin" NOT NULL,
"snap" timestamp(6) DEFAULT now() NOT NULL,
"comment" varchar(255) COLLATE "default",
"status" "public"."invoice_status",
"transaction" int8,
CONSTRAINT "invoice_pkey" PRIMARY KEY ("id"),
CONSTRAINT "invoice_wallet_fkey" FOREIGN KEY ("wallet") REFERENCES "accounts"."wallets" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
CONSTRAINT "invoice_transaction_fkey" FOREIGN KEY ("transaction") REFERENCES "orders"."transactions" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT
)
WITH (OIDS=FALSE)
;

DROP SEQUENCE IF EXISTS "accounts"."receipt_id_seq";
CREATE SEQUENCE "accounts"."receipt_id_seq"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 1
 CACHE 1
 OWNED BY "receipt"."id";

ALTER TABLE "accounts"."receipt"
ALTER COLUMN id SET DEFAULT nextval('"accounts".receipt_id_seq'::regclass);


