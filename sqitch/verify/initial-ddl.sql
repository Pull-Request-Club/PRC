-- Verify prc:initial-ddl on sqlite

BEGIN;

SELECT
  user_id,
  create_time,
  update_time,

  last_login_time,
  tos_agree_time,
  tos_agreed_version,
  scheduled_delete_time,
  is_deactivated,
  assignment_level,
  assignee_level,

  github_id,
  github_login,
  github_email,
  github_profile,

  last_repos_sync
FROM user
WHERE 0;

SELECT
  repo_id,
  user_id,
  create_time,
  update_time,

  gone_missing,
  accepting_assignees,

  github_id,
  github_name,
  github_full_name,
  github_language,
  github_html_url,
  github_pulls_url,
  github_events_url,
  github_issues_url,
  github_issue_events_url,
  github_open_issues_count,
  github_stargazers_count
FROM repo
WHERE 0;

SELECT
  assignment_id,
  repo_id,
  user_id,
  create_time,
  update_time,
  month,
  status
FROM assignment
WHERE 0;

ROLLBACK;
