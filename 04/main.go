package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

type void struct{}

var member void

func validFields(fields []string) bool {
	expected := map[string]void{
		"byr": member, "iyr": member, "eyr": member,
		"hgt": member, "hcl": member, "ecl": member,
		"pid": member}
	for _, field := range fields {
		key := strings.Split(field, ":")[0]
		delete(expected, key)
	}
	return len(expected) == 0
}

func isInRange(val string, low, high int) bool {
	num, _ := strconv.Atoi(val)
	return num >= low && num <= high
}

func splitField(field string) (string, string) {
	vals := strings.Split(field, ":")
	return vals[0], vals[1]
}

var (
	eyes = map[string]void{
		"amb": member, "blu": member, "brn": member,
		"gry": member, "grn": member, "hzl": member,
		"oth": member}
)

func validField(key, val string) bool {
	switch key {
	case "byr":
		return isInRange(val, 1920, 2002)
	case "iyr":
		return isInRange(val, 2010, 2020)
	case "eyr":
		return isInRange(val, 2020, 2030)
	case "hgt":
		if strings.HasSuffix(val, "cm") {
			return isInRange(strings.TrimSuffix(val, "cm"), 150, 193)
		}
		if strings.HasSuffix(val, "in") {
			return isInRange(strings.TrimSuffix(val, "in"), 59, 76)
		}
		return false
	case "hcl":
		if len(val) != 7 {
			return false
		}

		if val[0] != '#' {
			return false
		}

		if _, err := strconv.ParseUint(val[1:3], 16, 8); err != nil {
			return false
		}
		if _, err := strconv.ParseUint(val[3:5], 16, 8); err != nil {
			return false
		}
		if _, err := strconv.ParseUint(val[5:7], 16, 8); err != nil {
			return false
		}
		return true
	case "ecl":
		_, found := eyes[val]
		return found
	case "pid":
		if len(val) != 9 {
			return false
		}

		_, err := strconv.Atoi(val)
		return err == nil
	}
	return true
}

func validValues(fields []string) bool {

	for _, field := range fields {
		key, val := splitField(field)
		if !validField(key, val) {
			return false
		}
	}
	return true
}

func main() {
	file, err := os.Open("big.txt")
	if err != nil {
		log.Fatal(err)
	}

	defer file.Close()

	scanner := bufio.NewScanner(file)

	count1 := 0
	count2 := 0
	for scanner.Scan() {
		fields := strings.Fields(scanner.Text())
		if validFields(fields) {
			count1++
			if validValues(fields) {
				count2++
			}
		}
	}
	fmt.Println("Part 1: ", count1)
	fmt.Println("Part 1: ", count2)
}
