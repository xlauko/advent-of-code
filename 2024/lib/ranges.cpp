export module aoc:ranges;

import std;

export namespace aoc::views {

    struct split_to_string_views_fn {
        const char delimiter;

        constexpr auto operator()(std::string_view input) const noexcept {
            return input | std::views::split(delimiter) | std::views::transform([](auto&& subrange) noexcept {
                return std::string_view(&*subrange.begin(), subrange.size());
            });
        }

        template<std::ranges::range range_t>
        friend constexpr auto operator|(range_t&& range, const split_to_string_views_fn& splitter) noexcept {
            return splitter(std::forward<range_t>(range));
        }
    };

    constexpr auto split_to_string_views(char delimiter) noexcept {
       return split_to_string_views_fn{delimiter};
    }

} // namespace aoc::views
