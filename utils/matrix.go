package utils

import "math"

type Matrix [6]float64

var IdentitY Matrix = Matrix{
	1, 0, 0,
	0, 1, 0,
}

func Rotation(a float64) Matrix {
	sin := math.Sin(a * math.Pi / 180)
	cos := math.Cos(a * math.Pi / 180)
	return Matrix{
		cos, -sin, 0,
		sin, cos, 0,
	}
}

func DiscreteRotation(a float64) Matrix {
	sin := math.RoundToEven(math.Sin(a * math.Pi / 180))
	cos := math.RoundToEven(math.Cos(a * math.Pi / 180))
	return Matrix{
		cos, -sin, 0,
		sin, cos, 0,
	}
}

func Translation(v Vec2) Matrix {
	return Matrix{
		1, 0, v.X,
		0, 1, v.Y,
	}
}

func Scale(x, y float64) Matrix {
	return Matrix{
		x, 0, 0,
		0, y, 0,
	}
}

func (m Matrix) Transform(v Vec2) Vec2 {
	return Vec2{
		m[0]*v.X + m[1]*v.Y + m[2],
		m[3]*v.X + m[4]*v.Y + m[5],
	}
}

func (m Matrix) TransformDirection(v Vec2) Vec2 {
	return Vec2{
		m[0]*v.X + m[1]*v.Y,
		m[3]*v.X + m[4]*v.Y,
	}
}

func (m Matrix) Mulf(r float64) Matrix {
	for i := range m {
		m[i] *= r
	}
	return m
}

func (m Matrix) Mul(n Matrix) Matrix {
	return Matrix{
		m[0]*n[0] + m[1]*n[3], m[0]*n[1] + m[1]*n[4], m[0]*n[2] + m[1]*n[5] + m[2],
		m[3]*n[0] + m[4]*n[3], m[3]*n[1] + m[4]*n[4], m[3]*n[2] + m[4]*n[5] + m[5],
	}
}

func (m Matrix) Inverse() Matrix {
	return Matrix{
		m[4], -m[1], m[1]*m[5] - m[2]*m[4],
		-m[3], m[0], m[2]*m[3] - m[0]*m[5],
	}.Mulf(1 / (m[0]*m[4] - m[1]*m[3]))
}

func (m Matrix) To32() [6]float32 {
	n := [6]float32{}
	for i, f64 := range m {
		n[i] = float32(f64)
	}
	return n
}
