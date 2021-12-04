#!/usr/bin/env raku

my @input = slurp.split("\n\n");

my @boards  = @input[1..*].map: (*.words.list Z=> (^5 X ^5)).Map;
my @checked = [[False xx 5] xx 5] xx @boards.elems;

my SetHash $winners .= new;

sub score($i) {
    return [+] (@boards[$i].kv.grep: -> $v, ($r,$c) { !@checked[$i;$r;$c] })».[0];
}

for @input[0].split(',') -> $round {
    for @boards.kv -> $i, %board {
        next if $winners<$i>;
        if @boards[$i]{$round}:exists {
            my ($r, $c) = @boards[$i]{$round};
            @checked[$i;$r;$c] = True;
            if all(@checked[$i;$r;^5]) | all(@checked[$i;^5;$c]) {
                say "Part 1: " ~ score($i) * $round if !$winners;
                say "Part 2: " ~ score($i) * $round if $winners.elems == @boards.elems - 1;
                $winners.set($i);
            }
        }
    }
}
