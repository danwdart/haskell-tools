{
  nixpkgs ? import <nixpkgs> {},
  compiler ? "ghc910"
}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  lib = nixpkgs.haskell.lib;
  perCompiler = {
    ghc94 = let haskellPackages = nixpkgs.haskell.packages.ghc94; in {
      krank = haskellPackages.callCabal2nix "krank" (builtins.fetchGit {
        url = "https://github.com/guibou/krank.git";
        ref = "main";
      }) {};
      stylish-haskell = haskellPackages.stylish-haskell;
      ghci-dap = null;
      haskell-debug-adapter = null;
      cabal-install = null;
      stack = null;
      hlint = haskellPackages.hlint;
      weeder = haskellPackages.weeder;
      apply-refact = haskellPackages.apply-refact;
    };
    ghc910 = let haskellPackages = nixpkgs.haskell.packages.ghc910; in {
      krank = (haskellPackages.override {
        overrides = self: super: rec {
          pcre-heavy = lib.dontCheck super.pcre-heavy;
          PyF = lib.dontCheck super.PyF;
        };
      }).callCabal2nix "krank" (builtins.fetchGit {
        url = "https://github.com/guibou/krank.git";
        ref = "main";
      }) {};
      stylish-haskell = lib.dontCheck (
        haskellPackages.callCabal2nix "stylish-haskell" (builtins.fetchGit {
          url = "https://github.com/jhrcek/stylish-haskell.git";
          ref = "jhrcek/ghc-9.10";
        }) {}
      );
      ghci-dap = haskellPackages.ghci-dap;
      haskell-debug-adapter = haskellPackages.haskell-debug-adapter;
      cabal-install = haskellPackages.cabal-install;
      stack = lib.doJailbreak nixpkgs.haskell.packages.ghc98.stack; # 2024-11-09 not ready yet
      hlint = nixpkgs.haskell.packages.ghc98.hlint; # 2024-11-09 not ready yet
      weeder = lib.dontCheck (lib.doJailbreak haskellPackages.weeder); # 2024-11-09 not ready yet
      apply-refact = nixpkgs.haskell.packages.ghc98.apply-refact; # 2024-11-09 not ready yet
    };
  };
in
compiler: rec {
  # A lot of these packages must be built using the ghc version in use.
  haskellPackages = nixpkgs.haskell.packages.${compiler};
  defaultBuildTools = with haskellPackages; [
    perCompiler.${compiler}.apply-refact
    cabal-fmt
    perCompiler.${compiler}.cabal-install
    doctest
    perCompiler.${compiler}.ghci-dap
    ghcid
    ghcide
    haskell-dap
    perCompiler.${compiler}.haskell-debug-adapter
    haskell-language-server
    hasktags
    perCompiler.${compiler}.hlint
    hoogle
    hpack
    # (ghc.callCabal2nix "hpack-convert" (builtins.fetchGit {
    #   url = "https://github.com/yamadapc/hpack-convert.git";
    #   ref = "hpack-convert";
    # }) {}) # broken in all versions
    implicit-hie
    perCompiler.${compiler}.krank
    perCompiler.${compiler}.stack
    stan # broken in all versions
    perCompiler.${compiler}.stylish-haskell
    perCompiler.${compiler}.weeder
  ];
  optionalBuildTools = with haskellPackages; [
    selenium-server-standalone
  ];
}
