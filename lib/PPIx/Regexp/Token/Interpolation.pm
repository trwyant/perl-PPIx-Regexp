=head1 NAME

PPIx::Regexp::Token::Interpolation - Represent an interpolation in the PPIx::Regexp package.

=head1 SYNOPSIS

 use PPIx::Regexp::Dumper;
 PPIx::Regexp::Dumper->new('qr{$foo}smx')->print();

=head1 INHERITANCE

C<PPIx::Regexp::Token::Interpolation> is a
L<PPIx::Regexp::Token::Code|PPIx::Regexp::Token::Code>.

C<PPIx::Regexp::Token::Interpolation> has no descendants.

=head1 DESCRIPTION

This class represents a variable interpolation into a regular
expression. In the L</SYNOPSIS> the C<$foo> would be represented by an
object of this class.

=head1 METHODS

This class provides no public methods beyond those provided by its
superclass.

=cut

package PPIx::Regexp::Token::Interpolation;

use strict;
use warnings;

use base qw{ PPIx::Regexp::Token::Code };

use Params::Util 0.025 ();
use PPI::Document;
use PPIx::Regexp::Constant qw{ $COOKIE_CLASS $TOKEN_LITERAL };

our $VERSION = '0.003';

# Return true if the token can be quantified, and false otherwise
# This can be quantified because it might interpolate a quantifiable
# token. Of course, it might not, but we need to be permissive here.
# sub can_be_quantified { return };


# Match the beginning of an interpolation.

