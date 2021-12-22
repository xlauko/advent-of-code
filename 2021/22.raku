#!/usr/bin/env raku

sub parse-range($rng) {
    my ($b, $e) = $rng.split('=')[1].split('..');
    return ($b, $e);
}

sub parse-line($line) {
    my ($st, $ranges) = $line.split(" ");
    my ($x, $y, $z) = $ranges.split(",").map(&parse-range);
    return ($st ~~ 'on', ($x, $y, $z));
}

sub intersect($a, $b) {
    for $a.cache.list Z $b.cache.list -> ($ar, $br) {
        return if $ar[0] > $br[1] || $ar[1] < $br[0];
    }

    my @i;
    for ($a.list Z $b.list) -> ($ar, $br) {
        push @i, (max($ar[0], $br[0]), min($ar[1], $br[1]));
    };

    return @i;
}

sub diff($a, $b) {
    my $i = intersect($a, $b);
    return $a unless $i;

    my @split =
        ($a[0], $a[1], ($a[2][0], $i[2][0] - 1)),
        ($a[0], $a[1], ($i[2][1] + 1, $a[2][1])),
        (($a[0][0], $i[0][0] - 1), $a[1], $i[2]),
        (($i[0][1] + 1, $a[0][1]), $a[1], $i[2]),
        ($i[0], ($a[1][0], $i[1][0] - 1), $i[2]),
        ($i[0], ($i[1][1] + 1, $a[1][1]), $i[2]);

    return @split.grep({
        my ($x, $y, $z) = $_;
        $x[0] ≤ $x[1] && $y[0] ≤ $y[1] && $z[0] ≤ $z[1];
    });
}

my @cubes;
for (lines) -> $line {
    my ($on, $curr) = parse-line($line);
    my @next;
    for @cubes -> $cube {
        for diff($cube, $curr) -> $d {
            push @next, $d if $d;
        }
    }
    push @next, $curr if $on;
    @cubes = @next;
}

sub len($r) { $r.[1] - $r.[0] + 1 }
sub size(($x, $y, $z)) { len($x) * len($y) * len($z); }

say "Part 2: " ~ [+] @cubes.map(&size);


