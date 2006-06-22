# -*- perl -*-
#
# Authen::PAAS::Credential by Daniel Berrange
#
# Copyright (C) 2004-2006 Dan Berrange
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
# $Id: Credential.pm,v 1.2 2004/12/28 23:43:46 dan Exp $

=pod

=head1 NAME

Authen::PAAS::Credential - represents a credential for a subject

=head1 SYNOPSIS

  use Authen::PAAS::Credential;

  my $cred = Authen::PAAS::Credential->new(name => "krb5ticket");

  print $cred->name, "\n";

=head1 DESCRIPTION

The C<Authen::PAAS::Credential> module represents a credential for
an authenticated subject. A credential is merely an abstract token
generated during the authentication process. This module would be
subclassed by C<Authen::PAAS::LoginModule> implementations to provide
module specific data.

=head1 METHODS

=over 4

=cut

package Authen::PAAS::Credential;

use warnings;
use strict;

our $VERSION = '1.0.0';


=item $cred = Authen::PAAS::Credential->new(name => $name);

Create a new credential assigning it the name given by the
C<name> parameter to the method. This constructor is usually
only used by sub-classes.

=cut

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self = {};
    my %params = @_;

    $self->{name} = exists $params{name} ? $params{name} : die "name parameter is required";

    bless $self, $class;

    return $self;
}


=item $name = $cred->name;

Retrieves the name of this credential.

=cut

sub name {
    my $self = shift;
    return $self->{name};
}

1 # So that the require or use succeeds.

__END__

=back

=head1 AUTHORS

Daniel Berrange <dan@berrange.com>

=head1 COPYRIGHT

Copyright (C) 2004-2006 Daniel Berrange

=head1 SEE ALSO

L<Authen::PAAS::Subject>, L<Authen::PAAS::Principal>

=cut
