#! /usr/bin/raku

sub MAIN(Str $input where *.IO.f = 'input') {
    my ($h, $d, $a) = 0, 0, 0;
    for $input.IO.words -> $action, $v {
        given $action {
            when "forward" { $h += $v; $d += $a * $v; }
            when "down"    { $a += $v; }
            when "up"      { $a -= $v; }
        }
    }

    say "Part 2: " ~ $h * $d;
}
