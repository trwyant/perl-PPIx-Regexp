package main;

use strict;
use warnings;

use lib qw{ inc };

use PPIx::Regexp::Test;

plan 'no_plan';

{

    # The navigation tests get done in their own local scope so that all
    # the object references we have held go away when we are done.

    parse   ( '/ ( 1 2(?#comment)) /x' );

    my $lit1 = choose( find_first => 'Token::Literal' );
    class   ( 'PPIx::Regexp::Token::Literal' );
    content ( '1' );
    true    ( significant => [] );
    false   ( whitespace => [] );
    false   ( comment => [] );

    navigate( next_sibling => [] );
    class   ( 'PPIx::Regexp::Token::Whitespace' );
    content ( ' ' );
    false   ( significant => [] );
    true    ( whitespace => [] );
    false   ( comment => [] );

    my $lit2 = navigate( next_sibling => [] );
    class   ( 'PPIx::Regexp::Token::Literal' );
    content ( '2' );

    navigate( previous_sibling => [] );

    navigate( previous_sibling => [] );
    equals  ( $lit1, 'Two previouses undo two nexts' );

    navigate( snext_sibling => [] );
    equals  ( $lit2, 'A snext gets us the next significant token' );

    navigate( sprevious_sibling => [] );
    equals  ( $lit1, 'An sprevious gets us back' );

    navigate( previous_sibling => [] );
    equals  ( undef, 'Nobody before the first literal' );

    navigate( $lit2, next_sibling => [] );
    class   ( 'PPIx::Regexp::Token::Comment' );
    content ( '(?#comment)' );
    false   ( significant => [] );
    false   ( whitespace => [] );
    true    ( comment => [] );

    navigate( next_sibling => [] );
    equals  ( undef, 'Nobody after second whitespace' );

    navigate( $lit2, snext_sibling => [] );
    equals  ( undef, 'Nobody significant after second literal' );

    navigate( $lit1, sprevious_sibling => [] );
    equals  ( undef, 'Nobody significant before first literal' );

    navigate( $lit1, parent => [] );
    class   ( 'PPIx::Regexp::Structure::Capture' );

    my $top = navigate( top => [] );
    class   ( 'PPIx::Regexp' );
    true    ( ancestor_of => $lit1 );

    navigate( $lit1 );
    true    ( descendant_of => $top );

    choose  ( find => 'Token::Literal' );
    count   ( 2 );
    navigate( -1 );
    equals  ( $lit2, 'The last literal is the second one' );

    choose  ( find => sub {
	    ref $_[1] eq 'PPIx::Regexp::Token::Literal'
		or return 0;
	    $_[1]->content() eq '2'
		or return 0;
	    return 1;
	} );
    count   ( 1 );
    navigate( 0 );
    equals  ( $lit2, 'We found the second literal again' );

    navigate( parent => [], schild => 1 );
    equals  ( $lit2, 'The second significant child is the second literal' );

    navigate( parent => [], schild => -2 );
    equals  ( $lit1, 'The -2nd significant child is the first literal' );

}

SKIP:
{

    # The cache tests get done in their own scope to ensure the objects
    # are destroyed.

    my $num_tests = 3;
    eval {
	require PPI::Document;
	1;
    } or skip( $num_tests, 'Failed to load PPI::Document' );
    my $doc = PPI::Document->new( \'m/foo/smx' )
	or skip( $num_tests, 'Failed to create PPI::Document' );
    my $m = $doc->find_first( 'PPI::Token::Regexp::Match' )
	or skip( $num_tests, 'Failed to find PPI::Token::Regexp::Match' );

    my $o1 = PPIx::Regexp->new_from_cache( $m );
    my $o2 = PPIx::Regexp->new_from_cache( $m );

    equals( $o1, $o2, 'new_from_cache() same object' );

    cache_count( 1 );

    PPIx::Regexp->flush_cache();

    cache_count();

}


tokenize( '//smx' );
count   ( 4 );
choose  ( 3 );
class   ( 'PPIx::Regexp::Token::Modifier' );
content ( 'smx' );
true    ( asserts => 's' );
true    ( asserts => 'm' );
true    ( asserts => 'x' );
false   ( negates => 'i' );

tokenize( 'qr/foo{3}/' );
count   ( 10 );
choose  ( 7 );
class   ( 'PPIx::Regexp::Token::Structure' );
content ( '}' );
false   ( can_be_quantified => [] );
true    ( is_quantifier => [] );

