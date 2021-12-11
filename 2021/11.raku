#!/usr/bin/env raku

my @mask = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)];

sub infix:<⊕>(@grid, ($r, $c)) {
    if (0 ≤ $c < 10 and 0 ≤ $r < 10 and @grid[$r; $c] ≤ 9) {
        return (++@grid[$r; $c]) == 10;
    }
    return False;
}

sub flash(@grid, $pos) {
    for @mask -> $n {
        if @grid ⊕ ($n «+» $pos) {
            flash(@grid, ($n «+» $pos));
        }
    }
}

sub step(@grid) {
    for ^10 X ^10 -> $pos {
        if @grid ⊕ $pos {
            flash(@grid, $pos);
        }
    }

    for ^10 X ^10 -> ($r; $c) {
        if @grid[$r; $c] == 10 {
            @grid[$r; $c] = 0;
        }
    }

    return @grid».List.flat.grep(* == 0);
}

my @grid = lines».comb».Array;
say "Part 1: " ~ [+] (step(@grid) for ^100);

my $steps = 101;
while step(@grid) != 100 {
    $steps++;
}

say "Part 2: " ~ $steps;
