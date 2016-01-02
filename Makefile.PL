use strict;
use warnings;

use lib qw{ inc };

use ExtUtils::MakeMaker;
use My::Module::Meta;

(my $mmv = ExtUtils::MakeMaker->VERSION) =~ s/_//g;

my $meta = My::Module::Meta->new();

my %args = (
    NAME => 'PPIx::Regexp',
    VERSION_FROM => 'lib/PPIx/Regexp.pm',
    PREREQ_PM => $meta->requires(),
    PL_FILES => {},	# Prevent old MakeMaker from running Build.PL
    'dist' => {COMPRESS => 'gzip', SUFFIX => 'gz'},
    AUTHOR => 'Tom Wyant (wyant at cpan dot org)',
    ABSTRACT => 'Parse regular expressions',
);

$mmv >= 6.31 and $args{LICENSE} = 'perl';

$mmv >= 6.4501 and $args{META_ADD} = {
    no_index => {
	directory => [ qw{ inc t xt } ],
    },
};

$mmv >= 6.4501 and $args{META_MERGE} = {
    dynamic_config => 1,
    resources => {
	bugtracker => 'https://rt.cpan.org/Public/Dist/Display.html?Name=PPIx-Regexp',
	license => 'http://dev.perl.org/licenses/',
    },
};

$mmv >= 6.4701 and $args{MIN_PERL_VERSION} = $meta->requires_perl();

$mmv >= 6.5501
    and $args{BUILD_REQUIRES} = $meta->build_requires()
    or $mmv >= 6.4501
    and $args{META_MERGE}{build_requires} = $meta->build_requires();

WriteMakefile (%args);

# ex: set textwidth=72 :
