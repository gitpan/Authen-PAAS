# -*- perl -*-

use Test::More tests => 24;
use strict;
use warnings;
use File::Spec::Functions;

BEGIN {
    use_ok("Authen::PAAS::BasicLoginModule");
    use_ok("Authen::PAAS::BasicUser");
    use_ok("Authen::PAAS::SimpleCallback");
    use_ok("Authen::PAAS::Subject");
};

my $pwfile = catfile("t", "passwd.cfg");

BASIC: {
    my $subject = Authen::PAAS::Subject->new();
    my $module = Authen::PAAS::BasicLoginModule->new(flags => "requisite",
						     options => {
							 "passwd-file" => $pwfile,
						     });
    isa_ok($module, "Authen::PAAS::BasicLoginModule");
    isa_ok($module, "Authen::PAAS::LoginModule");
    
    my %callbacks = (
		     username => Authen::PAAS::SimpleCallback->new("dan"),
		     password => Authen::PAAS::SimpleCallback->new("123"),
		     );
    
    ok($module->login($subject, \%callbacks), "login was successful");
    
    # Check that login process added one Authen::PAAS::BasicUser principal
    my @pt1 = sort { $a cmp $b } $subject->principals;
    is(int(@pt1), 1, "got one principal");
    my @pt2 = sort { $a cmp $b } $subject->principals_by_owner(ref($module));
    is_deeply(\@pt2, \@pt1, "all principal by owner");

    my @pt3 = sort { $a cmp $b } $subject->principals_by_type("Authen::PAAS::BasicUser");    
    is_deeply(\@pt3, \@pt1, "all principal by type");
    
    # Check vs new principals;
    my $extp1 = MyPrincipal->new(name => "Foo");
    my $extp2 = Authen::PAAS::BasicUser->new("john");
    $subject->add_principal("MyMod", $extp1);
    $subject->add_principal("MyMod", $extp2);

    my @pt4 = sort { $a cmp $b } $subject->principals;
    is(int(@pt4), 3, "got three principals");

    my @pt5 = sort { $a cmp $b } $subject->principals_by_owner(ref($module));
    is_deeply(\@pt5, \@pt2, "principals for this module");

    my @pt6 = sort { $a cmp $b } $subject->principals_by_type("Authen::PAAS::BasicUser");    
    my @pt7 = sort { $a cmp $b } ( @pt1, $extp2);
    is_deeply(\@pt6, \@pt7, "all principal by type");

    my @pt8 = sort { $a cmp $b } $subject->principals_by_owner("MyMod");
    my @pt9 = sort { $a cmp $b } ($extp1, $extp2);
    is_deeply(\@pt8, \@pt9, "all principals for MyMod");
    
    
    $module->logout($subject);
    
    
    my @pt10 = $subject->principals;
    is(int(@pt10), 2, "got two principals");

    my @pt11 = $subject->principals_by_owner(ref($module));
    is_deeply(\@pt11, [], "no principals for this module");

    my @pt12 = $subject->principals_by_type("Authen::PAAS::BasicUser");    
    is_deeply(\@pt12, [$extp2], "all principal by type");

    my @pt13 = sort { $a cmp $b } $subject->principals_by_owner("MyMod");
    my @pt14 = sort { $a cmp $b } ($extp1, $extp2);
    is_deeply(\@pt13, \@pt14, "all principals for MyMod");
    
}

FAILED_USER: {
    my $subject = Authen::PAAS::Subject->new();
    my $module = Authen::PAAS::BasicLoginModule->new(flags => "requisite",
						     options => {
							 "passwd-file" => $pwfile,
						     });
    isa_ok($module, "Authen::PAAS::BasicLoginModule");
    isa_ok($module, "Authen::PAAS::LoginModule");
    
    my %callbacks = (
		     username => Authen::PAAS::SimpleCallback->new("notdan"),
		     password => Authen::PAAS::SimpleCallback->new("123"),
		     );
    
    ok(!$module->login($subject, \%callbacks), "login was not successful");
    
    my @pt1 = $subject->principals;
    is(int(@pt1), 0, "got no principals");
}

FAILED_PASSWORD: {
    my $subject = Authen::PAAS::Subject->new();
    my $module = Authen::PAAS::BasicLoginModule->new(flags => "requisite",
						     options => {
							 "passwd-file" => $pwfile,
						     });
    
    my %callbacks = (
		     username => Authen::PAAS::SimpleCallback->new("dan"),
		     password => Authen::PAAS::SimpleCallback->new("not123"),
		     );
    
    ok(!$module->login($subject, \%callbacks), "login was not successful");
    
    my @pt1 = $subject->principals;
    is(int(@pt1), 0, "got not principals");

}


package MyPrincipal;

use base qw(Authen::PAAS::Principal);

