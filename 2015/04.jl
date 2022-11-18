using MD5

parse_input(path::String) = strip(read(joinpath(@__DIR__, path), String))

function solve(input::AbstractString, ndigits::Int)
    number = 1
    compare = lpad(0, ndigits, "0")
    while true
        if bytes2hex(md5(input * string(number)))[1:ndigits] == compare
            return number
        end
        number += 1
    end
end

part_one(path::AbstractString = "big.txt", data = parse_input(path)) = solve(rstrip(data), 5)
part_two(path::AbstractString = "big.txt", data = parse_input(path)) = solve(rstrip(data), 6)

println("part 1B: ", part_one())
println("part 2B: ", part_two())
