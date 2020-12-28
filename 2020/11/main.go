package main

import (
	"fmt"
	"strings"
	"utils/utils"
)

func neighbours(seats [][]string, row, col int, diag bool) int {
	count := 0
	for dx := -1; dx < 2; dx++ {
		for dy := -1; dy < 2; dy++ {
			d := 1
			for {
				if dx == 0 && dy == 0 {
					break
				}
				x := row + dx*d
				y := col + dy*d
				if x < 0 || x >= len(seats) || y < 0 || y >= len(seats[0]) {
					break
				}
				if seats[x][y] == "L" {
					break
				}
				if seats[x][y] == "#" {
					count++
					break
				}
				if seats[x][y] == "." && !diag {
					break
				}
				d++
			}
		}
	}
	return count
}

func step(seats [][]string, bound int, diag bool) ([][]string, bool) {
	change := false

	next := make([][]string, len(seats))
	for i := range seats {
		next[i] = make([]string, len(seats[i]))
		copy(next[i], seats[i])
	}
	for row := range seats {
		for col := range seats[0] {
			place := seats[row][col]
			if place == "." {
				continue
			}

			neighbours := neighbours(seats, row, col, diag)
			switch place {
			case "L":
				if neighbours == 0 {
					next[row][col] = "#"
					change = true
				}
				break
			case "#":
				if neighbours >= bound {
					next[row][col] = "L"
					change = true
				}
				break
			}
		}
	}

	return next, change
}

func occupied(seats [][]string) int {
	count := 0
	for row := range seats {
		for col := range seats[0] {
			if seats[row][col] == "#" {
				count++
			}
		}
	}
	return count
}

func simulate(seats [][]string, bound int, diag bool) int {
	iterations := 0
	change := true
	for change {
		seats, change = step(seats, bound, diag)
		iterations++
	}

	return occupied(seats)
}

func main() {
	var seats = [][]string{}

	utils.ScanLine("big.txt", func(line string) {
		seats = append(seats, strings.Split(line, ""))
	})
	fmt.Println("Part 1: ", simulate(seats, 4, false))
	fmt.Println("Part 2: ", simulate(seats, 5, true))
}
