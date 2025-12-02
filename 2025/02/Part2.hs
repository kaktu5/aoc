{-# LANGUAGE LambdaCase #-}

module Part2 where

import Data.Functor ((<&>))
import Data.List.Split (splitOn)
import Flow

parseInput :: String -> [(Int, Int)]
parseInput =
  splitOn ","
    .> map
      ( splitOn "-" .> \case
          [start, end] -> (read start, read end)
          _ -> error "Invalid input"
      )

isInvalid :: Int -> Bool
isInvalid n =
  let s = show n
      len = length s
   in [1 .. len `div` 2]
        |> any
          ( \plen ->
              len `mod` plen == 0
                && let repeats = len `div` plen
                       pattern = take plen s
                    in repeats >= 2 && s == concat (replicate repeats pattern)
          )

invalidInRange :: (Int, Int) -> [Int]
invalidInRange (start, end) = filter isInvalid [start .. end]

solve :: [(Int, Int)] -> Int
solve = sum <. concatMap invalidInRange

main :: IO ()
main = do
  input <- readFile "input" <&> parseInput
  let part2 = solve input
  putStrLn <| "Part 2: " ++ show part2
