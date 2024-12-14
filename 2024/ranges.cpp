export module aoc:ranges;

import std;

export namespace aoc {

    template< std::ranges::range R >
    using iterator_t = decltype(std::begin(std::declval< R& >()));

    template< std::ranges::range R >
    using range_value_t = std::iter_value_t< iterator_t< R > >;

    template< typename T >
    concept has_reserve = requires(T t, std::size_t s) { t.reserve(s); };

    template< typename container_t, std::ranges::input_range R >
    void move_or_copy_elements(R&& rng, container_t& container) {
        if constexpr (std::is_rvalue_reference_v< decltype(rng) >) {
            std::ranges::move(rng, std::back_inserter(container));
        } else {
            std::ranges::copy(rng, std::back_inserter(container));
        }
    }

    template< template< typename... > class container_t >
    struct to_fn {
        template< std::ranges::input_range R >
        auto operator()(R&& range) const {
            using value_type         = std::ranges::range_value_t< R >;
            using result_container_t = container_t< value_type >;

            result_container_t container;

            if constexpr (has_reserve< result_container_t >) {
                if constexpr (requires { std::ranges::size(range); }) {
                    container.reserve(std::ranges::size(range));
                }
            }

            move_or_copy_elements(std::forward< R >(range), container);
            return container;
        }

        template< std::ranges::input_range R >
        friend auto operator|(R&& range, const to_fn& to) {
            return to(std::forward< R >(range));
        }
    };

    template< template< typename... > class container_t >
    inline constexpr to_fn< container_t > to{};

    template< template< typename... > class container_t, std::ranges::input_range R >
    auto operator|(R&& range, to_fn< container_t > const& to) {
        return to(std::forward< R >(range));
    }

} // namespace aoc
