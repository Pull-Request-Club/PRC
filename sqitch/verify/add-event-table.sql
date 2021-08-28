-- Verify prc:add-event-table on sqlite

BEGIN;

SELECT
  event_id,
  user_id,
  create_time,
  event_string
FROM event
WHERE 0;

ROLLBACK;
