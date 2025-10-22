{-# LANGUAGE LambdaCase #-}

module Main where

import Control.Arrow ((>>>))
import Data.Function ((&))
import Data.List (sortOn)
import Data.List.Split (splitOn)
import Data.Ord (Down (..))

elfTotals :: String -> [Int]
elfTotals =
  splitOn "\n\n"
    >>> map (lines >>> map read >>> sum)
    >>> sortOn Down

solve :: String -> (Int, Int)
solve input =
  elfTotals input & \case
    sorted@(x : _) -> (x, sum $ take 3 sorted)
    [] -> (0, 0)

main :: IO ()
main = do
  input <- readFile "input"
  let (part1, part2) = solve input
  putStrLn $ "Part 1: " ++ show part1
  putStrLn $ "Part 2: " ++ show part2
