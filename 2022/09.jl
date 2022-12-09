int(s) = parse(Int, s)

const data = readlines(stdin) .|> split

const dirs = Dict("U" => (0, 1), "D" => (0, -1), "R" => (1, 0), "L" => (-1, 0))

function update(h, t)
    Δ = h .- t
    if maximum(abs.(Δ)) > 1 || sum(abs.(Δ)) > 2
        return t .+ clamp.(Δ, -1, 1)
    end
    return t
end

function solve(cmds, len)
    h = (0, 0)
    t = fill((0, 0), len)

    pos = Set()
    push!(pos, last(t))

    for cmd in cmds
        for i in 1:int(cmd[2])
            h = h .+ dirs[cmd[1]]
            t[1] = update(h, t[1])
            for i in 2:len
                t[i] = update(t[i - 1], t[i])
            end
            push!(pos, last(t))
        end
    end

    return length(pos)
end

println("Part 1: ", solve(data, 1))
println("Part 2: ", solve(data, 9))
