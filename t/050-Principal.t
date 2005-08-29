# -*- perl -*-

use Test::More tests => 5;
use strict;
use warnings;

BEGIN {
	use_ok("Authen::PAAS::Principal");
};


BASIC: {
    my $principal = Authen::PAAS::Principal->new(name => "Foo");
    isa_ok($principal, "Authen::PAAS::Principal");
    
    is($principal->name, "Foo", "name is Foo");
}

SUBCLASS: {
    my $principal = MyPrincipal->new(name => "Foo");
    isa_ok($principal, "Authen::PAAS::Principal");
    isa_ok($principal, "MyPrincipal");
}

package MyPrincipal;

use base qw(Authen::PAAS::Principal);
