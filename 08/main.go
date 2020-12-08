package main

import (
	"fmt"
	"strconv"
	"strings"
	"utils/utils"
)

// Op operation
type Op struct {
	name string
	off  int
}

func run(code []Op) (bool, int) {
	acc := 0
	ip := 0
	seen := make(map[int]bool)

	for {
		if ip == len(code) {
			return true, acc
		}

		op := code[ip]
		if seen[ip] {
			return false, acc
		}

		seen[ip] = true
		switch op.name {
		case "acc":
			acc += op.off
			ip++
			break
		case "jmp":
			ip += op.off
			break
		case "nop":
			ip++
			break
		}
	}
}

func flip(code []Op, i int) {
	if code[i].name == "jmp" {
		code[i].name = "nop"
	} else if code[i].name == "nop" {
		code[i].name = "jmp"
	}
}

func terminates(code []Op) int {
	for i := 0; i < len(code); i++ {
		flip(code, i)
		fix, acc := run(code)
		if fix {
			return acc
		}
		flip(code, i)
	}
	return 0
}

func main() {
	var code []Op
	utils.ScanLine("big.txt", func(line string) {
		split := strings.Split(line, " ")
		off, _ := strconv.Atoi(split[1])
		op := Op{name: split[0], off: off}
		code = append(code, op)
	})
	_, acc := run(code)
	fmt.Println("Part 1: ", acc)
	fmt.Println("Part 2: ", terminates(code))
}
