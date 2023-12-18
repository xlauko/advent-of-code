use std::ops::{Add, Mul, Index, IndexMut};
use itertools::Itertools;
use lazy_static::lazy_static;
use crate::input::*;
use crate::iter::*;
use std::fmt;

//
// Position & Direction
//

#[derive(Debug, Clone, Copy, Hash, PartialEq, Eq)]
pub struct Vec2<T> {
    pub x: T,
    pub y: T,
}

impl<T> Vec2<T> {
    pub fn new(x: T, y: T) -> Self {
        Self { x, y }
    }
}

pub type Dir = Vec2<isize>;
pub type Pos = Vec2<usize>;

pub const U: Dir = Dir { x: -1, y: 0 };
pub const D: Dir = Dir { x: 1, y: 0 };
pub const R: Dir = Dir { x: 0, y: 1 };
pub const L: Dir = Dir { x: 0, y: -1 };

impl Dir {
    pub fn turn_left(self) -> Dir {
        match self { U => L, D => R, L => D, R => U, _ => panic!() }
    }

    pub fn turn_right(self) -> Dir {
        match self { U => R, D => L, L => U, R => D, _ => panic!() }
    }

    pub fn turn_back(self) -> Dir {
        match self { U => D, D => U, L => R, R => L, _ => panic!() }
    }

    pub fn length(&self) -> isize {
        (self.x * self.x + self.y * self.y).isqrt()
    }
}

impl Mul<isize> for Dir {
    type Output = Dir;

    fn mul(self, rhs: isize) -> Dir {
        Dir {
            x: self.x * rhs,
            y: self.y * rhs,
        }
    }
}

// neighbors
lazy_static! {
    pub static ref N4: Vec<Dir> = vec![U, R, D, L];
    pub static ref N8: Vec<Dir> = vec![U, R, D, L, U + R, U + L, D + R, D + L];
}

impl<T> Add<Dir> for Vec2<T>
where
   T: Add<Output = T> + Copy + From<isize> + Into<isize>
{
    type Output = Vec2<T>;

    fn add(self, dir: Dir) -> Vec2<T> {
        Vec2 {
            x: (self.x.into() + dir.x).into(),
            y: (self.y.into() + dir.y).into(),
        }
    }
}

impl<T> From<(T, T)> for Vec2<T> {
    fn from(tuple: (T, T)) -> Self {
        Vec2 { x: tuple.0, y: tuple.1 }
    }
}

pub trait TupleToVec2<T> {
    fn to_vec2(self) -> Vec2<T>;
}

impl<T> TupleToVec2<T> for (T, T) {
    fn to_vec2(self) -> Vec2<T> {
        Vec2::new(self.0, self.1)
    }
}

impl<T> Vec2<T>
where
   T: Add<Output = T> + Copy + From<isize> + Into<isize>
{
    pub fn neighbors<'a>(&'a self, dirs: &'a Vec<Dir>) -> impl Iterator<Item = Vec2<T>> + 'a {
        dirs.iter().map(move |&dir| *self + dir)
    }

    pub fn n4<'a>(&'a self) -> impl Iterator<Item = Vec2<T>> + 'a {
        self.neighbors(&N4)
    }

    pub fn n8<'a>(&'a self) -> impl Iterator<Item = Vec2<T>> + 'a {
        self.neighbors(&N8)
    }
}

impl Pos {
    pub fn man(&self, other: &Pos) -> usize {
        ((self.x as isize - other.x as isize).abs() + (self.y as isize - other.y as isize).abs()) as usize
    }
}

//
// Grid
//

#[derive(Hash, PartialEq, Eq, Clone)]
pub struct Grid<T> {
    pub data: Vec<Vec<T>>,
}

impl<T> Index<usize> for Grid<T> {
    type Output = Vec<T>;

    fn index(&self, index: usize) -> &Vec<T> {
        &self.data[index]
    }
}

impl<T> IndexMut<usize> for Grid<T> {
    fn index_mut(&mut self, index: usize) -> &mut Vec<T> {
        &mut self.data[index]
    }
}

impl<T> Index<Pos> for Grid<T> {
    type Output = T;

    fn index(&self, pos: Pos) -> &T {
        &self.data[pos.x][pos.y]
    }
}

impl<T> Index<(usize, usize)> for Grid<T> {
    type Output = T;

