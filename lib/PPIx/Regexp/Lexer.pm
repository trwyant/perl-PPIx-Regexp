=head1 NAME

PPIx::Regexp::Lexer - Assemble tokenizer output.
=head1 SYNOPSIS

 use PPIx::Regexp::Lexer;
 use PPIx::Regexp::Dumper;
 my $lex = PPIx::Regexp::Lexer->new('qr{foo}smx');
 my $dmp = PPIx::Regexp::Dumper->new( $lex );
 $dmp->print();

=head1 INHERITANCE

 PPIx::Regexp::Lexer

=head1 DESCRIPTION

Insert tedious prose here.

=head1 METHODS

This class provides the following public methods. Methods not documented
here are private, and unsupported in the sense that the author reserves
the right to change or remove them without notice.

=cut

package PPIx::Regexp::Lexer;

use strict;
use warnings;

use Carp qw{ confess };
use Params::Util 0.25 qw{ _INSTANCE };
use PPIx::Regexp::Constant qw{ $TOKEN_LITERAL $TOKEN_UNKNOWN };
use PPIx::Regexp::Node::Range				();
use PPIx::Regexp::Structure				();
use PPIx::Regexp::Structure::Assertion			();
use PPIx::Regexp::Structure::BranchReset		();
use PPIx::Regexp::Structure::Code			();
use PPIx::Regexp::Structure::Capture			();
use PPIx::Regexp::Structure::CharClass			();
use PPIx::Regexp::Structure::Subexpression		();
use PPIx::Regexp::Structure::Main			();
use PPIx::Regexp::Structure::Modifier			();
use PPIx::Regexp::Structure::NamedCapture		();
use PPIx::Regexp::Structure::Quantifier			();
use PPIx::Regexp::Structure::Switch			();
use PPIx::Regexp::Structure::Unknown			();
use PPIx::Regexp::Token::Unmatched			();
use PPIx::Regexp::Tokenizer				();

our $VERSION = '0.000_02';

=head2 new

This method instantiates the lexer. It takes as its argument the text
to be lexed.

=cut

{

    my $errstr;

    sub new {
	my ( $class, $tokenizer, %args ) = @_;
	ref $class and $class = ref $class;

	_INSTANCE( $tokenizer, 'PPIx::Regexp::Tokenizer' )
	    or $tokenizer = PPIx::Regexp::Tokenizer->new( $tokenizer, %args )
	    or do {
		$errstr = PPIx::Regexp::Tokenizer->errstr();
		return;
	    };

	my $self = {
	    deferred => [],
	    failures => 0,
	    tokenizer => $tokenizer,
	};

	bless $self, $class;
	return $self;
    }

    sub errstr {
	return $errstr;
    }

}

=head2 errstr

This method returns the error string from the last attempt to
instantiate a C<PPIx::Regexp::Lexer>. If the last attempt succeeded, the
error will be C<undef>.

=cut

# Defined above

=head2 failures

 print $lexer->failures(), " parse failures\n";

This method returns the number of parse failures encountered. A
parse failure is either a tokenization failure (see
L<PPIx::Regexp::Tokenizer/failures>) or a structural error.

=cut

sub failures {
    my ( $self ) = @_;
    return $self->{failures};
}

=head2 get_token

This method returns the next token from the tokenizer.

=cut

sub get_token {
    my ( $self ) = @_;

    if ( @{ $self->{deferred} } ) {
	return shift @{ $self->{deferred} };
    }

    my $token = $self->{tokenizer}->next_token() or return;

    return $token;
}

=head2 lex

This method lexes the tokens in the text, and returns the lexed list of
elements.

=cut

