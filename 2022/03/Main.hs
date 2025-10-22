{-# LANGUAGE LambdaCase #-}

module Common where

import Control.Arrow ((>>>))
import Data.Char (isLower, isUpper, ord)
import Data.Function ((&))
import Data.List (intersect)

import qualified Data.Set as Set

data Rucksack = Rucksack String String deriving (Show)

parseRucksack :: String -> Rucksack
parseRucksack line =
  let
    len = length line
    half = len `div` 2
    (first, second) = splitAt half line
   in
    Rucksack first second

commonItem :: Rucksack -> Char
commonItem (Rucksack first second) =
  Set.fromList first
    `Set.intersection` Set.fromList second
    & Set.elemAt 0

priority :: Char -> Int
priority c
  | isLower c = ord c - ord 'a' + 1
  | isUpper c = ord c - ord 'A' + 27
  | otherwise = error "Invalid item"

solve :: String -> Int
solve =
  lines
    >>> filter (not . null)
    >>> map parseRucksack
    >>> map commonItem
    >>> map priority
    >>> sum

main :: IO ()
main = do
  input <- readFile "input"
  putStrLn $ "Part 1: " ++ show (solve input)
