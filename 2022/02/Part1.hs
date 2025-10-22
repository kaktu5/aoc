{-# LANGUAGE LambdaCase #-}

module Part1 where

import Common (Round (..), SecondCol (..), Shape (..), opponentShape, parseInput, roundScore)
import Control.Arrow ((>>>))

playerShape :: SecondCol -> Shape
playerShape = \case
  X -> Rock
  Y -> Paper
  Z -> Scissors

solve :: String -> Int
solve =
  parseInput
    >>> map (\(Round opp player) -> roundScore (opponentShape opp) (playerShape player))
    >>> sum
