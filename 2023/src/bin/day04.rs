use std::collections::HashSet;

use aoc::{
    input::file_read_lines,
    iter::{IteratorExt, VecExt},
};

fn main() {
    let as_set = |nums: &Vec<u32>| nums.iter().cloned().collect::<HashSet<u32>>();
    let input = file_read_lines("input.txt");
    let intersections: Vec<usize> = input
        .map(|line| line.split(':').nth(1).unwrap().trim().to_string())
        .map(|card| -> Vec<Vec<u32>> {
            card.split('|').map(|part| {
                part.split_whitespace()
                    .filter_mapc(|line| line.parse::<u32>().ok())
            }).collect()
        })
        .mapc(|card| {
            as_set(&card[0]).intersection(&as_set(&card[1])).count()
        });

    println!("Part 1: {}", intersections
        .map(|&i| if i != 0 { 2_u64.pow((i - 1) as u32) } else { 0 }).sum::<u64>());

    let mut counts = vec![1; input.len()];
    intersections.enumerate().for_each(|(idx, &i)| {
        if i != 0 {
            for j in idx + 1..=idx + i {
                counts[j % input.len()] += counts[idx];
            }
        }
    });
    println!("Part 2: {}", counts.iter().sum::<i32>());
}
