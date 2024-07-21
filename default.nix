{
  nixpkgs ? import <nixpkgs> {},
  compiler ? "ghc910"
}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  haskellPackages = nixpkgs.haskellPackages;
in
compiler: rec {
  ghc = nixpkgs.haskell.packages.${compiler};
  defaultBuildTools = with haskellPackages; [
    apply-refact
    cabal-fmt
    cabal-install
    doctest
    ghci-dap
    ghcid
    ghcide
    haskell-dap
    haskell-debug-adapter
    haskell-language-server
    hasktags
    hlint
    hoogle
    hpack
    # hpack-convert # broken in all versions
    implicit-hie
    # krank # broken
    stack
    # stan # broken in all versions
    stylish-haskell
    weeder
  ];
  optionalBuildTools = with haskellPackages; [
    selenium-server-standalone
  ];
}
