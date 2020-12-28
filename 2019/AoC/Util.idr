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

-- input parsers

export
ints : (lines : List String) -> List Int
ints lines = catMaybes $ parsePositive <$> lines

