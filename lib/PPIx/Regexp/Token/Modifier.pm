=head1 NAME

PPIx::Regexp::Token::Modifier - Represent modifiers.

=head1 SYNOPSIS

 use PPIx::Regexp::Dumper;
 PPIx::Regexp::Dumper->new( 'qr{foo}smx' )
     ->print();

The trailing C<smx> will be represented by this class.

This class also represents the whole of things like C<(?ismx)>. But the
modifiers in something like C<(?i:foo)> are represented by a
L<PPIx::Regexp::Token::GroupType::Modifier|PPIx::Regexp::Token::GroupType::Modifier>.

=head1 INHERITANCE

C<PPIx::Regexp::Token::Modifier> is a
L<PPIx::Regexp::Token|PPIx::Regexp::Token>.

C<PPIx::Regexp::Token::Modifier> is the parent of
L<PPIx::Regexp::Token::GroupType::Modifier|PPIx::Regexp::Token::GroupType::Modifier>.

=head1 DESCRIPTION

This class represents modifier characters at the end of the regular
expression.  For example, in C<qr{foo}smx> this class would represent
the terminal C<smx>.

=head2 The C<d>, C<l>, and C<u> modifiers

The C<d>, C<l>, and C<u> modifiers, introduced into the C<(?...)>
construction in Perl 5.13.6 are used to force either Unicode pattern
semantics (C<u>), locale semantics (C<l>) or default semantics (C<d> the
traditional Perl semantics, which can also mean 'dual' since it means
Unicode if the string's UTF-8 bit is on, and locale if the UTF-8 bit is
off). These are mutually exclusive. In Perl, only one can be asserted at
a time, asserting any of these overrides the inherited value of any of
the others. This method reports as asserted the last one it sees, or
none of them if it has seen none.

For example, given C<PPIx::Regexp::Token::Modifier> C<$elem>
representing the invalid regular expression fragment C<(?dul)>,
C<< $elem->asserted( 'l' ) >> would return true, but
C<< $elem->asserted( 'u' ) >> would return false. Note that
C<< $elem->negated( 'u' ) >> would also return false, since C<u> is not
explicitly negated.

If C<$elem> represented regular expression fragment C<(?i)>,
C<< $elem->asserted( 'd' ) >> would return false, since even though C<d>
represents the default behavior it is not explicitly asserted.

=head2 The caret (C<^>) modifier

Calling C<^> a modifier is a bit of a misnomer. The C<(?^...)>
construction was introduced in Perl 5.13.6, to prevent the inheritance
of modifiers. The documentation calls the caret a shorthand equivalent
for C<d-imsx>, and that it the way this class handles it.

For example, given C<PPIx::Regexp::Token::Modifier> C<$elem>
representing regular expression fragment C<(?^i)>,
C<< $elem->asserted( 'd' ) >> would return true, since in the absence of
an explicit C<l> or C<u> this class considers the C<*> to explicitly
assert C<d>.

=head1 METHODS

This class provides the following public methods. Methods not documented
here are private, and unsupported in the sense that the author reserves
the right to change or remove them without notice.

=cut

package PPIx::Regexp::Token::Modifier;

use strict;
use warnings;

use base qw{ PPIx::Regexp::Token };

use PPIx::Regexp::Constant qw{
    MINIMUM_PERL
    MODIFIER_GROUP_MATCH_SEMANTICS
};

our $VERSION = '0.014';

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
    $self->{modifiers} ||= $self->_decode();
    defined $modifier
	or return ( sort grep { $self->{modifiers}{$_} }
	    keys %{ $self->{modifiers} } );
    return $self->{modifiers}{$modifier};
}

sub can_be_quantified { return };

=head2 match_semantics

 my $sem = $token->match_semantics();
 defined $sem or $sem = 'undefined';
 print "This token has $sem match semantics\n";

This method returns the match semantics asserted by the token, as one of
the letters C<d>, C<l>, or C<u>. If no explicit match semantics are
asserted, this method returns nothing (i.e. C<undef> in scalar context).

=cut

sub match_semantics {
    my ( $self ) = @_;
    foreach my $letter ( qw{ d l u } ) {
	$self->asserts( $letter ) and return $letter;
    }
    return;
}

=head2 modifiers

 my %mods = $token->modifiers();

Returns all modifiers asserted or negated by this token, and the values
set (true for asserted, false for negated). If called in scalar context,
returns a reference to a hash containing the values.

=cut

