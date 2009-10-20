package PPIx::Regexp::Test;

use strict;
use warnings;

use base qw{ Exporter };

use Params::Util 0.25 qw{ _INSTANCE };
use PPIx::Regexp;
use PPIx::Regexp::Element;
use PPIx::Regexp::Tokenizer;
use Scalar::Util qw{ looks_like_number refaddr };
use Test::More 0.40;

our $VERSION = '0.000_03';

our @EXPORT_OK = qw{
    cache_count
    choose
    class
    content
    count
    false
    finis
    equals
    navigate
    parse
    plan
    tokenize
    true
    value
};

our @EXPORT = @EXPORT_OK;	## no critic (ProhibitAutomaticExportation)

my ( $parse, $kind, @nav, $nav, $obj );

sub cache_count {		## no critic (RequireArgUnpacking)
    my ( $expect ) = @_;
    defined $expect or $expect = 0;
    $obj = undef;
    $parse = undef;
    _pause();
    @_ = ( PPIx::Regexp->_cache_size(), $expect,
	"Should be $expect leftover cache contents" );
    goto &is;
}

sub choose {
    my @args = @_;
    $obj = $parse;
    return navigate( @args );
}

# quote a string.
sub _safe {
    my @args = @_;
    my @rslt;
    foreach my $item ( @args ) {
	if ( _INSTANCE( $item, 'PPIx::Regexp::Element' ) ) {
	    $item = $item->content();
	}
	if ( ! defined $item ) {
	    push @rslt, 'undef';
	} elsif ( ref $item eq 'ARRAY' ) {
	    push @rslt, join( ' ', '[', _safe( @{ $item } ), ']' );
	} elsif ( looks_like_number( $item ) ) {
	    push @rslt, $item;
	} else {
	    $item =~ s/ ( [\\'] ) /\\$1/smxg;
	    push @rslt, "'$item'";
	}
    }
    return join( ', ', @rslt );
}

sub class {		## no critic (RequireArgUnpacking)
    my @args = @_;
    my $class = pop @args;
    if ( defined $class ) {
	@_ = ( $obj, $class, "$kind $nav" );
	goto &isa_ok;
    } else {
	@_ = ( ref $obj || undef, $class, "Class of $kind $nav" );
	goto &is;
    }
}

sub content {		## no critic (RequireArgUnpacking)
    my @args = @_;
    my $expect = pop @args;
    my $content;
    defined $obj and $content = $obj->content();
    my $safe;
    if ( defined $content ) {
	($safe = $content) =~ s/([\\'])/\\$1/smxg;
    } else {
	$safe = 'undef';
    }
    @_ = ( $content, $expect, "$kind $nav content '$safe'" );
    goto &is;
}

sub count {		## no critic (RequireArgUnpacking)
    my ( @args ) = @_;
    my $expect = pop @args;
    if ( ref $parse eq 'ARRAY' ) {
	@_ = ( scalar @{ $parse }, $expect, "Expect $expect tokens" );
    } elsif ( ref $obj eq 'ARRAY' ) {
	@_ = ( scalar @{ $obj }, $expect, "Expect $expect tokens" );
    } elsif ( $obj->can( 'children' ) ) {
	@_ = ( scalar $obj->children(), $expect, "Expect $expect children" );
    } else {
	@_ = ( $obj->can( 'children' ), ref( $obj ) . "->can( 'children')" );
	goto &ok;
    }
    goto &is;
}

sub equals {		## no critic (RequireArgUnpacking)
    my @args = @_;
    @args < 3 and unshift @args, $obj;
    my ( $left, $right, $name ) = @args;
    if ( ! defined $left && ! defined $right ) {
	@_ = ( 1, $name );
    } elsif ( ! defined $left || ! defined $right ) {
	@_ = ( undef, $name );
    } elsif ( ref $left && ref $right ) {
	@_ = ( refaddr( $left ) == refaddr( $right ), $name );
    } elsif ( ref $left || ref $right ) {
	@_ = ( undef, $name );
    } elsif ( looks_like_number( $left ) && looks_like_number( $right ) ) {
	@_ = ( $left == $right, $name );
    } else {
	@_ = ( $left eq $right, $name );
    }
    goto &ok;
}

sub false {		## no critic (RequireArgUnpacking)
    my @args = @_;
    my ( $method, $args ) = splice @args, -2;
    ref $args eq 'ARRAY' or $args = [ $args ];
    my $class = ref $obj;
    if ( $obj->can( $method ) ) {
	@_ = ( ! $obj->$method( @{ $args || [] } ),
	    "$class->$method() is false" );
    } else {
	@_ = ( undef, "$class->$method() exists" );
    }
    goto &ok;
}

sub finis {		## no critic (RequireArgUnpacking)
    $obj = undef;
    $parse = undef;
    _pause();
    @_ = ( PPIx::Regexp::Element->_parent_keys(), 0,
	'Should be no leftover objects' );
    goto &is;
}

{

    my %array = map { $_ => 1} qw{ start type children finish };

    sub navigate {
	my @args = @_;
	my $scalar = 1;
	@args > 1
	    and ref $args[-1] eq 'ARRAY'
	    and @{ $args[-1] } == 0
	    and $array{$args[-2]}
	    and $scalar = 0;
	@nav = ();
	while ( @args ) {
	    if ( _INSTANCE( $args[0], 'PPIx::Regexp::Element' ) ) {
		$obj = shift @args;
	    } elsif ( ref $obj eq 'ARRAY' ) {
		my $inx = shift @args;
		push @nav, $inx;
		$obj = $obj->[$inx];
	    } else {
		my $method = shift @args;
		my $args = shift @args;
		ref $args eq 'ARRAY' or $args = [ $args ];
		push @nav, $method, $args;
		$obj->can( $method ) or return;
		if ( @args || $scalar ) {
		    $obj = $obj->$method( @{ $args } ) or return;
		} else {
		    $obj = [ $obj->$method( @{ $args } ) ];
		}
	    }
	}
	$nav = _safe( @nav );
	$nav =~ s/ ' ( \w+ ) ' , /$1 =>/smxg;
	$nav =~ s/ \[ \s+ \] /[]/smxg;
	return $obj;
    }

}

sub parse {		## no critic (RequireArgUnpacking)
    my ( $regexp ) = @_;
    $kind = 'element';
    $obj = $parse = PPIx::Regexp->new( $regexp );
    $nav = '';
    @_ = ( $parse, 'PPIx::Regexp', $regexp );
    goto &isa_ok;
}

sub tokenize {		## no critic (RequireArgUnpacking)
    my ( $regexp, @args ) = @_;
    $kind = 'token';
    my $obj = PPIx::Regexp::Tokenizer->new( $regexp, @args );
    if ( $obj ) {
	$parse = [ $obj->tokens() ];
    } else {
	$parse = [];
    }
    $nav = '';
    @_ = ( $obj, 'PPIx::Regexp::Tokenizer', $regexp );
    goto &isa_ok;
}

sub true {		## no critic (RequireArgUnpacking)
    my @args = @_;
    my ( $method, $args ) = splice @args, -2;
    ref $args eq 'ARRAY' or $args = [ $args ];
    my $class = ref $obj;
    if ( $obj->can( $method ) ) {
	@_ = ( $obj->$method( @{ $args || [] } ),
	    "$class->$method() is true" );
    } else {
	@_ = ( undef, "$class->$method() exists" );
    }
    goto &ok;
}

sub value {		## no critic (RequireArgUnpacking)
    my ( @args ) = @_;
    my ( $method, $args, $expect ) = splice @args, -3;
    ref $args eq 'ARRAY' or $args = [ $args ];
    my $class = ref $obj;

    if ( ! $obj->can( $method ) ) {
	@_ = ( undef, "$class->$method() exists" );
	goto &ok;
    }

    if ( ref $expect eq 'ARRAY' ) {
	@_ = ( [ $obj->$method( @{ $args || [] } ) ], $expect, $method );
	goto &is_deeply;
    }

    @_ = ( $obj->$method( @{ $args || [] } ), $expect, $method );
    goto &is;
}

sub _pause {
    if ( eval { require Time::HiRes; 1 } ) {	# Cargo cult programming.
	Time::HiRes::sleep( 0.1 );		# Something like this is
    } else {					# in PPI's
	sleep 1;				# t/08_regression.t, and
    }						# who am I to argue?
    return;
}

1;

__END__

=head1 NAME

PPIx::Regexp::Test - support for testing PPIx::Regexp

=head1 SYNOPSIS

 use lib qw{ inc };
 use PPIx::Regexp::Test;

 parse   ( '/foo/' );
 value   ( failures => [], 0 );
 class   ( 'PPIx::Regexp' );
 choose  ( child => 0 );
 class   ( 'PPIx::Regexp::Token::Structure' );
 content ( '' );
 # and so on

=head1 DETAILS

This package exports various subroutines in support of testing
C<PPIx::Regexp>. Most of these are tests, with C<Test::More> doing the
dirty work. A few simply set up data for tests.

The whole test rig works by parsing (or tokenizing) a regular
expression, followed by a series of unit tests on the results of the
parse. Each set of unit tests is performed by selecting an object to
test using the C<choose> or C<navigate> subroutine, followed by the
tests to be performed on that object. A few tests do not test parse
objects, but rather the state of the system as a whole.

The following subroutines are exported:

=head2 cache_count

 cache_count( 1 );

This test compares the number of objects in the C<new_from_cache> cache
to its argument, succeeding if they are equal. If no argument is passed,
the default is 0.

=head2 choose

 choose( 2 );  # For tokenizer
 choose( child => 1, child => 2, type => 0 ); # For full parse

This subroutine does not itself represent a test. It chooses an object
from the parse tree for further testing. If testing a tokenizer, the
argument is the token number (from 0) to select. If testing a full
parse, the arguments are the navigation methods used to reach the
object to be tested, starting from the C<PPIx::Regexp> object. The
arguments to the methods are passed in an array reference, but if there
is a single argument it can be passed as a scalar, as in the example.

=head2 class

 class( 'PPIx::Regexp::Token::Structure' );

This test checks to see if the current object is of the given class, and
succeeds if it is. If the current object is C<undef>, the test fails.

=head2 content

 content( '\N{LATIN SMALL LETTER A}' );

This test checks to see if the C<content> method of the current object
is equal to the given string. If the current object is C<undef>, the
test fails.

=head2 count

 count( 42 );

This test checks the number of objects returned by an operation that
returns more than one object. It succeeds if the number of objects
returned is equal to the given number.

This test is valid only after C<tokenize>, or a C<choose> or C<navigate>
whose argument list ends in one of

 children => []
 finish => []
 start => []
 type => []

=head2 false

 false( significant => [] );

This test succeeds if the given method, with the given arguments, called
on the current object, returns a false value.

=head2 finis

 finis();

This test should be last in a series, and no references to parse objects
should be held when it is run. It checks the number of objects in the
internal C<%parent> hash, and succeeds if it is zero.

=head2 equals

 equals( $o1, $o2, 'Test name' );

This test compares two things, succeeding if they are equal. References
are compared by reference address and scalars by value (numeric or string
comparison as appropriate). If the first argument is omitted it defaults
to the current object.

=head2 navigate

 navigate( snext_sibling => [] );

Like C<choose>, this is not a test, but selects an object for testing.
Unlike C<choose>, selection starts from the current object, not the top
of the parse tree.

=head2 parse

 parse( 's/foo/bar/g' );

This test parses the given regular expression into a C<PPIx::Regexp>
object, and succeeds if a C<PPIx::Regexp> object was in fact generated.

=head2 plan

This subroutine is exported from R<Test::More|Test::More>.

=head2 tokenize

 tokenize( 'm/foo/smx' );

This test tokenizes the given regular expression into a
C<PPIx::Regexp::Tokenizer> object, and succeeds if a
C<PPIx::Regexp::Tokenizer> object was in fact generated.

=head2 true

 true( significant => [] );

This test succeeds if the given method, with the given arguments, called
on the current object, returns a true value.

=head2 value

 value( max_capture_number => [], 3 );

This test succeeds if the given method, with the given arguments, called
on the current object, returns the given value.

=head1 SUPPORT

Support is by the author. Please file bug reports at
L<http://rt.cpan.org>, or in electronic mail to the author.

=head1 AUTHOR

Thomas R. Wyant, III F<wyant at cpan dot org>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009, Thomas R. Wyant, III

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl 5.10.0. For more details, see the full text
of the licenses in the directory LICENSES.

This program is distributed in the hope that it will be useful, but
without any warranty; without even the implied warranty of
merchantability or fitness for a particular purpose.

=cut

# ex: set textwidth=72 :
