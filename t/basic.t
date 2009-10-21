package main;

use strict;
use warnings;

use Test::More 0.40 tests => 144;

require_ok( 'PPIx::Regexp' );
isa_ok( 'PPIx::Regexp', 'PPIx::Regexp::Node' );

require_ok( 'PPIx::Regexp::Constant' );
isa_ok( 'PPIx::Regexp::Constant', 'Exporter' );

require_ok( 'PPIx::Regexp::Dumper' );
isa_ok( 'PPIx::Regexp::Dumper', 'PPIx::Regexp::Support' );
isa_ok( PPIx::Regexp::Dumper->new( 'xyzzy'), 'PPIx::Regexp::Dumper' );

require_ok( 'PPIx::Regexp::Element' );

require_ok( 'PPIx::Regexp::Lexer' );

require_ok( 'PPIx::Regexp::Node' );
isa_ok( 'PPIx::Regexp::Node', 'PPIx::Regexp::Element' );

require_ok( 'PPIx::Regexp::Node::Range' );
isa_ok( 'PPIx::Regexp::Node::Range', 'PPIx::Regexp::Node' );

require_ok( 'PPIx::Regexp::Structure' );
isa_ok( 'PPIx::Regexp::Structure', 'PPIx::Regexp::Node' );

require_ok( 'PPIx::Regexp::Structure::Assertion' );
isa_ok( 'PPIx::Regexp::Structure::Assertion', 'PPIx::Regexp::Structure'
    );

require_ok( 'PPIx::Regexp::Structure::BranchReset' );
isa_ok( 'PPIx::Regexp::Structure::BranchReset',
    'PPIx::Regexp::Structure' );

require_ok( 'PPIx::Regexp::Structure::Capture' );
isa_ok( 'PPIx::Regexp::Structure::Capture', 'PPIx::Regexp::Structure'
    );

require_ok( 'PPIx::Regexp::Structure::CharClass' );
isa_ok( 'PPIx::Regexp::Structure::CharClass', 'PPIx::Regexp::Structure'
    );

require_ok( 'PPIx::Regexp::Structure::Code' );
isa_ok( 'PPIx::Regexp::Structure::Code', 'PPIx::Regexp::Structure' );

require_ok( 'PPIx::Regexp::Structure::Main' );
isa_ok( 'PPIx::Regexp::Structure::Main', 'PPIx::Regexp::Structure' );

require_ok( 'PPIx::Regexp::Structure::Modifier' );
isa_ok( 'PPIx::Regexp::Structure::Modifier', 'PPIx::Regexp::Structure'
    );

require_ok( 'PPIx::Regexp::Structure::NamedCapture' );
isa_ok( 'PPIx::Regexp::Structure::NamedCapture',
    'PPIx::Regexp::Structure::Capture' );

require_ok( 'PPIx::Regexp::Structure::Quantifier' );
isa_ok( 'PPIx::Regexp::Structure::Quantifier',
    'PPIx::Regexp::Structure' );

require_ok( 'PPIx::Regexp::Structure::Regexp' );
isa_ok( 'PPIx::Regexp::Structure::Regexp',
    'PPIx::Regexp::Structure::Main' );

require_ok( 'PPIx::Regexp::Structure::Replacement' );
isa_ok( 'PPIx::Regexp::Structure::Replacement',
    'PPIx::Regexp::Structure::Main' );

require_ok( 'PPIx::Regexp::Structure::Subexpression' );
isa_ok( 'PPIx::Regexp::Structure::Subexpression',
    'PPIx::Regexp::Structure' );

require_ok( 'PPIx::Regexp::Structure::Switch' );
isa_ok( 'PPIx::Regexp::Structure::Switch', 'PPIx::Regexp::Structure' );

require_ok( 'PPIx::Regexp::Structure::Unknown' );
isa_ok( 'PPIx::Regexp::Structure::Unknown', 'PPIx::Regexp::Structure'
    );

require_ok( 'PPIx::Regexp::Support' );

require_ok( 'PPIx::Regexp::Token' );
isa_ok( 'PPIx::Regexp::Token', 'PPIx::Regexp::Element' );
isa_ok( PPIx::Regexp::Token->_new( 'xyzzy'), 'PPIx::Regexp::Token' );

require_ok( 'PPIx::Regexp::Token::Assertion' );
isa_ok( 'PPIx::Regexp::Token::Assertion', 'PPIx::Regexp::Token' );
isa_ok( PPIx::Regexp::Token::Assertion->_new( 'xyzzy'),
    'PPIx::Regexp::Token::Assertion' );

require_ok( 'PPIx::Regexp::Token::Backreference' );
isa_ok( 'PPIx::Regexp::Token::Backreference',
    'PPIx::Regexp::Token::Reference' );
isa_ok( PPIx::Regexp::Token::Backreference->_new( 'xyzzy'),
    'PPIx::Regexp::Token::Backreference' );

require_ok( 'PPIx::Regexp::Token::Backtrack' );
isa_ok( 'PPIx::Regexp::Token::Backtrack', 'PPIx::Regexp::Token' );
isa_ok( PPIx::Regexp::Token::Backtrack->_new( 'xyzzy'),
    'PPIx::Regexp::Token::Backtrack' );

