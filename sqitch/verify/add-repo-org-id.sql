-- Verify prc:add-repo-org-id on sqlite

BEGIN;

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
  github_pulls_url,
  github_events_url,
  github_issues_url,
  github_issue_events_url,
  github_open_issues_count,
  github_stargazers_count
FROM repo
WHERE 0;

ROLLBACK;
