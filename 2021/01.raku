#! /usr/bin/raku

sub MAIN(Str $input where *.IO.f = 'input') {
    my @data = $input.IO.lines;
    say "Part 1: " ~ [+] @data Z< @data[1..*];

    my @tuples = [Z+] (@data, @data[1..*], @data[2..*]);
    say "Part 2: " ~ [+] @tuples Z< @tuples[1..*];
}
