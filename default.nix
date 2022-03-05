{
  haskellUpdates ? import  (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/haskell-updates.tar.gz") {},
  master ? import  (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {}
}:
let
  gitignore = haskellUpdates.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  haskell = haskellUpdates.pkgs.haskell;
  haskellPackages = haskell.packages;
  lib = haskell.lib;
  ghc921 = haskellPackages.ghc921;
  ghc902 = haskellPackages.ghc902;
in compiler: with compiler; {
  haskellPackages = haskellPackages;
  ghc = haskellPackages.${compiler};
  availableBuildTools = [
    ghc902.apply-refact
    ghc921.cabal-install
    ghc921.doctest
    ghc921.ghci-dap
    ghc921.ghcid
    ghc921.ghcide
    ghc921.haskell-dap
    ghc921.haskell-debug-adapter
    ghc921.haskell-language-server
    ghc921.hasktags
    ghc921.hlint
    ghc921.implicit-hie
    master.haskellPackages.krank
    master.haskellPackages.stan
    master.haskellPackages.stylish-haskell
    ghc902.weeder
  ];
  optionalBuildTools = with nixpkgs; [
    # selenium-server
  ];
}