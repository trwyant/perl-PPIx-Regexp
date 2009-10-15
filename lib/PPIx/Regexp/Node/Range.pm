=head1 NAME

PPIx::Regexp::Node::Range - Represent a character range in a character class

=head1 SYNOPSIS

 use PPIx::Regexp::Dumper;
 PPIx::Regexp::Dumper->new( 'qr{[a-z]}smx' )
     ->print();

=head1 INHERITANCE

 PPIx::Regexp::Node::Range
 isa PPIx::Regexp::Node

=head1 DESCRIPTION

This class represents a character range in a character class. It is a
node rather than a structure because there are no delimiters. The
content is simply the two literals with the '-' operator between them.

=head1 METHODS

This class provides no public methods beyond those provided by its
superclass.

=cut

package PPIx::Regexp::Node::Range;

use strict;
use warnings;

use base qw{ PPIx::Regexp::Node };

our $VERSION = '0.000_01';

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
