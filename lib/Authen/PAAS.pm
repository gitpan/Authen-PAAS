# -*- perl -*-
#
# Copyright (C) 2004-2005 Daniel Berrange
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

package Authen::PAAS;

use vars qw($VERSION);

$VERSION = "1.1.0";

=pod

=head1 NAME 

Authen::PAAS - Perl Authentication & Authorization Service

=head1 SYNOPSIS

  use Authen::PAAS::Context
  use Authen::PAAS::SimpleCallback;
  use Config::Record;
  
  my $config = Config::Record->new("/etc/myapp.cfg");

  my $context = Authen::PAAS::Context->new($config, "myapp");

  my $callbacks = {
    "username" => Authen::PAAS::SimpleCallback->new("joeblogs"),
    "password" => Authen::PAAS::SimpleCallback->new("123456"),
  };

  my $subject = $context->login($callbacks);

  unless ($subject) {
     die "could not authenticate subject"
  }

  .. do some work using the subject ..

  $context->logout($subject);


=head1 DESCRIPTION

The C<Authen::PAAS> distribution provides a Perl API for authenticating 
and authorizing users of computing services. Its design is inspired by 
existing pluggable authentication services such as C<PAM> and Java's
C<JAAS>, so people familiar with those two services should be comfortable
with the concepts in C<Authen::PAAS>. At its heart, C<Authen::PAAS> provides
a login service, with pluggable modules for performing different authentication 
schemes. The pluggable framework enables the system  administrator, rather 
than the application developer to define what method is used to authentication 
with a particular application.

One might ask, why not just use PAM directly via the existing 
L<Authen::PAM> Perl bindings. While this works well for applications 
which wish to authenticate against real UNIX user accounts (eg FTP, 
Telnet, SSH), it is not particularly well suited to applications 
with 'virtualized' user accounts. For example, a web application may 
maintain a set of virtual user accounts in a database, or a chat server, 
may maintain a set of user accounts in a text configuration file.
Since it merely delegates through to the underlying C libraries, 
the L<Authen::PAM> module does not provide a convenient means to
write new authentication schemes in Perl. Thus the C<Authen::PAAS> 
distribution provides a pure Perl API for authentication.

=head1 COPYRIGHT

Copyright 2004-2005 Daniel Berrange <dan@berrange.com>

=head1 SEE ALSO

L<Authen::PAAS::Context>, L<Authen::PAAS::Subject>, L<pam(8)>, L<Authen::PAM>

=cut

