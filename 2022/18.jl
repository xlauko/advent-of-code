mapby(f) = s -> map(f, s)
countby(f) = s -> count(f, s)
filterby(f) = s -> filter(f, s)
splitby(sep) = s -> split(s, sep)
int(v) = parse(Int, v)
ci(x, y, z)  = CartesianIndex((x, y, z))

const one   = ci(1, 1, 1)
const cubes = readlines(stdin) .|> splitby(",") .|> mapby(int) |> mapby(v -> ci(v...) + ci(2, 2, 2))

const cave  = zeros(Int, Tuple(maximum(cubes) + one))
cave[cubes] .= 1


const dirs = [ci(1, 0, 0), ci(-1, 0, 0), ci(0, 1, 0), ci(0, -1, 0), ci(0, 0, 1), ci(0, 0, -1)]
neigh_indices(idx) = dirs .|> dir -> idx + dir
neigh(idx) = cave[neigh_indices(idx)]

function fill_cave(idx)
    queue = [idx]
    seen = Set()
    push!(seen, idx)
    while !isempty(queue)
        pos = popfirst!(queue)
        if checkbounds(Bool, cave, pos) && cave[pos] == 0
            cave[pos] = 2
            for n ∈ neigh_indices(pos) |> filterby(v -> v ∉ seen)
                push!(queue, n)
                push!(seen, n)
            end
        end
    end
end

fill_cave(one)

println("Part 1: ", cubes .|> neigh .|> countby(v -> v == 0 || v == 2) |> sum)
println("Part 2: ", cubes .|> neigh .|> countby(v -> v == 2) |> sum)
