package utils

import (
	"bufio"
	"os"
	"strconv"
	"strings"
)

// ScanLine takes a file name and calls f for each line of the file
func ScanLine(filename string, f func(string)) error {
	file, err := os.Open(filename)
	if err != nil {
		return err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		f(scanner.Text())
	}

	return scanner.Err()
}

// ScanGroup takes a file name and calls f for group for consecutive non empty lines
func ScanGroup(filename string, f func([]string)) error {
	file, err := os.Open(filename)
	if err != nil {
		return err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	var groupLines []string
	for scanner.Scan() {
		s := scanner.Text()
		if s == "" {
			if groupLines != nil {
				f(groupLines)
			}
			groupLines = nil
		} else {
			groupLines = append(groupLines, s)
		}
	}
	if groupLines != nil {
		f(groupLines)
	}

	return scanner.Err()
}

func Lines(filename string) []string {
	var lines []string
	ScanLine(filename, func(line string) {
		lines = append(lines, line)
	})
	return lines
}

func ScanNumbers(filename, delim string) []int {
	var nums []int
	ScanLine(filename, func(line string) {
		for _, i := range strings.Split(line, delim) {
			v, _ := strconv.Atoi(i)
			nums = append(nums, v)
		}
	})
	return nums
}
