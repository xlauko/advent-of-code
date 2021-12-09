#!/usr/bin/env raku

my @plane = lines».comb;
my $w = @plane[0].elems;
my $h = @plane.elems;

sub infix:<at>(@p, ($row, $col)) {
    return (0 ≤ $row < $h and 0 ≤ $col < $w) ?? @p[$row; $col] !! 10;
}

sub prefix:<neigh>($pos) { [(-1, 0), (1, 0), (0, -1), (0, 1)].map($pos «+» *); }

sub infix:<around>(@p, $pos) { (neigh $pos).map(@p at *) }

my @risks = ( ^$h X ^$w ).grep( -> $p { (@plane around $p).map( @plane at $p < * ).all } );

say "Part 1: " ~ ([+] @risks.map(@plane at *)) + @risks.elems;

sub infix:<growfrom>(@p, $pos) {
    my $v = @plane at $pos;
    return (neigh $pos).grep( -> $n { ($v ≤ @p at $n) and @p at $n < 9 } );
}

sub basin($pos) {
    my @q = [$pos];
    my $seen = SetHash.new(< $pos.join >);
    while @q {
        my $p = @q.shift;
        for (@plane growfrom $p) -> $n {
            if $n.join ∉ $seen {
                $seen.set($n.join);
                push @q, $n;
            }
        }
    }

    return $seen.elems;
}

say "Part 2: " ~ [*] @risks.map(&basin).sort.tail(3);
