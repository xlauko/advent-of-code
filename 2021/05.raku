my %plane;

for (lines) {
    my ($a, $b) = .comb(/ \-? \d+ /).map: {[$^x, $^y]};
    my $Δ = ($b «-» $a)».sign;
    loop (; $a cmp $b «+» $Δ != Same; $a «+=» $Δ) {
        %plane<1>{$a}++ if ([*] $Δ.list) == 0;
        %plane<2>{$a}++;
    }
}

say %plane<1 2>».values».grep(* ≥ 2)».elems;
