-- Deploy prc:add-langs to sqlite

BEGIN;

INSERT INTO lang (lang_id, lang_name) VALUES
(1, 'C'),
(2, 'C#'),
(3, 'C++'),
(4, 'Go'),
(5, 'HTML'),
(6, 'Java'),
(7, 'JavaScript'),
(8, 'Objective C'),
(9, 'Perl'),
(10, 'Perl 6'),
(11, 'PHP'),
(12, 'Python'),
(13, 'Ruby'),
(14, 'Swift'),
(15, 'Visual Basic .NET');

COMMIT;
