=head1 NAME

PPIx::Regexp::Structure::Modifier - Represent modifying parentheses

=head1 SYNOPSIS

 use PPIx::Regexp::Dumper;
 PPIx::Regexp::Dumper->new( 'qr{(?i:foo)}smx' )
     ->print();

=head1 INHERITANCE

C<PPIx::Regexp::Structure::Modifier> is a
L<PPIx::Regexp::Structure|PPIx::Regexp::Structure>.

C<PPIx::Regexp::Structure::Modifier> has no descendants.

=head1 DESCRIPTION

This class represents parentheses that apply modifiers to their contents
-- even if there are no modifiers. The latter is to say that C<(?:foo)>
also ends up as this class.

=head1 METHODS

This class provides no public methods beyond those provided by its
superclass.

=cut

package PPIx::Regexp::Structure::Modifier;

use strict;
use warnings;

use Params::Util 0.25 qw{ _INSTANCE };

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