tokenize( 'qr/foo{3,}/' );
count   ( 11 );
choose  ( 8 );
class   ( 'PPIx::Regexp::Token::Structure' );
content ( '}' );
false   ( can_be_quantified => [] );
true    ( is_quantifier => [] );

tokenize( 'qr/foo{3,5}/' );
count   ( 12 );
choose  ( 9 );
class   ( 'PPIx::Regexp::Token::Structure' );
content ( '}' );
false   ( can_be_quantified => [] );
true    ( is_quantifier => [] );

tokenize( 'qr/foo{,3}/' );
count   ( 11 );
choose  ( 8 );
class   ( 'PPIx::Regexp::Token::Structure' );
content ( '}' );
false   ( can_be_quantified => [] );
false   ( is_quantifier => [] );

tokenize( '/{}/' );
count   ( 6 );
choose  ( 3 );
class   ( 'PPIx::Regexp::Token::Structure' );
content ( '}' );
false   ( can_be_quantified => [] );
false   ( is_quantifier => [] );

tokenize( '/x{}/' );
count   ( 7 );
choose  ( 4 );
class   ( 'PPIx::Regexp::Token::Structure' );
content ( '}' );
false   ( can_be_quantified => [] );
false   ( is_quantifier => [] );

tokenize( '/{2}/' );
count   ( 7 );
choose  ( 4 );
content ( '}' );
false   ( can_be_quantified => [] );
false   ( is_quantifier => [] );

tokenize( '/\\1?\\g{-1}*\\k<foo>{1,3}+/' );
count   ( 15 );
choose  ( 2 );
class   ( 'PPIx::Regexp::Token::Backreference' );
content ( '\\1' );
true    ( can_be_quantified => [] );
false   ( is_quantifier => [] );
value   ( perl_version_introduced => [], '5.006' );
choose  ( 4 );
class   ( 'PPIx::Regexp::Token::Backreference' );
content ( '\\g{-1}' );
true    ( can_be_quantified => [] );
false   ( is_quantifier => [] );
value   ( perl_version_introduced => [], '5.010' );
choose  ( 6 );
class   ( 'PPIx::Regexp::Token::Backreference' );
content ( '\\k<foo>' );
true    ( can_be_quantified => [] );
false   ( is_quantifier => [] );
value   ( perl_version_introduced => [], '5.010' );

tokenize( '/\\\\d{3,5}+.*?/' );
count   ( 15 );
choose  ( 9 );
class   ( 'PPIx::Regexp::Token::Greediness' );
content ( '+' );
value   ( perl_version_introduced => [], '5.010' );
choose  ( 12 );
class   ( 'PPIx::Regexp::Token::Greediness' );
content ( '?' );
value   ( perl_version_introduced => [], '5.006' );

tokenize( '/(?<foo>bar)/' );
count   ( 10 );
choose  ( 3 );
class   ( 'PPIx::Regexp::Token::GroupType::NamedCapture' );
content ( '?<foo>' );
value   ( name => [], 'foo' );
value   ( perl_version_introduced => [], '5.010' );

tokenize( '/(?\'for\'bar)/' );
count   ( 10 );
choose  ( 3 );
value   ( name => [], 'for' );
value   ( perl_version_introduced => [], '5.010' );

tokenize( '/(?P<fur>bar)/' );
count   ( 10 );
choose  ( 3 );
value   ( name => [], 'fur' );
value   ( perl_version_introduced => [], '5.010' );

tokenize( '/(*PRUNE:foo)x/' );
count   ( 6 );
choose  ( 2 );
class   ( 'PPIx::Regexp::Token::Backtrack' );
content ( '(*PRUNE:foo)' );
value   ( perl_version_introduced => [], '5.010' );

tokenize( 's/foo\\Kbar/baz/' );
count   ( 15 );
choose  ( 5 );
class   ( 'PPIx::Regexp::Token::Assertion' );
content ( '\\K' );
value   ( perl_version_introduced => [], '5.010' );

tokenize( '/(*PRUNE:foo)x/' );
count   ( 6 );
choose  ( 2 );
class   ( 'PPIx::Regexp::Token::Backtrack' );
content ( '(*PRUNE:foo)' );
value   ( perl_version_introduced => [], '5.010' );

