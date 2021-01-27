module Main where

import System.Environment
import System.IO
import Control.Monad
import Kparams.Parse

argParse :: [String] -> (String, Maybe String)
argParse (name:[])     = (name, Nothing)
argParse (name:def:[]) = (name, Just def)
argParse _             = error "Usage: kparams param_name [default]"

kp :: String -> String -> Maybe String -> String
kp _       ""   _ = error "param_name must not be blank"
kp cmdline name def =
   case find name cmdline of
     Just v -> v
     Nothing -> case def of
                  Just d -> d
                  Nothing -> error $ name ++ " is not set"

main :: IO ()
main = do
  handle <- openFile "/proc/cmdline" ReadMode
  cmdline <- hGetContents handle
  args <- getArgs
  let (name, def) = argParse args
  putStrLn $ kp cmdline name def
