from z3 import *

s = Optimize()

ds = [Int(f'I{i}') for i in range(14)]

for d in ds:
    s.add(d > 0, d < 10)

a = [1,   1,  1,  1, 26, 1, 1, 26, 1, 26, 26, 26, 26, 26]
b = [13, 15, 15, 11, -7, 10, 10, -5, 15, -3, 0, -5, -9, 0]
c = [6,   6, 10,  2, 15, 8, 1, 10, 5, 3, 5, 11, 12, 10]

z = 0
for i in range(14):
    w = ds[i]
    x = (z % 26) + b[i]
    z = z / a[i]
    z = If(x != w, z * 26 + w + c[i], z)

value = 0
for d in ds:
    value = value * 10 + d

s.add(z == 0)
s.maximize(value)
print(s.check())
print(s.model().eval(value))
