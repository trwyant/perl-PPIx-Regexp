# This test instantiates tokens directly rather than through the
# tokenizer. It is up to the author of the test to be sure that the
# the contents of each token are consistent with its class. There is
# also the risk that tokens instantiated directly may be set up
# differently than theoretically-equivalent tokens generated by the
# tokenizer, in cases where __PPIX_TOKEN__recognize() is used.
#
# Caveat Auctor.

package main;

use 5.006002;

use strict;
use warnings;

use Test::More 0.88;

our $REPORT;	# True to report rather than test.

# If $REPORT is true, you get instead of a test a CSV-formatted report
# of the syntax elements and the versions they were introduced and
# retracted. Named arguments to the routines have been added to support
# the report -- perhaps too many of them. All are optional. They are:
#     note => Text describing the thing being reported on. This is
#         described further in the details of the report.
#     text => The text of the thing reported on. If applied to the class
#         it is a sprintf template. The default is the content of the
#         token.
#     report => false to suppress the report. If applied to the class it
#         is a default for all tokens in that class.
# The columns of the report are:
#     Kind => The kind of syntax element. This is the 'note' argument to
#         the class() subroutine, and defaults to the class name.
#     Token => The syntax element itself. This is the 'text' argument of
#         the token() or class() subroutines (the latter suitably
#         processed), defaulting to the actual content of the syntax
#         element.
#     Descr => The description of the syntax element. This is the 'note'
#         argument of the token() subroutine, defaulting to the empty
#         string.
#     Introduced => The version of Perl in which the element was
#         introduced, from the perl_version_introduced() method of the
#         token. Since I have not researched Perl 4, and I have no
#         access to Perls earlier than 5.3, anything in 5.3 is assumed
#         willy-nilly to be in Perl 5.0.
#     Ref => The source of the version introduced, if known. Typically a
#         Perl documentation reference. If a reference other than
#         perl?*delta, the Perl version of the documentation is
#         prefaced, and the version is inferred from the fact that the
#         previous version of the document did not refer to the feature.
#         The default is the empty string.
#     Removed => The version of Perl in which the element was removed.
#         The default is '', indicating that the element is still in
#         Perl.
#     Ref => The source of the version removed, if known, and if the
#         element has in fact been removed.
#
# One way to use this is
#     $ perl -e '$REPORT = 1; do "t/version.t";'

# Trailing empty fields are removed.

use PPIx::Regexp::Constant qw{ COOKIE_REGEX_SET MINIMUM_PERL };
use PPIx::Regexp::Tokenizer;

sub class (@);
sub finis ();
sub method (@);
sub token (@);

class	'PPIx::Regexp::Token::Assertion', note => 'Assertion';
token	'^', note => 'Matches beginning of string or after newline';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'$', note => 'Matches end of string or newline';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'\b', note => 'Matches word/nonword boundary';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'\B', note => 'Opposite of \b';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'\A', note => 'Matches beginning of string';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'\Z', note => 'Matches end of string, or newline before end';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'\G', note => 'Matches at pos()';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'\z', note => 'Matches end of string';
method	perl_version_introduced => '5.005', note => 'perl5005delta';
method	perl_version_removed	=> undef;
token	'\K', note => 'In s///, keep everything before the \K';
method	perl_version_introduced => '5.009005', note => 'perl595delta';
method	perl_version_removed	=> undef;
token	'\b{gcb}', note => 'Assert grapheme cluster boundary';
method	perl_version_introduced => '5.021009', note => 'perl5219delta';
method	perl_version_removed	=> undef;
token	'\b{g}', note => 'Assert grapheme cluster boundary';
method	perl_version_introduced => '5.021009', note => 'perl5219delta';
method	perl_version_removed	=> undef;
token	'\b{wb}', note => 'Assert word boundary';
method	perl_version_introduced => '5.021009', note => 'perl5219delta';
method	perl_version_removed	=> undef;
token	'\b{sb}', note => 'Assert sentence boundary';
method	perl_version_introduced => '5.021009', note => 'perl5219delta';
method	perl_version_removed	=> undef;
token	'\B{gcb}', note => 'Assert no grapheme cluster boundary';
method	perl_version_introduced => '5.021009', note => 'perl5219delta';
method	perl_version_removed	=> undef;
token	'\B{g}', note => 'Assert no grapheme cluster boundary';
method	perl_version_introduced => '5.021009', note => 'perl5219delta';
method	perl_version_removed	=> undef;
token	'\B{wb}', note => 'Assert no word boundary';
method	perl_version_introduced => '5.021009', note => 'perl5219delta';
method	perl_version_removed	=> undef;
token	'\B{sb}', note => 'Assert no sentence boundary';
method	perl_version_introduced => '5.021009', note => 'perl5219delta';
method	perl_version_removed	=> undef;

