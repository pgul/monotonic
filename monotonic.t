#! /usr/bin/perl
use warnings;
use strict;

use Test::More;
use lib qw(.);

use_ok('Monotonic', 'find_monotonic');

my @tests = (
    { a => 2 }         => undef, # invalid input data
    []                 => [ 0, 0 ],
    [1]                => [ 1, 0 ],
    [1, 1]             => [ 2, 0 ],
    [1, 2, 1]          => [ 2, 0 ], # ascent and descent overlaping
    [1, 1, 2]          => [ 3, 0 ], # ascent with equial values
    [1, 2, 3, 1]       => [ 3, 0 ], # ascent at beginning
    [5, 1, 2, 4, 2]    => [ 3, 1 ], # ascent in the middle
    [5, 1, 2, 4]       => [ 3, 1 ], # ascent at the end
    [1, 5, 4, 3]       => [ 3, 1 ], # descent
    [5, -1, 0, 1, 1]   => [ 4, 1 ], # ascent with negative and zero
    [1, 5, 7, 2, 4, 8] => [ 3, 0 ], # two series with the same length
);

while (@tests) {
    my ($array, $expect) = splice(@tests, 0, 2);
    my @res = eval { find_monotonic($array) };
    if ($expect) {
        is($res[0], $expect->[0], "Length");
        is($res[1], $expect->[1], "Start");
    }
    else {
        ok($@, "died");
    }
}

done_testing;
