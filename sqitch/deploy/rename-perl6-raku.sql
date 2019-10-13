-- Deploy prc:rename-perl6-raku to sqlite

BEGIN;

update lang set lang_name = 'Raku' where lang_name = 'Perl 6';

COMMIT;
