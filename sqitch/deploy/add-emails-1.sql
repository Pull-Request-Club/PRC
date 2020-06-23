-- Deploy prc:add-emails-1 to sqlite

BEGIN;

INSERT INTO email (email_id, email_name, email_description) VALUES

(1, 'new-assignment','Sent when you have a new assignment.'               ),
(2, 'new-assignee'  ,'Sent when one of your repos is assigned to someone.'),
(3, 'open-reminder' ,'Sent to remind you about your open assignment.'     ),
(4, 'new-feature'   ,'Announcements about newly implemented features.'    );

COMMIT;
