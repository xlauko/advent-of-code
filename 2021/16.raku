#!/usr/bin/env raku

my @data = slurp.trim.comb».parse-base(16).map({
    sprintf '%04i', $_.base(2);
}).join.comb;


my $versions = 0;

sub eval(@data) {
    $versions += :2(@data.splice(0, 3).join);
    my $type = :2(@data.splice(0, 3).join);

    if $type == 4 {
        return :2((gather loop {
            my ($bit, @rest) = @data.splice(0, 5);
            take @rest.join;
            last if $bit == 0;
        }).join);
    }

    my @values;
    if @data.shift == 0 {
        my $len = :2(@data.splice(0, 15).join);
        my @sub = @data.splice(0, $len);
        push @values, eval(@sub) while @sub.elems > 6;
    } else {
        my $len = :2(@data.splice(0, 11).join);
        push @values, eval(@data) for ^$len;
    }

    given $type {
        when 0 { [+] @values }
        when 1 { [*] @values }
        when 2 { min @values }
        when 3 { max @values }
        when 5 { [<] @values }
        when 6 { [>] @values }
        when 7 { [==] @values }
    };
};


say "Part 2: " ~ eval(@data)[0];
say "Part 1: " ~ $versions;
