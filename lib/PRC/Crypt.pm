package PRC::Crypt;
use namespace::autoclean;

use Crypt::Mac::HMAC qw/hmac_b64u/;
use Crypt::Mode::CBC;
use JSON::XS;
use MIME::Base64::URLSafe;
use PRC::Secrets;
use String::Random;
use Try::Tiny;

=encoding utf8

=head1 NAME

PRC::Crypt - A Quick Library for cryptographic functions

=head1 DESCRIPTION

This is a library to create/validate encrypted and URL
safe ciphertext. It's utilizing already established libraries
(such as CryptX) and nothing is re-invented here.

Since this is currently only used for unsubscribe, there's one
encryption key and one hmac key. At some point it's likely we
will need to rotate these keys, or need multiple keys at the
same time.

=head1 METHODS

=head2 _encrypt_data

Method that takes a hashref of data, and returns
a hashref with two things: ciphertext and hmac.

=cut

sub _encrypt_data {
  my ($self, $data) = @_;

  return undef unless $data;
  return undef unless (ref $data eq 'HASH');

  # Collect keys
  my $enc_key  = PRC::Secrets->read('ENC_KEY');
  my $hmac_key = PRC::Secrets->read('HMAC_KEY');

  # Generate random-ish IV
  my $sr = String::Random->new;
  my $iv = $sr->randregex('\w{16}');

  # JSONify data
  my $data_json = encode_json($data);

  # Encrypt data
  my $cbc = Crypt::Mode::CBC->new('AES');
  my $ct  = $cbc->encrypt($data_json, $enc_key, $iv);

  # Encode ciphertext + make it URL safe
  my $uct = urlsafe_b64encode($ct);

  # Prepend IV
  my $iuct = $iv.$uct;

  # Calculate HMAC
  my $hmac = hmac_b64u('SHA256', $hmac_key, $iuct);

  return {
    ciphertext => $iuct,
    hmac       => $hmac,
  };
}

=head2 _decrypt_data

Method that takes a hashref of two things:
ciphertext and hmac.
Returns decrypted data in a hashref.

=cut

sub _decrypt_data {
  my ($self, $data) = @_;

  return undef unless $data;
  return undef unless (ref $data eq 'HASH');
  return undef unless $data->{ciphertext};
  return undef unless $data->{hmac};

  # Collect keys
  my $enc_key  = PRC::Secrets->read('ENC_KEY');
  my $hmac_key = PRC::Secrets->read('HMAC_KEY');

  # Collect iv-ciphertext, hmac
  my $iuct = $data->{ciphertext};
  my $hmac = $data->{hmac};

  # Check if HMAC is correct
  my $hmac_calc = hmac_b64u('SHA256', $hmac_key, $iuct);
  if ($hmac ne $hmac_calc){
    # If HMAC doesn't match, data may be tampered.
    return undef;
  }

  # Collect IV and uct
  my $iv  = substr($iuct,0,16);
  my $uct = substr($iuct,16);
  if (!$iv || length($iv) < 16 || !$uct){
    # If IV or UCT is missing, data may be tampered.
    return undef;
  }

  # Decode ciphertext
  my $ct = urlsafe_b64decode($uct);
  if (!$ct){
    return undef;
  }

  # Decrypt data
  my $cbc = Crypt::Mode::CBC->new('AES');
  my $data_json = $cbc->decrypt($ct, $enc_key, $iv);
  if (!$data_json){
    return undef;
  }

  # DeJSONify data
  my $data = try { decode_json($data_json); };
  if (!$data || (ref $data ne 'HASH')){
    return undef;
  }

  return $data;
}

1;