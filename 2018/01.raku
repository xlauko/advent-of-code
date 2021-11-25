#!/usr/bin/env raku

sub final($data --> Int) {
    my Int $freq = 0;
    for $data.lines -> $line {
        $freq += $line;
    }
    return $freq;
}

sub repeats($data --> Int) {
    my Int $freq = 0;
    my SetHash[Int] $seen .= new;

    loop {
        for $data.lines -> $line {
            $freq += $line;

            if $freq ∈ $seen {
                return $freq;
            }

            $seen.set( $freq );
        }
    }
}

sub MAIN(Str $input where *.IO.f = 'input') {
    say $input;

    my $data = slurp $input;

    say "Part 1: " ~ final($data);
    say "Part 2: " ~ repeats($data);
}
