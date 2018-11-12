CREATE TABLE IF NOT EXISTS user (
  user_id                INTEGER PRIMARY KEY,
  create_time            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_time            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  last_login_time        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  tos_agree_time         DATETIME DEFAULT NULL,
  tos_agreed_version     DATETIME DEFAULT NULL,
  scheduled_delete_time  DATETIME DEFAULT NULL,
  is_deactivated         BOOLEAN NOT NULL DEFAULT 0,
  assignment_level       INTEGER NOT NULL DEFAULT 0,
  assignee_level         INTEGER NOT NULL DEFAULT 0,

  github_id              INTEGER NOT NULL,
  github_login           VARCHAR(128) NOT NULL,
  github_email           VARCHAR(256) NOT NULL,
  github_profile         VARCHAR(256) NOT NULL,
  github_token           VARCHAR(256) DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS repo (
  repo_id                  INTEGER PRIMARY KEY,
  user_id                  INTEGER NOT NULL,
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

  FOREIGN KEY(user_id) REFERENCES user(user_id)
);
