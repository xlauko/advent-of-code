package main

import (
	"fmt"
	"sort"
	"strconv"
	"utils/utils"
)

func arrangements(adaps []int) int {
	tab := map[int]int{0: 1}
	for _, adap := range adaps {
		if val, ok := tab[adap-1]; ok {
			tab[adap] += val
		}
		if val, ok := tab[adap-2]; ok {
			tab[adap] += val
		}
		if val, ok := tab[adap-3]; ok {
			tab[adap] += val
		}
	}
	return tab[adaps[len(adaps)-1]]
}

func jolts(adaps []int) int {
	diffs := make(map[int]int)
	for i := 1; i < len(adaps); i++ {
		diffs[adaps[i]-adaps[i-1]]++
	}
	return diffs[1] * diffs[3]
}

func main() {
	adaps := []int{0}
	utils.ScanLine("big.txt", func(line string) {
		a, _ := strconv.Atoi(line)
		adaps = append(adaps, a)
	})
	adaps = append(adaps, adaps[len(adaps)-1]+3)

	sort.Ints(adaps)

	fmt.Println("Part 1: ", jolts(adaps))
	fmt.Println("Part 2: ", arrangements(adaps))
}
