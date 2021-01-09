module IntCode

import Data.Vect
import AoC.Util

data Mode
  = Abs -- absolute position
  | Imm -- immediate
  | Rel -- relative position
  | Inv -- invalid mode

Eq Mode where
  (==) Abs Abs = True
  (==) Imm Imm = True
  (==) Rel Rel = True
  (==) Inv Inv = True
  (==) _   _   = False

  (/=) x y = not (x == y)

Show Mode where
  show Abs = "Abs"
  show Imm = "Imm"
  show Rel = "Rel"
  show Inv = "Invalid"

mode : Nat -> Int -> Mode
mode m x = case digit (S m) x of
       0 => Abs
       1 => Imm
       2 => Rel
       _ => Inv

modes : Int -> (n : Nat) -> Vect n Mode
modes x 0 = []
modes x (S m) = mode (S m) x :: modes x m

data Opcode
  = Add (Vect 3 Mode)
  | Mul (Vect 3 Mode)
  | Hlt
  | Invalid

Show Opcode where
  show (Add modes) = "Add " ++ show modes
  show (Mul modes) = "Mul " ++ show modes
  show Hlt         = "Hlt"
  show Invalid     = "Invalid"

decode : Int -> Opcode
decode n = case (n `mod` 100) of
       1  => Add (modes n 3)
       2  => Mul (modes n 3)
       99 => Hlt
       _  => Invalid
