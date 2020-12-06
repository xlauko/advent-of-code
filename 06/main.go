package main

import (
	"fmt"
	"utils/utils"
)

func answers(group []string) []int {
	ans := make([]int, 26)
	for _, line := range group {
		for _, c := range line {
			ans[c-'a']++
		}
	}
	return ans
}

func main() {
	count1, count2 := 0, 0
	utils.ScanGroup("big.txt", func(group []string) {
		ans := answers(group)
		count1 += utils.CountIf(ans, func(a int) bool { return a > 0 })
		count2 += utils.CountIf(ans, func(a int) bool { return a == len(group) })
	})
	fmt.Println("Part 1: ", count1)
	fmt.Println("Part 2: ", count2)
}
