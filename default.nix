{
  nixpkgs ? import <nixpkgs> {},
  compiler ? "ghc910"
}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  lib = nixpkgs.haskell.lib;
  haskellPackages = nixpkgs.haskellPackages;
  perCompiler = {
    ghc94 = {
      krank = nixpkgs.haskell.packages.ghc94.callCabal2nix "krank" (builtins.fetchGit {
        url = "https://github.com/guibou/krank.git";
        ref = "main";
      }) {};
      stylish-haskell = nixpkgs.haskell.packages.ghc94.stylish-haskell;
    };
    ghc98 = {
      krank = nixpkgs.haskell.packages.ghc98.callCabal2nix "krank" (builtins.fetchGit {
        url = "https://github.com/guibou/krank.git";
        ref = "main";
      }) {};
      stylish-haskell = nixpkgs.haskell.packages.ghc98.stylish-haskell;
    };
    ghc910 = {
      krank = (nixpkgs.haskell.packages.ghc910.override {
        overrides = self: super: rec {
          pcre-heavy = lib.dontCheck super.pcre-heavy;
          PyF = lib.dontCheck super.PyF;
        };
      }).callCabal2nix "krank" (builtins.fetchGit {
        url = "https://github.com/guibou/krank.git";
        ref = "main";
      }) {};
      stylish-haskell = nixpkgs.haskell.lib.dontCheck (
        nixpkgs.haskell.packages.ghc910.callCabal2nix "stylish-haskell" (builtins.fetchGit {
          url = "https://github.com/jhrcek/stylish-haskell.git";
          ref = "jhrcek/ghc-9.10";
        }) {}
      );
    };
  };
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
    # (ghc.callCabal2nix "krank" (builtins.fetchGit {
    #   url = "https://github.com/yamadapc/hpack-convert.git";
    #   ref = "hpack-convert";
    # }) {}) # broken in all versions
    implicit-hie
    perCompiler.${compiler}.krank # broken
    stack
    stan # broken in all versions
    perCompiler.${compiler}.stylish-haskell
    weeder
  ];
  optionalBuildTools = with haskellPackages; [
    selenium-server-standalone
  ];
}
