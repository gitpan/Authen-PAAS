# -*- perl -*-
#
# Authen::PAAS::Subject by Daniel Berrange
#
# Copyright (C) 2004-2005 Dan Berrange
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
# $Id: Subject.pm,v 1.5 2005/08/21 10:57:06 dan Exp $

=pod

=head1 NAME

Authen::PAAS::Subject - represents an authenticated party

=head1 SYNOPSIS

  use Authen::PAAS::Subject;

  ####### Creating a populating a subject..

  # Create a new anonymous subject with no credentials
  my $subject = Authen::PAAS::Subject->new();

  # Add a principal eg a UNIX username, or a Kerberos 
  # principal, or some such
  my $prin = SomePrincipal->new();
  $subject->add_principal($prin)

  # Add a credential. eg some form of magic token 
  # representing a previously added principal
  my $cred = SomeCredential->new($principal)
  $subject->add_credential($cred);


  ######## Fetching and querying a subject

  # Create a context module for performing auth
  my $context = Context->new($config, "myapp");

  # Attempt to login
  my $subject = $context->login($callbacks);

  if ($subject) {
      # Retrieve set of all principals
      my @princs = $subject->principals;

      # Or only get principal of particular class
      my $princ = $subject->principal("SomePrincipal");

      # Retrieve set of all credentials
      my @cred = $subject->credentials;

      # Or only get credential of particular class
      my $cred = $subject->credential("SomeCredential");
  } else {
      die "login failed";
  }

=head1 DESCRIPTION

The C<Authen::PAAS::Subject> module provides a representation
of an authenticated party, be they a human user, or a independantly
operating computing service. An authenticated subject will have
one of more principals associated with them, which can be thought
of as their set of C<names>. These are represented by the 
L<Authen::PAAS::Principal> module. Some authentication mechanisms 
will also associate some form of security related token with a 
subject, thus an authenticated subject may also have zero or more 
credentials. These are represented by the L<Authen::PAAS::Credential>
module. 

An authenticated subject is typically obtained via the C<login>
method on the L<Authen::PAAS::Context> module. This creates an
anonymous subject, and invokes a set of login modules 
(L<Authen::PAAS::LoginModule>), which in turn populate the
subject with principals and credentials.

=head1 METHODS

=over 4

=cut

package Authen::PAAS::Subject;

use strict;
use Carp qw(confess);

our $VERSION = '1.0.0';

=pod

=item my $subject = Authen::PAAS::Subject->new();

Create a new subject, with no initial principals
or credentials.

=cut

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self = {};
    my %params = @_;

    $self->{principals} = {};
    $self->{credentials} = {};

    bless $self, $class;

    return $self;
}

=pod

=item $subject->add_pricipal($owner, $principal)

Adds a principal to the subject. The C<$owner> parameter
should be the class name of the login module owning the
principal. The principal parameter must be a subclass of 
the L<Authen::PAAS::Principal> class. 

=cut

sub add_principal {
    my $self = shift;
    my $owner = shift;
    my $principal = shift;

    my $type = ref($principal);
    $self->{principals}->{$owner} = {} unless exists $self->{principals}->{$owner};
    $self->{principals}->{$owner}->{$type} = $principal;
}

=pod

=item $subject->remove_principal($owner[, $type]);

Removes a previously added principal from the subject. The
C<$id> parameter is the index of the principal previously
added via the C<add_principal> method.

=cut

sub remove_principal {
    my $self = shift;
    my $owner = shift;
    my $type = shift;
    
    return  unless exists $self->{principals}->{$owner};
    if ($type) {
	delete $self->{principals}->{$owner}->{$type};
    } else {
	delete $self->{principals}->{$owner};
    }
}

=pod

=item $subject->principals_by_owner($owner);

Retrieves a list of all the principals for the subject associated
with the owner specified in the C<$owner> parameter. The
value of the C<$owner> parameter is the class name of a login
module

=cut

sub principals_by_owner {
    my $self = shift;
    
    my $owner = shift;
    return () unless exists $self->{principals}->{$owner};
    return values %{$self->{principals}->{$owner}};
}

=pod

=item $subject->principal($type);

Retrieves the first matching principal of a given type. The
C<$type> parameter should be the Perl module name of the 
principal implementation.

=cut

sub principals_by_type {
    my $self = shift;
    my $type = shift;
    
    return grep { $_->isa($type) } $self->principals;
}

=pod

=item my @principals = $subject->principals;

Retrieves a list of all the principals for the subject.

=cut

sub principals {
    my $self = shift;
    
    my @principals;
    foreach my $owner (keys %{$self->{principals}}) {
	push @principals, values %{$self->{principals}->{$owner}};
    }
    return @principals;
}


=pod

=item $subject->add_credential($owner, $credential)

Adds a credential to the subject. The C<$owner> parameter
should be the class name of the login module owning the
credential. The credential parameter must be a subclass of 
the L<Authen::PAAS::Credential> class. 

=cut

sub add_credential {
    my $self = shift;
    my $owner = shift;
    my $credential = shift;

    my $type = ref($credential);
    $self->{credentials}->{$owner} = {} unless exists $self->{credentials}->{$owner};
    $self->{credentials}->{$owner}->{$type} = $credential;
}

=pod

=item $subject->remove_credential($owner[, $type]);

Removes a previously added credential from the subject. The
C<$id> parameter is the index of the credential previously
added via the C<add_credential> method.

=cut

sub remove_credential {
    my $self = shift;
    my $owner = shift;
    my $type = shift;
    
    return  unless exists $self->{credentials}->{$owner};
    if ($type) {
	delete $self->{credentials}->{$owner}->{$type};
    } else {
	delete $self->{credentials}->{$owner};
    }
}

=pod

=item $subject->credentials_by_owner($owner);

Retrieves a list of all the credentials for the subject associated
with the owner specified in the C<$owner> parameter. The
value of the C<$owner> parameter is the class name of a login
module

=cut

sub credentials_by_owner {
    my $self = shift;
    
    my $owner = shift;
    return () unless exists $self->{credentials}->{$owner};
    return values %{$self->{credentials}->{$owner}};
}

=pod

=item $subject->credential($type);

Retrieves the first matching credential of a given type. The
C<$type> parameter should be the Perl module name of the 
credential implementation.

=cut

sub credentials_by_type {
    my $self = shift;
    my $type = shift;
    
    return grep { $_->isa($type) } $self->credentials;
}

=pod

=item my @credentials = $subject->credentials;

Retrieves a list of all the credentials for the subject.

=cut

sub credentials {
    my $self = shift;
    
    my @credentials;
    foreach my $owner (keys %{$self->{credentials}}) {
	push @credentials, values %{$self->{credentials}->{$owner}};
    }
    return @credentials;
}

1 # So that the require or use succeeds.

__END__

=back 4

=head1 AUTHORS

Daniel Berrange <dan@berrange.com>

=head1 COPYRIGHT

Copyright (C) 2004-2005 Daniel Berrange

=head1 SEE ALSO

L<perl(1)>, L<Authen::PAAS::Context>, L<Authen::PAAS::Credential>,
L<Authen::PAAS::Principal>

=cut
