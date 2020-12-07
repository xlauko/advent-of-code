package main

import (
	"fmt"
	"strconv"
	"strings"
	"utils/utils"
)

// Bag of bags
type Bag struct {
	name  string
	count int
}

const shiny = "shiny gold"

func containsShiny(outer string, bags map[string][]Bag) bool {
	if outer == shiny {
		return true
	}

	for _, bag := range bags[outer] {
		if containsShiny(bag.name, bags) {
			return true
		}
	}
	return false
}

func countContaintsShiny(bags map[string][]Bag) int {
	count := 0
	for bag := range bags {
		if bag != shiny && containsShiny(bag, bags) {
			count++
		}
	}
	return count
}

func countContents(outer string, bags map[string][]Bag) int {
	result := 1
	for _, bag := range bags[outer] {
		count := countContents(bag.name, bags)
		result += bag.count * count
	}
	return result
}

func preprocess(line string) (string, []string) {
	replacer := strings.NewReplacer(".", "", ", ", ":", " contain ", ":", " bags", "", " bag", "")
	line = replacer.Replace(line)
	split := strings.Split(line, ":")
	return split[0], split[1:]
}

func main() {

	bags := make(map[string][]Bag)
	utils.ScanLine("big.txt", func(line string) {
		name, contains := preprocess(line)
		bags[name] = nil

		var contents []Bag
		for _, bag := range contains {
			if bag == "no other" {
				break
			}
			parts := strings.SplitN(bag, " ", 2)
			count, _ := strconv.Atoi(parts[0])
			bag := Bag{name: parts[1], count: count}
			contents = append(contents, bag)
		}

		bags[name] = contents
	})

	fmt.Println("Part 1: ", countContaintsShiny(bags))
	fmt.Println("Part 2: ", countContents(shiny, bags)-1)
}
