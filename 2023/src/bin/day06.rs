use aoc::{input::{file_read_lines, nums}, iter::IteratorExt};

fn solve(time: Vec<u64>, distance: Vec<u64>) -> u64 {
    time.iter()
        .zip(distance.iter())
        .map(|(&t, &d)| {
            (1..t).filter(|&h| h * (t - h) > d).count() as u64
        })
        .product()
}

fn main() {
    let lines = file_read_lines("input.txt");
    let parse = |l: &str| nums(l.split(":").nthu(1));

    println!("Part 1: {}", solve(parse(&lines[0]), parse(&lines[1])));

    let kern = |line: &str| parse(&line.replace(" ", ""));
    println!("Part 2: {}", solve(kern(&lines[0]), kern(&lines[1])));
}
