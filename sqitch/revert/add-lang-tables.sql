-- Revert prc:add-lang-tables from sqlite

BEGIN;

DROP TABLE IF EXISTS lang;
DROP TABLE IF EXISTS user_lang;

COMMIT;
