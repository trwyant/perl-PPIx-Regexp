package main;

use strict;
use warnings;

BEGIN {
    eval {require Test::Spelling};
    $@ and do {
	print "1..0 # skip Test::Spelling not available.\n";
	exit;
    };
    Test::Spelling->import();
}

add_stopwords (<DATA>);

all_pod_files_spelling_ok ();

1;
__DATA__
errstr
lexed
lexes
nav
navigational
PPI
ppi
PPI's
reblesses
repl
schild
schildren
TODO
tokenization
tokenize
tokenized
tokenizer's
tokenizers
tokenizing
trigraphs
unicode
version's
wyant
