=head1 NAME

PPIx::Regexp::Token::Unknown - Represent an unknown token

=head1 SYNOPSIS

 use PPIx::Regexp::Dumper;
 PPIx::Regexp::Dumper->new( 'xyzzy' )
     ->print();

=head1 INHERITANCE

 PPIx::Regexp::Token::Unknown
 isa PPIx::Regexp::Token

=head1 DESCRIPTION

This token represents something that could not be identified by the
tokenizer. Sometimes the lexer can fix these up, but the presence of one
of these in a finished parse represents something in the regular
expression that was not understood.

=head1 METHODS

This class provides the following public methods. Methods not documented
here are private, and unsupported in the sense that the author reserves
the right to change or remove them without notice.

=cut

package PPIx::Regexp::Token::Unknown;

use strict;
use warnings;

use base qw{ PPIx::Regexp::Token };

our $VERSION = '0.000_03';

# Return true if the token can be quantified, and false otherwise
sub can_be_quantified { return };

=head2 ordinal

This method returns the results of the ord built-in on the content
(meaning, of course, the first character of the content). No attempt is
made to interpret the content, since after all this B<is> the unknown
token.

=cut

sub ordinal {
    my ( $self ) = @_;
    return ord $self->content();
}

# Since the lexer does not count these on the way in (because it needs
# the liberty to rebless them into a known class if it figures out what
# is going on) we count them as failures at the finalization step.
sub __PPIX_LEXER__finalize {
    return 1;
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
