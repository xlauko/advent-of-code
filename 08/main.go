package main

import (
	"fmt"
	"strconv"
	"strings"
	"utils/utils"
)

type inst struct {
	op   string
	args []int
}

type machine struct {
	code []inst
	seen map[int]bool
	pc   int
	acc  int
}

func parse(line string) inst {
	split := strings.Split(line, " ")
	arg, _ := strconv.Atoi(split[1])
	return inst{op: split[0], args: []int{arg}}
}

func load(path string) []inst {
	var code []inst
	utils.ScanLine(path, func(line string) {
		code = append(code, parse(line))
	})
	return code
}

func (m machine) terminated() bool {
	return m.pc == len(m.code)
}

func (m machine) loops() bool {
	return m.seen[m.pc]
}

func (m *machine) interpret(i inst) int {
	m.seen[m.pc] = true
	switch i.op {
	case "acc":
		m.acc += i.args[0]
		return 1
	case "jmp":
		return i.args[0]
	case "nop":
		return 1
	}
	panic("unknown operation " + i.op)
}

func (m machine) current() inst {
	return m.code[m.pc]
}

func (m *machine) run() (bool, int) {
	for !m.terminated() {
		if m.loops() {
			return false, m.acc
		}
		m.pc += m.interpret(m.current())
	}
	return true, m.acc
}

func eval(code []inst) (bool, int) {
	var m machine
	m.seen = make(map[int]bool)
	m.code = code
	return m.run()
}

func (i *inst) flip() {
	switch i.op {
	case "jmp":
		i.op = "nop"
	case "nop":
		i.op = "jmp"
	}
}

func debug(code []inst) int {
	for i := range code {
		code[i].flip()
		halts, res := eval(code)
		if halts {
			return res
		}
		code[i].flip()
	}
	panic("does not terminate")
}

func main() {
	code := load("big.txt")
	_, res := eval(code)
	fmt.Println("Part 1: ", res)
	fmt.Println("Part 2: ", debug(code))
}
