using DataStructures

reduceby(f) = x -> reduce(f, x)
filterby(f) = x -> filter(f, x)
filteroob(m) = filterby(v -> checkbounds(Bool, m, v))

function neighbours(pos, hmap)
    diff = ((-1, 0), (1, 0), (0, 1), (0, -1))

    inonestep(v) = hmap[v] <= hmap[pos] + 1

    return ([pos + CartesianIndex(d) for d in diff]
        |> filteroob(hmap)
        |> filterby(inonestep)
    )
end

function bfs(hmap, s, e)
    queue = s
    dist = DefaultDict(-1)

    for pos in s
        dist[pos] = 0
    end

    while !isempty(queue)
        pos = popfirst!(queue)
        d = dist[pos]

        if pos == e return d end

        for n in neighbours(pos, hmap)
            if dist[n] == -1
                dist[n] = d + 1
                push!(queue, n)
            end
        end
    end
end

const hmap = stdin |> eachline .|> collect |> reduceby(hcat)

const S = findfirst(v -> v == 'S', hmap)
const E = findfirst(v -> v == 'E', hmap)

hmap[S] = 'a'
hmap[E] = 'z'

println("Part 1: ", bfs(hmap, [S], E))
println("Part 2: ", bfs(hmap, findall(v -> v == 'a', hmap), E))