    fn index(&self, (i, j): (usize, usize)) -> &T {
        &self.data[i][j]
    }
}

impl<T> IndexMut<(usize, usize)> for Grid<T> {
    fn index_mut(&mut self, (i, j): (usize, usize)) -> &mut T {
        &mut self.data[i][j]
    }
}

impl<T: fmt::Debug + std::fmt::Display> fmt::Debug for Grid<T> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        if std::any::type_name::<T>() == "char" {
            for row in &self.data {
                for ch in row {
                    write!(f, "{}", ch)?;
                }
                writeln!(f)?;
            }
        } else {
            for row in &self.data {
                write!(f, "{:?}", row)?;
                writeln!(f)?;
            }
        }
        Ok(())
    }
}

impl<T> Grid<T> {
    pub fn rows_len(&self) -> usize {
        self.data.len()
    }

    pub fn cols_len(&self) -> usize {
        self.data.get(0).map_or(0, |row| row.len())
    }

    pub fn dims(&self) -> (usize, usize) {
        (self.rows_len(), self.cols_len())
    }

    pub fn rows(&self) -> RowIter<T> {
        RowIter {
            grid: self,
            row: 0,
        }
    }

    pub fn columns(&self) -> ColumnIter<T> {
        ColumnIter {
            grid: self,
            col: 0,
        }
    }

    pub fn positions(&self, predicate: fn(&T) -> bool) -> PositionIter<T> {
        PositionIter {
            grid: self,
            row: 0,
            col: 0,
            predicate,
        }
    }

    pub fn filter_row_indices<F>(&self, predicate: F) -> FilterRowIndices<T, F>
    where
        F: Fn(&[T]) -> bool,
    {
        FilterRowIndices {
            grid: self,
            predicate,
            row: 0,
        }
    }

    pub fn filter_col_indices<F>(&self, predicate: F) -> FilterColumnIndices<T, F>
    where
        F: Fn(&[T]) -> bool,
    {
        FilterColumnIndices {
            grid: self,
            predicate,
            col: 0,
        }

    }

    pub fn next_in_bounds(&self, pos: Pos, dir: Dir) -> Option<Pos> {
        let next = Vec2::<isize>{
            x: pos.x as isize + dir.x,
            y: pos.y as isize + dir.y,
        };

        if next.x >= 0 && next.y >= 0 && next.x < self.cols_len() as isize && next.y < self.rows_len() as isize {
            return Some((next.x as usize, next.y as usize).into());
        }

        None
    }

}

pub struct RowIter<'a, T> {
    grid: &'a Grid<T>,
    row: usize,
}

impl<'a, T: fmt::Debug> Iterator for RowIter<'a, T> {
    type Item = &'a [T];

    fn next(&mut self) -> Option<Self::Item> {
        if self.row < self.grid.data.len() {
            let row = &self.grid.data[self.row];
            self.row += 1;
            Some(row)
        } else {
            None
        }
    }
}

pub struct ColumnIter<'a, T> {
    grid: &'a Grid<T>,
    col: usize,
}

pub struct PositionIter<'a, T> {
    grid: &'a Grid<T>,
    row: usize,
    col: usize,
    predicate: fn(&T) -> bool,
}

impl<'a, T: fmt::Debug> Iterator for PositionIter<'a, T> {
    type Item = Pos;

    fn next(&mut self) -> Option<Self::Item> {
        while self.row < self.grid.data.len() {
            while self.col < self.grid.data[self.row].len() {
                if (self.predicate)(&self.grid.data[self.row][self.col]) {
                    let position = Pos { x: self.row, y: self.col };
                    self.col += 1;
                    return Some(position);
                }
                self.col += 1;
            }
            self.row += 1;
            self.col = 0;
        }

        None
    }
}

impl<'a, T: fmt::Debug> Iterator for ColumnIter<'a, T> {
    type Item = Vec<&'a T>;

    fn next(&mut self) -> Option<Self::Item> {
        if self.col < self.grid.data.get(0).map_or(0, |row| row.len()) {
            let column: Vec<&'a T> = self.grid.data.iter().map(|row| &row[self.col]).collect();
            self.col += 1;
            Some(column)
        } else {
            None
        }
    }
}

pub struct FilterRowIndices<'a, T, F> {
    grid: &'a Grid<T>,
    predicate: F,
    row: usize,
}

