# -*- perl -*-
#
# Authen::PAAS::Callback by Daniel Berrange
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
# $Id: Callback.pm,v 1.2 2005/08/21 07:39:37 dan Exp $

=pod

=head1 NAME

Authen::PAAS::Callback - callback for retrieving authentication data

=head1 SYNOPSIS

  use Authen::PAAS::Callback;

  my $callback = Authen::PAAS::Callback::SOMECLASS->new();
  my $data = $callback->data;

=head1 DESCRIPTION

This module provides an mechanism for login modules to retrieve
authentication data from an external party, without having to 
know the means of communication between the application and the
user. So, a login module can merely lookup the callback associated
with the key C<username>, and ask it for data, regardless of whether
the callback reads the username from the console, pops up a dialog
box, or fetches it from the HTTP headers.

=head1 METHODS

=over 4

=cut

package Authen::PAAS::Callback;

#use base qw();
use strict;
use Carp qw(confess);

our $VERSION = '1.0.0';

=pod

=item my $callback = Authen::PAAS::Callback->new();

Creates a new callback object. There are no required parameters
to this  constructor.

=cut

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self = {};
    my %params = @_;

    bless $self, $class;

    return $self;
}


=pod

=item my $data = $callback->data;

Retrieves the data from this callback. This method must be 
implemented by the subclass, and it is entirely upto the
subclass how the data is collected from the user. 

=cut

sub data {
    my $self = shift;
    confess "object " . ref($self) . " forgot to implement the data method";
}

1 # So that the require or use succeeds.

__END__

=back 4

=head1 AUTHORS

Daniel Berrange <dan@berrange.com>

=head1 COPYRIGHT

Copyright (C) 2004-2005 Daniel Berrange

=head1 SEE ALSO

L<perl(1)>, L<Authen::PAAS::Context>, L<Authen::PAAS::LoginModule>

=cut