tokenize( '/(?|(foo))/' );
count   ( 12 );
choose  ( 3 );
class   ( 'PPIx::Regexp::Token::GroupType::BranchReset' );
content ( '?|' );
value   ( perl_version_introduced => [], '5.010' );

parse   ( '/(?|(?<baz>foo(wah))|(bar))(hoo)/' );
value   ( failures => [], 0 );
value   ( max_capture_number => [], 3 );
value   ( capture_names => [], [ 'baz' ] );
value   ( perl_version_introduced => [], '5.010' );
class   ( 'PPIx::Regexp' );
count   ( 3 );
choose  ( child => 1, child => 0 );
class   ( 'PPIx::Regexp::Structure::BranchReset' );
count   ( 3 );
choose  ( child => 1, child => 0, start => 0 );
class   ( 'PPIx::Regexp::Token::Structure' );
content ( '(' );
choose  ( child => 1, child => 0, type => 0 );
class   ( 'PPIx::Regexp::Token::GroupType::BranchReset' );
content ( '?|' );
choose  ( child => 1, child => 0, finish => 0 );
class   ( 'PPIx::Regexp::Token::Structure' );
content ( ')' );
choose  ( child => 1, child => 0, child => 0 );
class   ( 'PPIx::Regexp::Structure::NamedCapture' );
count   ( 4 );
value   ( number => [], 1 );
value   ( name => [], 'baz' );
choose  ( child => 1, child => 0, child => 0, start => 0 );
class   ( 'PPIx::Regexp::Token::Structure' );
content ( '(' );
choose  ( child => 1, child => 0, child => 0, type => 0 );
class   ( 'PPIx::Regexp::Token::GroupType::NamedCapture' );
content ( '?<baz>' );
choose  ( child => 1, child => 0, child => 0, finish => 0 );
class   ( 'PPIx::Regexp::Token::Structure' );
content ( ')' );
choose  ( child => 1, child => 0, child => 0, child => 3 );
class   ( 'PPIx::Regexp::Structure::Capture' );
count   ( 3 );
value   ( number => [], 2 );
choose  ( child => 1, child => 0, child => 0, child => 3, start => 0 );
class   ( 'PPIx::Regexp::Token::Structure' );
content ( '(' );
choose  ( child => 1, child => 0, child => 0, child => 3, type => 0 );
class   ( undef );
content ( undef );
choose  ( child => 1, child => 0, child => 0, child => 3, finish => 0 );
class   ( 'PPIx::Regexp::Token::Structure' );
content ( ')' );
choose  ( child => 1, child => 0, child => 1 );
class   ( 'PPIx::Regexp::Token::Operator' );
content ( '|' );
true    ( significant => [] );
true    ( can_be_quantified => [] );
false   ( is_quantifier => [] );
choose  ( child => 1, child => 0, child => 2 );
class   ( 'PPIx::Regexp::Structure::Capture' );
count   ( 3 );
value   ( number => [], 1 );
choose  ( child => 1, child => 0, child => 2, start => 0 );
class   ( 'PPIx::Regexp::Token::Structure' );
content ( '(' );
choose  ( child => 1, child => 0, child => 2, type => 0 );
class   ( undef );
content ( undef );
choose  ( child => 1, child => 0, child => 2, finish => 0 );
class   ( 'PPIx::Regexp::Token::Structure' );
content ( ')' );
choose  ( child => 1, child => 1 );
class   ( 'PPIx::Regexp::Structure::Capture' );
count   ( 3 );
value   ( number => [], 3 );
choose  ( child => 1, child => 1, start => 0 );
class   ( 'PPIx::Regexp::Token::Structure' );
content ( '(' );
choose  ( child => 1, child => 1, type => 0 );
class   ( undef );
content ( undef );
choose  ( child => 1, child => 1, finish => 0 );
class   ( 'PPIx::Regexp::Token::Structure' );
content ( ')' );

parse   ( 's/(foo)/${1}bar/g' );
class   ( 'PPIx::Regexp' );
value   ( failures => [], 0 );
value   ( max_capture_number => [], 1 );
value   ( capture_names => [], [] );
value   ( perl_version_introduced => [], '5.006' );
count   ( 4 );
choose  ( type => 0 );
content ( 's' );
choose  ( regular_expression => [] );
content ( '/(foo)/' );
choose  ( replacement => [] );
content ( '${1}bar/' );
choose  ( modifier => [] );
content ( 'g' );

