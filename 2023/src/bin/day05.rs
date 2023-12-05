use aoc::{input::{file_read_lines, nums}, iter::IteratorExt, iter::VecExt};
use itertools::Itertools;

type Range = (u64, u64);
type Conversion = (u64, u64, u64);

fn index_in_range(value: u64, (_, start, length): Conversion) -> Option<u64> {
    (start..start + length).contains(&value).then(|| value - start)
}

fn convert(value: u64, map: &Vec<Conversion>) -> u64 {
    map.iter()
        .find_map(|line| index_in_range(value, *line).map(|index| line.0 + index))
        .unwrap_or(value)
}

fn locations(seeds: Vec<u64>, maps: &Vec<Vec<Conversion>>) -> Vec<u64> {
    maps.fold(seeds, |values, map| {
        values.mapc(|&value| convert(value, map))
    })
}

fn split(start: u64, end: u64, maps: &Vec<Conversion>) -> Vec<(u64, u64)> {
    let mut intervals = Vec::new();
    let mut queue: Vec<(u64, u64)> = vec![(start, end)];

    for &(to, from, len) in maps {
        let mut m: Vec<(u64, u64)> = Vec::new();

        for (s, e) in queue {
            let a = e.min(from);
            if s < a { m.push((s, a)); }

            let b = s.max(from);
            let c = (from + len).min(e);
            if b < c { intervals.push((b - from + to, c - from + to)); }

            let d = (from + len).max(s);
            if  d < e { m.push((d, e)); }
        }

        queue = m;
    }

    intervals.extend(queue);
    intervals
}

fn ranged_locations(seeds: Vec<Range>, maps: &Vec<Vec<Conversion>>) -> Vec<Range> {
    maps.fold(seeds, |values, maps| {
        values.iter().flat_map(|&(start, end)| {
            split(start, end, maps)
        }).collect()
    })
}

fn main() {
    let lines = file_read_lines("input.txt");
    let seeds = nums(lines[0].split(':').nthu(1));

    let maps = lines[2..]
        .split(|line| line.is_empty())
        .mapc(|map| map[1..].iter().mapc(|map| nums(map).into_iter().collect_tuple().unwrap()));

    println!("Part 1: {:?}", locations(seeds.clone(), &maps.clone()).minu());

    let converted = seeds.chunks(2).mapc(|s| (s[0], s[0] + s[1]));
    println!("Part 2: {:?}", ranged_locations(converted, &maps).map(|v| v.0).min().unwrap());
}
