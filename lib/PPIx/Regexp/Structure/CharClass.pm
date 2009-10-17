=head1 NAME

PPIx::Regexp::Structure::CharClass - Represent a character class

=head1 SYNOPSIS

 use PPIx::Regexp::Dumper;
 PPIx::Regexp::Dumper->new( 'qr{[fo]}smx' )
     ->print();

=head1 INHERITANCE

 PPIx::Regexp::Structure::CharClass
 isa PPIx::Regexp::Structure

=head1 DESCRIPTION

This class represents a square-bracketed character class.

=head1 METHODS

This class provides the following public methods. Methods not documented
here are private, and unsupported in the sense that the author reserves
the right to change or remove them without notice.

=cut

package PPIx::Regexp::Structure::CharClass;

use strict;
use warnings;

use base qw{ PPIx::Regexp::Structure };

use Params::Util 0.25 qw{ _INSTANCE };

our $VERSION = '0.000_03';

sub _new {
    my ( $class, @args ) = @_;
    ref $class and $class = ref $class;
    my %brkt;
    $brkt{finish} = pop @args;
    $brkt{start} = shift @args;
    _INSTANCE( $args[0], 'PPIx::Regexp::Token::Operator' )
	and $args[0]->content() eq '^'
	and $brkt{type} = shift @args;
    return $class->SUPER::_new( \%brkt, @args );
}

=head2 negated

 $class->negated() and print "Class is negated\n";

This method returns true if the character class is negated -- that is,
if the first token inside the left square bracket is a caret (C<^>).

=cut

sub negated {
    my ( $self ) = @_;
    return $self->type() ? 1 : 0;
}

# Called by the lexer to record the capture number.
sub __PPIX_LEXER__record_capture_number {
    my ( $self, $number ) = @_;
    return $number;
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
