=head1 NAME

PPIx::Regexp::Structure::NamedCapture - Represent a named capture

=head1 SYNOPSIS

 use PPIx::Regexp::Dumper;
 PPIx::Regexp::Dumper->new( 'qr{(?<foo>foo)}smx' )
     ->print();

=head1 INHERITANCE

 PPIx::Regexp::Structure::NamedCapture
 isa PPIx::Regexp::Structure::Capture

=head1 DESCRIPTION

This class represents a named capture.

=head1 METHODS

This class provides the following public methods. Methods not documented
here are private, and unsupported in the sense that the author reserves
the right to change or remove them without notice.

=cut

package PPIx::Regexp::Structure::NamedCapture;

use strict;
use warnings;

use Params::Util 0.25 qw{ _INSTANCE };

use base qw{ PPIx::Regexp::Structure::Capture };

our $VERSION = '0.000_03';

=head2 name

 my $name = $element->name();

This method returns the name of the capture.

=cut

sub name {
    my ( $self ) = @_;
    my $type = $self->type() or return;
    return $type->name();
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
