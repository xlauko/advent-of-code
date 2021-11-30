#!/usr/bin/env raku

sub dist($a, $b) { abs($a[0] - $b[0]) + abs($a[1] - $b[1]) }

sub MAIN(Str $input where *.IO.f = 'input') {
    my @coords;

    for $input.IO.lines {
        m:s/^(\d+)',' (\d+)$/ or die "Can't parse line '$_'";
        push @coords, [$0, $1];
    }

    my ($xmin, $xmax, $ymin, $ymax) = (
        @coords.min({ .[0].Int })[0],
        @coords.max({ .[0].Int })[0],
        @coords.min({ .[1].Int })[1],
        @coords.max({ .[1].Int })[1],
    );

    my %plane;
    for $xmin..$xmax X $ymin..$ymax -> ($x, $y)  {
        my @dist = @coords.map({ dist($_,  ($x, $y)) });
        my $min = min @dist;
        my $closest = @dist.pairs.grep(*.value == $min);
        %plane{$x; $y} = $closest[0].key if $closest.elems == 1;
    }

    # for $ymin..$ymax -> $y {
    #     for $xmin..$xmax -> $x {
    #         print (%plane{$x; $y}:exists ?? %plane{$x; $y} !! ".") ~ " ";
    #     }
    #     put "";
    # }


    my $infinite = SetHash.new;
    $infinite.set($_) for %plane{$xmin}.values;
    $infinite.set($_) for %plane{$xmax}.values;

    $infinite.set(%plane{$xmin; $_}) if %plane{$xmin; $_}:exists for $ymin..$ymax;
    $infinite.set(%plane{$xmax; $_}) if %plane{$xmax; $_}:exists for $ymin..$ymax;
    $infinite.set(%plane{$_; $ymin}) if %plane{$_; $ymin}:exists for $xmin..$xmax;
    $infinite.set(%plane{$_; $ymax}) if %plane{$_; $ymax}:exists for $xmin..$xmax;

    my %sizes;

    my @values = ( { $_.values } for %plane.values ).flat;

    my @counts;
    for @coords.keys {
        next if $infinite{$_}:exists;
        push @counts, @values.grep($_).elems;
    }

    say "Part 1: " ~ @counts.max;

    my @dists;
    for $xmin..$xmax X $ymin..$ymax -> ($x, $y)  {
        push @dists, sum @coords.map({ dist($_,  ($x, $y)) });
    }

    say "Part 2: " ~ @dists.grep( * < 10000 ).elems;
}
