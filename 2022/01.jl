using Pipe

int(v) = parse(Int, v)
const input = (@pipe split(read(stdin, String), "\n\n") .|> split |> map.(int, _) ) .|> sum

println("Part 1: ", maximum(input))
println("Part 2: ", sum(partialsort(input, 1:3, rev=true)))
