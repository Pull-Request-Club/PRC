package PRC::Secrets;
use namespace::autoclean;

use YAML qw/LoadFile/;

=encoding utf8

=head1 NAME

PRC::Secrets - A Quick Library for GitHub calls

=head1 DESCRIPTION

This is a library to abstract reading secrets. Look at ENV variables first,
look at secrets.yml later if first one is not there. Die if nothing is found.
There is a lot of room for improvement here. (Read file once and cache it etc)

=head1 METHODS

=head2 client_id

A quick subroutine to get client_id.

=cut

sub client_id {
  return shift->_read('CLIENT_ID');
}

=head2 client_secret

A quick subroutine to get client_secret.

=cut

sub client_secret {
  return shift->_read('CLIENT_SECRET');
}

=head2 init_admin

Subroutine that returns the initial admin's github id

=cut

sub init_admin {
  return shift->_read('INIT_ADMIN');
}
=head2 _read

Subroutine that does the actual reading.

=cut

sub _read {
  my ($self, $key) = @_;

  my $value;
  if ($ENV{$key}){
    $value = $ENV{$key};
  }
  elsif (-e 'secrets.yml'){
    my $file_contents = YAML::LoadFile('secrets.yml');
    if (ref $file_contents eq 'HASH' && $file_contents->{$key}){
      $value = $file_contents->{$key};
    }
  }
  die unless $value;
  return $value;
}

1;
