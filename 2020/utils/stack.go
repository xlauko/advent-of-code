package utils

type StringStack []string

func (self *StringStack) IsEmpty() bool {
	return len(*self) == 0
}

func (self *StringStack) Push(str string) {
	*self = append(*self, str)
}

func (self *StringStack) Top() string {
	index := len(*self) - 1
	return (*self)[index]
}

func (self *StringStack) Pop() string {
	index := len(*self) - 1
	element := (*self)[index]
	*self = (*self)[:index]
	return element
}

type IntStack []int

func (self *IntStack) IsEmpty() bool {
	return len(*self) == 0
}

func (self *IntStack) Push(val int) {
	*self = append(*self, val)
}

func (self *IntStack) Top() int {
	index := len(*self) - 1
	return (*self)[index]
}

func (self *IntStack) Pop() int {
	index := len(*self) - 1
	element := (*self)[index]
	*self = (*self)[:index]
	return element
}
