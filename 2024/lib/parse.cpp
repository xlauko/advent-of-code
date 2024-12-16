export module aoc:parse;

import std;

export namespace aoc {

    template< std::integral value_type = std::size_t >
    constexpr value_type parse_number(std::string_view part) noexcept {
        value_type num;
        std::from_chars(part.data(), part.data() + part.size(), num);
        return num;
    }

} // namespace aoc