sub lex {
    my ( $self ) = @_;

    my @content;
    $self->{failures} = 0;

    # Accept everything up to the first delimiter.
    {
	my $token = $self->get_token()
	    or return $self->_finalize( @content );
	$token->isa( 'PPIx::Regexp::Token::Delimiter' ) or do {
	    push @content, $token;
	    redo;
	};
	$self->unget_token( $token );
    }

    # Accept the first delimited structure.
    push @content, ( my $regexp = $self->_get_delimited() );

    # If we are a substitution ...
    if ( $content[0]->content() eq 's' ) {

	# Accept any insignificant stuff.
	while ( my $token = $self->get_token() ) {
	    if ( $token->significant() ) {
		$self->unget_token( $token );
		last;
	    } else {
		push @content, $token;
	    }
	}

	# Accept the next delimited structure.
	push @content, $self->_get_delimited();
    }

    # Accept the modifiers, we hope.
    push @content, $self->get_token();

    # Let all the elements finalize themselves, recording any additional
    # errors as they do so.
    $self->_finalize( @content );

    # If we found a regular expression (and we should have done so) ...
    if ( $regexp ) {

	# Calculate the maximum capture group, and number all the other
	# capture groups along the way.
	my $max_capture = $self->{max_capture_number} =
	    $regexp->__PPIX_LEXER__record_capture_number( 1 ) - 1;

	# If we have any back references
	if ( my $backrefs = $regexp->find(
		'PPIx::Regexp::Token::Backreference' ) ) {

	    # The break point for capture group numbers is either 9 or
	    # the actual number found, whichever is greater.
	    my $limit = $max_capture > 9 ? $max_capture : 9;

	    foreach my $elem ( @{ $backrefs } ) {

		# Named or relative captures are not at issue.
		( my $content = $elem->content() )
		    =~ m/ \A \\ ( \d+ ) \z /smx
		    or next;

		# Anything less than or equal to the break point remains
		# a capture group.
		$1 <= $limit and next;

		# Anything greater than the break point (in decimal)
		# gets made a literal. Because the literal is octal, we
		# make an unknown instead of it contains non-octal
		# digits.
		if ( $content =~ m/ [89] /smx ) {
		    bless $elem, $TOKEN_UNKNOWN;
		    $self->{failures}++;
		} else {
		    bless $elem, $TOKEN_LITERAL;
		}

	    }
	}
    }

    return @content;

}

# Finalize the content array, updating the parse failures count as we
# go.
sub _finalize {
    my ( $self, @content ) = @_;
    foreach my $elem ( @content ) {
	$self->{failures} += $elem->__PPIX_LEXER__finalize();
    }
    defined wantarray and return @content;
    return;
}

=head2 max_capture_number

 my $max = $lexer->max_capture_number();

This method returns the maximum capture number found by the lexer.

=cut

sub max_capture_number {
    my ( $self ) = @_;
    return $self->{max_capture_number};
}

=head2 unget_token

This method caches its argument so that it will be returned by the next
call to C<get_token()>. If more than one argument is passed, they will
be returned in the order given; that is, unget_token/get_token work like
unshift/shift.

=cut

sub unget_token {
    my ( $self, @args ) = @_;
    unshift @{ $self->{deferred} }, @args;
    return $self;
}

my %bracket = (
    '{' => '}',
    '(' => ')',
    '[' => ']',
##  '<' => '>',
);

my %unclosed = (
    '{' => '_recover_curly',
);

sub _get_delimited {
    my ( $self ) = @_;

    my @rslt;
    $self->{_rslt} = \@rslt;

    if ( my $token = $self->get_token() ) {
	push @rslt, [];
	if ( $token->isa( 'PPIx::Regexp::Token::Delimiter' ) ) {
	    push @{ $rslt[-1] }, '', $token;
	} else {
	    push @{ $rslt[-1] }, '', undef;
	    $self->unget_token( $token );
	}
    } else {
	return;
    }

    while ( my $token = $self->get_token() ) {
	if ( $token->isa( 'PPIx::Regexp::Token::Delimiter' ) ) {
	    $self->unget_token( $token );
	    last;
	}
	if ( $token->isa( 'PPIx::Regexp::Token::Structure' ) ) {
	    my $content = $token->content();

	    if ( my $finish = $bracket{$content} ) {
		# Open bracket
		push @rslt, [ $finish, $token ];

	    } elsif ( $content eq $rslt[-1][0] ) {

		# Matched close bracket
		$self->_make_node( $token );

	    } elsif ( $content ne ')' ) {

		# If the close bracket is not a parenthesis, it becomes
		# a literal.
		bless $token, $TOKEN_LITERAL;
		push @{ $rslt[-1] }, $token;

	    } elsif ( $content eq ')'
		    and my $recover = $unclosed{$rslt[-1][1]->content()} ) {

		# If the close bracket is a parenthesis and there is a
		# recovery procedure, we use it.
		$self->$recover( $token );

	    } else {

		# Unmatched close with no recovery.
		$self->{failures}++;
		bless $token, 'PPIx::Regexp::Token::Unmatched';
		push @{ $rslt[-1] }, $token;
	    }

	} else {
	    push @{ $rslt[-1] }, $token;
	}

	# We have to hand-roll the Range object.
	if ( _INSTANCE( $rslt[-1][-2], 'PPIx::Regexp::Token::Operator' )
	    && $rslt[-1][-2]->content() eq '-' ) {
	    my @tokens = splice @{ $rslt[-1] }, -3;
	    push @{ $rslt[-1] },
		PPIx::Regexp::Node::Range->_new( @tokens );
	}
    }

    while ( @rslt > 1 ) {
	if ( my $recover = $unclosed{$rslt[-1][1]->content()} ) {
	    $self->$recover();
	} else {
	    $self->{failures}++;
	    $self->_make_node( undef );
	}
    }

    if ( @rslt == 1 ) {
	my @last = @{ pop @rslt };
	shift @last;
	push @last, $self->get_token();
	return PPIx::Regexp::Structure::Main->_new( @last );
    } else {
	confess "Missing data";
    }

}

