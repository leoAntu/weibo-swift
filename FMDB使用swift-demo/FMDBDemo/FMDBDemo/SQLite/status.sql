CREATE TABLE IF NOT EXISTS "t_status" (
"statusId" integer,
"userId" integer,
"status" text,
PRIMARY KEY ("statusId", "userId")
);
