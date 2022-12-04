using  DelimitedFiles

int = v -> parse(Int, v)

const input = (readlines(stdin)
    .|> l -> match(r"(\d+)-(\d+),(\d+)-(\d+)", l)
     |> m -> ((int(m[1]), int(m[2])), (int(m[3]), int(m[4])))
)

contains(a, b) = a[1] ≤ b[1] ≤ b[2] ≤ a[2]

overlap(a, b) = a[1] ≤ b[1] ≤ a[2] || a[1] ≤ b[2] ≤ a[2]

solve(input, cmp) = input .|> (m -> cmp(m[1], m[2]) || cmp(m[2], m[1])) |> sum

println("Part 1: ", solve(input, contains))
println("Part 1: ", solve(input, overlap))
