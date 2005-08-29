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
# $Id: BasicLoginModule.pm,v 1.2 2005/08/21 10:57:06 dan Exp $

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

=head1 CONFIGURATION

This module expects one custom configuration option with
the key C<passwd> to refer to the username, password 
mapping file.

=head1 METHODS

=over 4

=cut

package Authen::PAAS::BasicLoginModule;

use warnings;
use strict;
use Config::Record;
use Authen::PAAS::BasicUser;
use base qw(Authen::PAAS::LoginModule);

our $VERSION = '1.0.0';

=pod

=item my $res = $module->login($subject, $callbacks);

Attempt to authenticate the subject against the simple username
and password configuration file. This module expects two callbacks,
one with the key C<username>, and the other with the key C<password>.

=cut

sub login {
    my $self = shift;
    my $subject = shift;
    my $callbacks = shift;
    
    return 0 unless exists $callbacks->{username};
    return 0 unless exists $callbacks->{password};
    
    my $username = $callbacks->{username}->data;
    my $password = $callbacks->{password}->data;
    
    my $expected = $self->_load_password($username);
    return 0 unless defined $expected;
    
    my $actual = crypt($password, $expected);
    
    return 0 unless $expected eq $actual;
    
    $subject->add_principal(ref($self), Authen::PAAS::BasicUser->new($username));
    
    return 1;
}

sub _load_password {
    my $self = shift;
    my $username = shift;
    
    my $config = Config::Record->new(file => $
				     self->option("passwd-file", 
						  "/etc/authen-paas-basic.cfg"));
    return $config->get("$username/password", undef);
}

=pod

=item $module->logout($subject);

Attempt to logout a subject, by removing any principals
anc credentials added during the C<login> method.
This method must be implemented by subclasses.

=cut


sub logout {
    my $self = shift;
    my $subject = shift;
    $subject->remove_principal(ref($self), "Authen::PAAS::BasicUser");
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