tokenize( '/((((((((((x))))))))))\\10/' );
count   ( 26 );
choose  ( 23 );
class   ( 'PPIx::Regexp::Token::Backreference' );
content ( '\\10' );

parse   ( '/((((((((((x))))))))))\\10/' );
value   ( failures => [], 0);
class   ( 'PPIx::Regexp' );
count   ( 3 );
choose  ( child => 1 );
class   ( 'PPIx::Regexp::Structure::Regexp' );
count   ( 2 );
choose  ( child => 1, start => 0 );
class   ( 'PPIx::Regexp::Token::Delimiter' );
content ( '/' );
choose  ( child => 1, type => 0 );
class   ( undef );
content ( undef );
choose  ( child => 1, finish => 0 );
class   ( 'PPIx::Regexp::Token::Delimiter' );
content ( '/' );
choose  ( child => 1, child => 1 );
class   ( 'PPIx::Regexp::Token::Backreference' );
content ( '\\10' );

tokenize( '/(((((((((x)))))))))\\10/' );
count   ( 24 );
choose  ( 21 );
class   ( 'PPIx::Regexp::Token::Backreference' );
content ( '\\10' );

parse   ( '/(((((((((x)))))))))\\10/' );
value   ( failures => [], 0);
class   ( 'PPIx::Regexp' );
count   ( 3 );
choose  ( child => 0 );
class   ( 'PPIx::Regexp::Token::Structure' );
content ( '' );
choose  ( child => 1 );
class   ( 'PPIx::Regexp::Structure::Regexp' );
count   ( 2 );
choose  ( child => 1, start => 0 );
class   ( 'PPIx::Regexp::Token::Delimiter' );
content ( '/' );
choose  ( child => 1, type => 0 );
class   ( undef );
content ( undef );
choose  ( child => 1, finish => 0 );
class   ( 'PPIx::Regexp::Token::Delimiter' );
content ( '/' );
choose  ( child => 1, child => 1 );
class   ( 'PPIx::Regexp::Token::Literal' );
content ( '\\10' );

parse   ( '/\\1/' );
value   ( failures => [], 0);
class   ( 'PPIx::Regexp' );
count   ( 3 );
choose  ( child => 1 );
class   ( 'PPIx::Regexp::Structure::Regexp' );
count   ( 1 );
choose  ( child => 1, child => 0 );
class   ( 'PPIx::Regexp::Token::Backreference' );
content ( '\\1' );
value   ( absolute => [], 1 );
false   ( is_named => [] );
value   ( name => [], undef );
value   ( number => [], 1 );

parse   ( '/\\g1/' );
value   ( failures => [], 0);
class   ( 'PPIx::Regexp' );
count   ( 3 );
choose  ( child => 1 );
class   ( 'PPIx::Regexp::Structure::Regexp' );
count   ( 1 );
choose  ( child => 1, child => 0 );
class   ( 'PPIx::Regexp::Token::Backreference' );
content ( '\\g1' );
value   ( absolute => [], 1 );
false   ( is_named => [] );
value   ( name => [], undef );
value   ( number => [], 1 );

parse   ( '/(x)\\g-1/' );
value   ( failures => [], 0);
class   ( 'PPIx::Regexp' );
count   ( 3 );
choose  ( child => 0 );
class   ( 'PPIx::Regexp::Token::Structure' );
content ( '' );
choose  ( child => 1 );
class   ( 'PPIx::Regexp::Structure::Regexp' );
count   ( 2 );
choose  ( child => 1, child => 0 );
class   ( 'PPIx::Regexp::Structure::Capture' );
count   ( 1 );
choose  ( child => 1, child => 0, start => 0 );
class   ( 'PPIx::Regexp::Token::Structure' );
content ( '(' );
choose  ( child => 1, child => 0, type => 0 );
class   ( undef );
content ( undef );
choose  ( child => 1, child => 0, finish => 0 );
class   ( 'PPIx::Regexp::Token::Structure' );
content ( ')' );
choose  ( child => 1, child => 0, child => 0 );
class   ( 'PPIx::Regexp::Token::Literal' );
content ( 'x' );
choose  ( child => 1, child => 1 );
class   ( 'PPIx::Regexp::Token::Backreference' );
content ( '\\g-1' );
value   ( absolute => [], 1 );
false   ( is_named => [] );
value   ( name => [], undef );
value   ( number => [], -1 );

