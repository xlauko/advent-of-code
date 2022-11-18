using Match

parse_input(path::String) = strip(read(joinpath(@__DIR__, path), String))

function move(dir, pos)
    @match dir begin
        '>' => [pos[1], pos[2] + 1]
        '<' => [pos[1], pos[2] - 1]
        '^' => [pos[1] + 1, pos[2]]
        'v' => [pos[1] - 1, pos[2]]
    end
end

function simulate(path::AbstractString)
    seen = Set()
    pos = [0, 0]
    push!(seen, pos)

    for dir in path
        pos = move(dir, pos)
        if pos ∉ seen
            push!(seen, pos)
        end
    end
    return seen
end

function part_one(path::AbstractString = "big.txt", data = parse_input(path))
    return length(simulate(data))
end

function part_two(path::AbstractString = "big.txt", data = parse_input(path))
    santa = simulate(data[begin:2:end])
    robot = simulate(data[begin + 1:2:end])
    return length(union!(santa, robot))
end

println("part 1S: ", part_one("small.txt"))
println("part 1B: ", part_one())
println("part 2S: ", part_two("small.txt"))
println("part 2B: ", part_two())
