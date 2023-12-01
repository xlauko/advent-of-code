use std::path::Path;
use aoc::input::{file_read_lines};

const NUMS : [&'static str; 9] = [ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" ];

pub fn sum_calibration_values(lines: Vec<String>, parse: bool) -> u32 {
    lines.iter()
        .map(|line| {
        let mut digs = Vec::<u32>::new();
        for (ci, c) in line.chars().into_iter().enumerate() {
            if c.is_digit(10) {
                digs.push(c.to_digit(10).unwrap());
            } else if parse {
                for (i, num) in NUMS.iter().enumerate() {
                    if line[ci..].starts_with(num) {
                        digs.push(i as u32 + 1);
                    }
                }
            }
        }

        return digs.first().unwrap() * 10 + digs.last().unwrap();
    }).sum()
}

fn main() {
    let path = Path::new("input.txt");
    let lines = file_read_lines(path);
    let sum = sum_calibration_values(lines, true);
    println!("{:?}", sum);
}
