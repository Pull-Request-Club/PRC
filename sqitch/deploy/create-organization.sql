-- Deploy prc:create-organization to sqlite

BEGIN;

CREATE TABLE IF NOT EXISTS organization (
  organization_id        INTEGER PRIMARY KEY,
  create_time            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_time            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by_user_id     INTEGER NOT NULL,

  github_id              INTEGER NOT NULL,
  github_login           VARCHAR(128) NOT NULL,
  github_profile         VARCHAR(256) NOT NULL,

  FOREIGN KEY(created_by_user_id) REFERENCES user(user_id)
);

CREATE TABLE IF NOT EXISTS user_in_organization (
  user_in_organization_id INTEGER PRIMARY KEY,
  user_id                 INTEGER NOT NULL,
  organization_id         INTEGER NOT NULL,
  create_time             DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_time             DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  gone_missing            BOOLEAN NOT NULL DEFAULT 0,
  fetch_repos             BOOLEAN NOT NULL DEFAULT 0,

  FOREIGN KEY(user_id) REFERENCES user(user_id),
  FOREIGN KEY(organization_id) REFERENCES organization(organization_id)
);

COMMIT;
