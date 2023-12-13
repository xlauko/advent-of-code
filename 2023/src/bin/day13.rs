use aoc::grid::*;
use itertools::izip;

fn row_diff(r1: &[char], r2: &[char]) -> usize {
    izip!(r1, r2).map(|(c1, c2)| (c1 != c2) as usize).sum()
}

fn mirror_position(plan: &Grid<char>, smudge: usize) -> usize {
    let rows = plan.rows_len();
    (1..rows)
        .position(|i| {
            let (left, right) = plan.data.split_at(i);
            izip!(left.iter().rev(), right.iter())
                .map(|(r1, r2)| row_diff(r1, r2))
                .sum::<usize>()
                == smudge
        })
        .map(|pos| pos + 1)
        .unwrap_or(0)
}

fn solve(plans: &Vec<Grid<char>>, smudge: usize) -> usize {
    plans.iter().map(|plan| {
        100 * mirror_position(plan, smudge) + mirror_position(&transpose(plan), smudge)
    }).sum()
}

fn main() {
    let plans = file_read_grids("input.txt");
    println!("Part 1: {}", solve(&plans, 0));
    println!("Part 2: {}", solve(&plans, 1));
}
