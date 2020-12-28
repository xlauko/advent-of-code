package utils

import "math"

type Vec2 struct {
	X, Y float64
}

func (self *Vec2) Add(other Vec2) {
	self.X += other.X
	self.Y += other.Y
}

func (self *Vec2) Sub(other Vec2) {
	self.X -= other.X
	self.Y -= other.Y
}

func (self *Vec2) Mul(other float64) {
	self.X *= other
	self.Y *= other
}

func (self Vec2) Dot(other Vec2) float64 {
	return self.X*other.X + self.Y*other.Y
}

func (self Vec2) Cross(other Vec2) float64 {
	return self.X*other.Y - self.Y*other.X
}

func (self Vec2) LengthSquared() float64 {
	return self.X*self.X + self.Y*self.Y
}

func (self Vec2) Length() float64 {
	return math.Sqrt(self.LengthSquared())
}

func (self Vec2) ManhattanLength() float64 {
	return math.Abs(self.X) + math.Abs(self.Y)
}

func (self *Vec2) Normalize() {
	self.Mul(1 / self.Length())
}

func (self Vec2) Normalized() Vec2 {
	return Mul(self, 1/self.Length())
}

func (v Vec2) Plus(v2 Vec2) Vec2 {
	return Add(v, v2)
}

func (v Vec2) Minus(v2 Vec2) Vec2 {
	return Sub(v, v2)
}

func (v Vec2) Times(r float64) Vec2 {
	return Mul(v, r)
}

func Add(v, u Vec2) Vec2 {
	return Vec2{v.X + u.X, v.Y + u.Y}
}

func Sub(v, u Vec2) Vec2 {
	return Vec2{v.X - u.X, v.Y - u.Y}
}

func Mul(v Vec2, r float64) Vec2 {
	return Vec2{v.X * r, v.Y * r}
}
