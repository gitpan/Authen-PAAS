# -*- perl -*-

use Test::More tests => 2;
use strict;
use warnings;

BEGIN {
    use_ok("Authen::PAAS::Callback");
};


BASIC: {   
    my $cb = Authen::PAAS::Callback->new();
    isa_ok($cb, "Authen::PAAS::Callback");
}
