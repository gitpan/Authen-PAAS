# -*- perl -*-

use Test::More tests => 5;
use strict;
use warnings;

BEGIN {
	use_ok("Authen::PAAS::Credential");
};


BASIC: {
    my $credential = Authen::PAAS::Credential->new(name => "Foo");
    isa_ok($credential, "Authen::PAAS::Credential");
    
    is($credential->name, "Foo", "name is Foo");
}

SUBCLASS: {
    my $credential = MyCredential->new(name => "Foo");
    isa_ok($credential, "Authen::PAAS::Credential");
    isa_ok($credential, "MyCredential");
}

package MyCredential;

use base qw(Authen::PAAS::Credential);
