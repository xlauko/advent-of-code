package utils

// CountIf counts number of elements satisfying predicate
func CountIf(arr []int, pred func(int) bool) int {
	res := 0
	for _, count := range arr {
		if pred(count) {
			res++
		}
	}
	return res
}

// Sum values of arr
func Sum(arr []int) int {
	res := 0
	for _, val := range arr {
		res += val
	}
	return res
}

// Max of arr
func Max(arr []int) int {
	res := arr[0]
	for _, val := range arr {
		if val > res {
			res = val
		}
	}
	return res
}

// Min of arr
func Min(arr []int) int {
	res := arr[0]
	for _, val := range arr {
		if val < res {
			res = val
		}
	}
	return res
}
