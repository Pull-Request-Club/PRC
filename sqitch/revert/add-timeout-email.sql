-- Revert prc:add-timeout-email from sqlite

BEGIN;

DELETE FROM email WHERE email_name in (
  'timeout'
);

COMMIT;
