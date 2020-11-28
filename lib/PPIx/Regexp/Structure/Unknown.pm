=head1 NAME

PPIx::Regexp::Structure::Unknown - Represent an unknown structure.

=head1 SYNOPSIS

 use PPIx::Regexp::Dumper;
 PPIx::Regexp::Dumper->new( 'qr{(?(foo)bar|baz|burfle)}smx' )
     ->print();

=head1 INHERITANCE

C<PPIx::Regexp::Structure::Unknown> is a
L<PPIx::Regexp::Structure|PPIx::Regexp::Structure>.

C<PPIx::Regexp::Structure::Unknown> has no descendants.

=head1 DESCRIPTION

This class is used for a structure which the lexer recognizes as being
improperly constructed.

=head1 METHODS

This class provides no public methods beyond those provided by its
superclass.

=cut

package PPIx::Regexp::Structure::Unknown;

use strict;
use warnings;

use base qw{ PPIx::Regexp::Structure };

use PPIx::Regexp::Constant qw{ @CARP_NOT };

our $VERSION = '0.076';

sub __new {
    my ( $class, $content, %arg ) = @_;

    my $self = $class->SUPER::__new( $content, %arg );

    defined $arg{error}
	and $self->{explanation} = $self->{error} = $arg{error};

    defined $arg{explanation}
	and $self->{explanation} = $arg{explanation};

    return $self;
}

sub explain {
    my ( $self ) = @_;
    return $self->{explanation} || $self->SUPER::explain();
}

sub __PPIX_ELEM__rebless {
    my ( $class, $self, %arg ) = @_;
    my $rslt = $class->SUPER::__PPIX_ELEM__rebless( $self, %arg );
    unless ( defined( $self->{error} = $arg{error} ) ) {
	Carp::cluck( 'Making unknown token with no error message' );
	$self->{error} = 'Unspecified error';
	$rslt++;
    }
    $self->{explanation} = defined $arg{explanation} ?
	$arg{explanation} :
	$arg{error};
    return $rslt;
}

1;

__END__

=head1 SUPPORT

Support is by the author. Please file bug reports at
L<https://rt.cpan.org>, or in electronic mail to the author.

=head1 AUTHOR

Thomas R. Wyant, III F<wyant at cpan dot org>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009-2020 by Thomas R. Wyant, III

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl 5.10.0. For more details, see the full text
of the licenses in the directory LICENSES.

This program is distributed in the hope that it will be useful, but
without any warranty; without even the implied warranty of
merchantability or fitness for a particular purpose.

=cut

# ex: set textwidth=72 :
