get_floor(data) = count(==('('), data) - count(==(')'), data)

read_one_line(path::String) = strip(read(joinpath(@__DIR__, path), String))

part_one(data = read_one_line("big.txt")) = get_floor(data)

function part_two(data = read_one_line("big.txt"))
    lvl = 0
    for (idx,char) in enumerate(data)
        lvl += char == '(' ? 1 : -1
        lvl < 0 && return idx
    end
end

println(part_one())
println(part_two())