{

    my %handler = (
	'(' => '_round',
	'[' => '_square',
	'{' => '_curly',
    );

    sub _make_node {
	my ( $self, $token ) = @_;
	my @args = @{ pop @{ $self->{_rslt} } };
	shift @args;
	push @args, $token;
	my @node;
	if ( my $method = $handler{ $args[0]->content() } ) {
	    @node = $self->$method( \@args );
	}
	@node or @node = PPIx::Regexp::Structure->_new( @args );
	push @{ $self->{_rslt}[-1] }, @node;
	return;
    }

}

sub _curly {
    my ( $self, $args ) = @_;

    if ( $args->[-1] && $args->[-1]->is_quantifier() ) {

	# If the tokenizer has marked the right curly as a quantifier,
	# make the whole thing a quantifier structure.
	return PPIx::Regexp::Structure::Quantifier->_new( @{ $args } );

    } elsif ( $args->[-1] ) {

	# If there is a right curly but it is not a quantifier,
	# make both curlys into literals.
	foreach my $inx ( 0, -1 ) {
	    bless $args->[$inx], $TOKEN_LITERAL;
	}

	# Try to recover possible quantifiers not recognized because we
	# thought this was a structure.
	$self->_recover_curly_quantifiers( $args );

	return @{ $args };

    } else {

	# If there is no right curly, just make a generic structure
	# TODO maybe this should be something else?
	return PPIx::Regexp::Structure->_new( @{ $args } );
    }
}

sub _recover_curly {
    my ( $self, $token ) = @_;

    # Get all the stuff we have accumulated for this curly.
    my @content = @{ pop @{ $self->{_rslt} } };

    # Lose the right bracket, which we have already failed to match.
    shift @content;

    # Rebless the left curly to a literal.
    bless $content[0], $TOKEN_LITERAL;

    # Try to recover possible quantifiers not recognized because we
    # thought this was a structure.
    $self->_recover_curly_quantifiers( \@content );

    # Shove the curly and its putative contents into whatever structure
    # we have going.
    push @{ $self->{_rslt}[-1] }, @content;

    # Shove the mismatched delimiter back into the input so we can have
    # another crack at it.
    $token and $self->unget_token( $token );

    # We gone.
    return;
}

sub _recover_curly_quantifiers {
    my ( $self, $args ) = @_;

    if ( _INSTANCE( $args->[0], $TOKEN_LITERAL )
	&& _INSTANCE( $args->[1], $TOKEN_UNKNOWN )
	&& PPIx::Regexp::Token::Quantifier->could_be_quantifier(
	$args->[1]->content() )
    ) {
	bless $args->[1], 'PPIx::Regexp::Token::Quantifier';

	if ( _INSTANCE( $args->[2], $TOKEN_UNKNOWN )
	    && PPIx::Regexp::Token::Greediness->could_be_greediness(
		$args->[2]->content() )
	) {
	    bless $args->[2], 'PPIx::Regexp::Token::Greediness';
	}

    }

    return;
}

sub _round {
    my ( $self, $args ) = @_;

    # The instantiator will rebless based on the first token if need be.
    return PPIx::Regexp::Structure::Capture->_new( @{ $args } );
}

sub _square {
    my ( $self, $args ) = @_;
    return PPIx::Regexp::Structure::CharClass->_new( @{ $args } );
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
