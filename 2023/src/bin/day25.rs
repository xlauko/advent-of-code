use petgraph::graph::{UnGraph, NodeIndex};
use petgraph::dot::{Dot, Config};
use petgraph::algo::kosaraju_scc;
use std::collections::HashMap;
use std::fs;

fn build_graph(input: &str) -> (UnGraph<&str, &str>, HashMap<&str, NodeIndex>) {
    let mut graph = UnGraph::<&str, &str>::with_capacity(0, 0);

    fn get_node<'a>(graph: &mut UnGraph<&'a str, &'a str>, nodes: &mut HashMap<&'a str, NodeIndex>, label: &'a str) -> NodeIndex {
        *nodes.entry(label).or_insert_with(|| graph.add_node(label))
    }

    let mut nodes: HashMap<&str, NodeIndex> = HashMap::new();

    for line in input.lines() {
        let parts: Vec<&str> = line.split(": ").collect();
        let source = parts[0];
        let targets: Vec<&str> = parts[1].split_whitespace().collect();

        let source_index = get_node(&mut graph, &mut nodes, source);

        for target in targets {
            let target_index = get_node(&mut graph, &mut nodes, target);
            graph.add_edge(source_index, target_index, "");
        }
    }

    (graph, nodes)
}

fn main() {
    let input = fs::read_to_string("input.txt").unwrap();
    let (mut graph, nodes) = build_graph(&input);

    let mut remove_edge = |a: &str, b: &str| {
        if let (Some(ai), Some(bi)) = (nodes.get(a), nodes.get(b)) {
            if let Some(edge) = graph.find_edge(*ai, *bi) {
                graph.remove_edge(edge);
            }
        }
    };

    // Get bridges manually
    // println!("{}", Dot::with_config(&graph, &[Config::EdgeNoLabel]));

    remove_edge("zhg", "fmr");
    remove_edge("krf", "crg");
    remove_edge("rgv", "jct");

    let scc = kosaraju_scc(&graph);
    println!("Part 1: {}", scc[0].len() * scc[1].len());
}
