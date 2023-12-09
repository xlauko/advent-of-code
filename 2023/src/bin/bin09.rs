use aoc::input::{file_read_lines, inums};
use aoc::iter::{IteratorExt, VecExt};

fn extrapolate(seq: &[i64]) -> i64 {
    if seq.iter().all(|&c| c == 0) {
        0
    } else {
        seq.last().unwrap() + extrapolate(&seq.windows(2).mapc(|w| w[1] - w[0]))
    }
}

fn main() {
    let lines: Vec<Vec<i64>> = file_read_lines("input.txt")
        .mapc(|line| inums(line.as_str()));
    println!("Part 1: {}", lines.map(|s| extrapolate(s)).sum::<i64>());

    let reverse_and_extrapolate = |s: &Vec<i64>| {
        extrapolate(&s.iter().cloned().rev().collect::<Vec<_>>())
    };
    println!("Part 2: {}", lines.map(reverse_and_extrapolate).sum::<i64>());
}
