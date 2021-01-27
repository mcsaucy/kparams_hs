module Main where

import Kparams.Parse

main :: IO ()
main =
  putStrLn $ "root: " ++ case (find "root" txt) of
                           Nothing -> "nil"
                           Just p -> p
  where txt = "root=foo'bar baz' lol this is great"
        split = wordsplit txt
