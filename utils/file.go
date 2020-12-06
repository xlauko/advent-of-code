package utils

import (
	"bufio"
	"os"
)

// ScanLine takes a file name and calls f for each line of the file
func ScanLine(filename string, f func(string) error) error {
	file, err := os.Open(filename)
	if err != nil {
		return err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		if err := f(scanner.Text()); err != nil {
			return err
		}
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