class	'PPIx::Regexp::Token::Backreference', note => 'Back reference';
token	'\1', note => 'Back reference to first capture group';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'\g1', note => 'Back reference to first capture group';
method	perl_version_introduced => '5.009005', note => 'perl595delta';
method	perl_version_removed	=> undef;
token	'\g{1}', note => 'Back reference to first capture group';
method	perl_version_introduced => '5.009005', note => 'perl595delta';
method	perl_version_removed	=> undef;
token	'\g-1', note => 'Back reference to previous capture group';
method	perl_version_introduced => '5.009005';
method	perl_version_removed	=> undef;
token	'\g{-1}', note => 'Back reference to previous capture group';
method	perl_version_introduced => '5.009005', note => 'perl595delta';
method	perl_version_removed	=> undef;
token	'\k<foo>', note => 'Back reference to named capture group';
method	perl_version_introduced => '5.009005', note => 'perl595delta';
method	perl_version_removed	=> undef;
token	q{\k'foo'}, note => 'Back reference to named capture group';
method	perl_version_introduced => '5.009005';
method	perl_version_removed	=> undef;
token	'(?P=foo)', note => 'Back reference to named capture group';
method	perl_version_introduced => '5.009005';
method	perl_version_removed	=> undef;

class	'PPIx::Regexp::Token::Backtrack', note => 'Back tracking control';
token	'(*THEN)', note => 'Forces next alternation on failure';
method	perl_version_introduced => '5.009005', note => 'perl595delta';
method	perl_version_removed	=> undef;
token	'(*PRUNE)', note => 'Prevent backtracking past here on failure';
method	perl_version_introduced => '5.009005', note => 'perl595delta';
method	perl_version_removed	=> undef;
token	'(*MARK)',
    note => 'Name branches of alternation, target for (*SKIP)';
method	perl_version_introduced => '5.009005', note => 'perl595delta';
method	perl_version_removed	=> undef;
token	'(*SKIP)',
    note => 'Like (*PRUNE) but also discards match to this point';
method	perl_version_introduced => '5.009005', note => 'perl595delta';
method	perl_version_removed	=> undef;
token	'(*COMMIT)',
    note => 'Causes match failure when backtracked into on failure';
method	perl_version_introduced => '5.009005', note => 'perl595delta';
method	perl_version_removed	=> undef;
token	'(*FAIL)', note => 'Always fails, forcing backtrack';
method	perl_version_introduced => '5.009005', note => 'perl595delta';
method	perl_version_removed	=> undef;
token	'(*ACCEPT)',
    note => 'Causes match to succeed at the point of the (*ACCEPT)';
method	perl_version_introduced => '5.009005', note => 'perl595delta';
method	perl_version_removed	=> undef;

class	'PPIx::Regexp::Token::CharClass::POSIX',
    note => 'POSIX character class';
token	'[:alpha:]', note => 'Match alphabetic';
method	perl_version_introduced	=> '5.006', note => 'perl56delta';
method	perl_version_removed	=> undef;

class	'PPIx::Regexp::Token::CharClass::Simple',
    note => 'Character class';
