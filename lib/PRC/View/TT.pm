package PRC::View::TT;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.html',
    render_die => 1,
);

=head1 NAME

PRC::View::TT - TT View for PRC

=head1 DESCRIPTION

TT View for PRC.

=head1 SEE ALSO

L<PRC>

=cut

1;
