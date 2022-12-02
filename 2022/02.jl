using Match

const input = readlines(stdin) .|> split

value(c, base) = Int(c[1]) - Int(base)

function score(a, b)
    if a == b
        return 3
    elseif ((a + 1) % 3) == b
        return 6
    end
    return 0
end

play(a, b) = score(a, b) + b + 1

function solve(plays, convert)
    s = 0
    for p in plays
        a, b = value(p[1], 'A'), value(p[2], 'X')
        s += play(a, convert(a, b))
    end
    return s
end

println("Part 1: ", solve(input, (a, x) -> x))
println("Part 2: ", solve(input, (a, x) -> (a + 2 + x) % 3))
