#!/usr/bin/env perl
use Test2::V0;
use Catalyst::Test 'PRC';

ok( request('/')->is_success, 'Request should succeed' );

done_testing();
