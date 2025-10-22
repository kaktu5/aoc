{-# LANGUAGE LambdaCase #-}

module Part2 where

import Common (Outcome (..), Round (..), SecondCol (..), Shape (..), opponentShape, parseInput, roundScore)
import Control.Arrow ((>>>))
import Data.Function ((&))

desiredOutcome :: SecondCol -> Outcome
desiredOutcome = \case
  X -> Loss
  Y -> Draw
  Z -> Win

shapeForOutcome :: Shape -> Outcome -> Shape
shapeForOutcome oppShape desired = case (oppShape, desired) of
  (oppShape, Draw) -> oppShape
  (Rock, Win) -> Paper
  (Rock, Loss) -> Scissors
  (Paper, Win) -> Scissors
  (Paper, Loss) -> Rock
  (Scissors, Win) -> Rock
  (Scissors, Loss) -> Paper

solve :: String -> Int
solve =
  parseInput
    >>> map
      ( \(Round opp col) ->
          opponentShape opp
            & \oppShape -> roundScore oppShape $ shapeForOutcome oppShape $ desiredOutcome col
      )
    >>> sum