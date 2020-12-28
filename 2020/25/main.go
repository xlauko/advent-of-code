package main

import (
	"fmt"
)

func findLoopSize(pub int) int {
	loops := 0
	num := 1
	for num != pub {
		num = (num * 7) % 20201227
		loops++
	}
	return loops
}

func getEncryptionKey(subject, loops int) int {
	num := 1
	for i := 0; i < loops; i++ {
		num = (num * subject) % 20201227
	}
	return num
}

func main() {
	cardPub := 5764801
	doorPub := 17807724
	cardLoopSize := findLoopSize(cardPub)
	fmt.Println("Part 1: ", getEncryptionKey(doorPub, cardLoopSize))
}
