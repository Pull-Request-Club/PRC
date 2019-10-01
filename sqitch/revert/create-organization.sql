-- Revert prc:create-organization from sqlite

BEGIN;

DROP TABLE IF EXISTS organization;
DROP TABLE IF EXISTS user_in_organization;

COMMIT;
