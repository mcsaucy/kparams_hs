{ mkDerivation, base, HUnit, stdenv }:
mkDerivation {
  pname = "kparams-hs";
  version = "0.1.0.1";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  libraryHaskellDepends = [ base ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [ base HUnit ];
  doHaddock = false;
  description = "Parses values from /proc/cmdline";
  license = stdenv.lib.licenses.mit;
}
