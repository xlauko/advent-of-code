package main

import (
	"fmt"
	"math"
	"strconv"
	"strings"
	"utils/utils"
)

type Tile = []string

type Puzzle = [][]Tile

func parseId(line string) int {
	split := strings.Split(line, " ")
	idstr := split[1]
	id, _ := strconv.Atoi(idstr[:len(idstr)-1])
	return id
}

func right(tile []string) string {
	side := ""
	for i := 0; i < len(tile); i++ {
		side = side + string(tile[i][len(tile[i])-1])
	}
	return side
}

func left(tile []string) string {
	side := ""
	for i := 0; i < len(tile); i++ {
		side = side + string(tile[i][0])
	}
	return side
}

func top(tile []string) string {
	return tile[0]
}

func bottom(tile []string) string {
	return tile[len(tile)-1]
}

func match(a, b string) bool {
	return a == b || a == utils.Reverse(b)
}

func transpose(tile []string) (res []string) {
	for col := range tile[0] {
		line := ""
		for row := range tile {
			line = line + string(tile[row][col])
		}
		res = append(res, line)
	}
	return
}

func reverse(tile []string) (res []string) {
	for _, line := range tile {
		res = append(res, utils.Reverse(line))
	}
	return
}

func rotations(tile []string) [][]string {
	res := [][]string{tile}
	for i := 0; i < 3; i++ {
		variant := reverse(transpose(res[len(res)-1]))
		res = append(res, variant)
	}
	return res
}

func variants(tile []string) [][]string {
	return append(rotations(tile), rotations(transpose(tile))...)
}

type Pos struct {
	row, col int
}

func (pos *Pos) isCorner(size int) bool {
	return (pos.col == 0 || pos.col == size-1) &&
		(pos.row == 0 || pos.row == size-1)
}

func (pos *Pos) isSide(size int) bool {
	return (pos.col == 0 || pos.col == size-1) ||
		(pos.row == 0 || pos.row == size-1)
}

func removeBorders(puzzle Puzzle) Puzzle {
	for r, trow := range puzzle {
		for c, tile := range trow {
			var sliced Tile
			for _, row := range tile[1 : len(tile)-1] {
				sliced = append(sliced, row[1:len(row)-1])
			}
			puzzle[r][c] = sliced
		}
	}
	return puzzle
}

func getImage(puzzle Puzzle) []string {
	tileSize := len(puzzle[0][0])
	board := make([]string, len(puzzle)*tileSize)
	for i, trow := range puzzle {
		for _, tile := range trow {
			for k := range tile {
				board[i*tileSize+k] += tile[k]
			}
		}
	}
	return board
}

func sides(t Tile) []string {
	return []string{top(t), right(t), bottom(t), left(t)}
}

func joinable(a, b Tile) bool {
	for _, aside := range sides(a) {
		for _, bside := range sides(b) {
			if match(aside, bside) {
				return true
			}
		}
	}
	return false
}

type Solver struct {
	tiles map[int]Tile
	match map[int][]int
	used  map[int]bool
}

func NewSolver(tiles map[int]Tile) *Solver {
	s := new(Solver)
	s.tiles = tiles
	match := make(map[int][]int)
	for i, ti := range tiles {
		for j, tj := range tiles {
			if i != j && joinable(ti, tj) {
				match[i] = append(match[i], j)
			}
		}
	}
	s.match = match
	s.used = make(map[int]bool)
	return s
}

func (s *Solver) side() int {
	return int(math.Sqrt(float64(len(s.tiles))))

}

func (s *Solver) puzzle() Puzzle {
	size := s.side()

	tab := make([][]Tile, size)
	for row := range tab {
		tab[row] = make([]Tile, size)
		for col := range tab {
			tab[row][col] = Tile{}
		}
	}
	return tab
}

