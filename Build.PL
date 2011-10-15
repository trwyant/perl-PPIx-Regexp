use 5.006;

use strict;
use warnings;

use lib qw{ inc };

use Module::Build;
use PPIx::Regexp::Build;
use PPIx::Regexp::Meta;

(my $mbv = Module::Build->VERSION()) =~ s/_//g;

my $meta = PPIx::Regexp::Meta->new();

my %args = (
    dist_author => 'Tom Wyant (wyant at cpan dot org)',
    dist_abstract => 'Parse regular expressions',
    module_name => 'PPIx::Regexp',
    build_requires => $meta->build_requires(),
    requires => $meta->requires(
	perl => $meta->requires_perl(),
    ),
    dynamic_config => 1,
    license => 'perl',
);

$mbv >= 0.28 and $args{meta_merge} = {
    no_index => {
	directory => [qw{ inc t xt }],
    },
    resources => {
	bugtracker => 'https://rt.cpan.org/Public/Dist/Display.html?Name=PPIx-Regexp',
    },
};

# Don't require Module::Build when building distribution, because user
# can use ExtUtils::MakeMaker.
$mbv >= 0.34
    and $args{auto_configure_requires} = !$meta->distribution();

my $bldr = PPIx::Regexp::Build->new (%args);

$bldr->create_build_script ();

# ex: set textwidth=72 :
