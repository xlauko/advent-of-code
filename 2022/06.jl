const input = read(stdin, String)

function solve(data, len)
    for i in 1:length(data)
        part = Set(data[i:i + len - 1])
        if length(part) == len
            return i + len - 1
        end
    end
end

println("Parst 1: ", solve(input, 4))
println("Parst 2: ", solve(input, 14))
