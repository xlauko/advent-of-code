package main

import (
	"fmt"
	"sort"
	"strconv"
	"utils/utils"
)

func arrangements(adaps []int) int {
	tab := map[int]int{0: 1}
	adaps = append(adaps, adaps[len(adaps)-1]+3)
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

func main() {
	var adapters []int
	adapters = append(adapters, 0)
	utils.ScanLine("big.txt", func(line string) {
		a, _ := strconv.Atoi(line)
		adapters = append(adapters, a)
	})

	sort.Ints(adapters)
	jolts := make(map[int]int)
	for i := 1; i < len(adapters); i++ {
		diff := adapters[i] - adapters[i-1]
		jolts[diff]++
	}

	fmt.Println("Part 1: ", jolts[1]*(jolts[3]+1))
	fmt.Println("Part 2: ", arrangements(adapters))
}
