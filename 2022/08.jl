using IterTools

int(s) = parse(Int, s)
mapby(f) = x -> map(f, x)
reduceby(f) = x -> reduce(f, x)

fall(f) = x -> all(f, x)

const hmap = stdin |> eachline .|> collect .|> mapby(int) |> reduceby(hcat)
const (rows, cols) = size(hmap)

dirs(row, col) = [
    reverse(hmap[row, 1:col - 1]),
    hmap[row, col + 1:cols],
    reverse(hmap[1:row - 1, col]),
    hmap[row + 1:rows, col]
]

visible((row, col)) = any(fall(<(hmap[row, col])), dirs(row, col))

function score((row, col))
    count_trees(line) = (smaller = findfirst(>=(hmap[row, col]), line)) === nothing ? length(line) : smaller
    prod(map(count_trees, dirs(row, col)))
end

println("Part 1: ", product(1:rows, 1:cols) .|> visible |> sum)
println("Part 2: ", product(2:rows - 1, 2:cols - 1) .|> score |> maximum)
