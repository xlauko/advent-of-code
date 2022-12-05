int = v -> parse(Int, v)

const input = (readlines(stdin)
    .|> line -> match(r"move (\d+) from (\d+) to (\d+)", line)
     |> m -> (int(m[1]), int(m[2]), int(m[3]))
)

function move_one(stacks, from, to, count)
    for _ in 1:count
        push!(stacks[to], pop!(stacks[from]))
    end
end

function move_two(stacks, from, to, count)
    append!(stacks[to], last(stacks[from], count))
    len = length(stacks[from])
    deleteat!(stacks[from], len - count + 1:len)
end


function solve(cmds, stacks, move)
    for (count, from, to) in cmds
        move(stacks, from, to, count)
    end
    return stacks .|> pop! |> join
end

const stacks = [
    ['Z', 'N'],
    ['M', 'C', 'D'],
    ['P']
]

println("Parst 1: ", solve(input, deepcopy(stacks), move_one))
println("Parst 2: ", solve(input, deepcopy(stacks), move_two))
