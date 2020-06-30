-- Verify prc:add-email-log on sqlite

BEGIN;

SELECT
  email_log_id,
  user_id,
  email_id,
  assignment_id
  create_time
FROM email_log
WHERE 0;

ROLLBACK;