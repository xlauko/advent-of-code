#! /usr/bin/raku

my @data = lines;
say "Part 1: " ~ [+] @data Z< @data[1..*];
say "Part 2: " ~ [+] @data Z< @data[3 ... *];
