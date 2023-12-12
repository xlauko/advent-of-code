use memoize::memoize;
use aoc::input::*;
use aoc::iter::*;
use itertools::Itertools;

fn main() {
    let input: Vec<(String, Vec<usize>)> = file_read_lines("input.txt")
        .mapc(|line| {
            let parts = line.split_whitespace().collect_vec();
            let springs = parts.get(0).cloned().unwrap().to_string();
            let groups = parts.get(1).unwrap().split(",").mapc(|x| x.parse().unwrap());
            (springs, groups)
        });

    println!("Part 1: {}", input.clone()
        .map(|(springs, groups)| solve(springs.to_string(), groups.to_vec())).sum::<usize>()
    );

    println!("Part 2: {}", input.map(|(springs, groups)| {
        let springs = vec![springs.clone(); 5].join("?");
        let groups = vec![groups.clone(); 5].into_iter().flatten().collect();
        solve(springs, groups)
    }).sum::<usize>());
}

#[memoize]
fn solve(springs: String, groups: Vec<usize>) -> usize {
    if springs.is_empty() {
        return if groups.is_empty() { 1 } else { 0 };
    }

    match springs.chars().nextu() {
        '.' => solve(springs[1..].to_string(), groups),
        '?' => {
            solve(springs.replacen('?', ".", 1), groups.clone())
            + solve(springs.replacen('?', "#", 1), groups)
        }
        '#' => {
            if groups.is_empty() {
                0
            } else if springs.len() < groups[0] {
                0
            } else if springs[0..groups[0]].contains('.') {
                0
            } else if groups.len() > 1 {
                if springs.len() < (groups[0] + 1) || springs.chars().nthu(groups[0]) == '#' {
                    0
                } else {
                    solve(springs[(groups[0] + 1)..].to_string(), groups[1..].to_vec())
                }
            } else {
                solve(springs[groups[0]..].to_string(), groups[1..].to_vec())
            }
        }
        _ => panic!()
    }
}
