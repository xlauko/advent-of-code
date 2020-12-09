package main

import (
	"fmt"
	"strconv"
	"utils/utils"
)

func valid(nums []int, i int, preamble int) bool {
	from := i - preamble
	for j := from; j < i; j++ {
		for k := j; k < i; k++ {
			if k != j && nums[k]+nums[j] == nums[i] {
				return true
			}
		}
	}
	return false
}

func part1(nums []int, preamble int) (int, int) {
	for i := preamble; i < len(nums); i++ {
		if !valid(nums, i, preamble) {
			return i, nums[i]
		}
	}
	return -1, -1
}

func part2(nums []int, i int, preamble int) int {
	val := nums[i]
	for k := 0; k < i; k++ {
		sum := 0
		j := k
		for sum < val {
			sum += nums[j]
			j++
		}
		if sum == val {
			fmt.Println(k, j, nums[k], nums[j])
			arr := nums[k:j]
			return utils.Min(arr) + utils.Max(arr)
		}
	}
	return -1
}

func main() {
	var nums []int
	utils.ScanLine("big.txt", func(line string) {
		n, _ := strconv.Atoi(line)
		nums = append(nums, n)
	})

	preamble := 25
	idx, val := part1(nums, preamble)
	fmt.Println(idx)
	fmt.Println("Part 1: ", val)
	fmt.Println("Part 2: ", part2(nums, idx, preamble))
}
