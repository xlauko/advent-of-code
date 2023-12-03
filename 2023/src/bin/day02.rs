use aoc::input::file_read_lines;
use aoc::iter::{IteratorExt, VecExt};

type CubeCount = (u32, u32, u32);

fn main() {
    let games: Vec<Vec<CubeCount>> = file_read_lines("input.txt")
        .mapc(|game| parse_game(game));

    let bounds = (12, 13, 14);

    let possible_games: usize = games
        .enumerate()
        .filter_map(|(index, rounds)|
            Some(index + 1).filter(|_| is_possible_game(rounds, bounds))
        )
        .sum();

    println!("Part 1: {}", possible_games);

    let total_power: u32 = games.map(|rounds| find_minimum_power(rounds)).sum();

    println!("Part 2: {}", total_power);
}

fn parse_game(game: &str) -> Vec<CubeCount> {
    game.splitn(2, ':')
        .nthu(1)
        .trim()
        .split(';')
        .mapc(parse_round)
}

fn parse_round(round: &str) -> CubeCount {
    let mut cube_count = (0, 0, 0);

    for cube in round.trim().split(',') {
        let parts: Vec<&str> = cube.trim().split_whitespace().collect();
        let count = parts[0].parse::<u32>().unwrap();
        match parts[1] {
            "red" => cube_count.0 += count,
            "green" => cube_count.1 += count,
            "blue" => cube_count.2 += count,
            _ => unreachable!("Unexpected cube color"),
        }
    }

    cube_count
}

fn is_possible_game(rounds: &[CubeCount], bounds: CubeCount) -> bool {
    rounds
        .iter()
        .all(|&count| count.0 <= bounds.0 && count.1 <= bounds.1 && count.2 <= bounds.2)
}

fn find_minimum_power(rounds: &[CubeCount]) -> u32 {
    let mut bounds = (0, 0, 0);
    for count in rounds {
        bounds.0 = bounds.0.max(count.0);
        bounds.1 = bounds.1.max(count.1);
        bounds.2 = bounds.2.max(count.2);
    }

    bounds.0 * bounds.1 * bounds.2
}
