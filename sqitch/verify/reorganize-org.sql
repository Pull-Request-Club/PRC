-- Verify prc:reorganize-org on sqlite

BEGIN;

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
WHERE 0;

ROLLBACK;
