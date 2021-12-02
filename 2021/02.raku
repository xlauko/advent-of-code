#! /usr/bin/raku

my ($h, $d, $a) = 0, 0, 0;
for (words) -> $action, $v {
    given $action {
        when "forward" { $h += $v; $d += $a * $v; }
        when "down"    { $a += $v; }
        when "up"      { $a -= $v; }
    }
}

say "Part 2: " ~ $h * $d;
