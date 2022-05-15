{
  nixpkgs ? import <nixpkgs> {},
  unstable ? import <unstable> {},
  haskellUpdates ? import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {},
  master ? import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {}
}:
let
  gitignore = master.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  haskell = master.pkgs.haskell;
  haskellPackages = haskell.packages;
  lib = haskell.lib;
  ghc922 = haskellPackages.ghc922;
  ghc902 = haskellPackages.ghc902;
in
compiler: rec {
  ghc = haskellPackages.${compiler};
  availableBuildTools = with ghc922; {
    # Cached in HU
    cabal-install           = cabal-install;
    doctest                 = doctest;
    ghcide                  = ghcide;
    haskell-language-server = haskell-language-server;
    hlint                   = hlint;
    implicit-hie            = implicit-hie;
    # Cached in HU with 9.0.2
    apply-refact = ghc902.apply-refact;
    weeder       = ghc902.weeder;
    # Cached only in unstable built with 9.2.2
    ghci-dap    = unstable.haskell.packages.ghc922.ghci-dap; # 0.0.17.0 in both?
    haskell-dap = unstable.haskell.packages.ghc922.haskell-dap; # 0.0.15.0 in both?
    # Cached only in unstable built with 9.0.2
    stylish-haskell       = unstable.haskell.packages.ghc902.stylish-haskell; # 0.14.0.1 whereas 0.14.1.0 in HU
    ghcid                 = unstable.haskell.packages.ghc902.ghcid; # 0.8.7-bin in unstable, 0.8.7 in HU
    hasktags              = unstable.haskell.packages.ghc902.hasktags; # 0.72.0 in both?
    haskell-debug-adapter = unstable.haskell.packages.ghc902.haskell-debug-adapter; # 0.0.35.0 in both?
    # Cached only on nixpkgs with ghc 8.10.7
    krank = nixpkgs.haskell.packages.ghc8107.krank;
    stan  = nixpkgs.haskell.packages.ghc8107.stan;
    # Other tools
    selenium-server-standalone = unstable.selenium-server-standalone;
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
