package PPIx::Regexp::Test;

use strict;
use warnings;

use base qw{ Exporter };

use Params::Util 0.25 qw{ _INSTANCE };
use PPIx::Regexp;
use PPIx::Regexp::Element;
use PPIx::Regexp::Tokenizer;
use Scalar::Util qw{ looks_like_number refaddr };
use Test::More 0.40;

our $VERSION = '0.000_01';

our @EXPORT_OK = qw{
    choose
    class
    content
    count
    false
    finis
    equals
    navigate
    parse
    plan
    tokenize
    true
    value
};

our @EXPORT = @EXPORT_OK;

my ( $parse, $kind, @nav, $nav, $obj );

sub choose {
    my @args = @_;
    $obj = $parse;
    return navigate( @args );
}

# quote a string.
sub _safe {
    my @args = @_;
    my @rslt;
    foreach my $item ( @args ) {
	if ( _INSTANCE( $item, 'PPIx::Regexp::Element' ) ) {
	    $item = $item->content();
	}
	if ( ! defined $item ) {
	    push @rslt, 'undef';
	} elsif ( ref $item eq 'ARRAY' ) {
	    push @rslt, join( ' ', '[', _safe( @{ $item } ), ']' );
	} elsif ( looks_like_number( $item ) ) {
	    push @rslt, $item;
	} else {
	    $item =~ s/ ( [\\'] ) /\\$1/smxg;
	    push @rslt, "'$item'";
	}
    }
    return join( ', ', @rslt );
}

sub class {		## no critic (RequireArgUnpacking)
    my @args = @_;
    my $class = pop @args;
    if ( defined $class ) {
	@_ = ( $obj, $class, "$kind $nav" );
	goto &isa_ok;
    } else {
	@_ = ( ref $obj || undef, $class, "Class of $kind $nav" );
	goto &is;
    }
}

sub content {		## no critic (RequireArgUnpacking)
    my @args = @_;
    my $expect = pop @args;
    my $content;
    defined $obj and $content = $obj->content();
    my $safe;
    if ( defined $content ) {
	($safe = $content) =~ s/([\\'])/\\$1/smxg;
    } else {
	$safe = 'undef';
    }
    @_ = ( $content, $expect, "$kind $nav content '$safe'" );
    goto &is;
}

sub count {		## no critic (RequireArgUnpacking)
    my ( @args ) = @_;
    my $expect = pop @args;
    if ( ref $parse eq 'ARRAY' ) {
	@_ = ( scalar @{ $parse }, $expect, "Expect $expect tokens" );
    } elsif ( ref $obj eq 'ARRAY' ) {
	@_ = ( scalar @{ $obj }, $expect, "Expect $expect tokens" );
    } elsif ( $obj->can( 'children' ) ) {
	@_ = ( scalar $obj->children(), $expect, "Expect $expect children" );
    } else {
	@_ = ( $obj->can( 'children' ), ref( $obj ) . "->can( 'children')" );
	goto &ok;
    }
    goto &is;
}

sub equals {		## no critic (RequireArgUnpacking)
    my @args = @_;
    @args < 3 and unshift @args, $obj;
    my ( $left, $right, $name ) = @args;
    if ( ! defined $left && ! defined $right ) {
	@_ = ( 1, $name );
    } elsif ( ! defined $left || ! defined $right ) {
	@_ = ( undef, $name );
    } elsif ( ref $left && ref $right ) {
	@_ = ( refaddr( $left ) == refaddr( $right ), $name );
    } elsif ( ref $left || ref $right ) {
	@_ = ( undef, $name );
    } elsif ( looks_like_number( $left ) && looks_like_number( $right ) ) {
	@_ = ( $left == $right, $name );
    } else {
	@_ = ( $left eq $right, $name );
    }
    goto &ok;
}

sub false {		## no critic (RequireArgUnpacking)
    my @args = @_;
    my ( $method, $args ) = splice @args, -2;
    ref $args eq 'ARRAY' or $args = [ $args ];
    my $class = ref $obj;
    if ( $obj->can( $method ) ) {
	@_ = ( ! $obj->$method( @{ $args || [] } ),
	    "$class->$method() is false" );
    } else {
	@_ = ( undef, "$class->$method() exists" );
    }
    goto &ok;
}

sub finis {		## no critic (RequireArgUnpacking)
    $obj = undef;
    $parse = undef;
    if ( eval { require Time::HiRes; 1 } ) {	# Cargo cult programming.
	Time::HiRes::sleep( 0.1 );		# Something like this is
    } else {					# in PPI's
	sleep 1;				# t/08_regression.t, and
    }						# who am I to argue?
    @_ = ( PPIx::Regexp::Element->_parent_keys(), 0,
	'Should be no leftover objects' );
    goto &is;
}

{

    my %array = map { $_ => 1} qw{ start type children finish };

    sub navigate {
	my @args = @_;
	my $scalar = 1;
	@args > 1
	    and ref $args[-1] eq 'ARRAY'
	    and @{ $args[-1] } == 0
	    and $array{$args[-2]}
	    and $scalar = 0;
	@nav = ();
	while ( @args ) {
	    if ( _INSTANCE( $args[0], 'PPIx::Regexp::Element' ) ) {
		$obj = shift @args;
	    } elsif ( ref $obj eq 'ARRAY' ) {
		my $inx = shift @args;
		push @nav, $inx;
		$obj = $obj->[$inx];
	    } else {
		my $method = shift @args;
		my $args = shift @args;
		ref $args eq 'ARRAY' or $args = [ $args ];
		push @nav, $method, $args;
		$obj->can( $method ) or return;
		if ( @args || $scalar ) {
		    $obj = $obj->$method( @{ $args } ) or return;
		} else {
		    $obj = [ $obj->$method( @{ $args } ) ];
		}
	    }
	}
	$nav = _safe( @nav );
	$nav =~ s/ ' ( \w+ ) ' , /$1 =>/smxg;
	$nav =~ s/ \[ \s+ \] /[]/smxg;
	return $obj;
    }

}

sub parse {		## no critic (RequireArgUnpacking)
    my ( $regexp ) = @_;
    $kind = 'element';
    $obj = $parse = PPIx::Regexp->new( $regexp );
    $nav = '';
    @_ = ( $parse, 'PPIx::Regexp', $regexp );
    goto &isa_ok;
}

sub tokenize {		## no critic (RequireArgUnpacking)
    my ( $regexp, @args ) = @_;
    $kind = 'token';
    my $obj = PPIx::Regexp::Tokenizer->new( $regexp, @args );
    if ( $obj ) {
	$parse = [ $obj->tokens() ];
    } else {
	$parse = [];
    }
    $nav = '';
    @_ = ( $obj, 'PPIx::Regexp::Tokenizer', $regexp );
    goto &isa_ok;
}

sub true {		## no critic (RequireArgUnpacking)
    my @args = @_;
    my ( $method, $args ) = splice @args, -2;
    ref $args eq 'ARRAY' or $args = [ $args ];
    my $class = ref $obj;
    if ( $obj->can( $method ) ) {
	@_ = ( $obj->$method( @{ $args || [] } ),
	    "$class->$method() is true" );
    } else {
	@_ = ( undef, "$class->$method() exists" );
    }
    goto &ok;
}

sub value {		## no critic (RequireArgUnpacking)
    my ( @args ) = @_;
    my ( $method, $args, $expect ) = splice @args, -3;
    ref $args eq 'ARRAY' or $args = [ $args ];
    my $class = ref $obj;

    if ( ! $obj->can( $method ) ) {
	@_ = ( undef, "$class->$method() exists" );
	goto &ok;
    }

    if ( ref $expect eq 'ARRAY' ) {
	@_ = ( [ $obj->$method( @{ $args || [] } ) ], $expect, $method );
	goto &is_deeply;
    }

    @_ = ( $obj->$method( @{ $args || [] } ), $expect, $method );
    goto &is;
}

1;

__END__

# ex: set textwidth=72 :
