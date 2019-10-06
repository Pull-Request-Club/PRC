-- Revert prc:add-langs from sqlite

BEGIN;

DELETE FROM lang WHERE lang_name in (
  'C',
  'C#',
  'C++',
  'Go',
  'HTML',
  'Java',
  'JavaScript',
  'Objective C',
  'Perl',
  'Perl 6',
  'PHP',
  'Python',
  'Ruby',
  'Swift',
  'Visual Basic .NET'
);

COMMIT;
