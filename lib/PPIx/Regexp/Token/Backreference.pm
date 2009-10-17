=head1 NAME

PPIx::Regexp::Token::Backreference - Represent a back reference

=head1 SYNOPSIS

 use PPIx::Regexp::Dumper;
 PPIx::Regexp::Dumper->new( 'qr{(foo|bar)baz\1}smx' )
     ->print();

=head1 INHERITANCE

 PPIx::Regexp::Token::Backreference
 isa PPIx::Regexp::Token::Reference

=head1 DESCRIPTION

This class represents back references of all sorts, both the traditional
numbered variety and the Perl 5.010 named kind.

=head1 METHODS

This class provides no public methods beyond those provided by its
superclass.

=cut

package PPIx::Regexp::Token::Backreference;

use strict;
use warnings;

use base qw{ PPIx::Regexp::Token::Reference };

use Carp qw{ confess };
use PPIx::Regexp::Constant qw{ $MINIMUM_PERL $RE_CAPTURE_NAME };

our $VERSION = '0.000_02';

# Return true if the token can be quantified, and false otherwise
# sub can_be_quantified { return };

{

    my %perl_version_introduced = (
	g => '5.010',	# \g1 \g-1 \g{1} \g{-1}
	k => '5.010',	# \k<name> \k'name'
	'?' => '5.010',	# (?P=name)	(PCRE/Python)
    );

    sub perl_version_introduced {
	my ( $self ) = @_;
	return $perl_version_introduced{substr( $self->content(), 1, 1 )} ||
	    $MINIMUM_PERL;
    }

}

my @external = (	# Recognition used externally
    [ qr{ \A \( \? P = ( $RE_CAPTURE_NAME ) \) }smx,
	{ is_named => 1 },
	],
);

my @recognize = (	# recognition used internally
    [
	qr{ \A \\ (?:		# numbered (including relative)
	    ( \d+ )	|
	    g (?: ( -? \d+ ) | \{ ( -? \d+ ) \} )
	)
	}smx, { is_named => 0 }, ],
    [
	qr{ \A \\ (?:		# named
	    g \{ ( $RE_CAPTURE_NAME ) \} |
	    k (?: \< ( $RE_CAPTURE_NAME ) \> |	# named with angles
		' ( $RE_CAPTURE_NAME ) ' )	#   or quotes
	)
	}smx, { is_named => 1 }, ],
);

# This must be implemented by tokens which do not recognize themselves.
# The return is a list of list references. Each list reference must
# contain a regular expression that recognizes the token, and optionally
# a reference to a hash to pass to make_token as the class-specific
# arguments. The regular expression MUST be anchored to the beginning of
# the string.
sub __PPIX_TOKEN__recognize {
    return __PACKAGE__->isa( scalar caller ) ?
	( @external, @recognize ) :
	( @external );
}

sub __PPIX_TOKENIZER__regexp {
    my ( $class, $tokenizer, $character ) = @_;

    # PCRE/Python back references are handled in
    # PPIx::Regexp::Token::Structure, because they are parenthesized.

    # All the other styles are escaped.
    $character eq '\\'
	or return;

    foreach ( @recognize ) {
	my ( $re, $arg ) = @{ $_ };
	my $accept = $tokenizer->find_regexp( $re ) or next;
	return $tokenizer->make_token( $accept, __PACKAGE__, $arg );
    }

    return;
}

*__PPIX_TOKENIZER__repl = \&__PPIX_TOKENIZER__regexp;

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
