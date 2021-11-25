#!/usr/bin/env raku

sub index($char) {
    $char - ord('a')
}

sub checksum($data --> Int) {
    my Int ($twice, $thrice) = (0, 0);
    for $data.lines -> $line {
        my @seen[26];
        for $line.ords -> $ch {
            @seen[index($ch)] += 1;
        }
        $twice++ if 2 ∈ @seen;
        $thrice++ if 3 ∈ @seen;
    }
    return $twice * $thrice;
}

sub box($data --> Str) {
    for $data.lines X $data.lines -> [$lhs, $rhs] {
        my @diff = ($lhs.comb Zne $rhs.comb);
        if ([+] @diff) == 1 {
            return ($lhs.comb Z @diff).grep({ !$_[1] }).map({ $_[0] }).join('');
        }
    }
}

sub MAIN(Str $input where *.IO.f = 'input') {
    say $input;

    my $data = slurp $input;

    say "Part 1: " ~ checksum($data);
    say "Part 2: " ~ box($data);
}
