{ pkgs ? import <nixpkgs> {}
}:

pkgs.mkShell {
  name = "dev-environment";
  buildInputs = with pkgs; [
    ghc cabal-install
  ];

}
