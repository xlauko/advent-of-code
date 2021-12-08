#!/usr/bin/raku

sub normalize($signal) { $signal.comb.sort }

sub decoder($signals) {
    my %dec;
    for $signals.sort({ .chars }).map(&normalize) -> $signal {
        given $signal.cache.elems {
            when 2 { %dec{1} = $signal }
            when 3 { %dec{7} = $signal }
            when 4 { %dec{4} = $signal }
            when 5 {
                if    %dec{1} ⊂ $signal { %dec{3} = $signal }
                elsif ($signal ∖ %dec{4}).elems == 2 { %dec{5} = $signal }
                else                    { %dec{2} = $signal };
            }
            when 6 {
                if    %dec{4} ⊂ $signal { %dec{9} = $signal }
                elsif %dec{1} ⊂ $signal { %dec{0} = $signal }
                else                    { %dec{6} = $signal };
            }
            when 7 { %dec{8} = $signal }
        }
    }
    return %dec».join.antipairs;
}

my ($p1, $p2) = (0, 0);

for lines».split('|') -> ($signals, $digs) {
    my %dec = decoder($signals.words);
    my $val = $digs.words.map(&normalize)».join.map({ %dec{$_} });
    $p1 += $val.cache.grep(/<[1478]>/).elems;
    $p2 += $val.cache.join;
}

say "Part 1: $p1";
say "Part 2: $p2";
