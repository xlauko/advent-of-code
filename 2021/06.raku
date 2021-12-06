#!/usr/bin/env raku

my $steps = 80;

my @state = 0 xx 9;
@state[$_]++ for words.split(',');

for ^$steps {
    my @next = @state[1..8];
    @next[8] = @state[0];
    @next[6] += @state[0];
    @state = @next;
}

say [+] @state;
