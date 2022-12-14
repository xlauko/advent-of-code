splitby(sep) = s -> split(s, sep)
mapby(f) = s -> map(f, s)
int(v) = parse(Int, v)
pairwise(x) = zip(x, x[2:end])
element(x)  = v -> v[x]

const input = (readlines(stdin)
    .|> splitby("->")
    .|> mapby(splitby(","))
    .|> mapby(mapby(int))
)

range((f, t)) = f == t ? Iterators.repeated(f) : f:t

function add_line(cave, (ax, ay), (bx, by))
    union!(cave, zip(range(sort([ax, bx])), range(sort([ay, by]))))
end

function make_cave(lines)
    cave = Set()
    for line ∈ lines
        for (a, b) ∈ pairwise(line)
            add_line(cave, a, b)
        end
    end
    return cave
end

cave  = make_cave(input)
floor = cave .|> element(2) |> maximum
const source = (500, 0)

function step(cave, unit)
    for dir ∈ [(0, 1), (-1, 1), (1, 1), (0, 0)]
        next = unit .+ dir
        if next ∉ cave
            return next
        end
    end
end

function simulate(cave, stop)
    rocks = length(cave)
    unit = source
    while !stop(unit, cave)
        next = step(cave, unit)
        if next == unit
            push!(cave, unit)
            unit = source
        else
            unit = next
        end
    end
    return length(cave) - rocks
end

println("Part 1: ", simulate(cave |> deepcopy, (unit, cave) -> unit[2] > floor))

floor = floor + 2
union!(cave, zip(range([500 - floor, 500 + floor]), range([floor, floor])))
println("Part 2: ", simulate(cave, (unit, cave) -> source ∈ cave))
