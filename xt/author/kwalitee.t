package main;

use 5.006002;

use strict;
use warnings;

use Test::More 0.88;

eval {
    require Test::Kwalitee;
    Test::Kwalitee->import();
    1;
} or plan skip_all => 'Test::Kwalitee not found';

1;

# ex: set textwidth=72 :