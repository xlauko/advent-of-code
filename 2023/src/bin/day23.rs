use aoc::grid::*;

fn solve(grid: &Grid<char>, seen: &mut Grid<bool>, pos: Pos, dist: usize, slopes: bool) -> usize {
    if pos.x == grid.rows_len() - 1 {
        return dist;
    }

    let dirs = match grid[pos] {
        _ if slopes => vec![U, D, R, L],
        '.' => vec![U, D, R, L],
        '^' => vec![U], '>' => vec![R], 'v' => vec![D], '<' => vec![L],
        _ => unreachable!()
    };

    let mut result: usize = 0;
    for dir in dirs {
        if let Some(next) = grid.next_in_bounds(pos, dir) {
            if seen[next] || grid[next] == '#' {
                continue;
            }
            seen[next] = true;
            result = result.max(solve(grid, seen, next, dist + 1, slopes));
            seen[next] = false;
        }
    }

    result
}

fn main() {
    let grid = file_read_grid("input.txt");
    let mut seen = Grid{ data: vec![vec![false; grid.cols_len()]; grid.rows_len()] };
    println!("Part 1: {}", solve(&grid, &mut seen, (0, 1).into(), 0, false));
    println!("Part 2: {}", solve(&grid, &mut seen, (0, 1).into(), 0, true));
}
