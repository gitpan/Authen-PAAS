# -*- perl -*-
#
# Authen::PAAS::Context by Daniel Berrange
#
# Copyright (C) 2004 Dan Berrange
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
# $Id: Context.pm,v 1.5 2005/08/21 10:57:06 dan Exp $

=pod

=head1 NAME

Authen::PAAS::Context - authentication a subject using login modules

=head1 SYNOPSIS

  use Authen::PAAS::Context;
  use Authen::PAAS::SimpleCallback;
  use Config::Record;
  
  my $config = Config::Record->new("/etc/myapp.cfg");

  my $context = Authen::PAAS::Context->new($config, "myapp");

  my $callbacks = {
    "username" => Authen::PAAS::SimpleCallback->new("joeblogs"),
    "password" => Authen::PAAS::SimpleCallback->new("123456"),
  };

  my $subject = $context->login($callbacks);

  unless ($subject) {
     die "could not authenticate subject"
  }

  .. do some work using the subject ..

  $context->logout($subject);

=head1 DESCRIPTION

The C<Authen::PAAS::Context> module provides the controller
for invoking a number of login modules, and having them
populate a subject with principals and credentials. The
authentication process consists of two stages. In the first 
phase the C<login> method is invoked on all modules to 
perform the actual authentication process. If a module's
authentication process succeded, then it may wish to store
state to represent the result of authentication in the 
supplied instance of C<Authen::PAAS::State>. If the first
phase was successful overall, then the C<commit> method will 
be invoked on all modules. The module's C<commit> method will 
check the stored state for the result of the first phase, and 
if it was successful, then it will add one or more principals
and zero or more credentials to the subject. If there is a
terminal failure of the authentication process at any point,
the abort() method will be invoked on all modules


=head1 CONFIGURATION

The L<Config::Record> module is used for accessing configuration
file information. The configuration file defines the set of 
login modules used for performing authentication. The modules
have associated flags controlling operation of the login process
upon success/failure of a module. The configuration is stored in
a single list, named C<auth.$APP> where $APP is the name token 
passed into the constructor of the C<Authen::PAAS::Context> object. 
Each element in the list is a dictionary, with the key C<module>
defining the class name of the login module, the key C<flags> 
defining the login flags and C<options> defining any module 
specific options. For example, a web application may have a
a username/password in the main login page, but elsewhere use a
cookie as the authentication data. In this case, a configuration
look like


  auth.mail-archive = (
    {
      module = Authen::PAAS::DB::PasswdLogin
      flags = optional
    }
    {
      module = Authen::PAAS::CGI::CookieLogin
      flags = requisite
      options = {
        secret = /etc/authen-paas/authen-paas-cgi-secret.dat
        user-module = Authen::PAAS::DB::User
      }
    }
  )


=head1 METHODS

=over 4

=cut

package Authen::PAAS::Context;

use strict;
use Carp qw(confess);
use Authen::PAAS::Subject;
use Log::Log4perl;

our $VERSION = '1.0.0';

=pod

=item $obj = Authen::PAAS::Context->new();

Create

=cut

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self = {};
    my %params = @_;

    $self->{config} = exists $params{config} ? $params{config} : confess "config parameter is required";
    $self->{name} = exists $params{name} ? $params{name} : confess "name parameter is required";
    $self->{modules} = [];

    bless $self, $class;

    $self->_load();

    return $self;
}

sub _load {
    my $self = shift;

    my $logger = Log::Log4perl->get_logger(ref($self));

    my $modules = $self->{config}->get("auth/" . $self->{name});
    my @modules;
    foreach my $module (@{$modules}) {
	my $pack = $module->{module};
	if (!exists $INC{$pack}) {
	    eval "use $pack;";
	    if ($@) {
		die $@;
	    }
	}
	$logger->debug("Loading module $pack with " . $module->{flags});
	my $object = $pack->new(flags => $module->{flags},
				options => $module->{options});
	
	push @modules, $object;
    }
    
    $self->{modules} = \@modules;
}

sub login {
    my $self = shift;
    my $callbacks = shift;

    my $logger = Log::Log4perl->get_logger(ref($self));
    my $subject = Authen::PAAS::Subject->new();
    
    my $success;
    foreach my $module (@{$self->{modules}}) {
	if ($module->flags eq "sufficient") {
	    if ($module->login($subject, $callbacks)) { 
		$logger->info("Sufficient login $module success");
		if (!defined $success) {
		    $success = 1;
		}
		last;
	    } else {
		$logger->info("Sufficient login $module fail");
		# continue
	    }
	} elsif ($module->flags eq "requisite") {
	    if ($module->login($subject, $callbacks)) { 
		$logger->info("Requisite login $module success");
		if (!defined $success) {
		    $success = 1;
		}
	    } else {
		$logger->info("Requisite login $module fail");
		$success = 0;
		last;		
	    }
	} elsif ($module->flags eq "required") {
	    if ($module->login($subject, $callbacks)) { 
		$logger->info("Required login $module success");
		$success = 1;
	    } else {
		$logger->info("Required login $module fail");
		$success = 0;
		# continue
	    }
	} elsif ($module->flags eq "optional") {
	    if ($module->login($subject, $callbacks)) { 
		$logger->info("Optional login $module success");
		if (!defined $success) {
		    $success = 1;
		}
	    } else {
		$logger->info("Optional login $module fail");
		# continue
	    }
	}
    }
    
    return $success ? $subject : undef;
}


sub logout {
    my $self = shift;
    my $subject = shift;

    my $logger = Log::Log4perl->get_logger(ref($self));
    
    foreach my $module (@{$self->{modules}}) {
	$logger->info("Logging out $module");
	$module->logout($subject);
    }
}


1 # So that the require or use succeeds.

__END__

=back 4

=head1 AUTHORS

Daniel Berrange <dan@berrange.com>

=head1 COPYRIGHT

Copyright (C) 2004 Daniel Berrange

=head1 SEE ALSO

L<perl(1)>

=cut
