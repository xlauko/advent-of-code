use aoc::{input::file_read_lines, iter::{IteratorExt}};
use counter::Counter;
use itertools::{Itertools, merge};

const RANKS: &str = "23456789TJQKA";

fn value(card: char) -> usize {
    RANKS.chars().position(|c| c == card).unwrap()
}

fn score(hand: &str) -> Vec<usize> {
    hand.chars()
        .collect::<Counter<_>>()
        .values()
        .sorted_by(|a, b| b.cmp(a))
        .cloned()
        .collect()
}

fn best_score(hand: &str, joker: bool) -> Vec<usize> {
    if joker {
         (0..13)
            .flat_map(|i| best_score(&hand.replace('J', &RANKS[i..=i]), false))
            .max()
            .into_iter()
            .collect()
    } else {
        score(hand)
    }
}

fn tiebreak(hand: &str, joker: bool) -> Vec<usize> {
    merge(best_score(hand, joker), hand.chars().map(value)).collect()
}

fn solve(lines: &[String], joker: bool) -> usize {
    lines
        .iter()
        .map(|line| {
            let mut parts = line.split_whitespace();
            let hand = parts.nextu();
            let bid: usize = parts.nextu().parse().unwrap();
            (tiebreak(hand, joker), bid)
        })
        .sorted_by(|a, b| a.0.cmp(&b.0))
        .enumerate()
        .map(|(rank, (_, bid))| (rank + 1) * bid)
        .sum()
}

fn main() {
    let lines = file_read_lines("input.txt");
    println!("Part 1: {}", solve(&lines, false));
    println!("Part 2: {}", solve(&lines, true));
}
