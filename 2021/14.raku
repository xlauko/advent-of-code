#!/usr/bin/env raku

my @input = slurp.split("\n\n");

my @poly = @input[0].comb;

my %rules;
@input[1].lines ~~ m:g/
    (\w+)" -> "(\w) { %rules{$0.Str} = $1.Str }
/;

sub step(%poly) {
    my %next;
    for %poly.kv -> $pair, $n {
        my $mid = %rules{$pair};
        my $p = $pair.comb;
        %next{$p[0] ~ $mid} += $n;
        %next{$mid ~ $p[1]} += $n;
    }
    return %next;
}

my %poly;
%poly{$_}++ for (@poly Z @poly[1..*])».join;

for ^10 { %poly = step(%poly) }

my %count;
for %poly.kv -> $pair, $n {
    my $p = $pair.comb;
    %count{$p[0]} += $n;
    %count{$p[1]} += $n;
}

my @sorted = sort {%count{$^b} <=> %count{$^a}}, %count.keys;
say (%count{@sorted.head} + 1) div 2 - (%count{@sorted.tail} + 1) div 2;
