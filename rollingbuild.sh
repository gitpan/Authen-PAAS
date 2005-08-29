#!/bin/sh

NAME="Authen-PAAS"

# Exit immediately if command fails
set -e

# Print command executed to stdout
set -v

AUTOBUILD_PERL5LIB=`perl -e 'use Config; my $dir = $Config{sitelib}; $dir =~ s|/usr|$ENV{AUTO_BUILD_ROOT}|; print $dir'`
if [ -z "$PERL5LIB" ]; then
  export PERL5LIB=$AUTOBUILD_PERL5LIB
else
  export PERL5LIB=$PERL5LIB:$AUTOBUILD_PERL5LIB
fi

# Make things clean.

[ -f Makefile ] && make -k realclean ||:
rm -rf MANIFEST blib

# Make makefiles.

perl Makefile.PL PREFIX=$AUTO_BUILD_ROOT
make manifest
echo $NAME.spec >> MANIFEST

# Build the RPM.
make
if [ -z "$USE_COVER" ]; then
  perl -MDevel::Cover -e '' 1>/dev/null 2>&1 && USE_COVER=1 || USE_COVER=0
fi
if [ "$USE_COVER" = "1" ]; then
  cover -delete
  HARNESS_PERL_SWITCHES=-MDevel::Cover make test
  cover
  mkdir blib/coverage
  cp -a cover_db/*.html cover_db/*.css blib/coverage
  mv blib/coverage/coverage.html blib/coverage/index.html
else
  make test
fi



make INSTALLMAN3DIR=$AUTO_BUILD_ROOT/share/man/man3 install

rm -f $NAME-*.tar.gz
make dist

if [ -x /usr/bin/rpmbuild ]; then
  rpmbuild -ta --clean $NAME-*.tar.gz
fi

#if [ -x /usr/bin/fakeroot ]; then
#  fakeroot debian/rules clean
#  fakeroot debian/rules DESTDIR=$HOME/packages/debian binary
#fi
