# -*- perl -*-

use Test::More tests => 4;
use strict;
use warnings;

BEGIN {
    use_ok("Authen::PAAS::SimpleCallback");
};


BASIC: {   
    my $cb = Authen::PAAS::SimpleCallback->new("hello");
    isa_ok($cb, "Authen::PAAS::Callback");
    isa_ok($cb, "Authen::PAAS::SimpleCallback");
    
    is($cb->data, "hello", "data is hello");
}
