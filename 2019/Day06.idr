module Day06

import System.File
import Data.Strings
import Data.List
import Data.List1
import Data.SortedMap
import Data.SortedSet
import AoC.Util

Planet : Type
Planet = String

Orbits : Type
Orbits = SortedMap Planet (List Planet)

Parents : Type
Parents = SortedMap Planet Planet

parse : String -> (String, String)
parse = break (== ')')

format : (String, String) -> (Planet, Planet)
format (a, b) = (a, (onString (drop 1)) b)

insertOrbit : Planet -> Planet -> Orbits -> Orbits
insertOrbit k v orbs with (lookup k orbs)
  insertOrbit k v orbs | Nothing = insert k [v] orbs
  insertOrbit k v orbs | Just planets = insert k (v :: planets) orbs

-- part 1 --
countOrbits : Orbits -> Nat -> Planet -> Nat
countOrbits orbs d planet with (lookup planet orbs)
  countOrbits orbs d planet | Nothing = d
  countOrbits orbs d planet | Just planets =
    (sum $ map (countOrbits orbs (d + 1)) planets) + d

-- part 2 --
path : Parents -> Planet -> List Planet
path parents planet with (lookup planet parents)
  path parents planet | Nothing = []
  path parents planet | Just parent = planet :: (path parents parent)


joinedpath : Parents -> Planet -> Planet -> SortedSet Planet
joinedpath parents a b = symDifference (pathset a) (pathset b) where
  pathset : Planet -> SortedSet Planet
  pathset from = SortedSet.fromList $ path parents from

transfers : Parents -> Planet -> Planet -> Nat
transfers parents a b = length $ SortedSet.toList $ joinedpath parents a b


partial main : IO ()
main = do
    (Right contents) <- readFile "input.txt"
    let pairs = map (format . parse) (lines contents)
    let orbs = foldr (uncurry insertOrbit) empty pairs
    putStrLn $ "Part 1: " ++ (show $ countOrbits orbs 0 "COM")
    
    let parents = SortedMap.fromList (map swap pairs)
    putStrLn $ "Part 2: " ++ (show $ (transfers parents "YOU" "SAN") `minus` 2)
