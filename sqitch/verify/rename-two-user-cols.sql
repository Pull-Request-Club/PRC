-- Verify prc:rename-two-user-cols on sqlite

BEGIN;

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
WHERE 0;

ROLLBACK;
