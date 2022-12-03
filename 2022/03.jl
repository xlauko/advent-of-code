using Base.Iterators

const input = readlines(stdin)

value(v) = islowercase(v) ?  v - 'a' + 1 : v - 'A' + 27

function part_one(pack)
    mid = div(length(pack), 2)
    sum(value, Set(pack[1:mid]) ∩ Set(pack[mid+1:end]))
end

function part_two(pack)
    sum(value, mapreduce(Set, ∩, pack))
end

println("part 1: ", input .|> part_one |> sum)
println("part 2: ", partition(input, 3) .|> part_two |> sum)
