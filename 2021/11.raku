#!/usr/bin/env raku

my @mask = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)];

sub infix:<⊕>(@grid, ($r, $c)) {
    if 0 ≤ $c ≤ 9 and 0 ≤ $r ≤ 9 and @grid[$r; $c] ≠ 0 {
        return ++@grid[$r; $c];
    }
    return 0;
}

sub flash(@grid, $pos) {
    @grid[$pos[0]; $pos[1]] = 0;
    for @mask -> $n {
        if @grid ⊕ ($n «+» $pos) > 9 {
            flash(@grid, ($n «+» $pos));
        }
    }
}

sub step(@grid) {
    for ^10 X ^10 -> ($r, $c) { @grid[$r; $c]++; }
    for ^10 X ^10 -> ($r, $c) { flash(@grid, ($r, $c)) if @grid[$r; $c] > 9; }
    return @grid».List.flat.grep(* == 0);
}

my @grid = lines».comb».Array;
say "Part 1: " ~ [+] (step(@grid) for ^100);

my $steps = 101;
while step(@grid) != 100 {
    $steps++;
}

say "Part 2: " ~ $steps;
