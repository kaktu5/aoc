{-# LANGUAGE LambdaCase #-}

module Part1 where

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
      half = length s `div` 2
   in even (length s) && take half s == drop half s

invalidInRange :: (Int, Int) -> [Int]
invalidInRange (start, end) = filter isInvalid [start .. end]

solvePart1 :: [(Int, Int)] -> Int
solvePart1 = concatMap invalidInRange .> sum

main :: IO ()
main = do
  input <- readFile "input" <&> parseInput
  let part1 = solvePart1 input
  putStrLn <| "Part 1: " ++ show part1
