=head1 NAME

PPIx::Regexp::Structure::Subexpression - Represent an independent subexpression

=head1 SYNOPSIS

 use PPIx::Regexp::Dumper;
 PPIx::Regexp::Dumper->new( 'qr{foo(?>bar)}smx' )
     ->print();

=head1 INHERITANCE

 PPIx::Regexp::Structure::Subexpression
 isa PPIx::Regexp::Structure

=head1 DESCRIPTION

This class represents an independent subexpression which must (says
F<perlre>) match at the current location.

=head1 METHODS

This class provides no public methods beyond those provided by its
superclass.

=cut

package PPIx::Regexp::Structure::Subexpression;

use strict;
use warnings;

use base qw{ PPIx::Regexp::Structure };

our $VERSION = '0.000_03';

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
