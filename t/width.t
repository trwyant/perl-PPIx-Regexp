package main;

use 5.006;

use strict;
use warnings;

use Test::More 0.88;	# Because of done_testing();

use PPIx::Regexp::Constant qw{ INFINITY };

use lib qw{ inc };
use My::Module::Test;

sub raw_width;
sub width;


note 'Literals';

width '/x/', 1, 1;


note 'Character classes';

width '/\w/', 1, 1;

width '/[x]/', 1, 1;

width '/(?[ \w | [.] ])/', 1, 1;


note 'Quantifiers';

width '/x?/', 0, 1;

width '/x*/', 0, INFINITY;

width '/x+/', 1, INFINITY;

width '/x{2}/', 2, 2;

width '/x{2,3}/', 2, 3;

width '/x{2,}/', 2, INFINITY;

width '/x{,3}/', 0, 3;

width '/x{,$foo}/', 0, undef;

width '/(xy?)/', 1, 2;

width '/(xy)?/', 0, 2;

width '/(xy?)?/', 0, 2;

width '/(xy?){,2}/', 0, 4;

width '/\w+/', 1, INFINITY;

width '/[xy]?/', 0, 1;


note 'Alternation';

width '/x|yz/', 1, 2;


note 'Interpolation';

width '/$foo/', undef, undef;

width '/a|$foo/', undef, undef;

width '/$foo|a/', undef, undef;

width '/x{2,$foo}/', 2, undef;


note 'Branch reset';

width '/(?|(foo)|(bazzle))/', 3, 6;


note 'Condition';

width '/(x)(?(1)y|z)/', 2, 2;

width '/(x)(?(1)y)/', 1, 2;

width '/(?(DEFINE)(?<FOO>fubar))/', 0, 0;


note 'Look-around assertion';

width '/(?=foo)/', 0, 0;
choose child => 1, child => 0;
raw_width undef, 3, 3;


note 'Back reference';

width '/(x)\1/', 2, 2;

width '/(x)\g{-1}/', 2, 2;

width '/(?|(x)|(y))\1/', 2, 2;

width '/(?|(x)|(yz))\1/', undef, undef;

width '/(?<x>y)\g{x}/', 2, 2;


note 'Recursion';

width '/x(?R)/', undef, undef;

# TODO: references
#       PPIx::Regexp::Token::Reference
#       This is actually an abstract class with a number of subclasses:
#     PPIx::Regexp::Token::Backreference
#       This is the \1 (absolute) and \g{-1} (relative) thingy. If I can
#       match them to their capture groups I'm set, because they match
#       whatever the capture group does.
#       I think the logic here is to take the width of the corresponding
#       capture if it can be identified uniquely. This may fail in the
#       presence of branch resets (numeric back references) or multiple
#       definintions (named back references).
#     PPIx::Regexp::Token::Condition
#       The width() is zero because the condition does not match
#       anything, it just determines whether a match occurred.
#       raw_width() will be the same as for ::Backreference
#     PPIx::Regexp::Token::Regression (DONE)
#       Indeterminate by static analysis.
#   It might make this job much easier if I could track capture numbers
#   and names as they are created. This doesn't work for regressions,
#   but I'm not targeting them anyway at this point.

done_testing;

sub raw_width {
    unshift @_, 'raw_width';
    goto &_do_it;
}

sub width {
    unshift @_, 'width';
    goto &_do_it;
}

sub _do_it {
    my ( $method, $re, @want ) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    if ( defined $re ) {
	parse $re
	    or return;
    }
    my $call = sprintf '%s->%s()', ref invocant, $method;
    my $fw = format_want( \@want );
    my $name = sprintf '%s on %s is %s', $call, invocant->content(), $fw;
    return value $method => [], \@want, $name;
}

1;

# ex: set textwidth=72 :
