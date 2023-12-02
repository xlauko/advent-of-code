use aoc::input::{file_read_lines};

const NUMS : &[&str] = &[ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" ];

pub fn sum_calibration_values(lines: Vec<String>, parse: bool) -> u32 {
    lines.iter().map(|line| {
        let digs: Vec<u32> = line.chars().enumerate().filter_map(|(ci, c)| {
            match c {
                _ if c.is_digit(10) => Some(c.to_digit(10).unwrap()),
                _ if parse => NUMS.iter().position(|&num| line[ci..].starts_with(num)).map(|i| i as u32 + 1),
                _ => None,
            }
        }).collect();

        return digs.first().unwrap() * 10 + digs.last().unwrap();
    }).sum()
}

fn main() {
    let lines = file_read_lines("input.txt");
    let sum = sum_calibration_values(lines, true);
    println!("{:?}", sum);
}
