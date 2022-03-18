{
  haskellUpdates ? import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/haskell-updates.tar.gz") {},
  master ? import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {}
}:
let
  gitignore = haskellUpdates.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  haskell = haskellUpdates.pkgs.haskell;
  haskellPackages = haskell.packages;
  lib = haskell.lib;
  ghc922 = haskellPackages.ghc922;
  ghc902 = haskellPackages.ghc902;
in
compiler: rec {
  ghc = haskellPackages.${compiler};
  availableBuildTools = with ghc922; {
    apply-refact = lib.dontHaddock ghc902.apply-refact;
    cabal-install = lib.dontHaddock cabal-install;
    doctest = lib.dontHaddock doctest;
    ghci-dap = lib.dontHaddock ghci-dap;
    ghcid = lib.dontHaddock ghcid;
    ghcide = lib.dontHaddock ghcide;
    haskell-dap = lib.dontHaddock haskell-dap;
    haskell-debug-adapter = lib.dontHaddock haskell-debug-adapter;
    haskell-language-server = lib.dontHaddock haskell-language-server;
    hasktags = lib.dontHaddock hasktags;
    hlint = lib.dontHaddock hlint;
    implicit-hie = lib.dontHaddock implicit-hie;
    krank = lib.dontHaddock master.haskellPackages.krank;
    selenium-server-standalone = master.selenium-server-standalone;
    stan = lib.dontHaddock master.haskellPackages.stan;
    stylish-haskell = lib.dontHaddock master.haskellPackages.stylish-haskell;
    weeder = lib.dontHaddock ghc902.weeder;
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
