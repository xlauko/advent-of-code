package main

import (
	"fmt"
	"strconv"
	"strings"
	"utils/utils"
)

func compute(args *utils.IntStack, ops *utils.StringStack) int {
	a := args.Pop()
	b := args.Pop()
	switch ops.Pop() {
	case "+":
		return a + b
	case "*":
		return a * b
	}

	panic("unknown operation")
}

type Precedence map[string]int

func eval(expr []string, prec Precedence) int {
	var args utils.IntStack
	var ops utils.StringStack

	for _, token := range expr {
		if val, err := strconv.Atoi(token); err == nil {
			args.Push(val)
		} else if token == "(" {
			ops.Push(token)
		} else if token == ")" {
			for ops.Top() != "(" {
				args.Push(compute(&args, &ops))
			}
			ops.Pop()
		} else if token == "*" || token == "+" {
			for !ops.IsEmpty() && prec[token] <= prec[ops.Top()] {
				args.Push(compute(&args, &ops))
			}
			ops.Push(token)
		} else {
			panic("unknown token")
		}
	}
	for !ops.IsEmpty() {
		args.Push(compute(&args, &ops))
	}
	return args.Pop()
}

func sum(file string, prec Precedence) (res int) {
	utils.ScanLine(file, func(line string) {
		line = strings.Replace(line, "(", "( ", -1)
		line = strings.Replace(line, ")", " )", -1)
		expr := strings.Split(line, " ")
		res += eval(expr, prec)
	})
	return
}

var precEq = map[string]int{"(": 0, "+": 1, "*": 1}
var precPlus = map[string]int{"(": 0, "+": 2, "*": 1}

func main() {
	file := "big.txt"
	fmt.Println("Part 1: ", sum(file, precEq))
	fmt.Println("Part 2: ", sum(file, precPlus))
}
