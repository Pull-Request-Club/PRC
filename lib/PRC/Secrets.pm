package PRC::Secrets;
use namespace::autoclean;

use YAML::LoadFileCached;

=encoding utf8

=head1 NAME

PRC::Secrets - A Quick Library for reading secrets

=head1 DESCRIPTION

This is a library to abstract reading secrets. Look at ENV variables first,
look at secrets.yml later if first one is not there. Die if nothing is found.

=head1 METHODS

=head2 read

Subroutine that reads the secret.
Tries ENV variable first, then goes for secrets.yml.
Available secrets:

CLIENT_ID
CLIENT_SECRET
SG_API_KEY
ENC_KEY
HMAC_KEY
FORM_URL

=cut

sub read {
  my ($self, $key) = @_;

  my $value;
  if ($ENV{$key}){
    $value = $ENV{$key};
  }
  elsif (-e 'secrets.yml'){
    my $file_contents = LoadFileCached('secrets.yml');

    if (ref $file_contents eq 'HASH' && $file_contents->{$key}){
      $value = $file_contents->{$key};
    }
  }
  die unless $value;
  return $value;
}

1;
