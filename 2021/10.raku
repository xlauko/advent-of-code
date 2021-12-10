#!/usr/bin/env raku

my @open  = |< ( [ { >, '<';
my @close = |< ) ] } >, '>';
my %exp   = @close «=>» @open;

my $lines = lines».comb;

sub parse($line) {
    my @stack;
    for |$line -> $c { given $c {
        when @open.any  { @stack.push($c) }
        when @close.any { return 'corrupted' => $c if @stack.pop ne %exp{$c} }
    }}
    return 'incomplete' => @stack.reverse;
}

my %parsed = $lines.map(&parse).categorize( *.key )».value;

my %score = @close Z=> 3, 57, 1197, 25137;
say "Part 1: " ~ [+] %parsed{'corrupted'}.map({ %score{$_} });

sub score(@stack) {
    state %score = @open Z=> 1..4;
    my $res = 0;
    $res = $res * 5 + %score{$_} for @stack;
    return $res;
}

my $mid = %parsed{'incomplete'}.elems div 2;
say "Part 2: " ~ %parsed{'incomplete'}.map(&score).sort[$mid];
