# -*- perl -*-

use Test::More tests => 29;
use strict;
use warnings;

BEGIN {
	use_ok("Authen::PAAS::Subject");
};


EMPTY: {
    my $subject = Authen::PAAS::Subject->new();
    
    my @pt1 = $subject->principals;
    is_deeply(\@pt1, [], "No principals in subject");
    my @pt2 = $subject->principals_by_owner("Dummy");
    is_deeply(\@pt2, [], "No principals in subject");
    my @pt3 = $subject->principals_by_type("Dummy");
    is_deeply(\@pt3, [], "No principals in subject");


    my @cd1 = $subject->credentials;
    is_deeply(\@cd1, [], "No credentials in subject");
    my @cd2 = $subject->credentials_by_owner("Dummy");
    is_deeply(\@cd2, [], "No credentials in subject");
    my @cd3 = $subject->credentials_by_type("Dummy");
    is_deeply(\@cd3, [], "No credentials in subject");
}


PRINCIPALS: {
    my $subject = Authen::PAAS::Subject->new();
    
    my $p1 = MyPrincipal->new(name => "P1");
    my $p2 = OtherPrincipal->new(name => "P2");
    my $p3 = MyPrincipal->new(name => "P3");

    $subject->add_principal("MyMod", $p1);
    $subject->add_principal("MyMod", $p2);
    $subject->add_principal("OtherMod", $p3);
    
    my @got1 = sort { $a cmp $b } $subject->principals;
    my @exp1 = sort { $a cmp $b } ($p1, $p2, $p3);
    is_deeply(\@got1, \@exp1, "Got all principals");

    my @got2 = sort { $a cmp $b } $subject->principals_by_owner("MyMod");
    my @exp2 = sort { $a cmp $b } ($p1, $p2);
    is_deeply(\@got2, \@exp2, "Got all principals for MyMod");

    my @got3 = $subject->principals_by_owner("NoSuchMod");
    my @exp3;
    is_deeply(\@got3, \@exp3, "Got no principals for NoSuchMod");


    my @got4 = sort { $a cmp $b } $subject->principals_by_type("MyPrincipal");
    my @exp4 = sort { $a cmp $b } ($p1, $p3);
    is_deeply(\@got4, \@exp4, "Got all principals of type MyPrincipal");

    my @got5 = $subject->principals_by_type("NoSuchPrincipal");
    my @exp5;
    is_deeply(\@got5, \@exp5, "Got no principals for NoSuchPrincipal");



    $subject->remove_principal("MyMod", "OtherPrincipal");


    my @got6 = sort { $a cmp $b } $subject->principals;
    my @exp6 = sort { $a cmp $b } ($p1, $p3);
    is_deeply(\@got6, \@exp6, "Got all principals");

    my @got7 = sort { $a cmp $b } $subject->principals_by_owner("MyMod");
    my @exp7 = sort { $a cmp $b } ($p1);
    is_deeply(\@got7, \@exp7, "Got all principals for MyMod");

    my @got8 = sort { $a cmp $b } $subject->principals_by_type("MyPrincipal");
    my @exp8 = sort { $a cmp $b } ($p1, $p3);
    is_deeply(\@got8, \@exp8, "Got all principals of type MyPrincipal");



    $subject->remove_principal("MyMod");


    my @got9 = sort { $a cmp $b } $subject->principals;
    my @exp9 = ($p3);
    is_deeply(\@got9, \@exp9, "Got all principals");

    my @got10 = sort { $a cmp $b } $subject->principals_by_owner("MyMod");
    my @exp10;
    is_deeply(\@got10, \@exp10, "Got all principals for MyMod");

    my @got11 = sort { $a cmp $b } $subject->principals_by_type("MyPrincipal");
    my @exp11 = sort { $a cmp $b } ($p3);
    is_deeply(\@got11, \@exp11, "Got all principals of type MyPrincipal");

}


CREDENTIALS: {
    my $subject = Authen::PAAS::Subject->new();
    
    my $p1 = MyCredential->new(name => "P1");
    my $p2 = OtherCredential->new(name => "P2");
    my $p3 = MyCredential->new(name => "P3");

    $subject->add_credential("MyMod", $p1);
    $subject->add_credential("MyMod", $p2);
    $subject->add_credential("OtherMod", $p3);
    
    my @got1 = sort { $a cmp $b } $subject->credentials;
    my @exp1 = sort { $a cmp $b } ($p1, $p2, $p3);
    is_deeply(\@got1, \@exp1, "Got all credentials");

    my @got2 = sort { $a cmp $b } $subject->credentials_by_owner("MyMod");
    my @exp2 = sort { $a cmp $b } ($p1, $p2);
    is_deeply(\@got2, \@exp2, "Got all credentials for MyMod");

    my @got3 = $subject->credentials_by_owner("NoSuchMod");
    my @exp3;
    is_deeply(\@got3, \@exp3, "Got no credentials for NoSuchMod");


    my @got4 = sort { $a cmp $b } $subject->credentials_by_type("MyCredential");
    my @exp4 = sort { $a cmp $b } ($p1, $p3);
    is_deeply(\@got4, \@exp4, "Got all credentials of type MyCredential");

    my @got5 = $subject->credentials_by_type("NoSuchCredential");
    my @exp5;
    is_deeply(\@got5, \@exp5, "Got no credentials for NoSuchCredential");


    $subject->remove_credential("MyMod", "OtherCredential");


    my @got6 = sort { $a cmp $b } $subject->credentials;
    my @exp6 = sort { $a cmp $b } ($p1, $p3);
    is_deeply(\@got6, \@exp6, "Got all credentials");

    my @got7 = sort { $a cmp $b } $subject->credentials_by_owner("MyMod");
    my @exp7 = sort { $a cmp $b } ($p1);
    is_deeply(\@got7, \@exp7, "Got all credentials for MyMod");

    my @got8 = sort { $a cmp $b } $subject->credentials_by_type("MyCredential");
    my @exp8 = sort { $a cmp $b } ($p1, $p3);
    is_deeply(\@got8, \@exp8, "Got all credentials of type MyCredential");



    $subject->remove_credential("MyMod");


    my @got9 = sort { $a cmp $b } $subject->credentials;
    my @exp9 = ($p3);
    is_deeply(\@got9, \@exp9, "Got all credentials");

    my @got10 = sort { $a cmp $b } $subject->credentials_by_owner("MyMod");
    my @exp10;
    is_deeply(\@got10, \@exp10, "Got all credentials for MyMod");

    my @got11 = sort { $a cmp $b } $subject->credentials_by_type("MyCredential");
    my @exp11 = sort { $a cmp $b } ($p3);
    is_deeply(\@got11, \@exp11, "Got all credentials of type MyCredential");

}


package MyPrincipal;

use base qw(Authen::PAAS::Principal);

package OtherPrincipal;

use base qw(Authen::PAAS::Principal);

package MyCredential;

use base qw(Authen::PAAS::Credential);

package OtherCredential;

use base qw(Authen::PAAS::Credential);

