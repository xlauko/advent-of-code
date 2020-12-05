package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

func main() {
	file, err := os.Open("big.txt")
	if err != nil {
		log.Fatal(err)
	}

	defer file.Close()

	scanner := bufio.NewScanner(file)
	min, max := 1024, 0

	var seen [1024]bool

	for scanner.Scan() {
		line := scanner.Text()

		replacer := strings.NewReplacer("F", "0", "B", "1", "L", "0", "R", "1")
		id, _ := strconv.ParseInt(replacer.Replace(line), 2, 0)

		if int(id) < min {
			min = int(id)
		}

		if int(id) > max {
			max = int(id)
		}
		seen[id] = true
	}

	my := 0
	for id := min; id < max; id++ {
		if !seen[id] {
			my = id
			break
		}
	}

	fmt.Println("Part 1: ", max)
	fmt.Println("Part 2: ", my)
}
