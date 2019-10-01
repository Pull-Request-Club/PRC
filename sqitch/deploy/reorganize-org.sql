-- Deploy prc:reorganize-org to sqlite

BEGIN;

DROP TABLE IF EXISTS organization;
DROP TABLE IF EXISTS user_in_organization;

CREATE TABLE IF NOT EXISTS org (
  org_id              INTEGER PRIMARY KEY,
  user_id             INTEGER NOT NULL,
  create_time         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_time         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  gone_missing        BOOLEAN NOT NULL DEFAULT 0,
  is_fetching_repos   BOOLEAN NOT NULL DEFAULT 0,

  github_id           INTEGER NOT NULL,
  github_login        VARCHAR(128) NOT NULL,
  github_profile      VARCHAR(256) NOT NULL,

  FOREIGN KEY(user_id) REFERENCES user(user_id)
);

COMMIT;
