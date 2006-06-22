# -*- perl -*-
#
# Authen::PAAS::Principal by Daniel Berrange
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
# $Id: Principal.pm,v 1.1 2005/08/21 07:39:38 dan Exp $

=pod

=head1 NAME

Authen::PAAS::Principal - An identity for a subject

=head1 SYNOPSIS

  use Authen::PAAS::Principal;

  my $princ = Authen::PAAS::Principal->new(name => $name);

  print $princ->name, "\n";

=head1 DESCRIPTION

This module represents an identity for a subject. An identity
may be a kerberos principal, a UNIX username, or any other
identifying token related to a particular authentication
scheme. This module will usually be sub-classed by each
C<Authen::PAAS::LoginModule> implementation to provide module
specific identifying data.

=head1 METHODS

=over 4

=cut

package Authen::PAAS::Principal;

use warnings;
use strict;

our $VERSION = '1.0.0';

=item $obj = Authen::PAAS::Principal->new(name => $name);

Create a new principal with a name given by the C<name>
parameter. This constructor will typically only be used
by sub-classes of this module.

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


=item my $name = $princ->name;

Retrieves the name associated with this principal, as set
in the constructor.

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

L<Authen::PAAS::Subject>, L<Authen::PAAS::Credential>

=cut
