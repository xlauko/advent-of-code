using Base.Iterators

metaeval(str) = Meta.parse(str) |> eval

compare(l::Int, r::Int) = sign(r - l)
compare(l::Int, r::AbstractVector) = compare([l], r)
compare(l::AbstractVector, r::Int) = compare(l, [r])

function compare(l::AbstractVector, r::AbstractVector)
    for (lv, rv) ∈ zip(l, r)
        if (v = compare(lv, rv)) != 0
            return v
        end
    end

    return sign(length(r) - length(l))
end

compare((l, r)) = compare(l, r)

compare((i, (l, r))) = compare(l, r) == 1 ? i : 0

part_one(packets) = enumerate(partition(packets, 2)) .|> compare |> sum

eq(v) = x -> x == v

function part_two(packets)
    sort!(packets, lt= (a, b) -> compare(a, b) == 1)
    return findfirst(eq([[2]]), packets) * findfirst(eq([[6]]), packets)
end

const input = read(stdin, String) |> split .|> metaeval
println("Part 1: ", part_one(input))
println("Part 2: ", part_two([[[[2]], [[6]]]; input]))
