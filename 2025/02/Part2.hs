{-# LANGUAGE LambdaCase #-}

module Part2 where

import Data.Functor ((<&>))
import Data.List (isInfixOf)
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
isInvalid = show .> \s -> s `isInfixOf` drop 1 (init <| s ++ s)

invalidInRange :: (Int, Int) -> [Int]
invalidInRange (start, end) = filter isInvalid [start .. end]

solve :: [(Int, Int)] -> Int
solve = sum <. concatMap invalidInRange

main :: IO ()
main = do
  input <- readFile "input" <&> parseInput
  let part2 = solve input
  putStrLn <| "Part 2: " ++ show part2
