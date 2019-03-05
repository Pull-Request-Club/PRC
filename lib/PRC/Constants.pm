package PRC::Constants;
use namespace::autoclean;
use DateTime;

use base 'Exporter';

=encoding utf8

=head1 NAME

PRC::Constants - Provide our constants to other libraries

=head1 DESCRIPTION

Import to get our constants.

=cut

use constant { LATEST_LEGAL_DATE => DateTime->new(
  year => 2018, month => 11, day => 10
) };

use constant USER_ASSIGNMENT_QUIT   => 0;
use constant USER_ASSIGNMENT_SKIP   => 1;
use constant USER_ASSIGNMENT_ACTIVE => 10;

use constant USER_ASSIGNEE_QUIT   => 0;
use constant USER_ASSIGNEE_ACTIVE => 10;

use constant ASSIGNMENT_OPEN    => 0;
use constant ASSIGNMENT_SKIPPED => 1;
use constant ASSIGNMENT_DONE    => 10;

use constant EMAIL_VIS_USER_ASSIGNMENT => 0;
use constant EMAIL_VIS_USER_ASSIGNED => 1;

our @EXPORT = qw/
  LATEST_LEGAL_DATE

  USER_ASSIGNMENT_QUIT
  USER_ASSIGNMENT_SKIP
  USER_ASSIGNMENT_ACTIVE

  USER_ASSIGNEE_QUIT
  USER_ASSIGNEE_ACTIVE

  ASSIGNMENT_OPEN
  ASSIGNMENT_SKIPPED
  ASSIGNMENT_DONE

  EMAIL_VIS_USER_ASSIGNMENT
  EMAIL_VIS_USER_ASSIGNED
/;

1;
