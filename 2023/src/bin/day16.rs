use std::collections::HashSet;
use std::collections::VecDeque;
use aoc::iter::VecExt;

use aoc::grid::*;

fn unique(beams: HashSet<Beam>) -> HashSet<Pos> {
    beams.iter().map(|&beam| beam.pos).collect()
}

fn next(beam: Beam, grid: &Grid<char>) -> Vec<Beam> {
    match grid[beam.pos] {
        '\\' => vec![beam.mirror_left()],
        '/'  => vec![beam.mirror_right()],
        '|'  => vec![beam.up(), beam.down()],
        '-'  => vec![beam.left(), beam.right()],
        '.'  => vec![beam],
        _ => panic!()
    }
}

fn energized(grid: &Grid<char>, beam: Beam) -> usize {
    let mut done = HashSet::new();
    let mut queue = VecDeque::from([beam]);
    while let Some(beam) = queue.pop_front() {
        if done.contains(&beam) {
            continue;
        }

        done.insert(beam);
        for next in next(beam, grid) {
            if let Some(moved) = next.step(grid) {
                queue.push_back(moved);
            }
        }
    }

    unique(done).len()
}

fn create_beams(cols: usize, rows: usize) -> Vec<Beam> {
    let mut beams: Vec<Beam> = Vec::new();

    for col in 0..cols {
        beams.push(((0, col), D).into());
        beams.push(((rows - 1, col), U).into());
    }

    for row in 1..rows - 1 {
        beams.push(((row, 0), R).into());
        beams.push(((row, cols - 1), L).into());
    }

    beams
}

fn main() {
    let grid: Grid<char> = file_read_grid("input.txt");
    println!("Part 1: {}", energized(&grid, ((0, 0), R).into()));

    let beams = create_beams(grid.cols_len(), grid.rows_len());
    println!("Part 2: {}", beams.map(|beam| energized(&grid, *beam)).into_iter().max().unwrap());
}