parse   ( '/\\g{1}/' );
value   ( failures => [], 0);
class   ( 'PPIx::Regexp' );
count   ( 3 );
choose  ( child => 0 );
class   ( 'PPIx::Regexp::Token::Structure' );
content ( '' );
choose  ( child => 1 );
class   ( 'PPIx::Regexp::Structure::Regexp' );
count   ( 1 );
choose  ( child => 1, child => 0 );
class   ( 'PPIx::Regexp::Token::Backreference' );
content ( '\\g{1}' );
value   ( absolute => [], 1 );
false   ( is_named => [] );
value   ( name => [], undef );
value   ( number => [], 1 );

parse   ( '/(x)\\g{-1}/' );
value   ( failures => [], 0);
class   ( 'PPIx::Regexp' );
count   ( 3 );
choose  ( child => 1 );
class   ( 'PPIx::Regexp::Structure::Regexp' );
count   ( 2 );
choose  ( child => 1, child => 0 );
class   ( 'PPIx::Regexp::Structure::Capture' );
count   ( 1 );
choose  ( child => 1, child => 0, child => 0 );
class   ( 'PPIx::Regexp::Token::Literal' );
content ( 'x' );
choose  ( child => 1, child => 1 );
class   ( 'PPIx::Regexp::Token::Backreference' );
content ( '\\g{-1}' );
value   ( absolute => [], 1 );
false   ( is_named => [] );
value   ( name => [], undef );
value   ( number => [], -1 );

parse   ( '/\\g{foo}/' );
value   ( failures => [], 0);
class   ( 'PPIx::Regexp' );
count   ( 3 );
choose  ( child => 1 );
class   ( 'PPIx::Regexp::Structure::Regexp' );
count   ( 1 );
choose  ( child => 1, child => 0 );
class   ( 'PPIx::Regexp::Token::Backreference' );
content ( '\\g{foo}' );
value   ( absolute => [], undef );
true    ( is_named => [] );
value   ( name => [], 'foo' );
value   ( number => [], undef );

parse   ( '/\\k<foo>/' );
value   ( failures => [], 0);
class   ( 'PPIx::Regexp' );
count   ( 3 );
choose  ( child => 1 );
class   ( 'PPIx::Regexp::Structure::Regexp' );
count   ( 1 );
choose  ( child => 1, child => 0 );
class   ( 'PPIx::Regexp::Token::Backreference' );
content ( '\\k<foo>' );
value   ( absolute => [], undef );
true    ( is_named => [] );
value   ( name => [], 'foo' );
value   ( number => [], undef );

parse   ( '/\\k\'foo\'/' );
value   ( failures => [], 0);
class   ( 'PPIx::Regexp' );
count   ( 3 );
choose  ( child => 1 );
class   ( 'PPIx::Regexp::Structure::Regexp' );
count   ( 1 );
choose  ( child => 1, child => 0 );
class   ( 'PPIx::Regexp::Token::Backreference' );
content ( '\\k\'foo\'' );
value   ( absolute => [], undef );
true    ( is_named => [] );
value   ( name => [], 'foo' );
value   ( number => [], undef );

parse   ( '/(?P=foo)/' );
value   ( failures => [], 0);
class   ( 'PPIx::Regexp' );
count   ( 3 );
choose  ( child => 1 );
class   ( 'PPIx::Regexp::Structure::Regexp' );
count   ( 1 );
choose  ( child => 1, child => 0 );
class   ( 'PPIx::Regexp::Token::Backreference' );
content ( '(?P=foo)' );
value   ( absolute => [], undef );
true    ( is_named => [] );
value   ( name => [], 'foo' );
value   ( number => [], undef );

parse   ( '/(?1)/' );
value   ( failures => [], 0);
class   ( 'PPIx::Regexp' );
count   ( 3 );
choose  ( child => 1 );
class   ( 'PPIx::Regexp::Structure::Regexp' );
count   ( 1 );
choose  ( child => 1, child => 0 );
class   ( 'PPIx::Regexp::Token::Recursion' );
content ( '(?1)' );
value   ( absolute => [], 1 );
false   ( is_named => [] );
value   ( name => [], undef );
value   ( number => [], 1 );

