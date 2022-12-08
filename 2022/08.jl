using IterTools

function string_block_to_matrix(input)
    as_arrays = split.(split(input, "\n"), "")
    as_int_arrays = [parse.(Int, array) for array in as_arrays]
    Matrix(transpose(hcat(as_int_arrays...)))
end

const hmap = string_block_to_matrix(read(stdin, String))
const (rows, cols) = size(hmap)

dirs(row, col) = [
    reverse(hmap[row, 1:col - 1]),
    hmap[row, col + 1:cols],
    reverse(hmap[1:row - 1, col]),
    hmap[row + 1:rows, col]
]

visible((row, col)) = any(line -> all(<(hmap[row, col]), line), dirs(row, col))

function score((row, col))
    count_trees(line) = (smaller = findfirst(>=(hmap[row, col]), line)) === nothing ? length(line) : smaller
    prod(map(count_trees, dirs(row, col)))
end

println("Part 1: ", product(1:rows, 1:cols) .|> visible |> sum)
println("Part 2: ", product(2:rows - 1, 2:cols - 1) .|> score |> maximum)
