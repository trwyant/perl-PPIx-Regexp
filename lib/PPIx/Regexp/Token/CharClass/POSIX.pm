=head1 NAME

PPIx::Regexp::Token::CharClass::POSIX - Represent a POSIX character class

=head1 SYNOPSIS

 use PPIx::Regexp::Dumper;
 PPIx::Regexp::Dumper->new( 'qr{[[:alpha:]]}smx' )
     ->print();

=head1 INHERITANCE

C<PPIx::Regexp::Token::CharClass::POSIX> is a
L<PPIx::Regexp::Token::CharClass|PPIx::Regexp::Token::CharClass>.

=head1 DESCRIPTION

This class represents a POSIX character class. It will only be
recognized within a character class.

=head1 METHODS

This class provides no public methods beyond those provided by its
superclass.

=cut

package PPIx::Regexp::Token::CharClass::POSIX;

use strict;
use warnings;

use base qw{ PPIx::Regexp::Token::CharClass };

use PPIx::Regexp::Constant qw{ $COOKIE_CLASS };

our $VERSION = '0.000_03';

# Return true if the token can be quantified, and false otherwise
# sub can_be_quantified { return };

# Return true to be included in the token scan. This determination
# should be good for the life of the tokenizer. It is called as a static
# method with two arguments: the tokenizer object and the mode name. Use
# of the latter is pre-deprecated.
# sub __PPIX_TOKEN__scan_me {
#     my ( $class, $tokenizer, $mode ) = @_;
#     return $tokenizer->interpolates();
# };

sub __PPIX_TOKENIZER__regexp {
    my ( $class, $tokenizer, $character ) = @_;

    $tokenizer->cookie( $COOKIE_CLASS ) or return;

    if ( my $accept = $tokenizer->find_regexp(
	    qr{ \A \[ : \^? [^:]* : \] }smx ) ) {
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

=head1 COPYRIGHT

Copyright 2009 by Thomas R. Wyant, III.

=cut

# ex: set textwidth=72 :
