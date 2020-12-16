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

// FindIf element in arr
func FindIf(arr []int, pred func(int) bool) (int, int) {
	for idx, v := range arr {
		if pred(v) {
			return idx, v
		}
	}
	return -1, -1
}

func Find(arr []int, val int) (int, bool) {
	for i, v := range arr {
		if v == val {
			return i, true
		}
	}
	return 0, false
}

func Delete(arr []int, val int) []int {
	if i, found := Find(arr, val); found {
		return append(arr[:i], arr[i+1:]...)
	}
	return arr[:]
}
