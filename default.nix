{
  haskellUpdates ? import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/haskell-updates.tar.gz") {},
  master ? import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {}
}:
let
  gitignore = haskellUpdates.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  haskell = haskellUpdates.pkgs.haskell;
  haskellPackages = haskell.packages;
  lib = haskell.lib;
  ghc921 = haskellPackages.ghc921;
  ghc902 = haskellPackages.ghc902;
in
compiler: rec {
  ghc = haskellPackages.${compiler};
  availableBuildTools = with ghc921; {
    apply-refact = ghc902.apply-refact;
    cabal-install = cabal-install;
    doctest = doctest;
    ghci-dap = ghci-dap;
    ghcid = ghcid;
    ghcide = ghcide;
    haskell-dap = haskell-dap;
    haskell-debug-adapter = haskell-debug-adapter;
    haskell-language-server = haskell-language-server;
    hasktags = hasktags;
    hlint = hlint;
    implicit-hie = implicit-hie;
    krank = master.haskellPackages.krank;
    selenium-server-standalone = master.selenium-server-standalone;
    stan = master.haskellPackages.stan;
    stylish-haskell = master.haskellPackages.stylish-haskell;
    weeder = ghc902.weeder;
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
