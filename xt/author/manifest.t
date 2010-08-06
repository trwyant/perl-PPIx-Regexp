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
##	ExtUtils::Manifest->import (qw{manicheck filecheck});
	1;
    } or do {
	print "1..0 # skip ExtUtils::Manifest required to check manifest.\n";
	exit;
    };

}

plan tests => 2;

foreach ([manicheck => 'Missing files per manifest'],
    [filecheck => 'Files not in MANIFEST or MANIFEST.SKIP'],
) {
    my ($subr, $title) = @$_;
    my @got = ExtUtils::Manifest->$subr();
    ok ( @got == 0, $title );
}

1;
