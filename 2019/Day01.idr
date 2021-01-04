module Day01

import System.File
import Data.Strings

import AoC.Util

requireFuel : (mass : Int) -> (fuel : Int)
requireFuel mass = (div mass 3) - 2

requireFuelRec : (mass : Int) -> (fuel : Int)
requireFuelRec mass
  = let fuel = requireFuel mass in
    if fuel > 0 then fuel + (requireFuelRec fuel) else 0

sumFuel : (Int -> Int) -> (List Int) -> Int
sumFuel fuel modules = sum $ fuel <$> modules

partial main : IO ()
main = do
  assert     2 (requireFuel 12)
  assert     2 (requireFuel 14)
  assert   654 (requireFuel 1969)
  assert 33583 (requireFuel 100756)

  assert     2 (requireFuelRec 12)
  assert   966 (requireFuelRec 1969)
  assert 50346 (requireFuelRec 100756)

  (Right contents) <- readFile "input.txt"
  let modules = ints $ lines contents
  putStrLn $ "Part 1: " ++ (show $ sumFuel requireFuel modules)
  putStrLn $ "Part 2: " ++ (show $ sumFuel requireFuelRec modules)