token	'.', note => 'Match any character';
method	perl_version_introduced	=> MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'\w', note => 'Match word character';
method	perl_version_introduced	=> MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'\W', note => 'Match non-word character';
method	perl_version_introduced	=> MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'\s', note => 'Match white-space character';
method	perl_version_introduced	=> MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'\S', note => 'Match non-white-space character';
method	perl_version_introduced	=> MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'\d', note => 'Match decimal digit';
method	perl_version_introduced	=> MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'\D', note => 'Match any character but a decimal digit';
method	perl_version_introduced	=> MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token   '\C', note => 'Match a single octet (removed in 5.23.0)';
method  perl_version_introduced => '5.006';
method  perl_version_removed    => '5.023';
token   '\X', note => 'Match a Unicode extended grapheme cluster';
method  perl_version_introduced => '5.006', note => '5.6.0 perlre';
method  perl_version_removed    => undef;
token	'\p{Latin}',
    note => 'Match a character with the given Unicode property';
method	perl_version_introduced	=> '5.006001', note => 'perl561delta';
method	perl_version_removed	=> undef;
token	'\h', note => 'Match a horizontal-white-space character';
method	perl_version_introduced => '5.009005', note => 'perl595delta';
method	perl_version_removed	=> undef;
token	'\H', note => 'Match a non-horizontal-white-space character';
method	perl_version_introduced => '5.009005', note => 'perl595delta';
method	perl_version_removed	=> undef;
token	'\v', note => 'Match a vertical-white-space character';
method	perl_version_introduced => '5.009005', note => 'perl595delta';
method	perl_version_removed	=> undef;
token	'\V', note => 'Match a non-vertical-white-space character';
method	perl_version_introduced => '5.009005', note => 'perl595delta';
method	perl_version_removed	=> undef;
token	'\R', note => 'Match a generic new-line character';
method	perl_version_introduced => '5.009005', note => 'perl595delta';
method	perl_version_removed	=> undef;
token	'\N', note => 'Match any character but a new-line character';
method	perl_version_introduced => '5.011', note => 'perl5110delta';
method	perl_version_removed	=> undef;

class	'PPIx::Regexp::Token::Code', note => 'Code', report => 0;
token	'{foo}';
method	perl_version_introduced	=> '5.005';	# see ::GroupType::Code
method	perl_version_removed	=> undef;
# The interesting version functionality is on
# PPIx::Regexp::Token::GroupType::Code.

class	'PPIx::Regexp::Token::Comment', note => 'Comment';
token	'(?#foo)', note => 'Embedded comment';
method	perl_version_introduced	=> MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'# foo', note => 'Extended comment, with /x';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;

class	'PPIx::Regexp::Token::Condition', note => 'Condition';
token	'(1)', note => 'True if the first capture group matched';
method	perl_version_introduced => '5.005', note => 'perl5005delta';
method	perl_version_removed	=> undef;
token	'(R1)',
    note => 'True if recursing directly inside first capture group';
method	perl_version_introduced => '5.009005';
method	perl_version_removed	=> undef;
token	'(R)', note => 'True if recursing';
method	perl_version_introduced => '5.009005';
method	perl_version_removed	=> undef;
token	'(<foo>)', note => 'True if capture group <foo> matched';
method	perl_version_introduced => '5.009005';
method	perl_version_removed	=> undef;
token	q{('foo')}, note => 'True if capture group <foo> matched';
method	perl_version_introduced => '5.009005';
method	perl_version_removed	=> undef;
token	'(R&foo)',
    note => 'True if recursing directly inside capture group <foo>';
method	perl_version_introduced => '5.009005';
method	perl_version_removed	=> undef;
token	'(DEFINE)', note => 'Define a group to be recursed into';
method	perl_version_introduced => '5.009005';
method	perl_version_removed	=> undef;

