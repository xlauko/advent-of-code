using DataStructures

const input = readlines(stdin)

function build(input)
    dirs = DefaultDict(0)
    curr = "/"
    for line in input
        chunks = line |> split
        if startswith(line, "\$ cd")
            curr = joinpath(curr, chunks[3]) |> normpath
        elseif (size = tryparse(Int, chunks[1])) !== nothing
            path = curr
            while path != "/"
                dirs[path] += size
                path = splitdir(path)[1]
            end
            dirs["/"] += size
        end
    end

    return dirs
end

dirs = build(input)

required = 30000000 - (70000000 - dirs["/"])

is_small = dir -> dir[2] <= 100000
is_large = dir -> dir[2] >= required

println("Part 1: ", values(filter(is_small, dirs)) |> sum)
println("Parst 2: ", values(filter(is_large, dirs)) |> minimum)
