package main

import (
	"fmt"
	"utils/utils"
)

type Pos struct {
	x, y, z, w int
}

func Add(a, b Pos) Pos {
	return Pos{a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w}
}

func neighbours3D(pos Pos) <-chan Pos {
	ch := make(chan Pos)
	go func() {
		for x := -1; x <= 1; x++ {
			for y := -1; y <= 1; y++ {
				for z := -1; z <= 1; z++ {
					if x == 0 && y == 0 && z == 0 {
						continue
					}
					ch <- Add(pos, Pos{x, y, z, 0})
				}
			}
		}
		close(ch)
	}()

	return ch
}

func neighbours4D(pos Pos) <-chan Pos {
	ch := make(chan Pos)
	go func() {
		for x := -1; x <= 1; x++ {
			for y := -1; y <= 1; y++ {
				for z := -1; z <= 1; z++ {
					for w := -1; w <= 1; w++ {
						if x == 0 && y == 0 && z == 0 && w == 0 {
							continue
						}
						ch <- Add(pos, Pos{x, y, z, w})
					}
				}
			}
		}
		close(ch)
	}()
	return ch
}

type Neighbours func(Pos) <-chan Pos

func countActive(world map[Pos]bool, pos Pos, neighbours Neighbours) (active int) {
	for n := range neighbours(pos) {
		if world[n] {
			active++
		}
	}
	return
}

func next(world map[Pos]bool, neighbours Neighbours) <-chan Pos {
	ch := make(chan Pos)
	go func() {
		for pos := range world {
			active := countActive(world, pos, neighbours)
			if 2 == active || active == 3 {
				ch <- pos
			}

			for n := range neighbours(pos) {
				if !world[n] && countActive(world, n, neighbours) == 3 {
					ch <- n
				}
			}
		}
		close(ch)
	}()
	return ch
}

func simulate(iter int, world map[Pos]bool, neighbours Neighbours) int {
	for i := 0; i < iter; i++ {
		nextgen := make(map[Pos]bool)
		for pos := range next(world, neighbours) {
			nextgen[pos] = true
		}
		world = nextgen
	}
	return len(world)
}

func main() {

	world := make(map[Pos]bool)

	y := 0
	utils.ScanLine("big.txt", func(line string) {
		for x, v := range line {
			if v == '#' {
				world[Pos{x, y, 0, 0}] = true
			}
		}
		y++
	})

	fmt.Println("Part 1: ", simulate(6, world, neighbours3D))
	fmt.Println("Part 2: ", simulate(6, world, neighbours4D))
}
