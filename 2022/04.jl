using  DelimitedFiles

const input = (readlines(stdin)
    .|> l -> match(r"(\d+)-(\d+),(\d+)-(\d+)", l)
     |> m -> ((m[1], m[2]), (m[3], m[4]))
)

contains(a, b) = a[1] ≤ b[1] ≤ b[2] ≤ a[2]

overlap(a, b) = a[1] ≤ b[1] ≤ a[2] || a[1] ≤ b[2] ≤ a[2]

solve(input, cmp) = input .|> (m -> cmp(m[1], m[2]) || cmp(m[2], m[1])) |> sum

println("Part 1: ", solve(input, contains))
println("Part 1: ", solve(input, overlap))
