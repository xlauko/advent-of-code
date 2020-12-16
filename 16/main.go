package main

import (
	"fmt"
	"strconv"
	"strings"
	"utils/utils"
)

type Interval struct {
	low, high int
}

type Range struct {
	intervals []Interval
}

func (i Interval) contains(v int) bool {
	return i.low <= v && v <= i.high
}

func (r Range) contains(v int) bool {
	return r.intervals[0].contains(v) || r.intervals[1].contains(v)
}

func getInterval(str string) Interval {
	parts := strings.Split(str, "-")
	low, _ := strconv.Atoi(parts[0])
	high, _ := strconv.Atoi(parts[1])
	return Interval{low: low, high: high}
}

func getRanges(group []string) map[string]Range {
	ranges := make(map[string]Range)
	for _, line := range group {
		field := strings.Split(line, ": ")
		parts := strings.Split(field[1], " or ")
		intervals := []Interval{getInterval(parts[0]), getInterval(parts[1])}
		ranges[field[0]] = Range{intervals: intervals}
	}
	return ranges
}

func parseTicket(str string) []int {
	var nums []int
	for _, i := range strings.Split(str, ",") {
		v, _ := strconv.Atoi(i)
		nums = append(nums, v)
	}
	return nums
}

func getTickets(group []string) [][]int {
	var tickets [][]int
	for i := 1; i < len(group); i++ {
		tickets = append(tickets, parseTicket(group[i]))
	}
	return tickets
}

func validInRange(field int, r Range) (valid bool) {
	for _, i := range r.intervals {
		if i.low <= field && field <= i.high {
			return true
		}
	}
	return false
}

func validField(field int, ranges map[string]Range) bool {
	for _, r := range ranges {
		if r.contains(field) {
			return true
		}
	}
	return false
}

func validTicket(ticket []int, ranges map[string]Range) bool {
	for _, field := range ticket {
		if !validField(field, ranges) {
			return false
		}
	}
	return true
}

func validTickets(tickets [][]int, ranges map[string]Range) (valid [][]int) {
	for _, ticket := range tickets {
		if validTicket(ticket, ranges) {
			valid = append(valid, ticket)
		}
	}
	return
}

func ticketsError(ranges map[string]Range, tickets [][]int) (cum int) {
	for _, ticket := range tickets {
		for _, field := range ticket {
			if !validField(field, ranges) {
				cum += field
			}
		}
	}
	return
}

func possibleIndices(tickets [][]int, ranges map[string]Range) map[string][]int {
	poss := make(map[string][]int)
	valid := func(i int, r Range) bool {
		for _, ticket := range tickets {
			if !r.contains(ticket[i]) {
				return false
			}
		}
		return true
	}

	for name, r := range ranges {
		for i := 0; i < len(ranges); i++ {
			if valid(i, r) {
				poss[name] = append(poss[name], i)
			}
		}
	}
	return poss
}

func main() {
	var groups [][]string
	utils.ScanGroup("big.txt", func(group []string) {
		groups = append(groups, group)
	})

	ranges := getRanges(groups[0])
	tickets := getTickets(groups[2])
	fmt.Println("Part 1: ", ticketsError(ranges, tickets))

	possible := possibleIndices(validTickets(tickets, ranges), ranges)

	delete := func(idx int) {
		for name, indices := range possible {
			if len(indices) != 1 {
				possible[name] = utils.Delete(indices, idx)
			}
		}
	}

	solved := make(map[string]int)
	for len(solved) < len(ranges) {
		for name, indices := range possible {
			if _, ok := solved[name]; !ok && len(indices) == 1 {
				idx := indices[0]
				solved[name] = idx
				delete(idx)
			}
		}
	}

	ticket := parseTicket(groups[1][1])
	departure := 1
	for name, idx := range solved {
		if strings.HasPrefix(name, "departure") {
			departure *= ticket[idx]
		}
	}
	fmt.Println("Part 2: ", departure)
}
