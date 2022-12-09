int(s) = parse(Int, s)
pairwise(x) = zip(x, last(Iterators.peel(x)))

const data = readlines(stdin) .|> split

const dirs = Dict("U" => (0, 1), "D" => (0, -1), "R" => (1, 0), "L" => (-1, 0))

function update((h, t))
    Δ = h .- t
    if maximum(abs.(Δ)) > 1
        return t .+ clamp.(Δ, -1, 1)
    end
    return t
end

function solve(cmds, len)
    r = fill((0, 0), len)

    pos = Set()
    push!(pos, last(r))

    for cmd in cmds
        for i in 1:int(cmd[2])
            r = [r[1] .+ dirs[cmd[1]]; pairwise(r) .|> update]
            push!(pos, last(r))
        end
    end

    return length(pos) + 1
end

println("Part 1: ", solve(data, 2))
println("Part 2: ", solve(data, 10))
