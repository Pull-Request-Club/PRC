PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS user(
  id            INTEGER PRIMARY KEY,
  create_time   DATETIME  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_time   DATETIME  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  name          VARCHAR(255),
  email_address VARCHAR(255)
);

CREATE TRIGGER [UpdateLastTime]
  AFTER UPDATE ON user FOR EACH ROW WHEN NEW.update_time <= OLD.update_time
BEGIN
  update user set update_time=CURRENT_TIMESTAMP where id=OLD.id;
END;
