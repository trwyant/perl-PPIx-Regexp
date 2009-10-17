=head1 NAME

PPIx::Regexp::Token::Delimiter - Represent the delimiters of the regular expression

=head1 SYNOPSIS

 use PPIx::Regexp::Dumper;
 PPIx::Regexp::Dumper->new( 'qr{foo}smx' )
     ->print();

=head1 INHERITANCE

 PPIx::Regexp::Token::Delimiter
 isa PPIx::Regexp::Token::Structure

=head1 DESCRIPTION

This token represents the delimiters of the regular expression. Since
the tokenizer has to figure out where these are anyway, this class is
used to give the lexer a hint about what is going on.

=head1 METHODS

This class provides no public methods beyond those provided by its
superclass.

This class provides the following public methods. Methods not documented
here are private, and unsupported in the sense that the author reserves
the right to change or remove them without notice.

=cut

package PPIx::Regexp::Token::Delimiter;

use strict;
use warnings;

use base qw{ PPIx::Regexp::Token::Structure };

our $VERSION = '0.000_03';

# Return true if the token can be quantified, and false otherwise
# sub can_be_quantified { return };

=begin comment

sub __PPIX_TOKENIZER__regexp {
    my ( $class, $tokenizer, $character ) = @_;

    if ( $character eq 'x' ) {
	$tokenizer->accept_character( 1 );
	return;
    }

    return $tokenizer->reject_character();
}

=end comment

=cut

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
