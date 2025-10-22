{-# LANGUAGE LambdaCase #-}

module Common where

import Control.Arrow ((>>>))
import Data.Function ((&))

data Opponent = A | B | C deriving (Eq, Read, Show)

data SecondCol = X | Y | Z deriving (Eq, Read, Show)

data Shape = Rock | Paper | Scissors deriving (Eq, Show)

data Outcome = Loss | Draw | Win deriving (Eq, Show)

data Round = Round Opponent SecondCol deriving (Show)

opponentShape :: Opponent -> Shape
opponentShape = \case
  A -> Rock
  B -> Paper
  C -> Scissors

shapeScore :: Shape -> Int
shapeScore = \case
  Rock -> 1
  Paper -> 2
  Scissors -> 3

gameOutcome :: Shape -> Shape -> Outcome
gameOutcome opponent player
  | opponent == player = Draw
  | (opponent, player) `elem` wins = Win
  | otherwise = Loss
 where
  wins = [(Rock, Paper), (Paper, Scissors), (Scissors, Rock)]

outcomeScore :: Outcome -> Int
outcomeScore = \case
  Loss -> 0
  Draw -> 3
  Win -> 6

roundScore :: Shape -> Shape -> Int
roundScore opponentShape playerShape =
  shapeScore playerShape + (gameOutcome opponentShape playerShape & outcomeScore)

parseLine :: String -> Round
parseLine line = case words line of
  [opponent, column] -> Round (read opponent) (read column)
  _ -> error "Invalid input"

parseInput :: String -> [Round]
parseInput =
  lines
    >>> filter (not . null)
    >>> map parseLine
