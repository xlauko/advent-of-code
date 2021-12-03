#! /usr/bin/raku

sub value(@bools) {
    my $bits = [~] @bools.map: *.Int;
    return "0b$bits".Int;
}

sub rate(@data) { [Z+] @data.map: *.comb }

my @in = lines;

my @γ = rate(@in).map: (* >= @in.elems / 2);
my @ε = @γ.map: !*;

say "Part 1: " ~ value(@γ) * value(@ε);

sub rating(@data, $op) {
    my @arr = @data;
    for 0..^(@arr[0].chars) {
        last if @arr.elems == 1;
        my $bit = $op(rate(@arr)[$_], @arr.elems / 2 ).Int;
        @arr = @arr.grep: *.comb[$_] == $bit;
    }

    return "0b@arr[0]".Int;
}

my $gen = rating(@in, { $^a >= $^b });
my $scr = rating(@in, { $^a < $^b });
say "Part 2: " ~ $gen * $scr;
