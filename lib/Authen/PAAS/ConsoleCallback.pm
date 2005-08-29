# -*- perl -*-
#
# Authen::PAAS::ConsoleCallback by Daniel Berrange
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
# $Id: ConsoleCallback.pm,v 1.1 2005/08/21 07:39:37 dan Exp $

=pod

=head1 NAME

Authen::PAAS::ConsoleCallback - blah

=head1 SYNOPSIS

  use Authen::PAAS::ConsoleCallback;

  my $callback = Authen::PAAS::ConsoleCallback->new("Enter username: ");
  my $username = $callback->data;

=head1 DESCRIPTION

This provides a callback which prompts for data on STDOUT,
and reads a response from STDIN.

=head1 METHODS

=over 4

=cut

package Authen::PAAS::ConsoleCallback;

use base qw(Authen::PAAS::Callback);
use strict;
use Carp qw(confess);
use IO::Handle;

our $VERSION = '1.0.0';

=pod

=item my $callback = Authen::PAAS::ConsoleCallback->new($label);

Create a new console callback, using the C<$label> parameter 
as the prompt to display on STDOUT.

=cut

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self = $class->SUPER::new();

    $self->{label} = shift;

    bless $self, $class;

    return $self;
}

=pod

=item my $data = $callback->data;

Displays a prompt on STDOUT (flushing buffers, in case the prompt
did not contain a newline). A response is then read from STDIN,
with any leading or trailing whitespace is trimmed, before the data
is returned

=cut

sub data {
    my $self = shift;
    
    print $self->{label};
    flush STDOUT;

    my $data = <STDIN>;
    $data =~ s/^\s*//g;
    $data =~ s/\s*$//g;
    return $data;
}

1 # So that the require or use succeeds.

__END__

=back 4

=head1 AUTHORS

Daniel Berrange <dan@berrange.com>

=head1 COPYRIGHT

Copyright (C) 2004-2005 Daniel Berrange

=head1 SEE ALSO

L<perl(1)>

=cut
