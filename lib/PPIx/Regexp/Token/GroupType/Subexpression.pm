=head1 NAME

PPIx::Regexp::Token::GroupType::Subexpression - Represent an independent subexpression marker

=head1 SYNOPSIS

 use PPIx::Regexp::Dumper;
 PPIx::Regexp::Dumper->new( 'qr{foo(?>bar)}smx' )
     ->print();

=head1 INHERITANCE

C<PPIx::Regexp::Token::GroupType::Subexpression> is a
L<PPIx::Regexp::Token::GroupType|PPIx::Regexp::Token::GroupType>.

C<PPIx::Regexp::Token::GroupType::Subexpression> has no descendants.

=head1 DESCRIPTION

This class represents the '?>' after a left parenthesis that identifies
an independent subexpression.

=head1 METHODS

This class provides no public methods beyond those provided by its
superclass.

=cut

package PPIx::Regexp::Token::GroupType::Subexpression;

use strict;
use warnings;

use base qw{ PPIx::Regexp::Token::GroupType };

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

    # The optional escapes are because any non-open-bracket character
    # may be the delimiter of the regular expression.
    if ( my $accept = $tokenizer->find_regexp(
	    qr{ \A \\? \? \\? > }smx ) ) {
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