sub modifiers {
    my ( $self ) = @_;
    $self->{modifiers} ||= $self->_decode();
    my %mods = %{ $self->{modifiers} };
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
    $self->{modifiers} ||= $self->_decode();
    defined $modifier
	or return ( sort grep { ! $self->{modifiers}{$_} }
	    keys %{ $self->{modifiers} } );
    return exists $self->{modifiers}{$modifier}
	&& ! $self->{modifiers}{$modifier};
}

sub perl_version_introduced {
    my ( $self ) = @_;
    my $content = $self->content();
    $content =~ m/ \A [(]? [?] \^ /smx
			and return '5.013006';
    if ( $content =~ m/ \A [(]? [?] /smx ) {
	# These were introduced in 5.13.6, but only inside (?...), not
	# as modifiers of the entire regular expression.
	$self->asserts( 'd' ) and return '5.013006';
	$self->asserts( 'l' ) and return '5.013006';
	$self->asserts( 'u' ) and return '5.013006';
    }
    $self->asserts( 'r' ) and return '5.013002';
    $self->asserts( 'p' ) and return '5.009005';
    $self->content() =~ m/ \A [(]? [?] .* - /smx
			and return '5.005';
    $self->asserts( 'c' ) and return '5.004';
    return MINIMUM_PERL;
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
    return (
	[ qr{ \A [(] [?] [[:lower:]]* -? [[:lower:]]* [)] }smx ],
	[ qr{ \A [(] [?] \^ [[:lower:]]* [)] }smx ],
    );
}

# After the token is made, figure out what it asserts or negates.

sub __PPIX_TOKEN__post_make {
    my ( $self, $tokenizer ) = @_;
    defined $tokenizer
	and $tokenizer->modifier_modify( $self->modifiers() );
    return;
}

{
    my %aggregate = (
	d	=> MODIFIER_GROUP_MATCH_SEMANTICS,
	l	=> MODIFIER_GROUP_MATCH_SEMANTICS,
	u	=> MODIFIER_GROUP_MATCH_SEMANTICS,
    );

    # Called by the tokenizer to modify the current modifiers with a new
    # set. Both are passed as hash references, and a reference to the
    # new hash is returned.
    sub __PPIX_TOKENIZER__modifier_modify {
	my ( @args ) = @_;

	my ( %merged, %multi_state );
	foreach my $hash ( @args ) {
	    while ( my ( $key, $val ) = each %{ $hash } ) {
		if ( my $bin = $aggregate{$key} ) {
		    $merged{$bin} = $key;
		    $multi_state{$key}++;
		} elsif ( $val ) {
		    $merged{$key} = $val;
		} else {
		    delete $merged{$key};
		}
	    }
	}

	foreach my $key ( keys %multi_state ) {
	    my $name = delete $merged{$key}
		or next;
	    $merged{$name} = 1;
	}

	return \%merged;

    }

    # Decode modifiers from the content of the token.
    sub _decode {
	my ( $self ) = @_;
	my $value = 1;
	my %present;
	my %group_present;
	my $content = $self->content();
	if ( $content =~ m/ \^ /smx ) {
	    %present = (
		MODIFIER_GROUP_MATCH_SEMANTICS()	=> 'd',
		i	=> 0,
		s	=> 0,
		m	=> 0,
		x	=> 0,
	    );
	    $group_present{ MODIFIER_GROUP_MATCH_SEMANTICS() } = 1;
	}
	# Have to do the global match rather than a split, because the
	# expression modifiers come through here too, and we need to
	# distinguish between s/.../.../e and s/.../.../ee.
	while ( $content =~ m/ ( ( [[:alpha:]-] ) \2* ) /smxg ) {
	    if ( $1 eq '-' ) {
		$value = 0;
	    } elsif ( my $bin = $aggregate{$1} ) {
		$present{$bin} = $1;
		$group_present{$bin}++;
	    } else {
		$present{$1} = $value;
	    }
	}

	foreach my $group ( keys %group_present ) {
	    my $modifier = delete $present{$group}
		or next;
	    $present{$modifier} = 1;
	}

	return \%present;
    }
}

1;

__END__

=head1 SUPPORT

Support is by the author. Please file bug reports at
L<http://rt.cpan.org>, or in electronic mail to the author.

=head1 AUTHOR

Thomas R. Wyant, III F<wyant at cpan dot org>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009-2010, Thomas R. Wyant, III

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl 5.10.0. For more details, see the full text
of the licenses in the directory LICENSES.

This program is distributed in the hope that it will be useful, but
without any warranty; without even the implied warranty of
merchantability or fitness for a particular purpose.

=cut

# ex: set textwidth=72 :
