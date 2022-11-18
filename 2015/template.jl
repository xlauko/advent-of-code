using DelimitedFiles

parse_input(path::AbstractString) = readdlm(path, 'x', Int, '\n')

function part_one(path::AbstractString = "big.txt", data = parse_input(path))
    return 0
end

function part_two(path::AbstractString = "big.txt", data = parse_input(path))
    return 0
end

println("part 1S: ", part_one("small.txt"))
println("part 1B: ", part_one())
println("part 2S: ", part_two("small.txt"))
println("part 2B: ", part_two())
