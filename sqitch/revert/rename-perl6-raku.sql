-- Revert prc:rename-perl6-raku from sqlite

BEGIN;

update lang set lang_name = 'Perl 6' where lang_name = 'Raku';

COMMIT;
