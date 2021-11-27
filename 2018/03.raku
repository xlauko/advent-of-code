#!/usr/bin/env raku

sub MAIN(Str $input where *.IO.f = 'input') {
    my %squares;
    my @lines = $input.IO.lines;

    for @lines {
        my ($id, $dx, $dy, $w, $h) = +<< $_.split(" ");
        for ($dx...$dx + $w - 1) X ($dy...$dy + $h - 1) -> $pos {
            %squares{$pos}++;
        }
    }

    say "Part 1: " ~ (grep {$_ > 1}, %squares.values).elems;

    for @lines {
        my ($id, $dx, $dy, $w, $h) = +<< $_.split(" ");
        my $overlap = False;
        for ($dx...$dx + $w - 1) X ($dy...$dy + $h - 1) -> $pos {
            if %squares{$pos} != 1 {
                $overlap = True;
            }
        }

        if !$overlap {
            say "Part 2: " ~ $id;
        }
    }
}

