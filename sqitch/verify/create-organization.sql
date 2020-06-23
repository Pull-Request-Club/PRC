-- Verify prc:create-organization on sqlite

BEGIN;

SELECT
  organization_id,
  create_time,
  update_time,
  created_by_user_id,
  github_id,
  github_login,
  github_profile
FROM organization
WHERE 0;

SELECT
  user_in_organization_id,
  user_id,
  organization_id,
  create_time,
  update_time,

  gone_missing,
  fetch_repos
FROM user_in_organization
WHERE 0;

ROLLBACK;
