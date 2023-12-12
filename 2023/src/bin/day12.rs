use memoize::memoize;
use aoc::input::*;
use aoc::iter::*;

fn main() {
    let input: Vec<String> = file_read_lines("input.txt");

    for part in 1..=2 {
        let mut total = 0;

        for line in input.clone() {
            let mut parts = line.split_whitespace();
            let left = parts.nextu().to_string();
            let right: Vec<usize> = parts.nextu().split(",").mapc(|x| x.parse().unwrap());

            if part == 2 {
                let left = vec![left.clone(); 5].join("?");
                let right = vec![right.clone(); 5].into_iter().flatten().collect();
                let res = solve(left, right);
                total += res;
            } else {
                total += solve(left, right);
            }
        }

        println!("Part {}: {}", part, total);
    }
}

#[memoize]
fn solve(springs: String, groups: Vec<usize>) -> u64 {
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
