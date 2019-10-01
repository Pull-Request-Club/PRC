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

use constant ASSIGNMENT_OPEN    => 0;
use constant ASSIGNMENT_SKIPPED => 1;
use constant ASSIGNMENT_DONE    => 10;

use constant REPO_NOT_ACCEPTING => 0;
use constant REPO_ACCEPTING     => 1;

use constant REPO_GONE_MISSING     => 1;
use constant REPO_NOT_GONE_MISSING => 0;

our @EXPORT = qw/
  LATEST_LEGAL_DATE

  ASSIGNMENT_OPEN
  ASSIGNMENT_SKIPPED
  ASSIGNMENT_DONE

  REPO_NOT_ACCEPTING
  REPO_ACCEPTING

  REPO_GONE_MISSING
  REPO_NOT_GONE_MISSING
/;

1;
