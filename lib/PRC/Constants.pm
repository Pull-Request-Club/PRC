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

our @EXPORT_OK = qw/LATEST_LEGAL_DATE/;

1;
