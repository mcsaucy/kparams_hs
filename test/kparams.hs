import Test.HUnit
import System.Exit
import Kparams.Parse
cases' = [
  "simple"
    ~: "find BOOT_IMAGE BOOT_IMAGE=..."
    ~: Just "blahblah"
    ~=? (find "BOOT_IMAGE" "BOOT_IMAGE=blahblah"),
  "simple"
    ~: "find NOTHING BOOT_IMAGE=..."
    ~: Nothing
    ~=? (find "NOTHING" "BOOT_IMAGE=blahblah"),
  "multi"
    ~: "find SOMETHING \"BOOT_IMAGE=... SOMETHING\""
    ~: Just ""
    ~=? (find "SOMETHING" "BOOT_IMAGE=blahblah SOMETHING"),
  "multi"
    ~: "find SOMETHING \"BOOT_IMAGE=... SOMETHING=...\""
    ~: Just "foo"
    ~=? (find "SOMETHING" "BOOT_IMAGE=blahblah SOMETHING=foo"),
  "quoting"
    ~: "find foobar foobar='foo bar'"
    ~: Just "foo bar"
    ~=? (find "foobar" "foobar='foo bar'"),
  "quoting"
    ~: "find foobar foobar=\"foo bar\""
    ~: Just "foo bar"
    ~=? (find "foobar" "foobar=\"foo bar\""),
  "quoting never closed"
    ~: "find foobar foobar=\"foo bar"
    ~: Just "foo bar"
    ~=? (find "foobar" "foobar=\"foo bar"),
  "quoting weirdly embedded"
    ~: "find foobar foobar=fo\"o b\"ar"
    ~: Just "foo bar"
    ~=? (find "foobar" "foobar=fo\"o b\"ar"),
  "quoting weirdly embedded"
    ~: "find foobar foobar=foo\" \"bar"
    ~: Just "foo bar"
    ~=? (find "foobar" "foobar=foo\" \"bar")]
{- TODO(mcsaucy): add an escaping test case when we support it.
  "escaping"
    ~: "find foobar foobar=foo\\ bar"
    ~: Just "foo bar"
    ~=? (find "foobar" "foobar=foo\\ bar"),
-}

main :: IO()
main = do
    counts <- runTestTT (TestList cases')
    if (errors counts + failures counts == 0)
      then exitSuccess
      else exitFailure