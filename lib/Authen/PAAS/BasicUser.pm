# -*- perl -*-
#
# Authen::PAAS::BasicUser by Daniel Berrange
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
# $Id: BasicUser.pm,v 1.1 2005/08/21 07:39:37 dan Exp $

=pod

=head1 NAME

Authen::PAAS::BasicUser - a simple user principal

=head1 SYNOPSIS

  use Authen::PAAS::BasicUser;

  my $principal = Authen::PAAS::BasicUser->new("joeblogs");

=head1 DESCRIPTION

This module provides a representation of the simple virtual user
principal created by the L<Authen::PAAS::BasicLoginModule> module

=head1 METHODS

=over 4

=cut

package Authen::PAAS::BasicUser;

use warnings;
use strict;
use base qw(Authen::PAAS::Principal);

our $VERSION = '1.0.0';

=pod

=item my $principal = Authen::PAAS::BasicUser->new($username);

Creates a new basic user, with the name given by the C<$username>
parameter.

=cut

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self = $class->SUPER::new(name => shift);

    bless $self, $class;

    return $self;
}

1 # So that the require or use succeeds.

__END__

=back 4

=head1 AUTHORS

Daniel Berrange <dan@berrange.com>

=head1 COPYRIGHT

Copyright (C) 2004-2005 Daniel Berrange

=head1 SEE ALSO

L<perl(1)>, L<Authen::PAAS::BasicLoginModule>, L<Authen::PAAS::Principal>

=cut