class	'PPIx::Regexp::Token::Control', note => 'Interpolation control';
token	'\l', note => 'Lowercase next character';
method	perl_version_introduced	=> MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'\u', note => 'Uppercase next character';
method	perl_version_introduced	=> MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'\L', note => 'Lowercase until \E';
method	perl_version_introduced	=> MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'\U', note => 'Uppercase until \E';
method	perl_version_introduced	=> MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'\F', note => 'Fold case until \E';
method  perl_version_introduced => '5.015008';
method	perl_version_removed	=> undef;
token	'\E', note => 'End of interpolation control';
method	perl_version_introduced	=> MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'\Q', note => 'Quote interpolated metacharacters until \E';
method	perl_version_introduced	=> MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;

class	'PPIx::Regexp::Token::Delimiter', note => 'Delimiter', report => 0;
token	'/';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';

class	'PPIx::Regexp::Token::Greediness', note => 'Greediness';
token	'?', note => 'Match shortest string first';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'+', note => 'Match longest string and give nothing back';
method	perl_version_introduced => '5.009005', note => 'perl595delta';
method	perl_version_removed	=> undef;

# PPIx::Regexp::Token::GroupType: see the individual subclasses, below.

class	'PPIx::Regexp::Token::GroupType::Assertion', note => 'Assertion',
    text => '(%sregexp)';
token	'?=', note => 'Positive lookahead';
method	perl_version_introduced	=> MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'?!', note => 'Negative lookahead';
method	perl_version_introduced	=> MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'?<=', note => 'Positive lookbehind';
method	perl_version_introduced	=> '5.005', note => 'perl5005delta';
method	perl_version_removed	=> undef;
token	'?<!', note => 'Negative lookbehind';
method	perl_version_introduced	=> '5.005', note => 'perl5005delta';
method	perl_version_removed	=> undef;

class	'PPIx::Regexp::Token::GroupType::BranchReset',
    note => 'Branch reset';
token	'?|',
    note => 'Re-use capture group numbers in branches of alternation',
    text => '(?|regexp|regexp...)';
method	perl_version_introduced	=> '5.009005', note => '5.9.5 perlre';
method	perl_version_removed	=> undef;

class	'PPIx::Regexp::Token::GroupType::Code', note => 'Code',
    text => '(%s{code})';
token	'?p', note => 'Function unknown';
method	perl_version_introduced	=> '5.005',
    note => 'Undocumented that I can find';
method	perl_version_removed	=> '5.009005', note => 'perl595delta';
token	'?', note => 'Evaluate code. Always matches.';
method	perl_version_introduced	=> '5.005', note => 'perl5005delta';
method	perl_version_removed	=> undef;
token	'??', note => 'Evaluate code, use as regexp at this point';
method	perl_version_introduced	=> '5.006',
    note => 'perl56delta (not in 5.5.4 perlre)';
method	perl_version_removed	=> undef;

class	'PPIx::Regexp::Token::GroupType::Modifier', note => 'Clustering',
    text => '(%sregexp)';
token	'?:', note => 'Basic clustering';
method	perl_version_introduced	=> MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'?i:', note => 'Cluster with case-independance';
method	perl_version_introduced	=> '5.005', note => 'perl5005delta';
method	perl_version_removed	=> undef;
token	'?i-x:',
    note => 'Cluster with case-independance but no extended syntax';
method	perl_version_introduced	=> '5.005', note => 'perl5005delta';
method	perl_version_removed	=> undef;

class	'PPIx::Regexp::Token::GroupType::Modifier', note => 'Modifiers',
    text => '(%s)', report => 0;
token	'?^i', note => 'Reassert defaults, case-independance';
method	perl_version_introduced	=> '5.013006', note => 'perl5136delta';
method	perl_version_removed	=> undef;
token	'?d', note => 'Compile without locale or unicode_strings';
method	perl_version_introduced	=> '5.013006', note => 'perl5136delta';
method	perl_version_removed	=> undef;
token	'?l', note => 'Compile with locale';
method	perl_version_introduced	=> '5.013006', note => 'perl5136delta';
method	perl_version_removed	=> undef;
token	'?u', note => 'Compile with unicode_strings';
method	perl_version_introduced	=> '5.013006', note => 'perl5136delta';
method	perl_version_removed	=> undef;