func (s *Solver) corners() []int {
	var result []int
	for id, neighbours := range s.match {
		if len(neighbours) == 2 {
			result = append(result, id)
		}
	}
	return result
}

func (s *Solver) sides() []int {
	var result []int
	for id, neighbours := range s.match {
		if len(neighbours) == 3 {
			result = append(result, id)
		}
	}
	return result
}

func (s *Solver) inner() []int {
	var result []int
	for id, neighbours := range s.match {
		if len(neighbours) == 4 {
			result = append(result, id)
		}
	}
	return result
}

func (s *Solver) posibilities(pos Pos) []int {
	if pos.isCorner(s.side()) {
		return s.corners()
	}

	if pos.isSide(s.side()) {
		return s.sides()
	}

	return s.inner()
}

func fit(tab Puzzle, tile []string, pos Pos) bool {
	if pos.row > 0 {
		over := tab[pos.row-1][pos.col]
		if bottom(over) != top(tile) {
			return false
		}
	}
	if pos.col > 0 {
		prev := tab[pos.row][pos.col-1]
		if right(prev) != left(tile) {
			return false
		}
	}
	return true
}

func freeze(tab Puzzle, pos Pos, t Tile) Puzzle {
	tab[pos.row][pos.col] = t
	return tab
}

func (s *Solver) nextPos(pos Pos) Pos {
	side := s.side()
	row := pos.row
	if pos.col == side-1 {
		row++
	}
	return Pos{row, (pos.col + 1) % side}
}

func (s *Solver) solve(pos Pos, tab Puzzle) (Puzzle, bool) {
	if pos.row == s.side() {
		return tab, true
	}

	next := s.nextPos(pos)
	for _, p := range s.posibilities(pos) {
		if s.used[p] {
			continue
		}
		for _, tile := range variants(s.tiles[p]) {
			if !fit(tab, tile, pos) {
				continue
			}

			s.used[p] = true
			if sol, found := s.solve(next, freeze(tab, pos, tile)); found {
				return sol, true
			}
		}
		delete(s.used, p)
	}
	return nil, false
}

func printPuzzle(puzzle [][]Tile) {
	for _, row := range puzzle {
		for trow := range row[0] {
			for _, t := range row {
				fmt.Print(t[trow], " ")
			}
			fmt.Println()
		}
		fmt.Println()
	}
}

func printTile(tile []string) {
	for _, row := range tile {
		fmt.Println(row)
	}
}

func main() {
	tiles := make(map[int]Tile)
	utils.ScanGroup("big.txt", func(group []string) {
		id := parseId(group[0])
		tiles[id] = group[1:]
	})

	solver := NewSolver(tiles)

	part1 := 1
	for _, cor := range solver.corners() {
		part1 *= cor
	}
	fmt.Println("Part 1: ", part1)

	sol, _ := solver.solve(Pos{0, 0}, solver.puzzle())
	img := getImage(removeBorders(sol))

	monster := []string{
		"                  # ",
		"#    ##    ##    ###",
		" #  #  #  #  #  #   "}

	mvars := variants(monster)

	matched := func(board []string, row, col int, monster []string) bool {
		for drow := range monster {
			for dcol := range monster[0] {
				if monster[drow][dcol] == '#' && board[row+drow][col+dcol] != '#' {
					return false
				}
			}
		}
		return true
	}

	count := 0
	for _, m := range mvars {
		for row := 0; row < len(img)-len(m); row++ {
			for col := 0; col < len(img[0])-len(m[0]); col++ {
				if matched(img, row, col, m) {
					for drow := range m {
						for dcol := range m[0] {
							if m[drow][dcol] == '#' {
								img[row+drow] = utils.ReplaceAtIndex(img[row+drow], 'O', col+dcol)
							}
						}
					}
				}
			}
		}
	}

	for row := range img {
		for col := range img[0] {
			if img[row][col] == '#' {
				count++
			}
		}
	}
	fmt.Println("Part 2: ", count)
}
