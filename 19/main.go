package main

import (
	"fmt"
	"strconv"
	"strings"
	"utils/utils"
)

type Rule struct {
	from string
	to   []string
}

type Grammar struct {
	nrules []Rule
	trules []Rule
}

func terminal(token string) bool {
	_, err := strconv.Atoi(token)
	return err != nil
}

func parseRule(from string, tokens []string) (Rule, bool) {
	if terminal(tokens[0]) {
		term := string(tokens[0][1])
		return Rule{from, []string{term}}, true
	}
	return Rule{from, tokens}, false
}

func makeGrammar(lines []string) (grammar Grammar) {
	for _, line := range lines {
		split := strings.Split(line, ": ")
		from := split[0]
		for _, alt := range strings.Split(split[1], " | ") {
			rule, term := parseRule(from, strings.Split(alt, " "))
			if term {
				grammar.trules = append(grammar.trules, rule)
			} else {
				grammar.nrules = append(grammar.nrules, rule)
			}
		}
	}
	return
}

func (g Grammar) match(word string) bool {
	table := make([][][]string, len(word))

	check := func(row, col int, rule string) bool {
		_, found := utils.FindStr(table[row][col], rule)
		return found
	}

	for i := range table {
		table[i] = make([][]string, len(word)-i)
	}

	for i, c := range word {
		for _, trule := range g.trules {
			if trule.to[0] == string(c) {
				table[0][i] = append(table[0][i], trule.from)
			}
		}
	}

	for i := 1; i < len(word); i++ {
		for j := 0; j < len(word)-i; j++ {
			for k := 0; k < i; k++ {
				for _, rule := range g.nrules {
					if check(k, j, rule.to[0]) && check(i-k-1, j+k+1, rule.to[1]) {
						table[i][j] = append(table[i][j], rule.from)
					}
				}
			}
		}
	}

	_, found := utils.FindStr(table[len(word)-1][0], "0")
	return found
}

func main() {
	var groups [][]string
	utils.ScanGroup("big.txt", func(group []string) {
		groups = append(groups, group)
	})

	g := makeGrammar(groups[0])

	for _, rule := range g.nrules {
		if len(rule.to) != 2 {
			panic("broken rule")
		}
	}

	matched := 0
	for _, word := range groups[1] {
		if g.match(word) {
			matched++
		}
	}

	fmt.Println("Matched: ", matched)
}
