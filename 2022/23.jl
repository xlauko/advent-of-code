using DataStructures

element(x)  = v -> v[x]

const quads = [
    [[ 0, -1], [ 1, -1], [-1, -1]],
    [[ 0,  1], [ 1,  1], [-1,  1]],
    [[-1,  0], [-1, -1], [-1,  1]],
    [[ 1,  0], [ 1, -1], [ 1,  1]]
]

const neigh = [[-1, -1], [0, -1], [1, -1], [1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0]]

neighbours(elf, n = neigh) = n .|> dir -> dir + elf

function solve(elves)
    round = 0
    next = Set()

    while elves != next
        if !isempty(next)
            elves = next
            next = Set()
        end

        proposed = Dict()

        for elf in elves
            proposed[elf] = elf
            if !isempty(neighbours(elf) ∩ elves)
                for q in 0:3
                    quad = quads[(q + round) % 4 + 1]
                    if isempty(neighbours(elf, quad) ∩ elves)
                        proposed[elf] = elf + quad[1]
                        break
                    end
                end
            end
        end

        count = counter(values(proposed))
        move = elf -> count[proposed[elf]] == 1 ? proposed[elf] : elf

        next = Set(elves .|> move)

        if round == 10
            cols = elves .|> element(1)
            rows = elves .|> element(2)
            println("Part 1: ", (maximum(cols) - minimum(cols) + 1) * (maximum(rows) - minimum(rows) + 1) - length(elves))
        end

        round += 1
    end
    return round
end

elves = Set([[col, row]
    for (row, line) ∈ enumerate(readlines(stdin)) for (col, char) ∈ enumerate(line) if char == '#'
])

println("Part 2: ", solve(elves))
