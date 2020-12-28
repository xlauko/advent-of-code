package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

func valid1(password string, letter rune, low, high int) bool {
	count := 0
	for _, c := range password {
		if c == letter {
			count++
		}
	}

	return count >= low && count <= high
}

func valid2(password string, letter byte, low, high int) bool {
	return (password[low-1] == letter) != (password[high-1] == letter)
}

func main() {
	file, err := os.Open("big.txt")
	if err != nil {
		log.Fatal(err)
	}

	defer file.Close()

	count1 := 0
	count2 := 0
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := strings.Fields(scanner.Text())

		bounds := strings.Split(line[0], "-")
		lower, _ := strconv.Atoi(bounds[0])
		upper, _ := strconv.Atoi(bounds[1])
		letter := line[1][0]
		password := line[2]

		if valid1(password, rune(letter), lower, upper) {
			count1++
		}

		if valid2(password, letter, lower, upper) {
			count2++
		}
	}
	fmt.Println("Part 1: ", count1)
	fmt.Println("Part 2: ", count2)
}
