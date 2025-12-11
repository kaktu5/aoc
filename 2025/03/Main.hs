module Main where

import Data.Char (digitToInt)
import Data.Functor ((<&>))
import Data.List (elemIndex)
import Data.Maybe (fromMaybe)
import Data.Ord (comparing)
import Flow

parseInput :: String -> [[Int]]
parseInput = lines .> map (map digitToInt)

maxJoltage :: Int -> [Int] -> Int
maxJoltage = go
 where
  go 0 _ = 0
  go _ [] = 0
  go remaining available =
    let lookAhead = length available - remaining + 1
        candidates = take lookAhead available
        maxDigit = maximum candidates
        maxPos = fromMaybe 0 <| elemIndex maxDigit candidates
        rest = drop (maxPos + 1) available
     in maxDigit * (10 ^ (remaining - 1)) + go (remaining - 1) rest

solvePart1 :: [[Int]] -> Int
solvePart1 = map (maxJoltage 2) .> sum

solvePart2 :: [[Int]] -> Int
solvePart2 = map (maxJoltage 12) .> sum

main :: IO ()
main = do
  input <- readFile "input" <&> parseInput
  let part1 = solvePart1 input
  let part2 = solvePart2 input
  putStrLn <| "Part 1: " ++ show part1
  putStrLn <| "Part 2: " ++ show part2
