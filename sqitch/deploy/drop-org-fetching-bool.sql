-- Deploy prc:drop-org-fetching-bool to sqlite

BEGIN;

-- Create a backup table
CREATE TEMPORARY TABLE org_backup (
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

-- Copy data from old table to backup table
INSERT INTO org_backup
  SELECT
    org_id,
    user_id,
    create_time,
    update_time,

    gone_missing,
    is_fetching_repos,

    github_id,
    github_login,
    github_profile
  FROM org
;

-- Drop old table
DROP TABLE org;

-- Create new table
CREATE TABLE org (
  org_id              INTEGER PRIMARY KEY,
  user_id             INTEGER NOT NULL,
  create_time         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_time         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  gone_missing        BOOLEAN NOT NULL DEFAULT 0,

  github_id           INTEGER NOT NULL,
  github_login        VARCHAR(128) NOT NULL,
  github_profile      VARCHAR(256) NOT NULL,

  FOREIGN KEY(user_id) REFERENCES user(user_id)
);

-- Copy data from backup table to new table
INSERT INTO org
  SELECT
    org_id,
    user_id,
    create_time,
    update_time,

    gone_missing,

    github_id,
    github_login,
    github_profile
  FROM org_backup
;

-- Drop backup table
DROP TABLE org_backup;

COMMIT;
