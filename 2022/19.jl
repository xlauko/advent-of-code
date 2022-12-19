int(v) = parse(Int, v)

function parse_line(line)
    ore = match(r"Each ore robot costs (\d+) ore.", line)[1] |> int
    clay = match(r"Each clay robot costs (\d+) ore.", line)[1] |> int
    obs = match(r"Each obsidian robot costs (\d+) ore and (\d+) clay.", line).captures .|> int
    geo = match(r"Each geode robot costs (\d+) ore and (\d+) obsidian.", line).captures .|> int
   return [[ore, 0, 0, 0], [clay, 0, 0, 0], [obs[1], obs[2], 0, 0], [geo[1], 0, geo[2], 0]]
end

const bps = readlines(stdin) .|> parse_line

function quality(bps, robots, resources, time)
    next_resources = resources + robots
    if time == 0
        return resources[4]
    end

    time -= 1
    if all(bps[4] .<= resources)
        return quality(bps, robots + [0, 0, 0, 1], next_resources - bps[4], time)
    end

    if all(bps[3] .<= resources) && robots[3] < bps[4][3]
        return quality(bps, robots +  [0, 0, 1, 0], next_resources - bps[3], time)
    end

    results = [0]
    ores = [bp[1] for bp in bps]
    if any(resources[1] .< ores)
        push!(results, quality(bps, robots, next_resources, time))
    end

    if all(bps[2] .<= resources) && robots[2] < bps[3][2]
        push!(results, quality(bps, robots +  [0, 1, 0, 0], next_resources - bps[2], time))
    end

    if all(bps[1] .<= resources) && any(robots[1] .< ores)
        push!(results, quality(bps, robots +  [1, 0, 0, 0], next_resources - bps[1], time))
    end

    return maximum(results)
end

quality(time) = bps -> quality(bps, [1, 0, 0, 0], [0, 0, 0, 0], time)

@time println("Part 1: ", zip(1:length(bps), bps .|> quality(24)) .|> prod |> sum)
@time println("Part 2: ", bps[1:3] .|> quality(32) |> prod)
