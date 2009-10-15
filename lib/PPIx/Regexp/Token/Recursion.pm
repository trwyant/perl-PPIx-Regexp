=head1 NAME

PPIx::Regexp::Token::Recursion - Represent a recursion

=head1 SYNOPSIS

 use PPIx::Regexp::Dumper;
 PPIx::Regexp::Dumper->new( 'qr{(foo(?1)?)}smx' )
     ->print();

=head1 INHERITANCE

 PPIx::Regexp::Token::Recursion
 isa PPIx::Regexp::Token::Reference

=head1 DESCRIPTION

This class represents a recursion to a named or numbered capture.

=head1 METHODS

This class provides no public methods beyond those provided by its
superclass.

=cut

package PPIx::Regexp::Token::Recursion;

use strict;
use warnings;

use base qw{ PPIx::Regexp::Token::Reference };

use Carp qw{ confess };
use PPIx::Regexp::Constant qw{ $RE_CAPTURE_NAME };

our $VERSION = '0.000_01';

# Return true if the token can be quantified, and false otherwise
# sub can_be_quantified { return };

sub perl_version_introduced {
    return '5.010';
}

# Return true to be included in the token scan. This determination
# should be good for the life of the tokenizer. It is called as a static
# method with two arguments: the tokenizer object and the mode name. Use
# of the latter is pre-deprecated.
# sub __PPIX_TOKEN__scan_me {
#     my ( $class, $tokenizer, $mode ) = @_;
#     return $tokenizer->interpolates();
# };

# This must be implemented by tokens which do not recognize themselves.
# The return is a list of list references. Each list reference must
# contain a regular expression that recognizes the token, and optionally
# a reference to a hash to pass to make_token as the class-specific
# arguments. The regular expression MUST be anchored to the beginning of
# the string.
sub __PPIX_TOKEN__recognize {
    return (
	[ qr{ \A \( \? (?: ( [-+]? \d+ )) \) }smx, { is_named => 0 } ],
	[ qr{ \A \( \? (?: R) \) }smx,
	    { is_named => 0, capture => '0' } ],
	[ qr{ \A \( \?  (?: & | P> ) ( $RE_CAPTURE_NAME ) \) }smx,
	    { is_named => 1 } ],
    );
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
