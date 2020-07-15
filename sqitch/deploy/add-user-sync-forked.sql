-- Deploy prc:add-user-sync-forked to sqlite

BEGIN;

-- Create a backup table
CREATE TEMPORARY TABLE user_backup (
  user_id                      INTEGER PRIMARY KEY,
  create_time                  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_time                  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  last_login_time              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_personal_repo_sync_time DATETIME DEFAULT NULL,
  last_org_repo_sync_time      DATETIME DEFAULT NULL,

  tos_agree_time               DATETIME DEFAULT NULL,
  tos_agreed_version           DATETIME DEFAULT NULL,
  scheduled_delete_time        DATETIME DEFAULT NULL,
  is_deactivated               BOOLEAN NOT NULL DEFAULT 0,
  is_receiving_assignments     BOOLEAN NOT NULL DEFAULT 0,

  github_id                    INTEGER NOT NULL,
  github_login                 VARCHAR(128) NOT NULL,
  github_email                 VARCHAR(256) NOT NULL,
  github_profile               VARCHAR(256) NOT NULL,
  github_token                 VARCHAR(256) DEFAULT NULL
);

-- Copy data from old table to backup table
INSERT INTO user_backup
    SELECT
        user_id,
        create_time,
        update_time,

        last_login_time,
        last_personal_repo_sync_time,
        last_org_repo_sync_time,

        tos_agree_time,
        tos_agreed_version,
        scheduled_delete_time,
        is_deactivated,
        is_receiving_assignments,

        github_id,
        github_login,
        github_email,
        github_profile,
        github_token
    FROM user
;

-- Drop old table
DROP TABLE user;

-- Create new table
CREATE TABLE user (
  user_id                      INTEGER PRIMARY KEY,
  create_time                  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_time                  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  last_login_time              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_personal_repo_sync_time DATETIME DEFAULT NULL,
  last_org_repo_sync_time      DATETIME DEFAULT NULL,

  tos_agree_time               DATETIME DEFAULT NULL,
  tos_agreed_version           DATETIME DEFAULT NULL,
  scheduled_delete_time        DATETIME DEFAULT NULL,
  is_deactivated               BOOLEAN NOT NULL DEFAULT 0,

  is_receiving_assignments     BOOLEAN NOT NULL DEFAULT 0,
  is_syncing_forked_repos      BOOLEAN NOT NULL DEFAULT 0,

  github_id                    INTEGER NOT NULL,
  github_login                 VARCHAR(128) NOT NULL,
  github_email                 VARCHAR(256) NOT NULL,
  github_profile               VARCHAR(256) NOT NULL,
  github_token                 VARCHAR(256) DEFAULT NULL
);

-- Copy data from backup table to new table
INSERT INTO user
    SELECT
        user_id,
        create_time,
        update_time,

        last_login_time,
        last_personal_repo_sync_time,
        last_org_repo_sync_time,

        tos_agree_time,
        tos_agreed_version,
        scheduled_delete_time,
        is_deactivated,

        is_receiving_assignments,
        0,

        github_id,
        github_login,
        github_email,
        github_profile,
        github_token
    FROM user_backup
;

-- Drop backup table
DROP TABLE user_backup;

COMMIT;
