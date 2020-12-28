package main

import (
	"fmt"
	"strconv"
	"strings"
	"utils/utils"
)

func main() {
	seen := make([]int, 1024)
	max := 0
	utils.ScanLine("big.txt", func(line string) {
		replacer := strings.NewReplacer("F", "0", "B", "1", "L", "0", "R", "1")
		id, _ := strconv.ParseInt(replacer.Replace(line), 2, 0)
		seen[id] = 1

		if int(id) > max {
			max = int(id)
		}
	})

	min, _ := utils.FindIf(seen, utils.IsOne)
	place, _ := utils.FindIf(seen[min:max], utils.IsZero)

	fmt.Println("Part 1: ", max)
	fmt.Println("Part 2: ", place+min)
}
