CREATE TABLE IF NOT EXISTS user(
  user_id                INTEGER PRIMARY KEY,
  create_time            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_time            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_login_time        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  tos_agree_time         DATETIME DEFAULT NULL,
  tos_agreed_version     DATETIME DEFAULT NULL,
  scheduled_delete_time  DATETIME DEFAULT NULL,
  is_deactivated         BOOLEAN NOT NULL DEFAULT 0,
  github_id              INTEGER NOT NULL,
  github_login           VARCHAR(128) NOT NULL,
  github_email           VARCHAR(256) NOT NULL,
  github_profile         VARCHAR(256) NOT NULL,
  github_token           VARCHAR(256) DEFAULT NULL
);
