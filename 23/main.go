package main

import (
	"container/ring"
	"fmt"
	"utils/utils"
)

type Cup = *ring.Ring

type Cups struct {
	current Cup
	handles map[int]Cup
	highest int
}

func MakeCups(labels []int) Cups {
	var cups Cups
	cups.current = ring.New(len(labels))
	cups.handles = make(map[int]Cup)
	cups.highest = len(labels)

	cup := cups.current
	for _, label := range labels {
		cup.Value = label
		cups.handles[label] = cup
		cup = cup.Next()
	}
	return cups
}

func (cups *Cups) CrabMove(rounds int) {
	for round := 0; round < rounds; round++ {
		removed := cups.current.Unlink(3)
		dest := cups.Destination(RingLabels(removed))
		dest.Link(removed)
		cups.current = cups.current.Next()
	}
}

func (cups *Cups) CurrentLabel() int {
	return cups.current.Value.(int)
}

func (cups *Cups) NextLabel(label int) int {
	if label == 1 {
		return cups.highest
	}
	return label - 1
}

func (cups *Cups) Destination(removed []int) Cup {
	label := cups.NextLabel(cups.CurrentLabel())
	for utils.IsIn(label, removed) {
		label = cups.NextLabel(label)
	}
	return cups.handles[label]
}

func RingLabels(ring *ring.Ring) []int {
	var labels []int
	ring.Do(func(cup interface{}) {
		labels = append(labels, cup.(int))
	})
	return labels
}

func Simulate(prefix []int, n int, rounds int) Cups {
	labels := make([]int, n)
	for i := range labels {
		labels[i] = i + 1
	}
	for i, digit := range prefix {
		labels[i] = digit
	}
	cups := MakeCups(labels)
	cups.CrabMove(rounds)
	return cups
}

func part1(prefix []int) string {
	cups := Simulate(prefix, len(prefix), 100)
	return utils.InstToString(RingLabels(cups.handles[1]), "")[1:]
}

func part2(prefix []int) int {
	cups := Simulate(prefix, 1000000, 10000000)
	one := cups.handles[1]
	a, b := one.Next(), one.Next().Next()
	return a.Value.(int) * b.Value.(int)
}

func main() {
	labelsNum := 389125467
	labels := utils.Digits(labelsNum)
	fmt.Println("Part 1: ", part1(labels))
	fmt.Println("Part 2: ", part2(labels))
}
