-- Deploy prc:add-email-log to sqlite

BEGIN;

CREATE TABLE IF NOT EXISTS email_log (
  email_log_id          INTEGER PRIMARY KEY,
  user_id               INTEGER NOT NULL,
  email_id              INTEGER NOT NULL,
  assignment_id         INTEGER DEFAULT NULL,
  create_time           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(user_id)  REFERENCES user(user_id),
  FOREIGN KEY(email_id) REFERENCES email(email_id),
  FOREIGN KEY(assignment_id) REFERENCES assignment(assignment_id)
);

COMMIT;