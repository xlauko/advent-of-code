# --- Day 5: Doesn't He Have Intern-Elves For This? --- Santa needs help
# figuring out which strings in his text file are naughty or nice.

# A nice string is one with all of the following properties:

# It contains at least three vowels (aeiou only), like aei, xazegov, or
# aeiouaeiouaeiou.

# It contains at least one letter that appears twice in a row,
# like xx, abcdde (dd), or aabbccdd (aa, bb, cc, or dd).

# It does not contain
# the strings ab, cd, pq, or xy, even if they are part of one of the other
# requirements.  For example:

# ugknbfddgicrmopn is nice because it has at least three vowels (u...i...o...),
# a double letter (...dd...), and none of the disallowed substrings.

# aaa is nice because it has at least three vowels and a double letter, even
# though the letters used by different rules overlap.

# jchzalrnumimnmhp is naughty because it has no double letter.

# haegwjzuvuyypxyu is naughty because it contains the string xy.

# dvszwmarrgswjxmb is naughty because it contains only one vowel.

# How many strings are nice?

using DelimitedFiles

import Base: filter

filter(f::Function)::Function = x -> filter(f, x)

vowel_rule(word) = count(c -> (c ∈ "aeiou"), word) >= 3

function twinchar_rule(word::AbstractString)
    for i = 2:lastindex(word)
        word[i - 1] == word[i] && return true
    end
    return false
end

function forbidden_rule(word::AbstractString)
    forbidden = ["ab", "cd", "pq", "xy"]
    for sub in forbidden
        occursin(sub, word) && return false
    end
    return true
end

function part_one(path::AbstractString = "big.txt", words = readlines(path))
    return words |> filter(vowel_rule) |> filter(twinchar_rule) |> filter(forbidden_rule) |> length
end

function repeat_rule(word::AbstractString)
    for i = 2:lastindex(word)
        for j = i + 2:lastindex(word)
            word[i-1] == word[j-1] && word[i] == word[j] && return true
        end
    end
    return false
end

function skip_rule(word::AbstractString)
    for i = 3:lastindex(word)
        word[i-2] == word[i] && return true
    end
    return false
end

function part_two(path::AbstractString = "big.txt", words = readlines(path))
    return words |> filter(repeat_rule) |> filter(skip_rule) |> length
end

println("part 1S: ", part_one("small.txt"))
println("part 1B: ", part_one())
println("part 2S: ", part_two("small.txt"))
println("part 2B: ", part_two())
