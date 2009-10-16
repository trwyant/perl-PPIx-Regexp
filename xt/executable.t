package main;

use strict;
use warnings;

BEGIN {

    eval {
	require Test::More;
	Test::More->VERSION(0.40);
	Test::More->import();
	1;
    } or do {
	print "1..0 # skip Test::More required to check manifest.\n";
	exit;
    };

    eval {
	require ExtUtils::Manifest;
	ExtUtils::Manifest->import( 'maniread' );
	1;
    } or do {
	print "1..0 # skip ExtUtils::Manifest required to check manifest.\n";
	exit;
    };

}

my $manifest = maniread ();

my @check;
foreach (sort keys %$manifest) {
    m/ \A bin \b /smx and next;
    m/ \A eg \b /smx and next;
    m/ \A tools \b /smx and next;
    push @check, $_;
}

plan (tests => scalar @check);

my $test = 0;
foreach my $file (@check) {
    open (my $fh, '<', $file) or die "Unable to open $file: $!\n";
    local $_ = <$fh>;
    defined $_ or $_ = '';
    close $fh;
    if ( my @stat = stat $file ) {
	ok( !($stat[2] & oct(111) || m/^#!.*perl/), $file );
    } else {
	warn "Can not stat $file";
	ok ( 1, $file );
    }
}

1;
