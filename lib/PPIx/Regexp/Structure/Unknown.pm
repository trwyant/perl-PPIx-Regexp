=head1 NAME

PPIx::Regexp::Structure::Unknown - Represent an unknown structure.

=head1 SYNOPSIS

 use PPIx::Regexp::Dumper;
 PPIx::Regexp::Dumper->new( 'qr{(?(foo)bar|baz)}smx' )
     ->print();

=head1 INHERITANCE

 PPIx::Regexp::Structure::Unknown
 isa PPIx::Regexp::Structure

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

our $VERSION = '0.000_02';

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
