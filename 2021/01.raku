#! /usr/bin/raku

sub MAIN(Str $input where *.IO.f = 'input') {
    my @data = $input.IO.lines;
    say "Part 1: " ~ [+] @data Z< @data[1..*];
    say "Part 2: " ~ [+] @data Z< @data[3 ... *];
}
