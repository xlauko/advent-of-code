#!/usr/bin/env raku

my $tx = (117, 164); #(20, 30);
my $ty = (-140, -89); #(-10, -5);

sub simulate($v) {
    my ($vel, $pos, $top) = $v,  0 + 0i, 0;

    while $pos.re ≤ $tx[1] and $pos.im ≥ $ty[0] {
        $pos += $vel;
        $vel -= $vel.re.sign + i;
        $top = max($top, $pos.im);
        if $tx[0] ≤ $pos.re ≤ $tx[1] and $ty[0] ≤ $pos.im ≤ $ty[1] {
            return $top;
        }
    }

    return -1;
}

my @heights = ((0 ... $tx[1]) X+ (($ty[0] ... $ty[0].abs).map: * * i)).map(&simulate).grep(* != -1);

say "Part 1: " ~ max @heights;
say "Part 2: " ~ @heights.elems;
