=head1 NAME

PPIx::Regexp::Element - Base of the PPIx::Regexp hierarchy.

=head1 SYNOPSIS

No user-serviceable parts inside.

=head1 INHERITANCE

C<PPIx::Regexp::Element> is not descended from any other class.

C<PPIx::Regexp::Element> is the parent of
L<PPIx::Regexp::Node|PPIx::Regexp::Node> and
L<PPIx::Regexp::Token|PPIx::Regexp::Token>.

=head1 DESCRIPTION

This class is the base of the L<PPIx::Regexp|PPIx::Regexp>
object hierarchy. It provides the same kind of navigational
functionality that is provided by L<PPI::Element|PPI::Element>.

=head1 METHODS

This class provides the following public methods. Methods not documented
here are private, and unsupported in the sense that the author reserves
the right to change or remove them without notice.

=cut

package PPIx::Regexp::Element;

use strict;
use warnings;

use 5.006;

use List::MoreUtils qw{ firstidx };
use Params::Util 0.25 qw{ _INSTANCE };
use Scalar::Util qw{ refaddr weaken };

use PPIx::Regexp::Constant qw{ $MINIMUM_PERL };

our $VERSION = '0.000_03';

=head2 ancestor_of

This method returns true if the object is an ancestor of the argument,
and false otherwise. By the definition of this method, C<$self> is its
own ancestor.

=cut

sub ancestor_of {
    my ( $self, $elem ) = @_;
    _INSTANCE( $elem, __PACKAGE__ ) or return;
    my $addr = refaddr( $self );
    while ( $addr != refaddr( $elem ) ) {
	$elem = $elem->_parent() or return;
    }
    return 1;
}

=head2 class

This method returns the class name of the element. It is the same as
C<ref $self>.

=cut

sub class {
    my ( $self ) = @_;
    return ref $self;
}

=head2 comment

This method returns true if the element is a comment and false
otherwise.

=cut

sub comment {
    return;
}

=head2 content

This method returns the content of the element.

=cut

sub content {
    return;
}

=head2 descendant_of

This method returns true if the object is a descendant of the argument,
and false otherwise. By the definition of this method, C<$self> is its
own descendant.

=cut

sub descendant_of {
    my ( $self, $node ) = @_;
    _INSTANCE( $node, __PACKAGE__ ) or return;
    return $node->ancestor_of( $self );
}

=head2 next_sibling

This method returns the element's next sibling, or nothing if there is
none.

=cut

sub next_sibling {
    my ( $self ) = @_;
    my ( $method, $inx ) = $self->_my_inx()
	or return;
    return $self->_parent()->$method( $inx + 1 );
}

=head2 parent

This method returns the parent of the element, or undef if there is
none.

=cut

sub parent {
    my ( $self ) = @_;
    return $self->_parent();
}

=head2 perl_version_introduced

This method returns the version of Perl in which the element was
introduced. But in practice it will never return a number less than
5.006, since that is the minimum version supported by this package.

=cut

sub perl_version_introduced {
    return $MINIMUM_PERL;
}

=head2 perl_version_removed

This method returns the version of Perl in which the element was
removed. If the element is still valid the return is C<undef>.

=cut

sub perl_version_removed {
    return undef;	## no critic (ProhibitExplicitReturnUndef)
}

=head2 previous_sibling

This method returns the element's previous sibling, or nothing if there
is none.

=cut

sub previous_sibling {
    my ( $self ) = @_;
    my ( $method, $inx ) = $self->_my_inx()
	or return;
    $inx or return;
    return $self->_parent()->$method( $inx - 1 );
}

=head2 significant

This method returns true if the element is significant and false
otherwise.

=cut

sub significant {
    return 1;
}

=head2 snext_sibling

This method returns the element's next significant sibling, or nothing
if there is none.

=cut

sub snext_sibling {
    my ( $self ) = @_;
    my $sib = $self;
    while ( defined ( $sib = $sib->next_sibling() ) ) {
	$sib->significant() and return $sib;
    }
    return;
}

=head2 sprevious_sibling

This method returns the element's previous significant sibling, or
nothing if there is none.

=cut

sub sprevious_sibling {
    my ( $self ) = @_;
    my $sib = $self;
    while ( defined ( $sib = $sib->previous_sibling() ) ) {
	$sib->significant() and return $sib;
    }
    return;
}

=head2 tokens

This method returns all tokens contained in the element.

=cut

sub tokens {
    my ( $self ) = @_;
    return $self;
}

=head2 top

This method returns the top of the hierarchy.

=cut

sub top {
    my ( $self ) = @_;
    my $kid = $self;
    while ( defined ( my $parent = $kid->_parent() ) ) {
	$kid = $parent;
    }
    return $kid;
}

=head2 whitespace

This method returns true if the element is whitespace and false
otherwise.

=cut

sub whitespace {
    return;
}

=head2 nav

This method returns navigation information from the top of the hierarchy
to this node. The return is a list of names of methods and references to
their argument lists. The idea is that given C<$elem> which is somewhere
under C<$top>,

 my @nav = $elem->nav();
 my $obj = $top;
 while ( @nav ) {
     my $method = shift @nav;
     my $args = shift @nav;
     $obj = $obj->$method( @{ $args } ) or die;
 }
 # At this point, $obj should contain the same object
 # as $elem.

=cut

sub nav {
    my ( $self ) = @_;
    _INSTANCE( $self, __PACKAGE__ ) or return;

    # We do not use $self->parent() here because PPIx::Regexp overrides
    # this to return the (possibly) PPI object that initiated us.
    my $parent = $self->_parent() or return;

    return ( $parent->nav(), $parent->_nav( $self ) );
}

# Make sure we are an instance of PPI::Element.

sub _instance {
    my ( $self, $element ) = @_;
    return _INSTANCE( $element, __PACKAGE__ );
}

# Find our location and index among the parent's children. If not found,
# just returns.

{
    my %method_map = (
	children => 'child',
    );
    sub _my_inx {
	my ( $self ) = @_;
	my $parent = $self->_parent() or return;
	my $addr = refaddr( $self );
	foreach my $method ( qw{ children start type finish } ) {
	    $parent->can( $method ) or next;
	    my $inx = firstidx { refaddr $_ == $addr } $parent->$method();
	    $inx < 0 and next;
	    return ( $method_map{$method} || $method, $inx );
	}
	return;
    }
}

{
    my %parent;

    # no-argument form returns the parent; one-argument sets it.
    sub _parent {
	my ( $self, @arg ) = @_;
	my $addr = refaddr( $self );
	if ( @arg ) {
	    my $parent = shift @arg;
	    if ( defined $parent ) {
		_INSTANCE( $parent, __PACKAGE__ ) or return;
		weaken(
		    $parent{$addr} = $parent );
	    } else {
		delete $parent{$addr};
	    }
	}
	return $parent{$addr};
    }

    sub _parent_keys {
	return scalar keys %parent;
    }

}

# Called by the lexer to record the capture number.
sub __PPIX_LEXER__record_capture_number {
    my ( $self, $number ) = @_;
    return $number;
}

sub DESTROY {
    $_[0]->_parent( undef );
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