parse   ( '/(x)(?-1)/' );
value   ( failures => [], 0);
class   ( 'PPIx::Regexp' );
count   ( 3 );
choose  ( child => 1 );
class   ( 'PPIx::Regexp::Structure::Regexp' );
count   ( 2 );
choose  ( child => 1, child => 0 );
class   ( 'PPIx::Regexp::Structure::Capture' );
choose  ( child => 1, child => 1 );
class   ( 'PPIx::Regexp::Token::Recursion' );
content ( '(?-1)' );
value   ( absolute => [], 1 );
false   ( is_named => [] );
value   ( name => [], undef );
value   ( number => [], -1 );

parse   ( '/(x)(?+1)(y)/' );
value   ( failures => [], 0);
class   ( 'PPIx::Regexp' );
count   ( 3 );
choose  ( child => 1 );
class   ( 'PPIx::Regexp::Structure::Regexp' );
count   ( 3 );
choose  ( child => 1, child => 0 );
class   ( 'PPIx::Regexp::Structure::Capture' );
choose  ( child => 1, child => 1 );
class   ( 'PPIx::Regexp::Token::Recursion' );
content ( '(?+1)' );
value   ( absolute => [], 2 );
false   ( is_named => [] );
value   ( name => [], undef );
value   ( number => [], '+1' );
choose  ( child => 1, child => 2 );
class   ( 'PPIx::Regexp::Structure::Capture' );

parse   ( '/(?R)/' );
value   ( failures => [], 0);
class   ( 'PPIx::Regexp' );
count   ( 3 );
choose  ( child => 1 );
class   ( 'PPIx::Regexp::Structure::Regexp' );
count   ( 1 );
choose  ( child => 1, child => 0 );
class   ( 'PPIx::Regexp::Token::Recursion' );
content ( '(?R)' );
value   ( absolute => [], 0 );
false   ( is_named => [] );
value   ( name => [], undef );
value   ( number => [], 0 );

parse   ( '/(?&foo)/' );
value   ( failures => [], 0);
class   ( 'PPIx::Regexp' );
count   ( 3 );
choose  ( child => 1 );
class   ( 'PPIx::Regexp::Structure::Regexp' );
count   ( 1 );
choose  ( child => 1, child => 0 );
class   ( 'PPIx::Regexp::Token::Recursion' );
content ( '(?&foo)' );
value   ( absolute => [], undef );
true    ( is_named => [] );
value   ( name => [], 'foo' );
value   ( number => [], undef );

parse   ( '/(?P>foo)/' );
value   ( failures => [], 0);
class   ( 'PPIx::Regexp' );
count   ( 3 );
choose  ( child => 1 );
class   ( 'PPIx::Regexp::Structure::Regexp' );
count   ( 1 );
choose  ( child => 1, child => 0 );
class   ( 'PPIx::Regexp::Token::Recursion' );
content ( '(?P>foo)' );
value   ( absolute => [], undef );
true    ( is_named => [] );
value   ( name => [], 'foo' );
value   ( number => [], undef );

parse   ( '/(?(1)foo)/' );
value   ( failures => [], 0);
class   ( 'PPIx::Regexp' );
count   ( 3 );
choose  ( child => 1 );
class   ( 'PPIx::Regexp::Structure::Regexp' );
count   ( 1 );
choose  ( child => 1, child => 0 );
class   ( 'PPIx::Regexp::Structure::Switch' );
count   ( 4 );
choose  ( child => 1, child => 0, child => 0 );
class   ( 'PPIx::Regexp::Token::Condition' );
content ( '(1)' );
value   ( absolute => [], 1 );
false   ( is_named => [] );
value   ( name => [], undef );
value   ( number => [], 1 );

parse   ( '/(?(R1)foo)/' );
value   ( failures => [], 0);
class   ( 'PPIx::Regexp' );
count   ( 3 );
choose  ( child => 1 );
class   ( 'PPIx::Regexp::Structure::Regexp' );
count   ( 1 );
choose  ( child => 1, child => 0 );
class   ( 'PPIx::Regexp::Structure::Switch' );
count   ( 4 );
choose  ( child => 1, child => 0, child => 0 );
class   ( 'PPIx::Regexp::Token::Condition' );
content ( '(R1)' );
value   ( absolute => [], 1 );
false   ( is_named => [] );
value   ( name => [], undef );
value   ( number => [], 1 );

