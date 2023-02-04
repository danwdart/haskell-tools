{
  nixpkgs ? import <nixpkgs> {},
  compiler ? "ghc94"
}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  haskell = nixpkgs.pkgs.haskell;
  haskellPackages = haskell.packages;
  lib = haskell.lib;
  ghc94 = haskellPackages.ghc944;
  ghc92 = haskellPackages.ghc92;
  ghc90 = haskellPackages.ghc90;
in
compiler: rec {
  ghc = haskellPackages.${compiler};
  defaultBuildTools = with ghc; [
    ghc92.apply-refact
    ghc92.cabal-install
    ghc92.doctest
    ghc92.ghci-dap
    ghc92.ghcid
    ghc92.ghcide
    ghc92.haskell-dap
    ghc92.haskell-debug-adapter
    ghc92.haskell-language-server
    ghc92.hasktags
    ghc92.hlint
    ghc92.hoogle
    ghc92.implicit-hie
    ghc92.krank
    #stan
    ghc92.stylish-haskell
    ghc92.weeder
  ];
  optionalBuildTools = with ghc; [
    ghc92.selenium-server-standalone
  ];
}
