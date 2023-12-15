#![feature(linked_list_remove)]

use std::fs;
use std::collections::LinkedList;
use aoc::iter::VecExt;

fn main() {
    let contents = fs::read_to_string("input.txt").expect("Error reading file");
    let data: Vec<&str> = contents.trim().split(',').collect();

    let char = |i: usize, c: char| (i + c as usize) * 17 % 256;
    let hash = |s: &&str| s.chars().fold(0, char);

    println!("Part 1: {}", data.map(hash).sum::< usize >());

    let mut boxes: Vec<LinkedList<(&str, usize)>> = vec![LinkedList::new(); 256];

    for step in data.iter() {
        let parts: Vec<&str> = step.trim_matches('-').split('=').collect();
        match &parts[..] {
            [label, f] => {
                let bx = &mut boxes[hash(label)];
                let focal = f.parse().unwrap();
                match bx.iter_mut().find(|(k, _)| k == label) {
                    Some(slot) => slot.1 = focal,
                    None => bx.push_back((label, focal)),
                }
            }
            [label] => {
                let bx = &mut boxes[hash(label)];
                if let Some(pos) = bx.iter().position(|(k, _)| k == label) {
                    bx.remove(pos);
                }
            }
            _ => {}
        }
    }

    println!("Part 2: {}", boxes.iter().enumerate().map(|(box_index, bx)| {
        bx.iter().enumerate().map(|(slot_index, &(_, focal))| {
            (box_index + 1) * (slot_index + 1) * focal
        }).sum::<usize>()
    }).sum::<usize>());
}
