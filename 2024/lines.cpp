module;

export module aoc:lines;

import std;

import :generator;

namespace aoc {

    export auto read_lines(const std::filesystem::path &file_path)
        -> aoc::generator< std::string >
    {
        std::string line;
        std::ifstream in(file_path);
        while (std::getline(in, line)) {
            co_yield line;
        }
    }

} // namespace aoc
