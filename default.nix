{
  nixpkgs ? import <nixpkgs> {},
  unstable ? import <unstable> {},
  haskellUpdates ? import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/haskell-updates.tar.gz") {},
  master ? import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {}
}:
let
  gitignore = unstable.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  haskell = haskellUpdates.pkgs.haskell;
  haskellPackages = haskell.packages;
  lib = haskell.lib;
  ghc923 = haskellPackages.ghc923;
  ghc902 = haskellPackages.ghc902;
in
compiler: rec {
  ghc = haskellPackages.${compiler};
  availableBuildTools = with ghc923; {
    # Currently selected
    ghcide                      = ghc.ghcide;
    cabal-install               = ghc.cabal-install;
    # All other
    doctest                     = doctest;
    implicit-hie                = implicit-hie;
    weeder                      = weeder;
    ghci-dap                    = ghci-dap;
    haskell-dap                 = haskell-dap;
    haskell-language-server     = ghc902.haskell-language-server;
    hlint                       = ghc902.hlint;
    apply-refact                = ghc902.apply-refact;
    stylish-haskell             = unstable.haskell.packages.ghc902.stylish-haskell;
    ghcid                       = unstable.haskell.packages.ghc902.ghcid;
    hasktags                    = unstable.haskell.packages.ghc902.hasktags;
    haskell-debug-adapter       = unstable.haskell.packages.ghc902.haskell-debug-adapter;
    krank                       = null; # nixpkgs.haskell.packages.ghc8107.krank;
    stan                        = null; # nixpkgs.haskell.packages.ghc8107.stan;
    selenium-server-standalone  = unstable.selenium-server-standalone;
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
