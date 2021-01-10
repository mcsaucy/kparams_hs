import qualified Data.List as L

quoted x = '"':x ++ ['"']
esc x = '\\':x
escQuoted x = quoted ( esc "\"" ++ x ++ esc "\"" )

whitespace = [' ', '\t', '\n']

join :: [String] -> String -> String
join [] _ = ""
join (x:[]) _ = x
join (x:xs) d = x ++ d ++ join xs d

testData = join [
  "bare",
  "unquoted=foo",
  "quoted2=" ++ quoted "bar",
  "quoted=" ++ quoted "bar",
  "escape.quoted=" ++ escQuoted "baz",
  "escape.unquoted=" ++ "left" ++ esc " " ++ "right"
  ] " "

data Context = Context { squote :: Bool
                       , dquote :: Bool
                       , escape :: Bool
                       --, progress :: Int
                       , outside :: Bool} deriving Show

updateCtx :: Context -> Char -> Context

updateCtx Context{ squote=False
                 , dquote=False
                 -- , nameMatchProgress=prog
                 , escape=False} cur =
  Context False False False (cur `elem` whitespace)
updateCtx ctx '\'' = ctx { squote = not ( squote ctx ) }
updateCtx ctx '"'  = ctx { dquote = not ( dquote ctx ) }
updateCtx ctx '\\' = ctx { escape = not ( escape ctx ) }

_begin :: Context -> String -> String -> Int
-- TODO: make our "we can't find this" suck less
_begin _ [] _ = minBound
_begin ctx (x:xs) needle
  -- | outside ctx && x == needle !! (progress ctx) = 
  -- | head haystack == need !! (ctx nameMatchProgress)
  -- TODO: ensure we don't overmatch; if needle == "foo", we'll match "foobar"
  | outside ctx && L.isPrefixOf needle (x:xs) = 0
  | otherwise = 1 + _begin (updateCtx ctx x) xs needle

_find :: Context -> String -> String -> Int
-- TODO: make our "we can't find this" suck less
_find _ [] _ = minBound
_find ctx (x:xs) needle
  -- | outside ctx && x == needle !! (progress ctx) = 
  -- | head haystack == need !! (ctx nameMatchProgress)
  -- TODO: ensure we don't overmatch; if needle == "foo", we'll match "foobar"
  | outside ctx && L.isPrefixOf needle (x:xs) = 0
  | otherwise = 1 + _begin (updateCtx ctx x) xs needle

_end :: Context -> String -> Int
_end _ [] = 0
_end _ (_:[]) = 1
_end Context{outside=True} _ = -1 -- just skidded past our end, roll it back one
_end ctx (x:xs) = 1 + _end (updateCtx ctx x) xs
  where inParam = squote ctx || dquote ctx || escape ctx

begin :: String -> String -> Int
begin haystack needle = _begin (Context False False False True) haystack needle

end :: String -> Int
end s = _end (Context False False False False) s

pad x | x < 0 = "?"
      | x == 0 = ""
      | otherwise = ' ': pad (x - 1)

main :: IO ()
main = do
  let prnt x = putStrLn (pad (begin testData x) ++ x)
      start = begin testData "unquoted"
      dropped = drop start testData
      finish = end dropped
  putStrLn (show finish)
  putStrLn ("[" ++ (take finish dropped) ++ "]")
  
  putStrLn testData
  prnt "bare"
  prnt "unquoted"
  prnt "quoted"
  prnt "escape.quoted"
  prnt "escape.unquoted"
  prnt "dne"
  putStrLn (show ( splitAt 3 "abcdefg" ) )