require_ok( 'PPIx::Regexp::Token::CharClass' );
isa_ok( 'PPIx::Regexp::Token::CharClass', 'PPIx::Regexp::Token' );
isa_ok( PPIx::Regexp::Token::CharClass->_new( 'xyzzy'),
    'PPIx::Regexp::Token::CharClass' );

require_ok( 'PPIx::Regexp::Token::CharClass::POSIX' );
isa_ok( 'PPIx::Regexp::Token::CharClass::POSIX',
    'PPIx::Regexp::Token::CharClass' );
isa_ok( PPIx::Regexp::Token::CharClass::POSIX->_new( 'xyzzy'),
    'PPIx::Regexp::Token::CharClass::POSIX' );

require_ok( 'PPIx::Regexp::Token::CharClass::Simple' );
isa_ok( 'PPIx::Regexp::Token::CharClass::Simple',
    'PPIx::Regexp::Token::CharClass' );
isa_ok( PPIx::Regexp::Token::CharClass::Simple->_new( 'xyzzy'),
    'PPIx::Regexp::Token::CharClass::Simple' );

require_ok( 'PPIx::Regexp::Token::Code' );
isa_ok( 'PPIx::Regexp::Token::Code', 'PPIx::Regexp::Token' );
isa_ok( PPIx::Regexp::Token::Code->_new( 'xyzzy'),
    'PPIx::Regexp::Token::Code' );

require_ok( 'PPIx::Regexp::Token::Comment' );
isa_ok( 'PPIx::Regexp::Token::Comment', 'PPIx::Regexp::Token' );
isa_ok( PPIx::Regexp::Token::Comment->_new( 'xyzzy'),
    'PPIx::Regexp::Token::Comment' );

require_ok( 'PPIx::Regexp::Token::Condition' );
isa_ok( 'PPIx::Regexp::Token::Condition',
    'PPIx::Regexp::Token::Reference' );
isa_ok( PPIx::Regexp::Token::Condition->_new( 'xyzzy'),
    'PPIx::Regexp::Token::Condition' );

require_ok( 'PPIx::Regexp::Token::Control' );
isa_ok( 'PPIx::Regexp::Token::Control', 'PPIx::Regexp::Token' );
isa_ok( PPIx::Regexp::Token::Control->_new( 'xyzzy'),
    'PPIx::Regexp::Token::Control' );

require_ok( 'PPIx::Regexp::Token::Delimiter' );
isa_ok( 'PPIx::Regexp::Token::Delimiter', 'PPIx::Regexp::Token' );
isa_ok( PPIx::Regexp::Token::Delimiter->_new( 'xyzzy'),
    'PPIx::Regexp::Token::Delimiter' );

require_ok( 'PPIx::Regexp::Token::Greediness' );
isa_ok( 'PPIx::Regexp::Token::Greediness', 'PPIx::Regexp::Token' );
isa_ok( PPIx::Regexp::Token::Greediness->_new( 'xyzzy'),
    'PPIx::Regexp::Token::Greediness' );

require_ok( 'PPIx::Regexp::Token::GroupType' );
isa_ok( 'PPIx::Regexp::Token::GroupType', 'PPIx::Regexp::Token' );
isa_ok( PPIx::Regexp::Token::GroupType->_new( 'xyzzy'),
    'PPIx::Regexp::Token::GroupType' );

require_ok( 'PPIx::Regexp::Token::GroupType::Assertion' );
isa_ok( 'PPIx::Regexp::Token::GroupType::Assertion',
    'PPIx::Regexp::Token::GroupType' );
isa_ok( PPIx::Regexp::Token::GroupType::Assertion->_new( 'xyzzy'),
    'PPIx::Regexp::Token::GroupType::Assertion' );

require_ok( 'PPIx::Regexp::Token::GroupType::BranchReset' );
isa_ok( 'PPIx::Regexp::Token::GroupType::BranchReset',
    'PPIx::Regexp::Token::GroupType' );
isa_ok( PPIx::Regexp::Token::GroupType::BranchReset->_new( 'xyzzy'),
    'PPIx::Regexp::Token::GroupType::BranchReset' );

require_ok( 'PPIx::Regexp::Token::GroupType::Code' );
isa_ok( 'PPIx::Regexp::Token::GroupType::Code',
    'PPIx::Regexp::Token::GroupType' );
isa_ok( PPIx::Regexp::Token::GroupType::Code->_new( 'xyzzy'),
    'PPIx::Regexp::Token::GroupType::Code' );

require_ok( 'PPIx::Regexp::Token::GroupType::Modifier' );
isa_ok( 'PPIx::Regexp::Token::GroupType::Modifier',
    'PPIx::Regexp::Token::GroupType' );
isa_ok( 'PPIx::Regexp::Token::GroupType::Modifier',
    'PPIx::Regexp::Token::Modifier' );
isa_ok( PPIx::Regexp::Token::GroupType::Modifier->_new( 'xyzzy'),
    'PPIx::Regexp::Token::GroupType::Modifier' );

