module;

#include <cstdint>

export module aoc:functional;

import std;

export namespace aoc
{
    inline constexpr auto add = std::plus<>{};
    inline constexpr auto sub = std::minus<>{};
    inline constexpr auto mul = std::multiplies<>{};
    inline constexpr auto div = std::divides<>{};
    inline constexpr auto mod = std::modulus<>{};

    inline constexpr auto eq = std::equal_to<>{};
    inline constexpr auto ne = std::not_equal_to<>{};
    inline constexpr auto lt = std::less<>{};
    inline constexpr auto le = std::less_equal<>{};
    inline constexpr auto gt = std::greater<>{};
    inline constexpr auto ge = std::greater_equal<>{};

    inline constexpr auto land = std::logical_and<>{};
    inline constexpr auto lor  = std::logical_or<>{};
    inline constexpr auto lnot = std::logical_not<>{};

    inline constexpr auto band = std::bit_and<>{};
    inline constexpr auto bor  = std::bit_or<>{};
    inline constexpr auto bxor = std::bit_xor<>{};
    inline constexpr auto bnot = std::bit_not<>{};

    inline constexpr auto id = std::identity{};

    constexpr size_t concat(size_t a, size_t b) noexcept{
        size_t multiplier = 1;
        while (b >= multiplier) {
            multiplier *= 10;
        }
        return a * multiplier + b;
    }

} // namespace aoc
