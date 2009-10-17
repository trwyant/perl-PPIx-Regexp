package PPIx::Regexp::Constant;

use strict;
use warnings;

our $VERSION = '0.000_03';

use base qw{ Exporter };

use Readonly;

our @EXPORT_OK = qw{
    $COOKIE_CLASS
    $COOKIE_QUANT
    $COOKIE_QUOTE
    $MINIMUM_PERL
    $RE_CAPTURE_NAME
    $STRUCTURE_UNKNOWN
    $TOKEN_LITERAL
    $TOKEN_UNKNOWN
};

Readonly::Scalar our $COOKIE_CLASS	=> ']';
Readonly::Scalar our $COOKIE_QUANT	=> '}';
Readonly::Scalar our $COOKIE_QUOTE	=> '\\E';

Readonly::Scalar our $MINIMUM_PERL	=> '5.006';

=begin comment

The perlre for Perl 5.010 says:

     Currently NAME is restricted to simple identifiers only.  In
     other words, it must match "/^[_A-Za-z][_A-Za-z0-9]*\z/" or
     its Unicode extension (see utf8), though it isn't extended by
     the locale (see perllocale).

=end comment

=cut

Readonly::Scalar our $RE_CAPTURE_NAME => qr{ [_[:alpha:]] \w* }smx;

Readonly::Scalar our $STRUCTURE_UNKNOWN	=> 'PPIx::Regexp::Structure::Unknown';

Readonly::Scalar our $TOKEN_LITERAL	=> 'PPIx::Regexp::Token::Literal';
Readonly::Scalar our $TOKEN_UNKNOWN	=> 'PPIx::Regexp::Token::Unknown';

1;

=head1 DETAILS

This module exports the following manifest constants:

=head2 $COOKIE_CLASS

The name of the cookie used to control the construction of character
classes.

This cookie is set in
L<PPIx::Regexp::Token::Structure|PPIx::Regexp::Token::Structure> when
the left square bracket is encountered, and cleared in the same module
when a right square bracket is encountered.

=head2 $COOKIE_QUANT

The name of the cookie used to control the construction of curly
bracketed quantifiers.

This cookie is set in
L<PPIx::Regexp::Token::Structure|PPIx::Regexp::Token::Structure> when a
left curly bracket is encountered. It requests itself to be cleared on
encountering anything other than a literal comma, a literal digit, or an
interpolation, or if more than one comma is encountered. If it survives
until L<PPIx::Regexp::Token::Structure|PPIx::Regexp::Token::Structure>
processes the right curly bracket, it is cleared there.

=head2 $COOKIE_QUOTE

The name of the cookie used to control the parsing of C<\Q ... \E>
quoted literals.

This cookie is set in
L<PPIx::Regexp::Token::Control|PPIx::Regexp::Token::Control> when a
C<\Q> is encountered, and it persists until the next C<\E>.

=head2 $MINIMUM_PERL

The minimum version of Perl understood by this parser, as a float. It is
currently set to 5.006, since that is the minimum version of Perl
accessible to the author.

=head2 $RE_CAPTURE_NAME

A regular expression that matches the name of a named capture buffer.

=head2 $STRUCTURE_UNKNOWN

The name of the class that represents the unknown structure. That is,
L<PPIx::Regexp::Structure::Unknown|PPIx::Regexp::Structure::Unknown>.

=head2 $TOKEN_LITERAL

The name of the class that represents a literal token. That is,
L<PPIx::Regexp::Token::Literal|PPIx::Regexp::Token::Literal>.

=head2 $TOKEN_UNKNOWN

The name of the class that represents the unknown token. That is,
L<PPIx::Regexp::Token::Unknown|PPIx::Regexp::Token::Unknown>.

=cut

# ex: set textwidth=72 :
