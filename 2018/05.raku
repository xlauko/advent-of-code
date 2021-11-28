
sub opposite($ch) {
    return $ch eq $ch.lc ?? $ch.uc !! $ch.lc;
}

sub MAIN(Str $input where *.IO.f = 'input') {
    my @string = $input.IO.lines[0].comb;

    my @results;

    for 'a'..'z' -> $sign  {
        my @stack;
        for @string -> $ch {
            next if $ch.lc eq $sign;

            if !@stack {
                @stack.push($ch);
            } else {
                if @stack.tail eq opposite($ch) {
                    @stack.pop;
                } else {
                    @stack.push($ch);
                }
            }
        }

        @results.push(@stack.elems);
    }

    say "Part 2: " ~ @results.min;
}