class	'PPIx::Regexp::Token::GroupType::NamedCapture',
    note => 'Named capture', text => '(%sregexp)';
token	'?<foo>', note => 'Basic named capture';
method	perl_version_introduced	=> '5.009005', note => 'perl595delta';
method	perl_version_removed	=> undef;
token	q{?'foo'}, note => 'Named capture, quoted syntax';
method	perl_version_introduced	=> '5.009005', note => '5.9.5 perlre';
method	perl_version_removed	=> undef;
token	'?P<foo>', note => 'Named capture, PCRE/Python syntax';
method	perl_version_introduced	=> '5.009005', note => '5.9.5 perlre';
method	perl_version_removed	=> undef;

class	'PPIx::Regexp::Token::GroupType::Subexpression',
    note => 'Subexpression', text => '(%sregexp)';
token	'?>', note => 'Match subexpression without backtracking';
method	perl_version_introduced	=> '5.005', note => 'perl5005delta';
method	perl_version_removed	=> undef;

class	'PPIx::Regexp::Token::GroupType::Switch', note => 'Switch',
    report => 0;	# See PPIx::Regexp::Token::Condition
token	'?';
method	perl_version_introduced => '5.005';
method	perl_version_removed	=> undef;

class	'PPIx::Regexp::Token::Interpolation', note => 'Interpolation';
token	'$foo', note => 'Interpolate the contents of $foo';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'$foo', cookie => COOKIE_REGEX_SET,
    note => 'Interpolation in regex set';
method	perl_version_introduced	=> '5.017009', note => 'perl5179delta';
method	perl_version_removed	=> undef;

class	'PPIx::Regexp::Token::Literal', note => 'Literal';
token	'a', note => q{Letter 'a'};
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'\b', note => 'Back space, in character class only';
method	perl_version_introduced => MINIMUM_PERL;
method	perl_version_removed	=> undef;
token	'\t', note => 'Horizontal tab';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'\n', note => 'New line';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'\r', note => 'Return';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'\a', note => 'Alarm (bell)';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'\e', note => 'Escape';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'\033', note => 'Octal 33 = escape, classic';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'\o{61}', note => q{Octal 61 = '1', new style};
method	perl_version_introduced	=> '5.013003', note => 'perl5133delta';
method	perl_version_removed	=> undef;
token	'\x1B', note => 'Hex 1b = escape, classic';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'\x{1b}', note => 'Hex 1b = escape, new style';
method	perl_version_introduced	=> '5.006',
    note => '5.6.0 perlre (not in perldelta)';
method	perl_version_removed	=> undef;
token	'\c[', note => 'Control-[ = escape';	# ]
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'\N{LATIN SMALL LETTER P}', note => q{Letter 'p', by name};
method	perl_version_introduced => '5.006001', note => 'perl561delta';
method	perl_version_removed	=> undef;
token   '\N{U+32}', note => q{Digit '2', by Unicode code point};
method  perl_version_introduced => '5.008', note => '5.8.0 charnames';
method	perl_version_removed	=> undef;

class	'PPIx::Regexp::Token::Modifier', note => 'Operator modifiers',
    text => '/%s';
token	'i', note => 'Case independent';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	's', note => 'Single-line';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'm', note => 'Multiple lines';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'x', note => 'Extended syntax';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'g', note => 'Global matching';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'o', note => 'Compile once';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'e', note => 'Replacement is expression';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'ee', note => 'Replacement is eval-ed expression';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'c', note => 'Do not reset pos() on failure (with /g)';
method	perl_version_introduced => '5.004', note => '5.4.5 perlop';
method	perl_version_removed	=> undef;
token	'p', note => 'Populate ${^PREMATCH}, ${^MATCH}, and ${^POSTMATCH}';
method	perl_version_introduced => '5.009005', note => '5.9.5 perlop';
method	perl_version_removed	=> undef;
token	'r',
    note => 'Return modified string from s///, leaving original unmodified';
