use regex::Regex;
use std::collections::HashSet;

use aoc::{input::file_read_chars, iter::IteratorExt};

fn is_valid_symbol(symbol: char) -> bool {
    !symbol.is_digit(10) && symbol != '.'
}

fn parse_line(input: &str) -> Vec<(u32, std::ops::Range<usize>)> {
    let re = Regex::new(r"(\d+)").unwrap();
    re.find_iter(input)
        .map(|m| {
            let number = m.as_str().parse().unwrap();
            let range = m.start()..m.end();
            (number, range)
        })
        .collect()
}

fn parse_numbers(schema: &Vec<Vec<char>>) -> Vec<Vec<u32>> {
    schema.iter().map(|chars| parse_line(&chars.iter().collect::<String>())).mapc(|number_ranges| {
        let mut row_numbers = vec![0; schema[0].len()];
        for (number, range) in number_ranges {
            for col in range {
                row_numbers[col] = number;
            }
        }
        row_numbers
    })
}

fn parts(schema: &Vec<Vec<char>>, number_matrix: &Vec<Vec<u32>>) -> Vec<(char, Vec<u32>)> {
    let mut parts: Vec<(char, Vec<u32>)> = Vec::new();

    for i in 0..schema.len() {
        for j in 0..schema[0].len() {
            if is_valid_symbol(schema[i][j]) {
                let seen: HashSet<u32> = ((i - 1)..=(i + 1).min(schema.len() - 1))
                    .flat_map(|row| ((j - 1)..=(j + 1).min(schema[0].len() - 1))
                        .map(move |col| number_matrix[row][col])
                    )
                    .filter(|&num| num != 0)
                    .collect();

                if !seen.is_empty() {
                    parts.push((schema[i][j], seen.iter().cloned().collect()));
                }
            }
        }
    }

    return parts;
}

fn main() {
    let schema = file_read_chars("input.txt");
    let numbers = parse_numbers(&schema);
    let parts = parts(&schema, &numbers);

    println!("Part 1: {}", parts.iter()
        .flat_map(|&(_, ref inner_vec)| inner_vec)
        .sum::<u32>()
    );

    println!("Part 2: {}", parts.iter()
        .filter(|&&(ch, ref inner)| ch == '*' && inner.len() == 2)
        .map(|&(_, ref inner)| inner.iter().product::<u32>())
        .sum::<u32>()
    );
}
