#!/usr/bin/env raku

sub MAIN(Str $input where *.IO.f = 'input') {
    my DateTime $from;
    my Int $id;

    my %sleep;
    my %minutes;

    my $maxv = { .max({ .value.Int }) };

    for $input.IO.lines.sort -> $line {
        $line ~~ m/ \[(.*)\] (.*) /;
        my ($time, $action) = DateTime($0.Str), $1;

        given $action {
            when /:s Guard (\d+) .*/ { $id = $0.Int }
            when /:s falls asleep/   { $from = $time }
            when /:s wakes up/       {
                my $to = $time;
                %sleep{$id} += $to - $from;
                %minutes{$id}{$_}++ for $from.minute...$to.minute - 1;
            }
        }
    }

    my ($guard, $sec) = $maxv(%sleep);
    my $minute = $maxv(%minutes{$guard.key});
    say "Part 1: " ~ $guard.key * $minute.key;

    my $g = %minutes.max({ $maxv($_.value).value });
    say "Part 2: " ~ $g.key * $maxv($g.value).key;
}