method	perl_version_introduced => '5.013002', note => 'perl5132delta';
method	perl_version_removed	=> undef;
token	'pi', report => 0;
method	perl_version_introduced => '5.009005';
method	perl_version_removed	=> undef;
token	'pir', report => 0;
method	perl_version_introduced => '5.013002';
method	perl_version_removed	=> undef;
token	'a',
    note => 'Match like /u, but restrict non-Unicode classes to ASCII';
method	perl_version_introduced	=> '5.013010', note => 'perl51310delta';
method	perl_version_removed	=> undef;
token	'aa',
    note => 'Match like /a, and do not match ASCII and non-ASCII literals';
method	perl_version_introduced	=> '5.013010', note => 'perl51310delta';
method	perl_version_removed	=> undef;
token	'd', note => 'Match using default (pre-5.13.10) semantics';
method	perl_version_introduced	=> '5.013010', note => 'perl51310delta';
method	perl_version_removed	=> undef;
token	'l', note => 'Match using current locale semantics';
method	perl_version_introduced	=> '5.013010', note => 'perl51310delta';
method	perl_version_removed	=> undef;
token	'u', note => 'Match using Unicode semantics';
method	perl_version_introduced	=> '5.013010', note => 'perl51310delta';
method	perl_version_removed	=> undef;

class	'PPIx::Regexp::Token::Modifier', note => 'Embedded modifiers';
token	'(?i)', note => 'Basic modifier (case-independence)';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'(?i-x)', note => 'Negated modifier (extended syntax)';
method	perl_version_introduced => '5.005', note => 'perl5005delta';
method	perl_version_removed	=> undef;
token	'(?^i)', note => 'Re-apply defaults, plus case-independence';
method	perl_version_introduced	=> '5.013006', note => 'perl5136delta';
method	perl_version_removed	=> undef;
token	'(?a)', note => 'Embedded /a';
method	perl_version_introduced	=> '5.013009', note => 'perl5139delta';
method	perl_version_removed	=> undef;
token	'(?d)', note => 'Embedded /d';
method	perl_version_introduced	=> '5.013006', note => 'perl5136delta';
method	perl_version_removed	=> undef;
token	'(?l)', note => 'Embedded /l';
method	perl_version_introduced	=> '5.013006', note => 'perl5136delta';
method	perl_version_removed	=> undef;
token	'(?u)', note => 'Embedded /u';
method	perl_version_introduced	=> '5.013006', note => 'perl5136delta';
method	perl_version_removed	=> undef;
token	'(?aa)', note => 'Embedded /aa';
method	perl_version_introduced	=> '5.013010', note => 'perl51310delta';
method	perl_version_removed	=> undef;

class	'PPIx::Regexp::Token::Operator', note => 'Operator';
token	'|', note => 'Alternation (outside character class)';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'^', note => 'Character class inversion';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'-', note => 'Character range (inside character class)';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;

class	'PPIx::Regexp::Token::Quantifier', note => 'Quantifier';
token	'*', note => 'Zero or more';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'+', note => 'One or more';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'?', note => 'Zero or one';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;

# TODO the quantifier {m,n} gets covered, if at all, under
# PPIx::Regexp::Token::Structure.

class	'PPIx::Regexp::Token::Recursion', note => 'Recursion';
token	'(?1)', note => 'Recurse to first capture';
method	perl_version_introduced => '5.009005';	# perl595delta
method	perl_version_removed	=> undef;
token	'(?+1)', note => 'Recurse to next capture';
method	perl_version_introduced => '5.009005';
method	perl_version_removed	=> undef;
token	'(?-1)', note => 'Recurse to previous capture';
method	perl_version_introduced => '5.009005';
method	perl_version_removed	=> undef;
token	'(?R)', note => 'Recurse to beginning of pattern';
method	perl_version_introduced => '5.009005';
method	perl_version_removed	=> undef;
token	'(?&foo)', note => 'Recurse to named capture <foo>';
method	perl_version_introduced => '5.009005';
method	perl_version_removed	=> undef;
token	'(?P>foo)',
    note => 'Recurse to named capture <foo>, PCRE/Python syntax';
