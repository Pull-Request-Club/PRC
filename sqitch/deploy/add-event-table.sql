-- Deploy prc:add-event-table to sqlite

BEGIN;

CREATE TABLE IF NOT EXISTS event (
  event_id            INTEGER PRIMARY KEY,
  user_id             INTEGER DEFAULT 0,
  create_time         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  event_string        VARCHAR(128) NOT NULL
);

COMMIT;
