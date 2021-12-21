#!/usr/bin/env raku

use experimental :cached;

sub part1 {
    my @dice = (0 ... *).map({$_ % 100 + 1}).rotor(3);
    my @score = [0, 0];
    my @pos = [3, 7]; # [6, 7];

    my $turn = 0;
    while @score.all < 1000 {
        my $move = [+] @dice[$turn];
        my $player = $turn % 2;
        @pos[$player] = (@pos[$player] + $move) % 10;
        @score[$player] += @pos[$player] + 1;
        $turn++;
    }

    return $turn * 3 * min(@score);
}

sub solve-roll(@pos, @score, $player, $move) is cached {
    @pos[$player] = (@pos[$player] + $move) % 10;
    @score[$player] += @pos[$player] + 1;
    return solve(@pos, @score, !$player);
}

sub solve(@pos, @score, $player) is cached {
    return 1 + 0i if @score[0] ≥ 21;
    return 0 + 1i if @score[1] ≥ 21;
    my $wins = 0 + 0i;
    for 1..3 X 1..3 X 1..3 -> $roll {
        $wins += solve-roll(@pos.clone(), @score.clone(), $player, [+] $roll)
    }
    return $wins;
}

sub part2 {
    my @score = [0, 0];
    my @pos = [3, 7]; # [6, 7];
    my $res = solve(@pos, @score, 0);
    return max $res.re, $res.im;
}

say "Part 1: " ~ part1();
say "Part 2: " ~ part2();
