using Distances

int(s) = parse(Int, s)
pairwise(x) = zip(x, x[2:end])

const data = readlines(stdin) .|> split
const dirs = Dict("U" => [0, 1], "D" => [0, -1], "R" => [1, 0], "L" => [-1, 0])

update((h, t)) = chebyshev(h, t) > 1 ? t + sign.(h - t) : t

function solve(cmds, len)
    r = fill([0, 0], len)

    pos = Set()
    push!(pos, last(r))

    for (dir, step) in cmds, _ in 1:int(step)
        r = [[r[1] + dirs[dir]]; pairwise(r) .|> update]
        push!(pos, last(r))
    end

    return length(pos)
end

println("Part 1: ", solve(data, 2))
println("Part 2: ", solve(data, 10))
