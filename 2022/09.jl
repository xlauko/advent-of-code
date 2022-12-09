using Distances
using Base.Iterators

int(s) = parse(Int, s)
pairwise(x) = zip(x, x[2:end])

const data = readlines(stdin) .|> split

const dirs = Dict("U" => [0, 1], "D" => [0, -1], "R" => [1, 0], "L" => [-1, 0])

update((h, t)) = chebyshev(h, t) > 1 ? t + sign.(h - t) : t

function solve(cmds, len)
    r = fill([0, 0], len)

    pos = Set()
    push!(pos, last(r))

    for cmd in cmds
        for _ in 1:int(cmd[2])
            r = [[r[1] + dirs[cmd[1]]]; pairwise(r) .|> update]
            push!(pos, last(r))
        end
    end

    return length(pos)
end

println("Part 1: ", solve(data, 2))
println("Part 2: ", solve(data, 10))
