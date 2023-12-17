use aoc::grid::*;
use priority_queue::PriorityQueue;
use std::{cmp::Reverse, collections::HashSet};

#[derive(Eq, PartialEq, Hash, Clone, Copy, Debug)]
struct Crucible {
    pos: Pos,
    dir: Dir,
    steps: u8,
}

impl From<(Pos, Dir, u8)> for Crucible {
    fn from((pos, dir, steps): (Pos, Dir, u8)) -> Self {
        Crucible { pos, dir, steps }
    }
}

fn shortest_path<Succ>(grid: &Grid<u8>, succ: Succ) -> u64
where
    Succ: Fn(&Crucible, &Grid<u8>) -> Vec<Crucible>,
{
    let mut queue: PriorityQueue<Crucible, Reverse<u64>> = PriorityQueue::new();
    let mut closed: HashSet<Crucible> = HashSet::new();

    queue.push(((0, 0).into(), R, 1).into(), Reverse(0));
    queue.push(((0, 0).into(), D, 1).into(), Reverse(0));

    let goal: Pos = (grid.cols_len() - 1, grid.rows_len() - 1).into();

    while let Some((cruc, cost)) = queue.pop() {
        if closed.contains(&cruc) {
            continue;
        }

        closed.insert(cruc);

        if cruc.pos == goal {
            return cost.0;
        }

        for next in succ(&cruc, grid) {
            queue.push_increase(next, Reverse(cost.0 + grid[next.pos] as u64));
        }
    }

    unreachable!()
}

fn push_checked(grid: &Grid<u8>, pos: Pos, dir: Dir, steps: u8, succ: &mut Vec<Crucible>) {
    if let Some(next) = grid.next_in_bounds(pos, dir) {
        succ.push((next, dir, steps).into());
    }
}

fn main() {
    let grid: Grid<u8> = file_read_grid_u8("input.txt");

    let succ = |cruc: &Crucible, grid: &Grid<u8>, min: u8, max: u8| -> Vec<Crucible> {
        let mut succ: Vec<Crucible> = vec![];
        if cruc.steps < max {
            push_checked(grid, cruc.pos, cruc.dir, cruc.steps + 1, &mut succ);
        }
        if cruc.steps >= min {
            push_checked(grid, cruc.pos, cruc.dir.turn_left(), 1, &mut succ);
            push_checked(grid, cruc.pos, cruc.dir.turn_right(), 1, &mut succ);
        }
        succ
    };

    println!("Part 1: {}", shortest_path(&grid, |cruc, grid| succ(cruc, grid, 0, 3)));
    println!("Part 2: {}", shortest_path(&grid, |cruc, grid| succ(cruc, grid, 4, 10)));
}
