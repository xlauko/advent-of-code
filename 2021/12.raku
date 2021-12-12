sub solve(%g, $n, $seen, $used_twice) {
    return 1 if $n eq 'end';

    my $used = $used_twice;
    if $n eq $n.lc and $seen{$n} {
        return 0 if $n eq 'start' or $used;
        $used = True;
    }

    return [+] %g{$n}.list.map({ solve(%g, $_, $seen ∪ $n, $used) });
}

my %graph;

for (lines) -> $line {
    my ($a, $b) = $line.split('-');
    push %graph{$a}, $b;
    push %graph{$b}, $a;
}

say "Part 1: " ~ solve(%graph, 'start', SetHash.new, True);
say "Part 2: " ~ solve(%graph, 'start', SetHash.new, False);
