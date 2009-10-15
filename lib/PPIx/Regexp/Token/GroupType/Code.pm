=head1 NAME

PPIx::Regexp::Token::GroupType::Code - Represent one of the embedded code indicators

=head1 SYNOPSIS

 use PPIx::Regexp::Dumper;
 PPIx::Regexp::Dumper->new( 'qr{(?{print "hello world!\n")}smx' )
     ->print();

=head1 INHERITANCE

 PPIx::Regexp::Token::GroupType::Code
 isa PPIx::Regexp::Token::GroupType

=head1 DESCRIPTION

This method represents one of the embedded code indicators, either '?'
or '??', in the zero-width assertion

 (?{ print "Hello, world!\n" })

or the old-style deferred expression syntax

 my $foo;
 $foo = qr{ foo (??{ $foo }) }smx;

=head1 METHODS

This class provides no public methods beyond those provided by its
superclass.

=cut

package PPIx::Regexp::Token::GroupType::Code;

use strict;
use warnings;

use base qw{ PPIx::Regexp::Token::GroupType };

our $VERSION = '0.000_01';

# Return true if the token can be quantified, and false otherwise
# sub can_be_quantified { return };

{
    sub perl_version_removed {
	my ( $self ) = @_;
	exists $self->{perl_version_removed}
	    and return $self->{perl_version_removed};
	return ( $self->{perl_version_removed} =
	    $self->content() =~ m/ \A \\? \? p \z /smx ? '5.010' : undef
	);
    }
}

# Return true to be included in the token scan. This determination
# should be good for the life of the tokenizer. It is called as a static
# method with two arguments: the tokenizer object and the mode name. Use
# of the latter is pre-deprecated.
# sub __PPIX_TOKEN__scan_me {
#     my ( $class, $tokenizer, $mode ) = @_;
#     return $tokenizer->interpolates();
# };

sub __PPIX_TOKENIZER__regexp {
    my ( $class, $tokenizer, $character ) = @_;

    # Recognize '?{', '??{', or '?p{', the latter deprecated in Perl
    # 5.6, and removed in 5.10. The extra escapes are because the
    # non-open-bracket characters may appear as delimiters to the
    # expression.
    if ( my $accept = $tokenizer->find_regexp(
	    qr{ \A \\? \? \\? [?p]? \{ }smx ) ) {

	--$accept;	# Don't want the curly bracket.

	# Code token comes after.
	$tokenizer->expect( 'PPIx::Regexp::Token::Code' );

	return $accept;
    }

    return;
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
