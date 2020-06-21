-- Deploy prc:add-email-tables to sqlite

BEGIN;

CREATE TABLE IF NOT EXISTS email (
  email_id              INTEGER PRIMARY KEY,
  email_name            VARCHAR(128) NOT NULL,
  email_description     VARCHAR(256) NOT NULL,

  create_time           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_time           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS user_email_opt_in (
  user_email_opt_in_id  INTEGER PRIMARY KEY,
  user_id               INTEGER NOT NULL,
  email_id              INTEGER NOT NULL,

  create_time           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_time           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY(user_id)  REFERENCES user(user_id),
  FOREIGN KEY(email_id) REFERENCES email(email_id)
);

COMMIT;
