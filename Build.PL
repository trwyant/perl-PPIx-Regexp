use strict;
use warnings;

use lib qw{ inc };

use Module::Build;
use PPIx::Regexp::Build;

(my $mbv = Module::Build->VERSION()) =~ s/_//g;
my %args = (
    dist_author => 'Tom Wyant (wyant at cpan dot org)',
    dist_abstract => 'Parse regular expressions',
    module_name => 'PPIx::Regexp',
    build_requires => {
	'Test::More' => 0.40,
    },
    requires => {
	'List::MoreUtils'	=> 0,
	'List::Util'	=> 0,
	'PPI::Document'	=> 0,
	'Params::Util'	=> 0.250,
	'Readonly'	=> 0,
	'Scalar::Util'	=> 0,
    },
    license => 'perl',
);

$mbv >= 0.28 and $args{meta_merge} = {
    no_index => {
	directory => [qw{inc t}],
    },
};

$mbv >= 0.34
    and $args{auto_configure_requires} = 0;	# Don't require PPIx::Regexp::Build

my $bldr = PPIx::Regexp::Build->new (%args);

$bldr->create_build_script ();
