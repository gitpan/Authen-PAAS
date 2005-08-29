# $Id: Makefile.PL,v 1.4 2005/08/21 10:57:05 dan Exp $
# -*- perl -*-

use ExtUtils::MakeMaker;

WriteMakefile(
	      NAME => "Authen::PAAS",
	      VERSION_FROM => 'lib/Authen/PAAS.pm',
	      PREREQ_PM => {
		  "Config::Record" => "1.1.0",
	      },
	      dist =>
	      {
	       COMPRESS => 'gzip --force --best',
	      },

	      clean =>
	      {
	       FILES => '*.bak *~',
	      },
	      
	      depend => {
	        Makefile => '$(VERSION_FROM)',
	      },
	      
	      realclean => {
	       FILES => 'Authen-PAAS-*.tar.gz',
	      },
              EXE_FILES => [
                "bin/authen-paas-passwd.pl"
              ],
	     );

package MY;

sub libscan
  {
    my ($self, $path) = @_;
    ($path =~ /\~$/) ? undef : $path;
  }

sub postamble {
    return '
HTMLDIR = blib/html

HTMLURLPREFIX = /
HTMLPODS = $(MAN3PODS:lib/%.pm=$(HTMLDIR)/%.html)

htmlifypods: $(HTMLDIR) $(HTMLPODS)

$(HTMLDIR):
	mkdir $@

$(HTMLDIR)/%.html: lib/%.pm
	mkdir -p `dirname $@`
	pod2html --htmlroot=$(HTMLURLPREFIX) --infile=$< --outfile=$@ --podpath=$(HTMLDIR)

';
}

sub test {
    my $self = shift;
    my $mm_test = $self->SUPER::test(@_);
    
    return '
TO_TEST_PM = $(TO_INST_PM:lib/%.pm=blib/test/%.pm)

test :: test-syntax

test-syntax: pure_all $(TO_TEST_PM)

blib/test/%.pm: lib/%.pm
	@echo -n "Checking $<: "
	@perl -I blib/lib -c $<
	@mkdir -p `dirname $@`
	@touch $@

' . $mm_test;
  }


__END__
