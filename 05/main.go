package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
)

func main() {
	file, err := os.Open("big.txt")
	if err != nil {
		log.Fatal(err)
	}

	defer file.Close()

	scanner := bufio.NewScanner(file)
	highest := 0

	ids := make(map[int]bool)

	for scanner.Scan() {
		line := scanner.Text()
		row, _ := strconv.ParseInt(line[:7], 2, 32)
		seat, _ := strconv.ParseInt(line[7:], 2, 32)
		id := int(row*8 + seat)
		if id > highest {
			highest = id
		}
		ids[id] = true
	}

	my := 0
	for id := 85; id < highest; id++ {
		if !ids[id] {
			my = id
			break
		}
	}

	fmt.Println("Part 1: ", highest)
	fmt.Println("Part 2: ", my)
}
