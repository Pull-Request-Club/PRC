-- Revert prc:repo-add-drop-cols from sqlite

BEGIN;

-- Create a backup table
CREATE TEMPORARY TABLE repo_backup (
  repo_id                  INTEGER PRIMARY KEY,
  user_id                  INTEGER NOT NULL,
  org_id                   INTEGER DEFAULT NULL,
  create_time              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_time              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  gone_missing             BOOLEAN NOT NULL DEFAULT 0,
  accepting_assignees      BOOLEAN NOT NULL DEFAULT 0,

  github_id                INTEGER NOT NULL,
  github_name              VARCHAR(256) NOT NULL,
  github_full_name         VARCHAR(256) NOT NULL,
  github_language          VARCHAR(256) DEFAULT NULL,
  github_is_fork           BOOLEAN NOT NULL DEFAULT 0,
  github_html_url          VARCHAR(512) NOT NULL,
  github_events_url        VARCHAR(512) NOT NULL,
  github_open_issues_count INTEGER NOT NULL DEFAULT 0,
  github_stargazers_count  INTEGER NOT NULL DEFAULT 0,
  github_forks_count       INTEGER NOT NULL DEFAULT 0,

  FOREIGN KEY(user_id) REFERENCES user(user_id),
  FOREIGN KEY(org_id) REFERENCES org(org_id)
);

-- Copy data from new table to backup table
INSERT INTO repo_backup
    SELECT
        repo_id,
        user_id,
        org_id,
        create_time,
        update_time,

        gone_missing,
        accepting_assignees,

        github_id,
        github_name,
        github_full_name,
        github_language,
        github_is_fork,
        github_html_url,
        github_events_url,
        github_open_issues_count,
        github_stargazers_count,
        github_forks_count
    FROM repo
;

-- Drop new table
DROP TABLE repo;

-- Create old table
CREATE TABLE repo (
  repo_id                  INTEGER PRIMARY KEY,
  user_id                  INTEGER NOT NULL,
  org_id                   INTEGER DEFAULT NULL,
  create_time              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_time              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  gone_missing             BOOLEAN NOT NULL DEFAULT 0,
  accepting_assignees      BOOLEAN NOT NULL DEFAULT 0,

  github_id                INTEGER NOT NULL,
  github_name              VARCHAR(256) NOT NULL,
  github_full_name         VARCHAR(256) NOT NULL,
  github_language          VARCHAR(256) DEFAULT NULL,
  github_html_url          VARCHAR(512) NOT NULL,
  github_pulls_url         VARCHAR(512) NOT NULL,
  github_events_url        VARCHAR(512) NOT NULL,
  github_issues_url        VARCHAR(512) NOT NULL,
  github_issue_events_url  VARCHAR(512) NOT NULL,
  github_open_issues_count INTEGER NOT NULL DEFAULT 0,
  github_stargazers_count  INTEGER NOT NULL DEFAULT 0,

  FOREIGN KEY(user_id) REFERENCES user(user_id),
  FOREIGN KEY(org_id) REFERENCES org(org_id)
);


-- Copy data from backup table to old table
INSERT INTO repo
    SELECT
        repo_id,
        user_id,
        org_id,
        create_time,
        update_time,

        gone_missing,
        accepting_assignees,

        github_id,
        github_name,
        github_full_name,
        github_language,
        github_html_url,
        '',
        github_events_url,
        '',
        '',
        github_open_issues_count,
        github_stargazers_count
    FROM repo_backup
;

-- Drop backup table
DROP TABLE repo_backup;

COMMIT;
