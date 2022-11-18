using DelimitedFiles
using Base.Sort

parse_input(path::AbstractString) = readdlm(joinpath(@__DIR__, path), 'x', Int, '\n')

paper_dims(dims::AbstractArray) = dims .* circshift(dims, -1)

paper_size(dims::AbstractArray) = (paper_dims(dims) .* 2 |> sum) + minimum(paper_dims(dims))

function smallestn(a, n)
    sort(a; alg = Sort.PartialQuickSort(n))[1:n]
end

function part_one(path::AbstractString = "big.txt", data = parse_input(path))
    return map(paper_size, eachrow(data)) |> sum
end

ribbon_lenght(dims::AbstractArray) = (smallestn(dims, 2) .* 2 |> sum) + prod(dims)

function part_two(path::AbstractString = "big.txt", data = parse_input(path))
    return map(ribbon_lenght, eachrow(data)) |> sum
end

println("part 1S: ", part_one("small.txt"))
println("part 1B: ", part_one("big.txt"))
println("part 2S: ", part_two("small.txt"))
println("part 2B: ", part_two("big.txt"))
