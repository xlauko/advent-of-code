# Experimental!
Util ~ "utils.ua"

Input ← Util~ReadInput

StepInRange ← /×/≠⊞<1_4⌵
IsSafe ← ×⊃(StepInRange|Util~Deltas)≡/-◫2

Part₁ ← /+≡◇IsSafe Util~ParseNumbers
Part₂ ← /+≡◇(/↥≡(IsSafe⍜↻↘₁)⊙¤°⊏) Util~ParseNumbers

⊟⊃Part₁Part₂ Input
