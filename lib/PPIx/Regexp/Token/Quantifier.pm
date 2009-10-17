=head1 NAME

PPIx::Regexp::Token::Quantifier - Represent an atomic quantifier.

=head1 SYNOPSIS

 use PPIx::Regexp::Dumper;
 PPIx::Regexp::Dumper->new( 'qr{\w+}smx' )
     ->print();

=head1 INHERITANCE

 PPIx::Regexp::Token::Quantifier
 isa PPIx::Regexp::Token

=head1 DESCRIPTION

This class represents an atomic quantifier; that is, one of the
characters C<*>, C<+>, or C<?>.

=head1 METHODS

This class provides the following public methods. Methods not documented
here are private, and unsupported in the sense that the author reserves
the right to change or remove them without notice.

=cut

package PPIx::Regexp::Token::Quantifier;

use strict;
use warnings;

use base qw{ PPIx::Regexp::Token };

our $VERSION = '0.000_02';

# Return true if the token can be quantified, and false otherwise
sub can_be_quantified { return };

# Return true if the token is a quantifier.
sub is_quantifier { return 1 };

my %quantifier = map { $_ => 1 } qw{ * + ? };

=head2 could_be_quantifier

 PPIx::Regexp::Token::Quantifier->could_be_quantifier( '*' );

This method returns true if the given string could be a quantifier; that
is, if it is '*', '+', or '?'.

=cut

sub could_be_quantifier {
    my ( $class, $string ) = @_;
    return $quantifier{$string};
}

sub __PPIX_TOKENIZER__regexp {
    my ( $class, $tokenizer, $character ) = @_;

    $tokenizer->prior( 'can_be_quantified' )
	or return;

    return $quantifier{$character};
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
