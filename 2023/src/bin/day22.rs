use std::collections::HashMap;

use aoc::input::*;
use aoc::iter::*;

#[derive(Debug, Clone, Copy)]
struct Brick {
    x1: u32,
    y1: u32,
    z1: u32,
    x2: u32,
    y2: u32,
    z2: u32,
}

impl Brick {
    fn new(from: (u32, u32, u32), to: (u32, u32, u32)) -> Brick {
        Brick {
            x1: from.0, y1: from.1, z1: from.2,
            x2: to.0, y2: to.1, z2: to.2,
        }
    }
}

fn parse_coord(s: &str) -> (u32, u32, u32) {
    let mut parts = s.split(',');
    let mut parse_next = || parts.nextu().parse().unwrap();
    (parse_next(), parse_next(), parse_next())
}

fn drop_brick(tops: &HashMap<(u32, u32), u32>, brick: &Brick) -> Brick {
    let mut result = brick.clone();
    let peak = (brick.x1..=brick.x2)
        .flat_map(|x| (brick.y1..=brick.y2).map(move |y| tops.get(&(x, y)).cloned().unwrap_or_default()))
        .max()
        .unwrap_or_default();

    let dz = u32::max(brick.z1.saturating_sub(peak).saturating_sub(1), 0);

    result.z1 = brick.z1.saturating_sub(dz);
    result.z2 = brick.z2.saturating_sub(dz);

    result
}

fn drop(bricks: Vec<Brick>) -> (Vec<Brick>, i32) {
    let mut tops: HashMap<(u32, u32), u32> = HashMap::new();
    let mut result = Vec::new();
    let mut falls = 0;

    for brick in bricks {
        let dropped = drop_brick(&tops, &brick);

        if dropped.z1 != brick.z1 {
            falls += 1;
        }

        result.push(dropped);

        for x in brick.x1..=brick.x2 {
            for y in brick.y1..=brick.y2 {
                tops.insert((x, y), dropped.z2);
            }
        }
    }

    (result, falls)
}

fn main() {
    let input = file_read_lines("input.txt");
    let mut bricks = input.mapc(|line| {
        let (from, to) = line.split_once('~').unwrap();
        Brick::new(parse_coord(from), parse_coord(to))
    });

    bricks.sort_by(|a, b| a.z1.cmp(&b.z1));

    let (dropped,_) = drop(bricks);

    let mut p1 = 0;
    let mut p2 = 0;

    for i in 0..dropped.len() {
        let removed = [&dropped[..i], &dropped[i + 1..]].concat();
        let (_, falls) = drop(removed);

        if falls == 0 {
            p1 += 1;
        } else {
            p2 += falls;
        }
    }

    println!("Part 1: {}", p1);
    println!("Part 2: {}", p2);
}
