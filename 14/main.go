package main

import (
	"fmt"
	"strconv"
	"strings"
	"utils/utils"
)

func parseMask(str string) map[int]bool {
	mask := make(map[int]bool)

	for i, c := range str {
		if c != 'X' {
			mask[35-i] = c == '1'
		}
	}
	return mask
}

func parseValue(str string) int {
	i, _ := strconv.Atoi(str)
	return i
}

func parseIndex(str string) int {
	str = strings.TrimLeft(str, "mem[")
	str = strings.TrimRight(str, "]")
	return parseValue(str)
}

func getBit(n int, pos int) int {
	return n & (1 << pos)
}

func setBit(n int, pos int) int {
	n |= (1 << pos)
	return n
}

func clearBit(n int, pos int) int {
	mask := ^(1 << pos)
	n &= mask
	return n
}

func applyMask(n int, mask map[int]bool) int {
	for i, v := range mask {
		if v {
			n = setBit(n, i)
		} else {
			n = clearBit(n, i)
		}
	}
	return n
}

func masked(n int, mask string, idx int) []int {
	if idx == 36 {
		return []int{0}
	}
	masks := masked(n, mask, idx+1)
	var res []int
	for _, m := range masks {
		switch mask[35-idx] {
		case '0':
			res = append(res, m|getBit(n, idx))
			break
		case '1':
			res = append(res, setBit(m, idx))
			break
		case 'X':
			res = append(res, m)
			res = append(res, setBit(m, idx))
		}
	}
	return res
}

func sum(mem map[int]int) int {
	res := 0
	for _, val := range mem {
		res += val
	}
	return res
}

func part1(lines []string) int {
	mem := make(map[int]int)
	var mask map[int]bool

	for _, line := range lines {
		split := strings.Split(line, " = ")
		if strings.TrimSpace(split[0]) == "mask" {
			mask = parseMask(split[1])
		} else {
			idx := parseIndex(split[0])
			val := parseValue(split[1])
			mem[idx] = applyMask(val, mask)
		}
	}
	return sum(mem)
}

func part2(lines []string) int {
	mem := make(map[int]int)
	var mask string

	for _, line := range lines {
		split := strings.Split(line, " = ")
		if strings.TrimSpace(split[0]) == "mask" {
			mask = split[1]
		} else {
			idx := parseIndex(split[0])
			val := parseValue(split[1])
			for _, i := range masked(idx, mask, 0) {
				mem[i] = val
			}
		}
	}
	return sum(mem)
}

func main() {
	lines := utils.Lines("big.txt")
	fmt.Println("Part 1: ", part1(lines))
	fmt.Println("Part 2: ", part2(lines))
}
