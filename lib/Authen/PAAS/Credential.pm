# -*- perl -*-
#
# Authen::PAAS::Credential by Daniel Berrange
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
# $Id: Credential.pm,v 1.2 2004/12/28 23:43:46 dan Exp $

=pod

=head1 NAME

Authen::PAAS::Credential - blah

=head1 SYNOPSIS

  use Authen::PAAS::Credential;

=head1 DESCRIPTION

Blah

=head1 METHODS

=over 4

=cut

package Authen::PAAS::Credential;

use warnings;
use strict;
use Carp qw(confess);

our $VERSION = '1.0.0';

=pod

=item $obj = Authen::PAAS::Credential->new();

Create

=cut

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self = {};
    my %params = @_;

    $self->{name} = exists $params{name} ? $params{name} : confess "name parameter is required";

    bless $self, $class;

    return $self;
}


sub name {
    my $self = shift;
    return $self->{name};
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
