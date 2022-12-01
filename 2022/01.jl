using Pipe

const input = @pipe (ARGS[1]
    |> read(_, String) |> strip |> split(_, "\n\n")
    |> split.(_, "\n")
    |> map.(x -> parse(Int, x), _)
    |> sum.(_)
)

println("Part 1: ", maximum(input))
println("Part 2: ", sum(partialsort(input, 1:3, rev=true)))
