module AoC.Util

import Data.Strings
import Data.List

%default total

export
assert : (Eq a, Show a) => (expected : a) -> (actual : a) -> IO ()
assert expected actual =
  if actual /= expected
    then putStrLn ("assertion failed: expected " ++ show expected ++ ", but was " ++ show actual)
    else pure ()

export
catMaybes : List (Maybe a) -> List a
catMaybes = mapMaybe id

export
groupBy : (a -> a -> Bool) -> List a -> List (List a)
groupBy _ [] = []
groupBy p list@(x :: xs) =
  let (ys, zs) = span (p x) xs in
    (x :: ys) :: groupBy p (assert_smaller list zs)

export
group : Eq a => List a -> List (List a)
group = groupBy (==)

export
swap : (a, b) -> (b, a)
swap (a, b) = (b, a)

export
pow : Num a => a -> Nat -> a
pow _  0  = 1
pow x (S n) = x * (pow x n)

export
digit : Nat -> Int -> Int
digit d n = n `div` (pow 10 d) `mod` 10

-- string helpers

export
onString : ((List Char) -> (List Char)) -> (String -> String)
onString f = pack . f . unpack

-- input parsers

export
ints : (Functor listlike) => listlike String -> listlike Int
ints = map cast

