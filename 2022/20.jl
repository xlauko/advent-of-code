int(v) = parse(Int, v)
const data = readlines(stdin) .|> int

index(v, c) = findfirst(x -> x == v, c)

function decrypt(data, repeat=1)
    len = length(data)
    indices = collect(1:len)
    for _ in 1:repeat
        for (i, n) in enumerate(data)
            pos = index(i, indices)
            idx = mod1((pos + n), len - 1)
            deleteat!(indices, pos)
            idx == 1 ? append!(indices, i) : insert!(indices, idx, i)
        end
    end

    zero = index(index(0, data), indices)
    coord = (offset) -> data[indices[mod1(zero + offset, len)]]
    return [1000, 2000, 3000] .|> coord |> sum
end

println("Part 1: ", decrypt(data))
println("Part 2: ", decrypt(map(v -> v * 811589153, data), 10))
