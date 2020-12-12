package main

import (
	"fmt"
	"strconv"
	"utils/utils"
)

type state struct {
	pos utils.Vec2
	dir utils.Vec2
}

type inst struct {
	action byte
	value  float64
}

var (
	N = utils.Vec2{X: 0, Y: 1}
	S = utils.Vec2{X: 0, Y: -1}
	E = utils.Vec2{X: 1, Y: 0}
	W = utils.Vec2{X: -1, Y: 0}
)

func rotate(degrees float64, vec utils.Vec2) utils.Vec2 {
	return utils.DiscreteRotation(degrees).Transform(vec)
}

func direction(d byte) utils.Vec2 {
	switch d {
	case 'N':
		return N
	case 'S':
		return S
	case 'E':
		return E
	case 'W':
		return W
	}
	panic("unknown direction")

}

func simulate(insts []inst, dir utils.Vec2, updateWayPoint bool) state {
	var s state
	s.dir = dir

	for _, i := range insts {
		if i.action == 'F' {
			s.pos.Add(utils.Mul(s.dir, i.value))
		} else if i.action == 'L' {
			s.dir = rotate(i.value, s.dir)
		} else if i.action == 'R' {
			s.dir = rotate(360-i.value, s.dir)
		} else {
			update := utils.Mul(direction(i.action), i.value)
			if updateWayPoint {
				s.dir.Add(update)
			} else {
				s.pos.Add(update)
			}
		}
	}
	return s
}

func main() {
	var insts []inst
	utils.ScanLine("big.txt", func(line string) {
		a := line[0]
		v, _ := strconv.ParseFloat(line[1:], 64)
		insts = append(insts, inst{action: a, value: v})
	})

	fmt.Println("Part 1: ", simulate(insts, E, false).pos.ManhattanLength())

	wayPoint := utils.Vec2{X: 10, Y: 1}
	fmt.Println("Part 2: ", simulate(insts, wayPoint, true).pos.ManhattanLength())
}
