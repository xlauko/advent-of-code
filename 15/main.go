package main

import (
	"fmt"
	"utils/utils"
)

func speak(val int, spoken map[int][]int) int {
	hist := spoken[val]
	if len(hist) == 1 {
		return 0
	}

	return hist[len(hist)-1] - hist[len(hist)-2]
}

func main() {
	nums := utils.ScanNumbers("big.txt", ",")

	spoken := make(map[int][]int)
	for i, n := range nums {
		spoken[n] = append(spoken[n], i+1)
	}

	last := nums[len(nums)-1]
	for i := len(nums) + 1; i <= 30000000; i++ {
		last = speak(last, spoken)
		spoken[last] = append(spoken[last], i)
		if i == 2020 {
			fmt.Println("\nPart 1: ", last)
		}
	}

	fmt.Println("Part 2: ", last)
}
