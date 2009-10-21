=head1 NAME

PPIx::Regexp::Token::Modifier - Represent modifiers.

=head1 SYNOPSIS

 use PPIx::Regexp::Dumper;
 PPIx::Regexp::Dumper->new( 'qr{foo}smx' )
     ->print();

=head1 INHERITANCE

C<PPIx::Regexp::Token::Modifier> is a
L<PPIx::Regexp::Token|PPIx::Regexp::Token>.

C<PPIx::Regexp::Token::Modifier> is the parent of
L<PPIx::Regexp::Token::GroupType::Modifier|PPIx::Regexp::Token::GroupType::Modifier>.

=head1 DESCRIPTION

This class represents modifier characters at the end of the regular
expression.  For example, in C<qr{foo}smx> this class would represent
the terminal C<smx>.

=head1 METHODS

This class provides the following public methods. Methods not documented
here are private, and unsupported in the sense that the author reserves
the right to change or remove them without notice.

=cut

package PPIx::Regexp::Token::Modifier;

use strict;
use warnings;

use base qw{ PPIx::Regexp::Token };

use PPIx::Regexp::Constant qw{ $MINIMUM_PERL };

our $VERSION = '0.000_04';

sub _new {
    my ( $class, @args ) = @_;
    my $self = $class->SUPER::_new( @args );
    $self->{asserts} = {};	# We set these because the lexer may
    $self->{negates} = {};	# do an ad-hoc bless into this class.
    return $self;
}

=head2 asserts

 $token->asserts( 'i' ) and print "token asserts i";
 foreach ( $token->asserts() ) { print "token asserts $_\n" }

This method returns true if the token explicitly asserts the given
modifier. The example would return true for the modifier in
C<(?i:foo)>, but false for C<(?-i:foo)>.

If called without an argument, or with an undef argument, all modifiers
explicitly asserted by this token are returned.

=cut

sub asserts {
    my ( $self, $modifier ) = @_;
    defined $modifier or return ( sort keys %{ $self->{asserts} } );
    return $self->{asserts}{$modifier};
}

sub can_be_quantified { return };

=head2 modifiers

 my %mods = $token->modifiers();

Returns all modifiers asserted or negated by this token, and the values
set (true for asserted, false for negated). If called in scalar context,
returns a reference to a hash containing the values.

=cut

sub modifiers {
    my ( $self ) = @_;
    my %mods;
    foreach my $key ( %{ $self->{asserts} } ) {
	$mods{$key} = 1;
    }
    foreach my $key ( %{ $self->{negates} } ) {
	$mods{$key} = 0;
    }
    return wantarray ? %mods : \%mods;
}

=head2 negates

 $token->negates( 'i' ) and print "token negates i\n";
 foreach ( $token->negates() ) { print "token negates $_\n" }

This method returns true if the token explicitly negates the given
modifier. The example would return true for the modifier in
C<(?-i:foo)>, but false for C<(?i:foo)>.

If called without an argument, or with an undef argument, all modifiers
explicitly negated by this token are returned.

=cut

sub negates {
    my ( $self, $modifier ) = @_;
    defined $modifier or return ( sort keys %{ $self->{negates} } );
    return $self->{negates}{$modifier};
}

sub perl_version_introduced {
    my ( $self ) = @_;
    return $self->asserts( 'p' ) ? '5.010' : $MINIMUM_PERL;
}

# Return true if the token can be quantified, and false otherwise
# sub can_be_quantified { return };

# This must be implemented by tokens which do not recognize themselves.
# The return is a list of list references. Each list reference must
# contain a regular expression that recognizes the token, and optionally
# a reference to a hash to pass to make_token as the class-specific
# arguments. The regular expression MUST be anchored to the beginning of
# the string.
sub __PPIX_TOKEN__recognize {
    return ( [ qr{ \A \( \? [[:lower:]]* -? [[:lower:]]* \) }smx ] );
}

# After the token is made, figure out what it asserts or negates.

sub __PPIX_TOKEN__post_make {
    my ( $self, $tokenizer ) = @_;
    local $_ = $self->content();
    s/ [^-[:lower:]] //smxg;
    my $kind = 'asserts';
    foreach ( split qr{}smx, $_ ) {
	if ( $_ eq '-' ) {
	    $kind eq 'negates' and return;
	    $kind = 'negates';
	} else {
	    $self->{$kind}{$_} = 1;
	}
    }
    defined $tokenizer
	and $tokenizer->modifier_modify( $self->modifiers() );
    return;
}

1;

__END__

=head1 SUPPORT

Support is by the author. Please file bug reports at
L<http://rt.cpan.org>, or in electronic mail to the author.

=head1 AUTHOR

Thomas R. Wyant, III F<wyant at cpan dot org>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009, Thomas R. Wyant, III

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl 5.10.0. For more details, see the full text
of the licenses in the directory LICENSES.

This program is distributed in the hope that it will be useful, but
without any warranty; without even the implied warranty of
merchantability or fitness for a particular purpose.

=cut

# ex: set textwidth=72 :
