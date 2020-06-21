-- Revert prc:add-email-tables from sqlite

BEGIN;

DROP TABLE IF EXISTS email;
DROP TABLE IF EXISTS user_email_opt_in;

COMMIT;
