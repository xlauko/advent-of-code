using Mods

const input = readlines(stdin) .|> split

parse_one(c, base) = Mod{3}(Int(c[1]) - Int(base))
parse(p) = parse_one(p[1], 'A'), parse_one(p[2], 'X')

play(a, b) = value(b - a + 1) * 3 + value(b) + 1
solve(plays, convert) = sum((plays .|> parse) .|> p -> play(p[1], convert(p[1], p[2])))

println("Part 1: ", solve(input, (a, x) -> x))
println("Part 2: ", solve(input, (a, x) -> a + 2 + x))
