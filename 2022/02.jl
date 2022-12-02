using Mods

const input = readlines(stdin) .|> split

parse(c, base) = Mod{3}(Int(c[1]) - Int(base))

play(a, b) = value(b - a + 1) * 3 + value(b) + 1

function solve(plays, convert)
    s = 0
    for p in plays
        a, b = parse(p[1], 'A'), parse(p[2], 'X')
        s += play(a, convert(a, b))
    end
    return s
end

println("Part 1: ", solve(input, (a, x) -> x))
println("Part 2: ", solve(input, (a, x) -> a + 2 + x))
