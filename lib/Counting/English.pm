# this is a quick hack
package Counting::English;

use strict;
use warnings;

our $names = {
    1  => 'one',
    2  => 'two',
    3  => 'three',
    4  => 'four',
    5  => 'five',
    6  => 'six',
    7  => 'seven',
    8  => 'eight',
    9  => 'nine',
    10 => 'ten',
    11 => 'eleven',
    12 => 'twelve',
    13 => 'thirteen',
    14 => 'fourteen',
    15 => 'fifteen',
    16 => 'sixteen',
    17 => 'seventeen',
    18 => 'eighteen',
    19 => 'nineteen',
    20 => 'twenty',
    30 => 'thirty',
    40 => 'forty',
    50 => 'fifty',
    60 => 'sixty',
    70 => 'seventy',
    80 => 'eighty',
    90 => 'ninety',
};

our $magnitudes = {
    3 => { value => 1_000     =>, name => 'thousand' },
    6 => { value => 1_000_000 =>, name => 'million' },
    9  => { value => 1_000_000_000,             name => 'billion' },
    12 => { value => 1_000_000_000_000,         name => 'trillion' },
    15 => { value => 1_000_000_000_000_000,     name => 'quadrillion' },
    18 => { value => 1_000_000_000_000_000_000, name => 'quintillion' },
};

sub _less_than_100 {
    my ($num) = @_;
    die "$num not _less_than_100" if ( ( $num >= 100 ) or ( $num < 0 ) );

    if ( defined $names->{$num} ) {
        return $names->{$num};
    }

    my $tens      = int( $num / 10 );
    my $remainder = $num % 10;
    if ( $tens && $remainder ) {
        return join( '-', $names->{$tens}, $names->{$remainder} );
    }
    return $tens ? $names->{$tens} : $names->{$remainder};
}

sub _less_than_1000 {
    my ($num) = @_;
    die '$num not _less_than_1000' if ( ( $num >= 1000 ) or ( $num < 0 ) );

    my @vals;
    if ( $num > 100 ) {
        my $hundreds = int( $num / 100 );
        push @vals, _less_than_100($hundreds), 'hundred';
        my $remainder = $num % 100;
        if ($remainder) {
            push @vals, _less_than_100($remainder);
        }
    }
    elsif ( $num == 100 ) {
        push @vals, $names->{1}, 'hundred';
    }
    else {
        push @vals, _less_than_100($num);
    }
    return @vals;
}

sub as_text {
    my ($number) = @_;

    # maybe detect non-int and die?
    my $int_num = int($number);
    my $num     = $int_num;

    my $words = [];
    if ( $num == 0 ) {
        return 'zero';
    }

    if ( $num < 0 ) {
        push @$words, 'negative';
        $num = $num * -1;
    }

    for my $magnitude_key ( sort { $b <=> $a } keys %$magnitudes ) {
        my $magnitude_entry = $magnitudes->{$magnitude_key};
        my $magnitude       = $magnitude_entry->{value};
        if ( $num >= $magnitude ) {
            my $magnitude_name = $magnitude_entry->{name};
            my $part           = int( $num / $magnitude );
            $num = $num % $magnitude;
            push @$words, _less_than_1000($part), $magnitude_name;
        }
    }

    if ( $num > 0 ) {
        push @$words, _less_than_1000($num);
    }

    return join( ' ', @$words );
}