my $interp_re =
	qr{ \A (?: \$ [-\w&`'+^./\\";%=~:?!\@\$<>\[\]\{\},#] |
		   \@ [\w\{] )
	}smx;

# We pull out the logic of finding and dealing with the interpolation
# into a separate subroutine because if we fail to find an interpolation
# we want to do something with the sigils.
sub _interpolation {
    my ( $class, $tokenizer, $character ) = @_;

    # If the regexp does not interpolate, bail now.
    $tokenizer->interpolates() or return;

    # Make sure we start off plausably
    $tokenizer->find_regexp( $interp_re )
	or return;

    # See if PPI can figure out what we have
    my $doc = $tokenizer->ppi_document()
	or return;

    # Get the first statement to work on.
    my $stmt = $doc->find_first( 'PPI::Statement' )
	or return;

    my @accum;	# The elements of the interpolation
    my $allow_subscript;	# Assume no subscripts allowed

    # Find the beginning of the interpolation
    my $next = $stmt->child( 0 ) or return;

    # The interpolation should start with
    if ( $next->isa( 'PPI::Token::Symbol' ) ) {

	# A symbol
	push @accum, $next;
	$allow_subscript = 1;	# Subscripts are allowed

    } elsif ( $next->isa( 'PPI::Token::Cast' ) ) {

	# Or a cast followed by a block
	push @accum, $next;
	$next = $next->next_sibling() or return;
	if ( $next->isa( 'PPI::Token::Symbol' ) ) {
	    $accum[-1]->content() eq '$#'
		or return;
	    push @accum, $next;
	} elsif ( $next->isa( 'PPI::Structure::Block' ) ) {
	    local $_ = $next->content();
	    if ( m< \A { / } >smx ) {
		push @accum, 3;	# Number of characters to accept.
	    } else {
		$allow_subscript = $accum[-1]->content() ne '$#';
		push @accum, $next;
	    }
	} else {
	    return;
	}

    } elsif ( $next->isa( 'PPI::Token::ArrayIndex' ) ) {

	# Or an array index
	push @accum, $next;

    } else {

	# None others need apply.
	return;

    }

    # The interpolation _may_ be subscripted. If so ...
    {

	# Only accept a subscript if wanted and available
	$allow_subscript and $next = $next->next_sibling() or last;

	# Accept an optional dereference operator.
	my @subscr;
	if ( $next->isa( 'PPI::Token::Operator' ) ) {
	    $next->content() eq '->' or last;
	    push @subscr, $next;
	    $next = $next->next_sibling() or last;
	}

	# Accept only a subscript
	$next->isa( 'PPI::Structure::Subscript' ) or last;

	# The subscript must have a closing delimiter.
	$next->finish() or last;

	# Screen the subscript for content, since [] could be a
	# character class, and {} could be a quantifier. The perlop docs
	# say that Perl applies undocumented heuristics subject to
	# change without notice to figure this out. So we do our poor
	# best to be heuristical and undocumented.
	$class->_subscript( $next ) or last;

	# If we got this far, accept the subscript and try for another
	# one.
	push @accum, @subscr, $next;
	redo;
    }

    # Compute the length of all the PPI elements accumulated, and return
    # it.
    my $length = 0;
    foreach ( @accum ) {
	$length += ref $_ ? length $_->content() : $_;
    }
    return $length;
}

{

    my %allowed = (
	'[' => '_square',
	'{' => '_curly',
    );

    sub _subscript {
	my ( $class, $struct ) = @_;

	# We expect to have a left delimiter, which is either a '[' or a
	# '{'.
	my $left = $struct->start() or return;
	my $lc = $left->content();
	my $handler = $allowed{$lc} or return;

	# We expect a single child, which is a PPI::Statement
	( my @kids = $struct->schildren() ) == 1 or return;
	$kids[0]->isa( 'PPI::Statement' ) or return;

	# We expect the statement to have at least one child.
	( @kids = $kids[0]->schildren() ) or return;

	return $class->$handler( @kids );

    }

}

# Return true if we think a curly-bracketed subscript is really a
# subscript, rather than a quantifier.
sub _curly {
    my ( $class, @kids ) = @_;

    # If the first child is a word, and either it is an only child or
    # the next child is the fat comma operator, we accept it as a
    # subscript.
    if ( $kids[0]->isa( 'PPI::Token::Word' ) ) {
	@kids == 1 and return 1;
	$kids[1]->isa( 'PPI::Token::Operator' )
	    and $kids[1]->content() eq '=>'
	    and return 1;
    }

    # If we have exactly one child which is a symbol, we accept it as a
    # subscript.
    @kids == 1
	and $kids[0]->isa( 'PPI::Token::Symbol' )
	and return 1;

    # We reject anything else.
    return;
}

# Return true if we think a square-bracketed subscript is really a
# subscript, rather than a character class.
sub _square {
    my ( $class, @kids ) = @_;

    # We expect to have either a number or a symbol as the first
    # element.
    $kids[0]->isa( 'PPI::Token::Number' ) and return 1;
    $kids[0]->isa( 'PPI::Token::Symbol' ) and return 1;

    # Anything else is rejected.
    return;
}

# Alternate classes for the sigils, depending on whether we are in a
# character class (index 1) or not (index 0).
my %sigil_alternate = (
    '$' => [ 'PPIx::Regexp::Token::Assertion', $TOKEN_LITERAL ],
    '@' => [ $TOKEN_LITERAL, $TOKEN_LITERAL ],
);

sub __PPIX_TOKENIZER__regexp {
    my ( $class, $tokenizer, $character ) = @_;

    exists $sigil_alternate{$character} or return;

    if ( my $accept = _interpolation( $class, $tokenizer, $character ) ) {
	return $accept;
    }

    my $alternate = $sigil_alternate{$character} or return;
    return $tokenizer->make_token(
	1, $alternate->[$tokenizer->cookie( $COOKIE_CLASS ) ? 1 : 0 ] );

}

sub __PPIX_TOKENIZER__repl {
    my ( $class, $tokenizer, $character ) = @_;

    exists $sigil_alternate{$character} or return;

    if ( my $accept = _interpolation( $class, $tokenizer, $character ) ) {
	return $accept;
    }

    return $tokenizer->make_token( 1, $TOKEN_LITERAL );

}

1;

__END__

=begin comment

Interpolation notes:

$ perl -E '$foo = "\\w"; $bar = 3; say qr{$foo{$bar}}'
(?-xism:)
white2:~/Code/perl/PPIx-Regexp.new tom 22:50:33
$ perl -E '$foo = "\\w"; $bar = 3; say qr{foo{$bar}}'
(?-xism:foo{3})
white2:~/Code/perl/PPIx-Regexp.new tom 22:50:59
$ perl -E '$foo = "\\w"; $bar = 3; %foo = {baz => 42};  say qr{$foo{$bar}}'
(?-xism:)
white2:~/Code/perl/PPIx-Regexp.new tom 22:51:38
$ perl -E '$foo = "\\w"; $bar = 3; %foo = {baz => 42};  say qr{$foo}'
(?-xism:\w)
white2:~/Code/perl/PPIx-Regexp.new tom 22:51:50
$ perl -E '$foo = "\\w"; $bar = 3; %foo = {baz => 42};  say qr{$foo{baz}}'
(?-xism:)
white2:~/Code/perl/PPIx-Regexp.new tom 22:52:49
$ perl -E '$foo = "\\w"; $bar = 3; %foo = {baz => 42};  say qr{${foo}{baz}}'
(?-xism:\w{baz})
white2:~/Code/perl/PPIx-Regexp.new tom 22:54:07
$ perl -E '$foo = "\\w"; $bar = 3; %foo = {baz => 42};  say qr{${foo}{$bar}}'
(?-xism:\w{3})

The above makes me think that Perl is extremely reluctant to understand
an interpolation followed by curlys as a hash dereference. In fact, only
when the interpolation was what PPI calls a block was it understood at
all.

$ perl -E '$foo = { bar => 42 }; say qr{$foo->{bar}};'
(?-xism:42)
$ perl -E '$foo = { bar => 42 }; say qr{$foo->{baz}};'
(?-xism:)

On the other hand, Perl seems to be less reluctant to accept an explicit
dereference as a hash dereference.

$ perl -E '$foo = "\\w"; $bar = 3; @foo = (42);  say qr{$foo}'
(?-xism:\w)
white2:~/Code/perl/PPIx-Regexp.new tom 22:58:20
$ perl -E '$foo = "\\w"; $bar = 3; @foo = (42);  say qr{$foo[0]}'
(?-xism:42)
white2:~/Code/perl/PPIx-Regexp.new tom 22:58:28
$ perl -E '$foo = "\\w"; $bar = 3; @foo = (42);  say qr{$foo[$bar]}'
(?-xism:)
white2:~/Code/perl/PPIx-Regexp.new tom 22:58:43
$ perl -E '$foo = "\\w"; $bar = 0; @foo = (42);  say qr{$foo[$bar]}'
(?-xism:42)

The above makes it somewhat easier to get $foo[$bar] interpreted as an
array dereference, but it appears to make use of information that is not
available to a static analysis, such as whether $foo[$bar] exists.

Actually, the above suggests a strategy: a subscript of any kind is to
be accepted as a subscript if it looks like \[\d+\], \[\$foo\], \{\w+\},
or \{\$foo\}. Otherwise, accept it as a character class or a quantifier
depending on the delimiter. Obviously when I bring PPI to bear I will
have to keep track of '->' operators before subscripts, and shed them
from the interpolation as well if the purported subscript does not pass
muster.

=end comment

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
