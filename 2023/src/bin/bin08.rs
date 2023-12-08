use aoc::input::file_read_lines;
use std::collections::HashMap;
use num::integer::lcm;

type Map = HashMap<String, (String, String)>;

fn navigate(start: String, dirs: &Vec<char>, map: &Map) -> usize {
    dirs.iter().cycle()
        .scan(start, |current, &dir| {
            let (left, right) = map.get(current).unwrap();
            *current = match dir {
                'L' => left,
                'R' => right,
                 _ => panic!()
            }.to_string();
            Some(current.clone())
        })
        .take_while(|current| !current.ends_with('Z'))
        .count() + 1
}

fn navigate_ghost(dirs: &Vec<char>, map: &Map) -> usize {
    map.keys()
        .filter(|start| start.ends_with('A'))
        .map(|start| navigate(start.to_string(), &dirs, &map))
        .reduce(|a, b| lcm(a, b)).unwrap()
}

fn main() {
    let lines = file_read_lines("input.txt");
    let dirs = lines[0].trim().chars().collect();

    let map = lines[2..]
        .iter()
        .map(|line| {
            let bind = line.replace(&['(', ')', '=', ','][..], "");
            let parts: Vec<&str> = bind.split_whitespace().collect();
            (parts[0].to_string(), (parts[1].to_string(), parts[2].to_string()))
        }).collect::<Map>();

    println!("Part 1: {}", navigate("AAA".to_string(), &dirs, &map));
    println!("Part 2: {}", navigate_ghost(&dirs, &map));
}
