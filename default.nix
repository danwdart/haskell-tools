{
  nixpkgs ? import <nixpkgs> {},
  compiler ? "ghc924"
}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  haskell = nixpkgs.pkgs.haskell;
  haskellPackages = haskell.packages;
  lib = haskell.lib;
  ghc902 = haskellPackages.ghc902;
in
compiler: rec {
  ghc = haskellPackages.${compiler};
  availableBuildTools = with ghc; {
    apply-refact                = ghc902.apply-refact;
    cabal-install               = cabal-install;
    doctest                     = doctest;
    ghcid                       = ghcid;
    ghcide                      = ghc902.ghcide;
    ghci-dap                    = ghci-dap;
    haskell-dap                 = haskell-dap;
    haskell-debug-adapter       = haskell-debug-adapter;
    haskell-language-server     = ghc902.haskell-language-server;
    hasktags                    = hasktags;
    hlint                       = hlint;
    implicit-hie                = implicit-hie;
    krank                       = null; # krank;
    selenium-server-standalone  = selenium-server-standalone;
    stan                        = null; # stan;
    stylish-haskell             = ghc902.stylish-haskell;
    weeder                      = null; # weeder;
  };
  defaultBuildTools = with availableBuildTools; [
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
    implicit-hie
    krank
    stan
    stylish-haskell
    weeder
  ];
  optionalBuildTools = with availableBuildTools; [
    selenium-server-standalone
  ];
}
