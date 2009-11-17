use strict;
use warnings;

use ExtUtils::MakeMaker;

(my $mmv = ExtUtils::MakeMaker->VERSION) =~ s/_//g;

my %args = (
    NAME => 'PPIx::Regexp',
    VERSION_FROM => 'lib/PPIx/Regexp.pm',
    PREREQ_PM => {
	'List::MoreUtils'	=> 0,
	'List::Util'	=> 0,
	'PPI::Document'	=> 0,
	'Params::Util'	=> 0.250,
	'Readonly'	=> 0,
	'Scalar::Util'	=> 0,
	'Task::Weaken'	=> 0,
    },
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
    build_requires => {
	'Test::More' => 0.40,
    },
    resources => {
	license => 'http://dev.perl.org/licenses/',
    },
};

WriteMakefile (%args);

