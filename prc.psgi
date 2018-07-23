use strict;
use warnings;

use PRC;

my $app = PRC->apply_default_middlewares(PRC->psgi_app);
$app;

