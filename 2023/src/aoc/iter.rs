use std::iter::{Enumerate, Map};

pub trait IteratorExt: Iterator {
    fn mapc<U, F>(self, f: F) -> Vec<U>
    where
        F: FnMut(Self::Item) -> U,
        Self: Sized,
    {
        self.map(f).collect()
    }

    fn filter_mapc<U, F>(self, f: F) -> Vec<U>
    where
        F: FnMut(Self::Item) -> Option<U>,
        Self: Sized,
    {
        self.filter_map(f).collect()
    }


    fn nextu(&mut self) -> Self::Item {
        self.next().unwrap()
    }

    fn nthu(&mut self, n: usize) -> Self::Item {
        self.nth(n).unwrap()
    }
}

impl<T: Iterator> IteratorExt for T {}

pub trait VecExt<T> {
    fn map<U, F>(&self, f: F) -> Map<std::slice::Iter<T>, F>
    where
        F: FnMut(&T) -> U;

    fn mapc<U, F>(&self, f: F) -> Vec<U>
    where
        F: FnMut(&T) -> U;

    fn filter_mapc<U, F>(&self, f: F) -> Vec<U>
    where
        F: FnMut(&T) -> Option<U>;

    fn enumerate(&self) -> Enumerate<std::slice::Iter<T>>;
}

impl<T> VecExt<T> for Vec<T> {
    fn map<U, F>(&self, f: F) -> Map<std::slice::Iter<T>, F>
    where
        F: FnMut(&T) -> U,
    {
        self.iter().map(f)
    }

    fn mapc<U, F>(&self, f: F) -> Vec<U>
    where
        F: FnMut(&T) -> U,
    {
        self.iter().map(f).collect()
    }

    fn filter_mapc<U, F>(&self, f: F) -> Vec<U>
    where
        F: FnMut(&T) -> Option<U>,
    {
        self.iter().filter_map(f).collect()
    }

    fn enumerate(&self) -> Enumerate<std::slice::Iter<T>> {
        self.iter().enumerate()
    }
}
