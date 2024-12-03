# Experimental!
Util ~ "utils.ua"

Input ← Util~ReadInput

Insts ← {"don't()""do()"}
Mask  ← ↘1\(↥0↧1+)⊂1/-⊞≍Insts

Regex ← ⬚@0regex $ mul\((\d+),(\d+)\)|do\(\)|don't\(\)

Parse ← ≡°⊂ Regex
Mul   ← /×∵⋕⍉

Part₁ ← /+Mul◌
Part₂ ← /+×⊓Mask Mul

⊟⊃Part₁Part₂ Parse Input
