# -*- perl -*-
#
# Authen::PAAS::LoginModule by Daniel Berrange
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
# $Id: LoginModule.pm,v 1.1 2005/08/21 07:39:37 dan Exp $

=pod

=head1 NAME

Authen::PAAS::LoginModule - a pluggable authentication module

=head1 SYNOPSIS

  use Authen::PAAS::LoginModule;

  my $result = $module->login($subject, \%callbacks);

=head1 DESCRIPTION

This module provides the API for authenticating a subject
for the purposes of session login. It will be subclassed
to provide the implementations of different authentication 
schemes.

=head1 METHODS

=over 4

=cut

package Authen::PAAS::LoginModule;

use warnings;
use strict;
use Carp qw(confess);

our $VERSION = '1.0.0';

=pod

=item my $module = Authen::PAAS::LoginModule->new(flags => $flags, options => \%options);

Creates a new login modules. The C<flags> parameter should be one of the
keywords C<sufficient>, C<requisite>, C<required> and C<optional>. The
C<options> parameter is a hash reference containing sub-class specific
configuration options.

=cut

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self = {};
    my %params = @_;

    $self->{flags} = exists $params{flags} ? $params{flags} : confess "flags parameter is required";
    $self->{options} = exists $params{options} ? $params{options} : {};

    bless $self, $class;

    return $self;
}

=pod

=item $module->option($name, $default);

Retrieves the value of the configuration option identified by
the C<$name> parameter. If the named configuration option is
not set, then the C<$default> value is returned.

=cut

sub option {
    my $self = shift;
    my $name = shift;
    return exists $self->{options}->{$name} ? $self->{options}->{$name} : shift;
}

=pod

=item my $flags = $module->flags;

Retrieves the flags for the module, one of the keywords C<sufficient>, 
C<requisite>, C<required> and C<optional>. 

=cut

sub flags {
    my $self = shift;
    return $self->{flags};
}

=pod

=item my $res = $module->login($subject, $callbacks);

Attempt to login using authentication data obtained
from the callbacks, if successful, adding principals
and credentials to the subject. The C<$callbacks> 
parameter is a hash reference, whose keys are the
names of authentication tokes, and values are instances
of th L<Authen::PAAS::Callback> class. If successful, 
this method must return a true value, otherwise a false
value. This method must be implemented by subclasses.

=cut

sub login {
    my $self = shift;
    confess "module " . ref($self) . " forgot to implement login";
}

=pod

=item $module->logout($subject);

Attempt to logout a subject, by removing any principals
anc credentials added during the C<login> method.
This method must be implemented by subclasses.

=cut


sub logout {
    my $self = shift;
    confess "module " . ref($self) . " forgot to implement logout";
}


1 # So that the require or use succeeds.

__END__

=back 4

=head1 AUTHORS

Daniel Berrange <dan@berrange.com>

=head1 COPYRIGHT

Copyright (C) 2004-2005 Daniel Berrange

=head1 SEE ALSO

L<perl(1)>, L<Authen::PAAS::Context>, L<Authen::PAAS::Subject>,
L<Authen::PAAS::Callback>.

=cut
