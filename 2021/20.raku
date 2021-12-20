#!/usr/bin/env raku

my @input = slurp.split("\n\n");

my @mask = @input[0].=trans( '.' => '0', '#' => '1' ).comb;

my %img is default('0');

for @input[1].lines.kv -> $row, $line {
    for $line.comb.kv -> $col, $v {
        %img{"$row:$col"} = $v eq '.' ?? '0' !! '1';
    }
}

my ($minx, $maxx, $miny, $maxy) = (0, @input[1].lines[0].chars, 0, @input[1].lines.elems);

my @around = (-1, 0, 1) X (-1, 0, 1);
sub value($row, $col) {
    my $idx;
    for @around -> ($dr, $dc) {
        my ($r, $c) = ($row + $dr, $col + $dc);
        push $idx, %img{"$r:$c"};
    }
    return @mask[$idx.join.parse-base(2)]
}

sub enhance(%img) {
    my %next;
    ($minx, $maxx, $miny, $maxy) = ($minx - 1, $maxx + 1, $miny - 1, $maxy + 1);
    for ($miny ... ^$maxy) X ($minx ... ^$maxx) -> ($row, $col) {
        %next{"$row:$col"} = value($row, $col);
    }
    return %next;
}

%img = enhance(%img) for ^2;
say "Part 1: " ~ [+] %img.values;

%img = enhance(%img) for ^48;
say "Part 2: " ~ [+] %img.values;
