package utils

import (
	"strconv"
	"strings"
)

func Digits(value int) []int {
	var digits []int
	for value != 0 {
		d := value % 10
		digits = append([]int{d}, digits...)
		value = value / 10
	}
	return digits
}

func InstToString(values []int, delim string) string {
	strs := make([]string, len(values))
	for i, v := range values {
		strs[i] = strconv.Itoa(v)
	}
	return strings.Join(strs, delim)
}
