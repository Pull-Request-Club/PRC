-- Deploy prc:add-timeout-email to sqlite

BEGIN;

INSERT INTO email (email_id, email_name, email_description) VALUES

(5, 'timeout','Sent when your open assignment times out.');

COMMIT;
