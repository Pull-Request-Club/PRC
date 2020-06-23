-- Revert prc:add-emails-1 from sqlite

BEGIN;

DELETE FROM email WHERE email_name in (
  'new-assignment',
  'new-assignee',
  'open-reminder',
  'new-feature'
);

COMMIT;
