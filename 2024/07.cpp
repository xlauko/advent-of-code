#include <cstdint>

import std;
import aoc;

std::tuple< size_t, std::vector< size_t > > parse(std::string_view line) {
    auto colon = line.find(':');
    size_t result = aoc::parse_number<>(line.substr(0, colon));

    auto nums = line.substr(colon + 2)
        | aoc::views::split_to_string_views(' ')
        | std::views::transform(aoc::parse_number<>)
        | std::ranges::to< std::vector >();

    return { result, nums };
}

bool achievable(size_t acc, std::span<size_t> ns, size_t exp, auto... ops) {
    if (ns.empty()) {
        return acc == exp;
    }

    auto head = ns[0];
    auto tail = ns.subspan(1);

    return (... || achievable(ops(acc, head), tail, exp, ops...));
}

size_t solve(std::ranges::range auto const& nums, auto... ops) {
    return std::ranges::fold_left(nums, size_t{0}, [&](size_t acc, auto const& pair) {
        auto [exp, ns] = pair;
        return acc + (achievable(0, ns, exp, ops...) ? exp : 0);
    });
}

int main(int /* argc */, char **argv) {
    auto ns = aoc::read_lines(argv[1]) | std::views::transform(parse) | std::ranges::to< std::vector >();
    std::println("Part 1: {}", solve(ns, aoc::add, aoc::mul));
    std::println("Part 2: {}", solve(ns, aoc::add, aoc::mul, aoc::concat));
}
