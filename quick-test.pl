#!/usr/bin/env perl
use strict;
use warnings;

use POSIX;
use Counting::English;

for my $i ( 0 .. 10 ) {
    print $i, " => ", Counting::English::as_text($i), "\n";
    my $num = int( rand(1000) * ( 10 * int( rand(18) ) ) );
    if ( ( $i % 2 ) == 0 ) { $num *= -1; }
    my $text = Counting::English::as_text($num);
    print "$num => $text\n";
}

my $num = LONG_MAX;
print $num, " => ", Counting::English::as_text($num), "\n";

$num = LONG_MIN;
print $num, " => ", Counting::English::as_text($num), "\n";
