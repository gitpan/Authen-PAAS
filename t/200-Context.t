# -*- perl -*-

use Test::More tests =>27;
use strict;
use warnings;
use File::Spec::Functions;
use Config::Record;
use Log::Log4perl;

Log::Log4perl::init("t/log4perl.conf");

BEGIN {
	use_ok("Authen::PAAS::Context");
};


package MyLoginModule;

$INC{MyLoginModule} = 1;

use base qw(Authen::PAAS::LoginModule);

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);

    $self->{done_login} = 0;
    
    bless $self, $class;

    return $self;
}

sub login {
    my $self = shift;
    $self->{done_login} = 1;
    return $self->option("result");
}


sub done_login {
    my $self = shift;
    return $self->{done_login};
}

sub logout {
    my $self = shift;
    $self->{done_logout} = 1;
}


sub done_logout {
    my $self = shift;
    return $self->{done_logout};
}

package main;

my $cf = Config::Record->new(file => catfile("t", "context.cfg"));

&one_time($cf, "one", 1);
&one_time($cf, "two", 0);
&one_time($cf, "three", 1);
&one_time($cf, "four", 1);
&one_time($cf, "five", 1);
&one_time($cf, "six", 0);

sub one_time {
    my $config = shift;
    my $name = shift;
    my $pass = shift;
    
    my $context = Authen::PAAS::Context->new(config => $config,
					     name => $name);
    
    my $subject = $context->login;
    ok(($pass && $subject) ||
       (!$pass && !$subject), "Login pass $pass");
    
    foreach my $mod (@{$context->{modules}}) {
	is($mod->done_login, $mod->option("execute"), "executed module");
    }

    if ($subject) {
	$context->logout($subject);
	foreach my $mod (@{$context->{modules}}) {
	    is($mod->done_logout, 1, "executed module");
	}
    }
    
}

