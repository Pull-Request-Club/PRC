-- Verify prc:add-lang-tables on sqlite

BEGIN;

SELECT
  email_id,
  email_name,
  email_description,
  create_time,
  update_time
FROM email
WHERE 0;

SELECT
  user_email_opt_in_id,
  user_id,
  email_id,
  create_time,
  update_time
FROM user_email_opt_in
WHERE 0;

ROLLBACK;
