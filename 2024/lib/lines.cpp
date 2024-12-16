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

    export auto text(const std::filesystem::path &file_path)
        -> std::string
    {
        std::ifstream in(file_path);
        return std::string(
            std::istreambuf_iterator< char >(in),
            std::istreambuf_iterator< char >()
        );
    }

} // namespace aoc
