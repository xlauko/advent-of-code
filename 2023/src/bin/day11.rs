use aoc::grid::*;
use itertools::Itertools;

fn find_paths(data: Grid<char>, expand: usize) -> usize {
    let empty = |seq: &[char]| seq.iter().all(|&c| c == '.');

    let empty_cols: Vec<usize> = data.filter_col_indices(empty).collect();
    let empty_rows: Vec<usize> = data.filter_row_indices(empty).collect();

    let between = |a: usize, b: usize, values: &Vec<usize>| -> usize {
        values.iter().filter(|&&x| x >= a && x <= b).count()
    };

    let galaxies: Vec<Pos> = data.positions(|&value| value == '#').map(|pos| {
        Pos {
            x: pos.x + between(0, pos.x, &empty_rows) * expand,
            y: pos.y + between(0, pos.y, &empty_cols) * expand
        }
    }).collect();

    galaxies.iter().tuple_combinations().map(|(a, b)| { a.man(b) }).sum()
}

fn main() {
    let grid = file_read_grid("input.txt");

    // println!("Part 1: {}", find_paths(grid, 1));
    println!("Part 2: {}", find_paths(grid, 999999));
}
