package main

import (
	"fmt"
	"strings"
	"utils/utils"
)

type Coord struct {
	q, r int
}

type Dir = Coord

var Dirs = map[string]Dir{
	"w":  Dir{-1, 0},
	"sw": Dir{-1, 1},
	"nw": Dir{0, -1},
	"e":  Dir{1, 0},
	"ne": Dir{1, -1},
	"se": Dir{0, 1},
}

type Tiles = map[Coord]bool

func Move(c Coord, d Dir) Coord {
	return Coord{c.q + d.q, c.r + d.r}
}

func MoveTo(line string) (coord Coord) {
	for _, dir := range strings.Split(line, " ") {
		coord = Move(coord, Dirs[dir])
	}
	return
}

func Flip(tiles Tiles, coord Coord) {
	if tiles[coord] {
		delete(tiles, coord)
	} else {
		tiles[coord] = true
	}
}

func Neighbours(coord Coord) (neighbours []Coord) {
	for _, dir := range Dirs {
		neighbours = append(neighbours, Move(coord, dir))
	}
	return
}

func CountBlackNeighbours(coord Coord, tiles Tiles) int {
	count := 0
	for _, neighbour := range Neighbours(coord) {
		if tiles[neighbour] {
			count++
		}
	}
	return count
}

func Simulate(tiles Tiles) Tiles {
	next := tiles
	flip := make(Tiles)
	for tile := range tiles {
		blacks := CountBlackNeighbours(tile, tiles)
		if blacks == 0 || blacks > 2 {
			flip[tile] = true
		}

		for _, neighbour := range Neighbours(tile) {
			if !flip[neighbour] && !tiles[neighbour] && CountBlackNeighbours(neighbour, tiles) == 2 {
				flip[neighbour] = true
			}
		}
	}
	for tile := range flip {
		Flip(next, tile)
	}
	return next
}

func main() {
	var lines []string
	utils.ScanLine("small.txt", func(line string) {
		r := strings.NewReplacer(
			"nw", "nw ", "ne", "ne ",
			"se", "se ", "sw", "sw ",
			"e", "e ", "w", "w ",
		)
		lines = append(lines, strings.TrimSpace(r.Replace(line)))
	})

	tiles := make(Tiles)
	for _, line := range lines {
		Flip(tiles, MoveTo(line))
	}

	fmt.Println("Part 1: ", len(tiles))

	rounds := 100
	for i := 0; i < rounds; i++ {
		tiles = Simulate(tiles)
	}
	fmt.Println("Part 2: ", len(tiles))
}