method	perl_version_introduced => '5.009005';
method	perl_version_removed	=> undef;

# PPIx::Regexp::Token::Reference is the parent of
# PPIx::Regexp::Token::Backreference, PPIx::Regexp::Token::Condition,
# and PPIX::Regexp::Token::Recursion. It has no separate tests.

class	'PPIx::Regexp::Token::Structure', report => 0;
token	'(';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	')';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'[';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	']';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'{';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;

class	'PPIx::Regexp::Token::Structure', note => 'Quantifier';
token	'}',	is_quantifier => 1, note => 'Explicit quantifier',
    text => '{n} or {n,m}';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;

class	'PPIx::Regexp::Token::Structure', note => 'Perl operator';
token	'm', note => 'Match', text => 'm//';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	's', note => 'Substitute', text => 's///';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;
token	'qr', note => 'Regexp constructor', text => 'qr{}';
method	perl_version_introduced => '5.005', note => 'perl5005delta';
method	perl_version_removed	=> undef;
# TODO if the quantifier {m,n} gets forms that are only legal for
# certain Perls, things may get sticky, but at the token level '}' is
# the one marked as a quantifier, so here's the starting point.

class	'PPIx::Regexp::Token::Whitespace', note => 'White space';
token	' ', note => 'Not significant under /x';
method	perl_version_introduced => MINIMUM_PERL, note => '5.3.7 perlre';
method	perl_version_removed	=> undef;

# RT #91798. The following was implemented prematurely. What happened in
# 5.17.9 was not the recognition of non-ASCII spaces, but the
# requirement that they be escaped, so they could be recognized
# eventually.
# The non-ASCII white space was finally introduced in 5.21.1.

if ( $] >= 5.008 ) {
    # The following eval is to hide the construct from Perl 5.6, which
    # does not understand \N{...}.
    token	eval q<" \\N{U+0085}">,	## no critic (ProhibitStringyEval)
		note	=> 'Non-ASCII space';
    method	perl_version_introduced	=> '5.021001', note => 'perl5179delta';
    method	perl_version_removed	=> undef;
}

class   'PPIx::Regexp::Token::Structure', note => 'Regex set';
token   '(?[';
method  perl_version_introduced => '5.017008', note => 'perl5178delta';
method	perl_version_removed	=> undef;

class	'PPIx::Regexp::Token::Modifier', note => 'Non-capturing parens';
token	'n';
method	perl_version_introduced => '5.021008', note => 'perl5218delta';
method	perl_version_removed	=> undef;

finis;

my $context;
my @report_info;

BEGIN {
    $context = {};
}

sub class (@) {
    my ( $class, %args ) = @_;
    $args{class} = $class;
    $context = undef;
    my $title = "require $class";
    if ( eval "require $class; 1" ) {
	$context->{class} = \%args;
	$REPORT
	    and return;
	@_ = ( $title );
	goto &pass;
    } else {
	$REPORT
	    and die $title;
	@_ = ( "$title: $@" );
	goto &fail;
    }
}

sub _dor {	# Because we do not require 5.010.
    my ( @args ) = @_;
    foreach my $arg ( @args ) {
	defined $arg
	    and return $arg;
    }
    return undef;	# Yes, I want this in array context.
}

{
    my $csv;

    sub _report {
	my ( @args ) = @_;

	if ( ! $csv ) {
	    require Text::CSV;
	    $csv = Text::CSV->new();

	    $csv->combine(
		'Kind', 'Token', 'Descr', 'Introduced', 'Ref',
		'Removed', 'Ref' )
		or die 'Invalid CSV input: ', $csv->error_input();
	    print $csv->string(), "\n";
	}

	$csv->combine( @args )
	    or die 'Invalid CSV input: ', $csv->error_input();
	print $csv->string(), "\n";

	return;
    }
}

