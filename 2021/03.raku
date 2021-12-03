#! /usr/bin/raku

my @in = lines».comb;
sub value(@bools) { ([~] @bools».Int).parse-base(2) }

my @γ = ([Z+] @in).map: * ≥ @in.elems / 2;
my @ε = @γ.map: !*;

say "Part 1: " ~ value(@γ) * value(@ε);

sub rating(@data, $op) {
    for 0..* -> $i {
        return value(@data[0]) if @data.elems == 1;
        my $bit = $op(([+] @data».[$i]), @data.elems / 2);
        @data = @data.grep: { .[$i] == $bit.Int };
    }
}

say "Part 2: " ~ rating(@in.clone, * ≥ *) * rating(@in.clone, * < *);
