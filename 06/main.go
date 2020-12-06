package main

import (
	"bufio"
	"fmt"
	"os"
)

func answers(group []string) [26]int {
	var ans [26]int
	for _, line := range group {
		for _, c := range line {
			ans[c-'a']++
		}
	}
	return ans
}

func count(group []string, pred func(int) bool) int {
	ans := answers(group)
	res := 0
	for _, count := range ans {
		if pred(count) {
			res++
		}
	}
	return res
}

func main() {
	file, _ := os.Open("big.txt")
	defer file.Close()

	scanner := bufio.NewScanner(file)

	count1, count2 := 0, 0
	var group []string
	for scanner.Scan() {
		line := scanner.Text()
		if line == "" {
			count1 += count(group, func(a int) bool { return a > 0 })
			count2 += count(group, func(a int) bool { return a == len(group) })
			group = nil
		} else {
			group = append(group, line)
		}
	}
	fmt.Println("Part 1: ", count1)
	fmt.Println("Part 2: ", count2)
}
