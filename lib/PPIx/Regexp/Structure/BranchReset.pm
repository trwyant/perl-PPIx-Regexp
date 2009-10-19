=head1 NAME

PPIx::Regexp::Structure::BranchReset - Represent a branch reset group

=head1 SYNOPSIS

 use PPIx::Regexp::Dumper;
 PPIx::Regexp::Dumper->new( 'qr{(?|(foo)|(bar))}smx' )
     ->print();

=head1 INHERITANCE

C<PPIx::Regexp::Structure::BranchReset> is a
L<PPIx::Regexp::Structure|PPIx::Regexp::Structure>.

=head1 DESCRIPTION

This class represents a branch reset group. That is, the construction
C<(?|(...)|(...)|...)>. This is new with Perl 5.010.

=head1 METHODS

This class provides no public methods beyond those provided by its
superclass.

=cut

package PPIx::Regexp::Structure::BranchReset;

use strict;
use warnings;

use base qw{ PPIx::Regexp::Structure };

use Carp qw{ confess };

our $VERSION = '0.000_03';

# Called by the lexer to record the capture number.
sub __PPIX_LEXER__record_capture_number {
    my ( $self, $number ) = @_;
    defined $number
	or confess 'Programming error - initial $number is undef';
    my $original = $number;
    my $hiwater = $number;
    foreach my $kid ( $self->children() ) {
	if ( $kid->isa( 'PPIx::Regexp::Token::Operator' )
	    && $kid->content() eq '|' ) {
	    $number > $hiwater and $hiwater = $number;
	    $number = $original;
	} else {
	    $number = $kid->__PPIX_LEXER__record_capture_number( $number );
	}
    }
    return $number > $hiwater ? $number : $hiwater;
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