impl<'a, T, F> Iterator for FilterRowIndices<'a, T, F>
where
    F: Fn(&[T]) -> bool,
{
    type Item = usize;

    fn next(&mut self) -> Option<Self::Item> {
        while self.row < self.grid.data.len() {
            if (self.predicate)(&self.grid.data[self.row]) {
                let index = self.row;
                self.row += 1;
                return Some(index);
            }
            self.row += 1;
        }

        None
    }
}

pub struct FilterColumnIndices<'a, T, F> {
    grid: &'a Grid<T>,
    predicate: F,
    col: usize,
}

impl<'a, T, F> Iterator for FilterColumnIndices<'a, T, F>
where
    T: Clone,
    F: Fn(&[T]) -> bool,
{
    type Item = usize;

    fn next(&mut self) -> Option<Self::Item> {
        while self.col < self.grid.data.get(0).map_or(0, |row| row.len()) {
            let column: Vec<T> =
                self.grid.data.iter().map(|row| row[self.col].clone()).collect();
            if (self.predicate)(column.as_slice()) {
                let index = self.col;
                self.col += 1;
                return Some(index);
            }
            self.col += 1;
        }

        None
    }
}

pub fn file_read_grid(path: &str) -> Grid<char> {
    Grid { data: file_read_chars(path) }
}

pub fn file_read_grid_u8(path: &str) -> Grid<u8> {
    Grid { data: file_read_chars(path).map(|row| {
        row.iter().map(|&ch| ch as u8 - b'0').collect()
    }).collect_vec() }
}

pub fn file_read_grids(path: &str) -> Vec<Grid<char>> {
    read_by_chunks(path).mapc(|chunk|
        Grid{ data: chunk.mapc(|line| line.chars().collect()) }
    )
}

// impl<T: Clone> Grid<T>
// {
//     pub fn neighbors<'a>(&'a self, pos: Pos, dirs: &'a Vec<Dir>) -> impl Iterator<Item = T> + 'a {
//         pos.neighbors(dirs)
//             .filter(move |&p| p.x < self.data[0].len() && p.y < self.data.len())
//             .map(move |p| self[p].clone())
//             .into_iter()
//     }

//     pub fn n4<'a>(&'a self, pos: Pos) -> impl Iterator<Item = T> + 'a {
//         self.neighbors(pos, &N4)
//     }

//     pub fn n8<'a>(&'a self, pos: Pos) -> impl Iterator<Item = T> + 'a {
//         self.neighbors(pos, &N8)
//     }
// }

pub fn transpose<T: Clone + Copy + fmt::Debug>(grid: &Grid<T>) -> Grid<&T> {
    Grid { data: grid.columns().collect() }
}

#[derive(Debug, Clone, Copy, Hash, PartialEq, Eq)]
pub struct Beam {
    pub pos: Pos,
    pub dir: Dir,
}

impl From<((usize, usize), Dir)> for Beam {
    fn from(((x, y), dir): ((usize, usize), Dir)) -> Self {
        Beam { pos: (x, y).into(), dir: dir }
    }
}

impl From<(Pos, Dir)> for Beam {
    fn from((pos, dir): (Pos, Dir)) -> Self {
        Beam { pos: pos, dir: dir }
    }
}

impl Beam {
    pub fn mirror_left(&self) -> Beam {
        Beam{pos: self.pos, dir: match self.dir { U => L, D => R, L => U, R => D, _ => panic!() }}
    }

    pub fn mirror_right(&self) -> Beam {
        Beam{pos: self.pos, dir: match self.dir { U => R, D => L, L => D, R => U, _ => panic!() }}
    }

    pub fn step<T>(&self, grid: &Grid<T>) -> Option::<Beam> {
        let next = Vec2::<isize>{
            x: self.pos.x as isize + self.dir.x,
            y: self.pos.y as isize + self.dir.y,
        };

        if next.x >= 0 && next.y >= 0 && next.x < grid.cols_len() as isize && next.y < grid.rows_len() as isize {
            let next_pos = Pos{ x: next.x as usize, y: next.y as usize };
            Some(Beam{pos: next_pos, dir: self.dir})
        } else {
            None
        }
    }

    pub fn up(&self)    -> Beam { (self.pos, U).into() }
    pub fn down(&self)  -> Beam { (self.pos, D).into() }
    pub fn right(&self) -> Beam { (self.pos, R).into() }
    pub fn left(&self)  -> Beam { (self.pos, L).into() }
}
