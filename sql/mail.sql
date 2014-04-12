-- ----------------------------
-- SendTasks
-- ----------------------------
DROP TABLE IF EXISTS "mail"."send_tasks";
CREATE TABLE "mail"."send_tasks" (
"id" int4 NOT NULL,
"to" varchar(255) COLLATE "default" NOT NULL,
"subj" varchar(255) COLLATE "default" NOT NULL,
"body" text COLLATE "default" NOT NULL,
"from" varchar(255) COLLATE "default" NOT NULL,
"reply" varchar(255) COLLATE "default",
"headers" varchar(255) COLLATE "default",
"appeared" timestamp(6) DEFAULT now() NOT NULL,
"sended" timestamp(6),
PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

DROP SEQUENCE IF EXISTS "mail"."send_tasks_id_seq";
CREATE SEQUENCE "mail"."send_tasks_id_seq"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 1
 CACHE 1
 OWNED BY "send_tasks"."id";

ALTER TABLE "mail"."send_tasks"
ALTER COLUMN id SET DEFAULT nextval('"mail".send_tasks_id_seq'::regclass);
