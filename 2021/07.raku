#!/usr/bin/env raku

my @data = words.split(',')».Int;
my @range = (@data.min .. @data.max);

my @p1 = gather {
    for @range -> $p { take [+] ($p X- @data)».abs };
}

my @p2 = gather {
    for @range -> $p { take [+] ($p X- @data)».abs.map({$_ * ($_ + 1) / 2}) };
}

say min @p1;
say min @p2;
