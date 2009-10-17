=head1 NAME

PPIx::Regexp::Token::Greediness - Represent a greediness qualifier.

=head1 SYNOPSIS

 use PPIx::Regexp::Dumper;
 PPIx::Regexp::Dumper->new( 'qr{foo*+}smx' )
     ->print();

=head1 INHERITANCE

 PPIx::Regexp::Token::Greediness
 isa PPIx::Regexp::Token

=head1 DESCRIPTION

This class represents a greediness qualifier for the preceding
quantifier.

=head1 METHODS

This class provides the following public methods. Methods not documented
here are private, and unsupported in the sense that the author reserves
the right to change or remove them without notice.

=cut

package PPIx::Regexp::Token::Greediness;

use strict;
use warnings;

use base qw{ PPIx::Regexp::Token };

use PPIx::Regexp::Constant qw{ $MINIMUM_PERL };

our $VERSION = '0.000_02';

# Return true if the token can be quantified, and false otherwise
sub can_be_quantified { return };

my %greediness = (
    '?' => $MINIMUM_PERL,
    '+' => '5.010',
);

=head2 could_be_greediness

 PPIx::Regexp::Token::Greediness->could_be_greediness( '?' );

This method returns true if the given string could be a greediness
indicator; that is, if it is '+' or '?'.

=cut

sub could_be_greediness {
    my ( $class, $string ) = @_;
    return $greediness{$string};
}

sub perl_version_introduced {
    my ( $self ) = @_;
    return $greediness{ $self->content() } || $MINIMUM_PERL;
}

sub __PPIX_TOKENIZER__regexp {
    my ( $class, $tokenizer, $character, $char_type ) = @_;

    $tokenizer->prior( 'is_quantifier' ) or return;

    $greediness{$character} or return;

    return length $character;
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
