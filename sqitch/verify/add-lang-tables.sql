-- Verify prc:add-lang-tables on sqlite

BEGIN;

SELECT
  lang_id,
  lang_name,
  create_time,
  update_time,

  gone_missing
FROM lang
WHERE 0;

SELECT
  user_lang_id,
  user_id,
  lang_id,
  create_time,
  update_time
FROM user_lang
WHERE 0;

ROLLBACK;
