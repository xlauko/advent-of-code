my %plane;

for (lines) {
    my ($a, $b) = .comb(/ \-? \d+ /).map: {[$^x, $^y]};
    my $Δ = ($b «-» $a)».sign;
    my $bound = $b «+=» $Δ;
    my $is-hv = ([*] $Δ.list) == 0;
    loop (; $a cmp $bound != Same; $a «+=» $Δ) {
        %plane<1>{$a}++ if $is-hv;
        %plane<2>{$a}++;
    }
}

say %plane<1 2>».values».grep(* ≥ 2)».elems;
