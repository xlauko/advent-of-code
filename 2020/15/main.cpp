#include <array>

constexpr uint32_t size = 30000000;

int main() {
    std::array<uint64_t, size> seen{};
    std::array nums{7,12,1,0,16,2};
    uint64_t i = 1;
    for ( auto n : nums )
        seen[n] = i++;

    uint32_t last = nums.back();
    for (uint32_t i = nums.size() + 1; i <= size; i++ ) {
        uint64_t hist = seen[last];
        uint32_t high = hist >> 32;
        uint32_t low = uint32_t(hist);
        last = high == 0 ? 0 : low - high;
        seen[last] = (uint64_t(seen[last]) << 32) + i;
    }

    return last;
}
