{-# LANGUAGE LambdaCase #-}

module Main where

import qualified Part1 (solve)
import qualified Part2 (solve)

main :: IO ()
main = do
  input <- readFile "input"
  putStrLn $ "Part 1: " ++ show (Part1.solve input)
  putStrLn $ "Part 2: " ++ show (Part2.solve input)
