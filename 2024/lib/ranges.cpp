export module aoc:ranges;

import std;

import :parse;

export namespace aoc::views {

    struct split_to_string_views_fn : std::ranges::range_adaptor_closure< split_to_string_views_fn > {
        const char delimiter;

        explicit split_to_string_views_fn(char delimiter) noexcept : delimiter(delimiter) {}

        constexpr auto operator()(std::string_view input) const noexcept {
            return input | std::views::split(delimiter) | std::views::transform([](auto&& subrange) noexcept {
                return std::string_view(&*subrange.begin(), subrange.size());
            });
        }
    };

    constexpr auto split_to_string_views(char delimiter) noexcept {
       return split_to_string_views_fn(delimiter);
    }

} // namespace aoc::views
