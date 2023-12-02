use std::fs::File;
use std::io::{self, Read};

pub fn read_lines<I: Read>(mut source: I) -> Result<Vec<String>, io::Error> {
    let mut contents: String = String::new();
    source.read_to_string(&mut contents)?;
    Ok(contents.lines().map(String::from).collect())
}

pub fn file_read_lines(path: &str) -> Vec<String> {
    read_lines(File::open(&path).unwrap()).unwrap()
}

pub fn read_by_chunks(path: &str) -> Vec<Vec<String>> {
    let mut chunks: Vec<Vec<String>> = Vec::new();
    let mut chunk: Vec<String> = Vec::new();
    for line in file_read_lines(path) {
        if line.trim().is_empty() {
            chunks.push(chunk);
            chunk = Vec::new();
        } else {
            chunk.push(line);
        }
    }
    chunks.push(chunk);
    chunks
}

pub fn file_read_nums(path: &str) -> Vec<u32> {
    file_read_lines(path)
        .iter()
        .filter_map(|line| line.parse().ok())
        .collect()
}

pub fn chunks_read_nums(path: &str) -> Vec<Vec<u32>> {
    read_by_chunks(path)
        .iter()
        .map(|chunk| chunk.iter().filter_map(|line| line.parse().ok()).collect())
        .collect()
}
