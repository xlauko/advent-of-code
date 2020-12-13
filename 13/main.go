package main

import (
	"fmt"
	"strconv"
	"strings"
	"utils/utils"
)

func mulInv(a, b int) int {
	if b == 1 {
		return 1
	}
	aa, bb, x0, x1 := a, b, 0, 1
	for aa > 1 {
		q := aa / bb
		aa, bb = bb, aa%bb
		x0, x1 = x1-q*x0, x0
	}
	if x1 < 0 {
		x1 += b
	}
	return x1
}

func crt(n, a []int) int {
	prod := 1
	for _, v := range n {
		prod *= v
	}

	sum := 0
	for i, v := range n {
		p := prod / v
		sum += a[i] * mulInv(p, v) * p
	}
	return sum % prod
}

func part1(busses []int, arrival int) int {
	shortest := arrival
	id := 0
	for _, bus := range busses {
		wait := (bus - arrival%bus)
		if wait < shortest {
			id = bus
			shortest = wait
		}
	}
	return id * shortest
}

func main() {
	var busses, res []int

	var lines []string
	utils.ScanLine("big.txt", func(line string) {
		lines = append(lines, line)
	})

	s := strings.Split(lines[1], ",")
	for i, col := range s {
		if col != "x" {
			bus, _ := strconv.Atoi(col)
			busses = append(busses, bus)
			res = append(res, bus-i)
		}
	}
	arrival, _ := strconv.Atoi(lines[0])
	fmt.Println("Part 1: ", part1(busses, arrival))
	fmt.Println("Part 2: ", crt(busses, res))
}
