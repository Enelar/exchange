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
