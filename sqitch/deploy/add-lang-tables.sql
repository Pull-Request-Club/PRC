-- Deploy prc:add-lang-tables to sqlite

BEGIN;

CREATE TABLE IF NOT EXISTS lang (
  lang_id             INTEGER PRIMARY KEY,
  lang_name           INTEGER NOT NULL,
  create_time         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_time         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  gone_missing        BOOLEAN NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS user_lang (
  user_lang_id        INTEGER PRIMARY KEY,
  user_id             INTEGER NOT NULL,
  lang_id             INTEGER NOT NULL,
  create_time         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_time         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY(user_id) REFERENCES user(user_id),
  FOREIGN KEY(lang_id) REFERENCES lang(lang_id)
);

COMMIT;
