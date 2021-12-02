#! /usr/bin/raku

sub MAIN(Str $input where *.IO.f = 'input') {
    my @lines = $input.IO.lines;

    my ($h, $d, $a) = 0, 0, 0;
    for @lines {
        given $_ {
            when /:s forward (\d+)/ { $h += $0; $d += $a * $0; }
            when /:s down (\d+)/    { $a += $0; }
            when /:s up (\d+)/      { $a -= $0; }
        }
    }
    say "Part 2: " ~ $h * $d;
}
