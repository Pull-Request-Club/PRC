-- Revert prc:add-email-log from sqlite

BEGIN;

DROP TABLE IF EXISTS email_log;

COMMIT;