parse   ( '/(?(<bar>)foo)/' );
value   ( failures => [], 0);
class   ( 'PPIx::Regexp' );
count   ( 3 );
choose  ( child => 1 );
class   ( 'PPIx::Regexp::Structure::Regexp' );
count   ( 1 );
choose  ( child => 1, child => 0 );
class   ( 'PPIx::Regexp::Structure::Switch' );
count   ( 4 );
choose  ( child => 1, child => 0, child => 0 );
class   ( 'PPIx::Regexp::Token::Condition' );
content ( '(<bar>)' );
value   ( absolute => [], undef );
true    ( is_named => [] );
value   ( name => [], 'bar' );
value   ( number => [], undef );

parse   ( '/(?(\'bar\')foo)/' );
value   ( failures => [], 0);
class   ( 'PPIx::Regexp' );
count   ( 3 );
choose  ( child => 1 );
class   ( 'PPIx::Regexp::Structure::Regexp' );
count   ( 1 );
choose  ( child => 1, child => 0 );
class   ( 'PPIx::Regexp::Structure::Switch' );
count   ( 4 );
choose  ( child => 1, child => 0, child => 0 );
class   ( 'PPIx::Regexp::Token::Condition' );
content ( '(\'bar\')' );
value   ( absolute => [], undef );
true    ( is_named => [] );
value   ( name => [], 'bar' );
value   ( number => [], undef );

parse   ( '/(?(R&bar)foo)/' );
value   ( failures => [], 0);
class   ( 'PPIx::Regexp' );
count   ( 3 );
choose  ( child => 1 );
class   ( 'PPIx::Regexp::Structure::Regexp' );
count   ( 1 );
choose  ( child => 1, child => 0 );
class   ( 'PPIx::Regexp::Structure::Switch' );
count   ( 4 );
choose  ( child => 1, child => 0, child => 0 );
class   ( 'PPIx::Regexp::Token::Condition' );
content ( '(R&bar)' );
value   ( absolute => [], undef );
true    ( is_named => [] );
value   ( name => [], 'bar' );
value   ( number => [], undef );

parse   ( '/(?(DEFINE)foo)/' );
value   ( failures => [], 0);
class   ( 'PPIx::Regexp' );
choose  ( child => 1 );
class   ( 'PPIx::Regexp::Structure::Regexp' );
count   ( 1 );
choose  ( child => 1, child => 0 );
class   ( 'PPIx::Regexp::Structure::Switch' );
count   ( 4 );
choose  ( child => 1, child => 0, child => 0 );
class   ( 'PPIx::Regexp::Token::Condition' );
content ( '(DEFINE)' );
value   ( absolute => [], 0 );
false   ( is_named => [] );
value   ( name => [], undef );
value   ( number => [], 0 );

tokenize( '/(?p{ code })/' );
count   ( 8 );
value   ( perl_version_removed => [], undef );
choose  ( 3 );
class   ( 'PPIx::Regexp::Token::GroupType::Code' );
content ( '?p' );
value   ( perl_version_removed => [], '5.010' );

parse   ( '/(?p{ code })/' );
value   ( failures => [], 0);
class   ( 'PPIx::Regexp' );
value   ( perl_version_removed => [], '5.010' );
count   ( 3 );
choose  ( child => 0 );
class   ( 'PPIx::Regexp::Token::Structure' );
content ( '' );
value   ( perl_version_removed => [], undef );
choose  ( child => 1 );
class   ( 'PPIx::Regexp::Structure::Regexp' );
count   ( 1 );
value   ( perl_version_removed => [], '5.010' );
choose  ( child => 1, child => 0 );
class   ( 'PPIx::Regexp::Structure::Code' );
count   ( 1 );
value   ( perl_version_removed => [], '5.010' );
choose  ( child => 1, child => 0, start => [] );
count   ( 1 );
choose  ( child => 1, child => 0, start => 0 );
class   ( 'PPIx::Regexp::Token::Structure' );
content ( '(' );
value   ( perl_version_removed => [], undef );
choose  ( child => 1, child => 0, type => [] );
count   ( 1 );
choose  ( child => 1, child => 0, type => 0 );
class   ( 'PPIx::Regexp::Token::GroupType::Code' );
content ( '?p' );
value   ( perl_version_removed => [], '5.010' );

finis   ();

1;

# ex: set textwidth=72 :
