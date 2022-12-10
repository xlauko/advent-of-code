using Match

int(s) = parse(Int, s)

const input = readlines(stdin) .|> split

pixel(T, X) = ((T - 1) % 40) in X - 1:X + 1 ? '#' : ' '

function solve(cmds, cycles)
    PC = 1; X = 1; M = nothing
    result = 0

    for T in 1:cycles + 1
        print(pixel(T, X))
        if (T - 1) % 40 == 39
            print("\n")
        end

        if T in [20, 60, 100, 140, 180, 220] result += T * X end

        if M !== nothing
            X, M = M + X, nothing
        else
            cmd = cmds[PC]
            @match cmd[1] begin
                "noop" => nothing
                "addx" => (M = int(cmd[2]))
            end
            PC += 1
        end
    end
    return result
end

println("\nPart 1: ", solve(input, 220))
