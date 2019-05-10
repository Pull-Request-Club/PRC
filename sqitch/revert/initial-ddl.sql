-- Revert prc:initial-ddl from sqlite

BEGIN;

DROP TABLE IF EXISTS assignment;
DROP TABLE IF EXISTS repo;
DROP TABLE IF EXISTS user;

COMMIT;
