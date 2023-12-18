use aoc::grid::*;
use aoc::input::*;
use aoc::iter::*;

fn dir(dir: char) -> Dir {
    match dir { '0' => R, '1' => D, '2' => L, '3' => U, _ => panic!() }
}

fn char_dir(dir: &str) -> Dir {
     match dir { "R" => R, "D" => D, "L" => L, "U" => U, _ => panic!() }
}

fn parse_one(line: &str) -> (Dir, isize) {
    let parts: Vec<&str> = line.split_whitespace().collect();
    (char_dir(parts[0]), parts[1].parse::<isize>().unwrap())
}

fn parse_two(line: &str) -> (Dir, isize) {
    let parts: Vec<&str> = line.split_whitespace().collect();
    let len = isize::from_str_radix(&parts[2][2..7], 16).unwrap();
    let dir = dir(parts[2].chars().nth(7).unwrap());
    (dir, len)
}

fn solve(steps: Vec<(Dir, isize)>) -> isize {
    let mut y = 0;
    let mut perimeter = 0;
    let mut area = 0;

    for (dir, len) in steps.iter() {
        y += dir.y * len;
        perimeter += len;
        area += y * dir.x * len;
    }

    area + perimeter / 2 + 1
}

fn main() {
    let input = file_read_lines("input.txt");
    println!("Part 1: {}", solve(input.mapc(|line| parse_one(&line))));
    println!("Part 2: {}", solve(input.mapc(|line| parse_two(&line))));
}
