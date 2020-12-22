package main

import (
	"fmt"
	"strconv"
	"strings"
	"utils/utils"
)

type Deck []int

func (self *Deck) enqueue(card int) {
	*self = append(*self, card)
}

func (self *Deck) dequeue() int {
	card := (*self)[0]
	*self = (*self)[1:]
	return card
}

func (self *Deck) copy(n int) Deck {
	var deck Deck
	for _, card := range (*self)[:n] {
		deck = append(deck, card)
	}
	return deck
}

func (self *Deck) empty() bool {
	return len(*self) == 0
}

func (self *Deck) score() int {
	res := 0
	length := len(*self)
	for i, card := range *self {
		res += card * (length - i)
	}
	return res
}

func (self *Deck) toString() string {
	strs := make([]string, len(*self))
	for i, v := range *self {
		strs[i] = strconv.Itoa(v)
	}
	return strings.Join(strs, ".")
}

func game(p1, p2 Deck, recurse bool) (int, int) {
	seen := make(map[string]bool)
	for !p1.empty() && !p2.empty() {
		state := p1.toString() + "-" + p2.toString()
		if seen[state] {
			return 1, p1.score()
		}
		seen[state] = true

		a := p1.dequeue()
		b := p2.dequeue()

		winner := 1
		if recurse && a <= len(p1) && b <= len(p2) {
			winner, _ = game(p1.copy(a), p2.copy(b), recurse)
		} else if b > a {
			winner = 2
		}

		if winner == 1 {
			p1.enqueue(a)
			p1.enqueue(b)
		} else {
			p2.enqueue(b)
			p2.enqueue(a)
		}
	}

	if p1.empty() {
		return 2, p2.score()
	}
	return 1, p1.score()
}

func deal(file string) []Deck {
	var decks []Deck
	utils.ScanGroup(file, func(group []string) {
		var deck Deck
		for _, line := range group[1:] {
			card, _ := strconv.Atoi(line)
			deck.enqueue(card)
		}
		decks = append(decks, deck)
	})

	return decks
}

func play(file string, recursive bool) int {
	decks := deal(file)
	_, score := game(decks[0], decks[1], recursive)
	return score
}

func main() {
	file := "big.txt"
	fmt.Println("Part 1: ", play(file, false))
	fmt.Println("Part 2: ", play(file, true))
}
