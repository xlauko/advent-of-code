package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
)

func sumTwo(nums []int) int {
	for _, a := range nums {
		for _, b := range nums {
			if a+b == 2020 {
				return a * b
			}
		}
	}

	return -1
}

func sumThree(nums []int) int {
	for _, a := range nums {
		for _, b := range nums {
			for _, c := range nums {
				if a+b+c == 2020 {
					return a * b * c
				}
			}
		}
	}

	return -1
}

func main() {
	file, err := os.Open("big.txt")
	if err != nil {
		log.Fatal(err)
	}

	defer file.Close()

	scanner := bufio.NewScanner(file)
	scanner.Split(bufio.ScanWords)
	var nums []int
	for scanner.Scan() {
		num, _ := strconv.Atoi(scanner.Text())
		nums = append(nums, num)
	}

	fmt.Println(sumTwo(nums))
	fmt.Println(sumThree(nums))
}
