module Day04

import Data.List
import AoC.Util

digits : Int -> List Char
digits = unpack . show

ascending : Int -> Bool
ascending = sorted . digits

adjacents : (Nat -> Bool) -> Int -> Bool
adjacents comp = any comp . map length . group . digits

valid : (Nat -> Bool) -> Int -> Bool
valid comp n = ascending n && adjacents comp n

countValid : (Int -> Bool) -> List Int -> Nat
countValid check = length . filter check

range : List Int
range = [183564..657474]

partial main : IO ()
main = do
    assert True  (valid (>=2) 111111)
    assert False (valid (>=2) 223450)
    assert False (valid (>=2) 123789)

    assert True  (valid (==2) 112233)
    assert False (valid (==2) 123444)
    assert True  (valid (==2) 111122)

    putStrLn $ "Part 1: " ++ (show $ countValid (valid (>=2)) range)
    putStrLn $ "Part 2: " ++ (show $ countValid (valid (==2)) range)