sub finis () {
    $REPORT
	or goto &done_testing;

    foreach my $item ( @report_info ) {
	my @data = (
	    _dor( $item->{class}{note}, $item->{class}{class} ),
	    _dor( $item->{token}{text}, $item->{token}{content} ),
	    _dor( $item->{token}{note}, '' ),
	);
	foreach my $method ( qw{ perl_version_introduced
	    perl_version_removed } ) {
	    if ( $item->{$method} ) {
		push @data,
		_dor( $item->{$method}{got}, '' ),
		_dor( $item->{$method}{note}, '' );
	    } else {
		push @data, '', '';
	    }
	}
	while ( @data && '' eq $data[-1] ) {
	    pop @data;
	}

	_report( @data );
    }
    return;
}

{

    my %annotate;

    BEGIN {

	%annotate = map { $_ => 1 } qw{
	    perl_version_introduced
	    perl_version_removed
	};

    }

    sub method (@) {
	my ( $method, @args ) = @_;

	my ( %info, $kind, $want );

	if ( $annotate{$method} ) {
	    $kind = $1;
	    $want = shift @args;
	    %info = @args;
	    @args = ();
	} else {
	    $want = pop @args;
	}

	SKIP: {
	    defined $context->{object}
		or skip 'No object defined', 1;

	    my $argtxt = @args ? ' ' . join( ', ', map { "'$_'" } @args
		) . ' ' : '';
	    my $title;
	    if ( defined $want ) {
		$title = "$method($argtxt) is '$want'";
	    } else {
		$title = "$method($argtxt) is undef";
	    }
	    my $got;
	    eval {
		$got = $context->{object}->$method( @args );
		1;
	    } or do {
		$title .= ": $@";
		chomp $title;
		$REPORT
		    and die $title;
		@_ = ( $title );
		goto &fail;
	    };

	    $info{got} = $got;
	    $context->{$method} = \%info;

	    $REPORT
		and return;

	    @_ = ( $got, $want, $title );
	    goto &is;

	}
    }

}

sub token (@) {
    my ( $content, %args ) = @_;

    SKIP: {
	defined $context->{class}
	    or skip 'No class defined', 1;

	$context = {
	    class	=> $context->{class},
	    token	=> {
		content	=> $content,
		note	=> delete $args{note},
	    },
	};

	my $text = exists $args{text} ? delete $args{text} :
	    exists $context->{class}{text} ?
		sprintf $context->{class}{text}, $content :
		undef;

	defined $text
	    and $context->{token}{text} = $text;

	my $report = exists $args{report} ? delete $args{report} :
	    exists $context->{class}{report} ? $context->{class}{report} :
	    1;

	$REPORT
	    and $report
	    and push @report_info, $context;

	my $title = "Instantiate $context->{class}{class} with '$content'";

	if ( eval {
		my $obj = $context->{class}{class}->_new( $content );
		my $tokenizer;
		if ( my $cookie = delete $args{cookie} ) {
		    $tokenizer = PPIx::Regexp::Tokenizer->new( $content );
		    $tokenizer->cookie( $cookie => sub { 1 } );
		}
		$obj->can( '__PPIX_TOKEN__post_make' )
		    and $obj->__PPIX_TOKEN__post_make( $tokenizer );
		$context->{object} = $obj;
	    } ) {
	    while ( my ( $name, $val ) = each %args ) {
		$context->{object}{$name} = $val;
	    }
	    $REPORT
		and return;
	    @_ = ( $title );
	    goto &pass;
	} else {
	    $title .= ": $@";
	    chomp $title;
	    $REPORT
		and die $title;
	    @_ = ( $title );
	    goto &fail;
	}
    }
}

1;

__END__

# ex: set textwidth=72 :
