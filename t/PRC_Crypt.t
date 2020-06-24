use Test2::V0;
use PRC::Crypt;
use Sub::Override;

# Let's mock reading secrets for all subtests
my $override = Sub::Override->new('PRC::Secrets::read' => sub {'a'x32});

subtest encrypt_decrypt_ok => sub {
  my $data = { a => 1, b => 2, c => 3 };
  my $enc  = PRC::Crypt->_encrypt_data($data);
  my $dec  = PRC::Crypt->_decrypt_data($enc);
  is $dec, $data, "Got the same data back";
};

subtest encrypt_decrypt_key_changed => sub {
  my $data = { a => 1, b => 2, c => 3 };
  my $enc  = PRC::Crypt->_encrypt_data($data);
  my $override_2 = Sub::Override->new('PRC::Secrets::read' => sub {'b'x32});
  my $dec  = PRC::Crypt->_decrypt_data($enc);
  is $dec, undef, "Got undef back";
  $override_2->restore;
};

subtest encrypt_decrypt_tampered => sub {
  my $data = { a => 1, b => 2, c => 3 };
  my $enc  = PRC::Crypt->_encrypt_data($data);
  $enc->{ciphertext} .= 'x';
  my $dec  = PRC::Crypt->_decrypt_data($enc);
  is $dec, undef, "Got undef back";
};

$override->restore;
done_testing();