require_ok( 'PPIx::Regexp::Token::GroupType::NamedCapture' );
isa_ok( 'PPIx::Regexp::Token::GroupType::NamedCapture',
    'PPIx::Regexp::Token::GroupType' );
isa_ok( PPIx::Regexp::Token::GroupType::NamedCapture->_new( 'xyzzy'),
    'PPIx::Regexp::Token::GroupType::NamedCapture' );

require_ok( 'PPIx::Regexp::Token::GroupType::Subexpression' );
isa_ok( 'PPIx::Regexp::Token::GroupType::Subexpression',
    'PPIx::Regexp::Token::GroupType' );
isa_ok( PPIx::Regexp::Token::GroupType::Subexpression->_new( 'xyzzy'),
    'PPIx::Regexp::Token::GroupType::Subexpression' );

require_ok( 'PPIx::Regexp::Token::GroupType::Switch' );
isa_ok( 'PPIx::Regexp::Token::GroupType::Switch',
    'PPIx::Regexp::Token::GroupType' );
isa_ok( PPIx::Regexp::Token::GroupType::Switch->_new( 'xyzzy'),
    'PPIx::Regexp::Token::GroupType::Switch' );

require_ok( 'PPIx::Regexp::Token::Interpolation' );
isa_ok( 'PPIx::Regexp::Token::Interpolation',
    'PPIx::Regexp::Token::Code' );
isa_ok( PPIx::Regexp::Token::Interpolation->_new( 'xyzzy'),
    'PPIx::Regexp::Token::Interpolation' );

require_ok( 'PPIx::Regexp::Token::Literal' );
isa_ok( 'PPIx::Regexp::Token::Literal', 'PPIx::Regexp::Token' );
isa_ok( PPIx::Regexp::Token::Literal->_new( 'xyzzy'),
    'PPIx::Regexp::Token::Literal' );

require_ok( 'PPIx::Regexp::Token::Modifier' );
isa_ok( 'PPIx::Regexp::Token::Modifier', 'PPIx::Regexp::Token' );
isa_ok( PPIx::Regexp::Token::Modifier->_new( 'xyzzy'),
    'PPIx::Regexp::Token::Modifier' );

require_ok( 'PPIx::Regexp::Token::Operator' );
isa_ok( 'PPIx::Regexp::Token::Operator', 'PPIx::Regexp::Token' );
isa_ok( PPIx::Regexp::Token::Operator->_new( 'xyzzy'),
    'PPIx::Regexp::Token::Operator' );

require_ok( 'PPIx::Regexp::Token::Quantifier' );
isa_ok( 'PPIx::Regexp::Token::Quantifier', 'PPIx::Regexp::Token' );
isa_ok( PPIx::Regexp::Token::Quantifier->_new( 'xyzzy'),
    'PPIx::Regexp::Token::Quantifier' );

require_ok( 'PPIx::Regexp::Token::Recursion' );
isa_ok( 'PPIx::Regexp::Token::Recursion',
    'PPIx::Regexp::Token::Reference' );
isa_ok( PPIx::Regexp::Token::Recursion->_new( 'xyzzy'),
    'PPIx::Regexp::Token::Recursion' );

require_ok( 'PPIx::Regexp::Token::Reference' );
isa_ok( 'PPIx::Regexp::Token::Reference', 'PPIx::Regexp::Token' );
isa_ok( PPIx::Regexp::Token::Reference->_new( 'xyzzy'),
    'PPIx::Regexp::Token::Reference' );

require_ok( 'PPIx::Regexp::Token::Structure' );
isa_ok( 'PPIx::Regexp::Token::Structure', 'PPIx::Regexp::Token' );
isa_ok( PPIx::Regexp::Token::Structure->_new( 'xyzzy'),
    'PPIx::Regexp::Token::Structure' );

require_ok( 'PPIx::Regexp::Token::Unknown' );
isa_ok( 'PPIx::Regexp::Token::Unknown', 'PPIx::Regexp::Token' );
isa_ok( PPIx::Regexp::Token::Unknown->_new( 'xyzzy'),
    'PPIx::Regexp::Token::Unknown' );

require_ok( 'PPIx::Regexp::Token::Unmatched' );
isa_ok( 'PPIx::Regexp::Token::Unmatched', 'PPIx::Regexp::Token' );
isa_ok( PPIx::Regexp::Token::Unmatched->_new( 'xyzzy'),
    'PPIx::Regexp::Token::Unmatched' );

require_ok( 'PPIx::Regexp::Token::Whitespace' );
isa_ok( 'PPIx::Regexp::Token::Whitespace', 'PPIx::Regexp::Token' );
isa_ok( PPIx::Regexp::Token::Whitespace->_new( 'xyzzy'),
    'PPIx::Regexp::Token::Whitespace' );

require_ok( 'PPIx::Regexp::Tokenizer' );
isa_ok( 'PPIx::Regexp::Tokenizer', 'PPIx::Regexp::Support' );
isa_ok( PPIx::Regexp::Tokenizer->new( 'xyzzy'),
    'PPIx::Regexp::Tokenizer' );

1;
