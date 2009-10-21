=head1 NAME

PPIx::Regexp::Token::CharClass::Simple - This class represents a simple character class

=head1 SYNOPSIS

 use PPIx::Regexp::Dumper;
 PPIx::Regexp::Dumper->new( 'qr{\w}smx' )
     ->print();

=head1 INHERITANCE

C<PPIx::Regexp::Token::CharClass::Simple> is a
L<PPIx::Regexp::Token::CharClass|PPIx::Regexp::Token::CharClass>.

C<PPIx::Regexp::Token::CharClass::Simple> has no descendants.

=head1 DESCRIPTION

This class represents one of the simple character classes that can occur
anywhere in a regular expression.

=head1 METHODS

This class provides no public methods beyond those provided by its
superclass.

This class provides the following public methods. Methods not documented
here are private, and unsupported in the sense that the author reserves
the right to change or remove them without notice.

=cut

package PPIx::Regexp::Token::CharClass::Simple;

use strict;
use warnings;

use base qw{ PPIx::Regexp::Token::CharClass };

use PPIx::Regexp::Constant qw{ $COOKIE_CLASS $TOKEN_LITERAL };

our $VERSION = '0.000_04';

# Return true if the token can be quantified, and false otherwise
# sub can_be_quantified { return };

sub __PPIX_TOKENIZER__regexp {
    my ( $class, $tokenizer, $character ) = @_;

    my $in_class = $tokenizer->cookie( $COOKIE_CLASS );

    if ( $character eq '.' ) {
	$in_class
	    and return $tokenizer->make_token( 1, $TOKEN_LITERAL );
	return 1;
    }

    if ( my $accept = $tokenizer->find_regexp(
	    qr{ \A \\ (?:
		[wWsSdDvVhHX] |
		[Pp] \{ \^? [\w:]+ \}
	    ) }smx
	) ) {
	return $accept;
    }

    # \R is not legal in a character class.
    if ( not $in_class and my $accept = $tokenizer->find_regexp(
	    qr{ \A \\ R }smx ) ) {
	return $accept;
    }

    return;
}

1;

__END__

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
