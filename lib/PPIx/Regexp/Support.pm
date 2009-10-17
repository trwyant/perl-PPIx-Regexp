=head1 NAME

PPIx::Regexp::Support - Basis for the PPIx::Regexp support classes

=head1 SYNOPSIS

 use PPIx::Regexp::Dumper;
 PPIx::Regexp::Dumper->new( 'qr{foo}smx' )
     ->print();

=head1 INHERITANCE

 PPIx::Regexp::Support

=head1 DESCRIPTION

This abstract class provides methods for the C<PPIx::Regexp> support
classes.

=head1 METHODS

This class provides the following public methods. Methods not documented
here are private, and unsupported in the sense that the author reserves
the right to change or remove them without notice.

=cut

package PPIx::Regexp::Support;

use strict;
use warnings;

our $VERSION = '0.000_03';

=head2 decode

This method wraps the Encode::decode subroutine. If the object specifies
no encoding or encode_available() returns false, this method simply
returns its input string.

=cut

sub decode {
    my ( $self, $data ) = @_;
    defined $self->{encoding} or return $data;
    encode_available() or return $data;
    return Encode::decode( $self->{encoding}, $data );
}

=head2 encode

This method wraps the Encode::encode subroutine. If the object specifies
no encoding or encode_available() returns false, this method simply
returns its input string.

=cut

sub encode {
    my ( $self, $data ) = @_;
    defined $self->{encoding} or return $data;
    encode_available() or return $data;
    return Encode::encode( $self->{encoding}, $data );
}

=head2 encode_available

This method returns true if the Encode module is available, and false
otherwise. If it returns true, the Encode module has actually been
loaded.

=cut

{

    my $encode_available;

    sub encode_available {
	defined $encode_available and return $encode_available;
	return ( $encode_available = eval {
		require Encode;
		1;
	    } ? 1 : 0
	);
    }

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
