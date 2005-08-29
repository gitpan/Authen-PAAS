#!/usr/bin/perl

use strict;
use warnings;

use Authen::PAAS::Context;
use Authen::PAAS::ConsoleCallback;
use Config::Record;

my $config = Config::Record->new(file => "examples/login.cfg");

my $context = Authen::PAAS::Context->new(config => $config, name => "validate");

my $callbacks = {
    "username" => Authen::PAAS::ConsoleCallback->new("Enter username:\n"),
    "password" => Authen::PAAS::ConsoleCallback->new("Enter password:\n"),
};

my $subject = $context->login($callbacks);

if ($subject) {
    print "Successfully got subject\n";
    print "Principals after login:\n";
    foreach ($subject->principals) {
	print "  ", ref($_), " ", $_->name, "\n";
    }
    $context->logout($subject);
    print "Principals after logout:\n";
    foreach ($subject->principals) {
	print "  ", ref($_), " ", $_->name, "\n";
    }
    exit 0;
} else {
    print "Could not authenticate subject\n";
    exit 1;
}

