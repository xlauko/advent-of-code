using Match
using SymPy

int(v) = parse(Int, v)

function parse_tree(lines)
    tree = Dict()

    for line in lines
        if (m = match(r"(.+): (\d+)", line); m !== nothing)
            tree[m[1]] = int(m[2])
        end

        if (m = match(r"(.+): (.+) (.) (.+)", line); m !== nothing)
            tree[m[1]] = (m[2], m[4], m[3])
        end
    end
    return tree
end

function eval_tree(tree, name, solve)
    if name == "humn" && solve return Sym("h") end

    node = tree[name]
    if typeof(node) == Int return node end

    lhs = eval_tree(tree, node[1], solve)
    rhs = eval_tree(tree, node[2], solve)

    return @match node[3] begin
        "+" => lhs + rhs
        "-" => lhs - rhs
        "*" => lhs * rhs
        "/" => lhs // rhs
    end
end

function part_two(tree)
    lhs = eval_tree(tree, tree["root"][1], true)
    rhs = eval_tree(tree, tree["root"][2], true)
    return solve(lhs - rhs)
end

tree = readlines(stdin) |> parse_tree

println("Part 1: ", eval_tree(tree, "root", false))
println("Part 2: ", part_two(tree))
