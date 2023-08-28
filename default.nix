{
  nixpkgs ? import <nixpkgs> {},
  compiler ? "ghc94"
}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  haskellPackages = nixpkgs.haskellPackages;
in
compiler: rec {
  ghc = nixpkgs.haskell.packages.${compiler};
  defaultBuildTools = with haskellPackages; [
    apply-refact
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
    implicit-hie
    krank
    #stan
    stylish-haskell
    weeder
  ];
  optionalBuildTools = with haskellPackages; [
    selenium-server-standalone
  ];
}
