import Base.show, Base.string

using DelimitedFiles
using Match

struct Coordinate
    row::Int
    col::Int
end

function string(coord::Coordinate)
    "$(string(coord.row)), $(string(coord.col))"
end

function show(io::IO, coord::Coordinate)
    println(io, string(coord))
end

struct Command
    kind::AbstractString
    a::Coordinate
    b::Coordinate
end

function string(cmd::Command)
    "$(string(cmd.kind)) : $(string(cmd.a)) -> $(string(cmd.b))"
end

function show(io::IO, cmd::Command)
    println(io, string(cmd))
end

# turn on 0,0 through 999,999

function Command(line::AbstractString)
    matched = match(r"(.*?) (\d+),(\d+) through (\d+),(\d+)", line)
    a = Coordinate(parse(Int, matched[2]), parse(Int, matched[3]))
    b = Coordinate(parse(Int, matched[4]), parse(Int, matched[5]))
    Command(matched[1], a, b)
end

function parse_input(path::AbstractString)
    return [Command(line) for line in readlines(path)]
end

function part_one(path::AbstractString = "big.txt", cmds = parse_input(path))
    grid = zeros(Bool, 1000, 1000)
    for cmd in cmds
        a, b = cmd.a, cmd.b
        row = a.row + 1:b.row + 1
        col = a.col + 1:b.col + 1
        @match cmd.kind begin
            "turn on"  => (grid[row, col] .= true)
            "turn off" => (grid[row, col] .= false)
            "toggle"   => (grid[row, col] .= .!grid[row, col])
        end
    end
    return sum(grid)
end

function part_two(path::AbstractString = "big.txt", cmds = parse_input(path))
    grid = zeros(Int, 1000, 1000)
    for cmd in cmds
        a, b = cmd.a, cmd.b
        row = a.row + 1:b.row + 1
        col = a.col + 1:b.col + 1
        @match cmd.kind begin
            "turn on"  => (grid[row, col] .+= 1)
            "turn off" => (
                grid[row, col] .-= 1,
                grid[grid .== -1] .= 0
            )
            "toggle"   => (grid[row, col] .+= 2)
        end
    end
    return sum(grid)
end

println("part 1S: ", part_one("small.txt"))
println("part 1B: ", part_one())
println("part 2S: ", part_two("small.txt"))
println("part 2B: ", part_two())
