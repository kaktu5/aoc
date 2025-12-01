module Main where

import Flow

dialMax = 100

dialStart = 50

parseInput :: String -> [Int]
parseInput =
  lines .> map parseLine
 where
  parseLine :: String -> Int
  parseLine ('R' : num) = read num
  parseLine ('L' : num) = negate <| read num
  parseLine line = error <| "Invalid input: " ++ show line

dialPositions :: [Int] -> [Int]
dialPositions = scanl rotateDial dialStart

rotateDial :: Int -> Int -> Int
rotateDial pos change = (pos + change) `mod` dialMax

solvePart1 :: [Int] -> Int
solvePart1 = dialPositions .> filter (== 0) .> length

solvePart2 :: [Int] -> Int
solvePart2 rotations =
  sum <| zipWith crossing (dialPositions rotations) rotations
 where
  crossing pos change
    | change >= 0 = (pos + change) `div` dialMax - pos `div` dialMax
    | otherwise = (pos - 1) `div` dialMax - (pos + change - 1) `div` dialMax

main :: IO ()
main = do
  input <- readFile "input"
  let
    rotations = parseInput input
    part1 = solvePart1 rotations
    part2 = solvePart2 rotations
  putStrLn <| "Part 1: " ++ show part1
  putStrLn <| "Part 2: " ++ show part2
