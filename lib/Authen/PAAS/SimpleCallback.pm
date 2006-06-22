# -*- perl -*-
#
# Authen::PAAS::SimpleCallback by Daniel Berrange
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
# $Id: SimpleCallback.pm,v 1.1 2005/04/23 22:45:36 dan Exp $

=pod

=head1 NAME

Authen::PAAS::SimpleCallback - A callback implementation with static data

=head1 SYNOPSIS

  use Authen::PAAS::SimpleCallback;

  my $cb = Authen::PAAS::SimpleCallback->new(data => "joe");

  print $cb->data, "\n";

=head1 DESCRIPTION

This module provides a trivial subclass of the L<Authen::PAAS::Callback>
which always returns a pre-defined chunk of static data.

=head1 METHODS

=over 4

=cut

package Authen::PAAS::SimpleCallback;

use base qw(Authen::PAAS::Callback);

use strict;
use warnings;

our $VERSION = '1.0.0';


=item $cb = Authen::PAAS::SimpleCallback->new(data => $data);

Create a new callback object which will later provide the piece
of static data defined by the C<data> parameter. The data can be
of an arbitrary Perl data type, it is treated opaquely by this
module.

=cut

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self = $class->SUPER::new();

    $self->{data} = shift;

    bless $self, $class;

    return $self;
}

=item $cb->data;

Retrieve the data associated with this callback object. The
returned data will be that which was orginally passed into
the constructor.

=cut

sub data {
    my $self = shift;
    return $self->{data};
}

1 # So that the require or use succeeds.

__END__

=back

=head1 AUTHORS

Daniel Berrange <dan@berrange.com>

=head1 COPYRIGHT

Copyright (C) 2004-2006 Daniel Berrange

=head1 SEE ALSO

L<Authen::PAAS::Context>, L<Authen::PAAS::Callback>

=cut
