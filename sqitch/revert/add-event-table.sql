-- Revert prc:add-event-table from sqlite

BEGIN;

DROP TABLE IF EXISTS event;

COMMIT;
