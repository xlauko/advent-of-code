using Distances

int(v) = parse(Int, v)
captures(rgx) = str -> match(rgx, str).captures .|> int
mapby(f) = s -> map(f, s)
element(x)  = v -> v[x]

const input = (readlines(stdin)
    .|> captures(r"Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)")
)

function part_one(lines, target)
    low  = maximum(lines .|> element(3))
    high = minimum(lines .|> element(3))
    for (sx, sy, bx, by) in lines
        d  = cityblock((sx, sy), (bx, by))
        dx = d - abs(target - sy)
        if  dx > 0
            low  = min(low, sx - dx)
            high = max(high, sx + dx)
        end
    end
    return high - low
end

diamond(p, d, sx, sy) = [
    ( sx - d - 1 + p, sy - p ),
    ( sx + d + 1 - p, sy - p ),
    ( sx - d - 1 + p, sy + p ),
    ( sx + d + 1 - p, sy + p )
]

function test(dx, dy, lines)
    for (sx, sy, bx, by) in lines
        if cityblock((dx, dy), (sx, sy)) <= cityblock((sx, sy), (bx, by))
            return false
        end
    end
    return true
end

function part_two(lines)
    min, max = 0, 4000000
    for (sx, sy, bx, by) in lines
        d  = cityblock((sx, sy), (bx, by))
        for p in 1:d
            for (dx, dy) in diamond(p, d, sx, sy)
                if min ≤ dx ≤ max && min ≤ dy ≤ max && test(dx, dy, lines)
                    return dx * max + dy
                end
            end
        end
    end
end

println("Part 1: ", part_one(input, 2000000))
println("Part 2: ", part_two(input))
