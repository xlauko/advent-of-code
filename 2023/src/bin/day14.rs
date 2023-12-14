use aoc::grid::*;

fn slide(grid: &mut Grid<char>) {
    let (n, m) = grid.dims();

    for j in 0..m {
        let mut ci = 0;

        for i in 0..n {
            if grid.data[i][j] == '#' {
                ci = i + 1;
            }

            if grid.data[i][j] == 'O' {
                grid.data[i][j] = '.';
                grid.data[ci][j] = 'O';
                ci += 1;
            }
        }
    }
}

fn score(grid: &Grid<char>) -> usize {
    grid.data.iter()
        .enumerate()
        .map(|(i, row)| {
            (grid.data.len() - i) * row.iter().filter(|&&c| c == 'O').count()
        })
        .sum()
}

fn rotate_inplace(grid: &mut Grid<char>) {
    let (n, m) = grid.dims();
    let mut rotated = vec![vec!['.'; m]; n];

    for i in 0..n {
        for j in 0..m {
            rotated[j][n - i - 1] = grid.data[i][j];
        }
    }

    grid.data = rotated;
}

fn solve(grid: &mut Grid<char>, goal: usize) -> usize {
    let mut cache = std::collections::HashMap::new();
    let mut idx = 1;

    loop {
        for _ in 0..4 {
            slide(grid);
            rotate_inplace(grid);
        }

        if let Some(&(a, _)) = cache.get(grid) {
            let cyclen: usize = idx - a;

            for &(_, res) in cache.values().filter(|&&(av, _)|
                av >= a && av % cyclen == goal % cyclen
            ) {
                return res;
            }
        }

        cache.insert(grid.clone(), (idx, score(grid)));
        idx += 1;
    }
}

fn main() {
    let mut grid: Grid<char> = file_read_grid("input.txt");
    let goal = 1_000_000_000;

    println!("Part 2: {}", solve(&mut grid, goal));
}
