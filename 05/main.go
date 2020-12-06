package main

import (
	"fmt"
	"strconv"
	"strings"
	"utils/utils"
)

func main() {
	var seen [1024]int
	min, max := len(seen), 0
	utils.ScanLine("big.txt", func(line string) {
		replacer := strings.NewReplacer("F", "0", "B", "1", "L", "0", "R", "1")
		id, _ := strconv.ParseInt(replacer.Replace(line), 2, 0)

		if int(id) < min {
			min = int(id)
		}

		if int(id) > max {
			max = int(id)
		}
		seen[id] = 1
	})

	place, _ := utils.FindIf(seen[min:max], func(val int) bool { return val == 0 })

	fmt.Println("Part 1: ", max)
	fmt.Println("Part 2: ", place+min)
}
