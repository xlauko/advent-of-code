# Experimental!

&fras ⊣ &args
Input ←

Parse ← ⊜(□⊜⋕⊸≠@ )⊸≠@\n

IsMonotonic ← =1⧻◴±

StepInRange ← /×/≠⊞<1_4⌵

IsSafe ← ×⊃(StepInRange|IsMonotonic)≡/-◫2

Part₁ ← /+≡◇IsSafe Parse

Part₂ ← /+≡◇(/↥≡(IsSafe⍜↻↘₁)⊙¤°⊏) Parse

⊟⊃Part₁Part₂ Input
