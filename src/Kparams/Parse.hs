module Kparams.Parse where

-- word extracts the first "word" from the input,
-- returning the word itself and what's left.
-- We split on unquoted, unescaped spaces.
word :: String -> Maybe Char -> (String, String)
word []        _       = ([], [])

word (x:[])    Nothing = ([x], [])
word (' ':xs)  Nothing = ([], xs)
word ('\t':xs) Nothing = ([], xs)
word ('\n':xs) Nothing = ([], xs)
word (x:xs)    Nothing = (progress, rem)
  where quot = x == '"' || x == '\''
        (wurd, rem) = word xs (if quot then Just x else Nothing)
        progress = if quot then wurd else x:wurd

word ('\'':xs) (Just '\'') = word xs Nothing
word ('"':xs)  (Just '"')  = word xs Nothing
word (x:xs)    q           = (x:wurd, rem)
  where (wurd, rem) = word xs q


-- wordsplit splits a string into words, using `word`.
wordsplit :: String -> [String]
wordsplit "" = []
wordsplit s = wurd:(wordsplit rem)
  where (wurd, rem) = word s Nothing

-- var splits a string into a name-value pait at the first =.
var :: String -> (String, String)
var []       = ([], [])
var ('=':xs) = ([], xs)
var (x:xs)   = (x:vname, val)
  where (vname, val) = var xs


-- find takes a /proc/cmdline string and Maybe finds the desired param.
find :: String -> String -> Maybe String
find "" _      = Nothing
find _  ""     = Nothing
find want have = if length matching > 0
                 then (Just . snd) $ last matching
                 else Nothing
  where varpairs = map var (wordsplit have)
        isOurParam vp = want == fst vp
        matching = filter isOurParam varpairs
