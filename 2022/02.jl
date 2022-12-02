using Mods

parse_one(c, base) = Mod{3}(c[1] - base)
parse(p) = parse_one(p[1], 'A'), parse_one(p[2], 'X')

const input = readlines(stdin) .|> split .|> parse

play(a, b) = value(b - a + 1) * 3 + value(b) + 1
solve(plays, convert) = sum(plays .|> p -> play(p[1], convert(p[1], p[2])))

println("Part 1: ", solve(input, (a, x) -> x))
println("Part 2: ", solve(input, (a, x) -> a + 2 + x))
