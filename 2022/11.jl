using DataStructures

mutable struct Monkey items; op; cond; test end

byline = block -> split(block, "\n")
int    = v -> parse(Int, v)

move!(v) = splice!(v, firstindex(v):lastindex(v))

function parse_monkey(chunk)
    items = split(chunk[2], (':', ','))[2:end] .|> int

    op   = @eval old -> $(Meta.parse(split(chunk[3], "=")[2]))

    cond = match(r"Test: divisible by (\d+)", chunk[4])[1] |> int
    tres = match(r"If true: throw to monkey (\d+)", chunk[5])[1] |> int
    fres = match(r"If false: throw to monkey (\d+)", chunk[6])[1] |> int
    test = v -> (v % cond == 0 ? tres : fres) + 1
    return Monkey(items, op, cond, test)
end

function solve(monkeys, rounds, relief)
    inspect = DefaultDict(0)

    LCM = lcm(monkeys .|> m -> m.cond)

    for round in 1:rounds
        for m in monkeys
            inspect[m] += length(m.items)
            for item in move!(m.items)
                worry = m.op(item) % LCM
                if relief
                    worry = worry  ÷ 3
                end
                append!(monkeys[m.test(worry)].items, worry)
            end
        end
    end

    return prod(partialsort(inspect |> values |> collect, 1:2, rev=true))
end

monkeys = split(read(stdin, String), "\n\n") .|> byline .|> parse_monkey

println("Part 1: ", solve(monkeys |> deepcopy, 20, true))
println("Part 2: ", solve(monkeys, 10000, false))
