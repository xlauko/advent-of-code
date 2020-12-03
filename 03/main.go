package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
)

func loadArea(path string) [][]bool {
	file, err := os.Open(path)
	if err != nil {
		log.Fatal(err)
	}

	defer file.Close()

	area := [][]bool{}

	scanner := bufio.NewScanner(file)
	scanner.Split(bufio.ScanWords)
	for scanner.Scan() {
		row := []bool{}
		for _, point := range scanner.Text() {
			row = append(row, point == '#')
		}
		area = append(area, row)
	}

	return area
}

func hitTress(dx, dy int, area [][]bool) int {
	height := len(area)
	width := len(area[0])
	trees := 0
	x, y := dx, dy
	for y < height {
		if area[y][x] {
			trees++
		}
		x = (x + dx) % width
		y += dy
	}
	return trees
}

func main() {
	area := loadArea("big.txt")

	fmt.Println("Part 1: ", hitTress(3, 1, area))

	part2 := 1
	dx := []int{1, 3, 5, 7, 1}
	dy := []int{1, 1, 1, 1, 2}
	for i := 0; i < len(dx); i++ {
		part2 *= hitTress(dx[i], dy[i], area)
	}

	fmt.Println("Part 2: ", part2)
}
