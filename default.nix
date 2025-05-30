{
  nixpkgs ? <nixpkgs> {},
  compiler ? "ghc912"
}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  lib = nixpkgs.haskell.lib;
  perCompiler = {
    ghc912 = let haskellPackages = nixpkgs.haskell.packages.ghc912; in {
      cabal-fmt = nixpkgs.haskell.packages.ghc912.cabal-fmt;
      ghcide = nixpkgs.haskell.packages.ghc912.ghcide;
      doctest = nixpkgs.haskell.packages.ghc912.doctest;
      krank = (nixpkgs.haskell.packages.ghc912.override {
        overrides = self: super: rec {
          pcre-heavy = lib.dontCheck super.pcre-heavy;
          PyF = lib.dontCheck super.PyF;
        };
      }).callCabal2nix "krank" (builtins.fetchGit {
        url = "https://github.com/guibou/krank.git";
        ref = "main";
      }) {};
      # https://github.com/jhrcek/stylish-haskell/pull/3
      stylish-haskell = lib.dontCheck (
        haskellPackages.callCabal2nix "stylish-haskell" (builtins.fetchGit {
          url = "https://github.com/jhrcek/stylish-haskell.git";
          ref = "jhrcek/ghc-9.10";
        }) {}
      );
      implicit-hie = nixpkgs.haskell.packages.ghc912.implicit-hie;
      hoogle = nixpkgs.haskell.packages.ghc912.hoogle;
      hpack = nixpkgs.haskell.packages.ghc912.hpack;
      haskell-language-server = nixpkgs.haskell.packages.ghc912.haskell-language-server;
      hasktags = nixpkgs.haskell.packages.ghc912.hasktags;
      ghci-dap = haskellPackages.ghci-dap;
      haskell-debug-adapter = haskellPackages.haskell-debug-adapter;
      cabal-install = haskellPackages.cabal-install;
      stack = lib.doJailbreak nixpkgs.haskell.packages.ghc98.stack; # 2024-11-09 not ready yet
      hlint = nixpkgs.haskell.packages.ghc98.hlint; # 2024-11-09 not ready yet
      weeder = lib.dontCheck (lib.doJailbreak haskellPackages.weeder); # 2024-11-09 not ready yet
      apply-refact = nixpkgs.haskell.packages.ghc98.apply-refact; # 2024-11-09 not ready yet
      # https://github.com/haskell-fswatch/hfsnotify/issues/115
      ghcid = nixpkgs.haskell.packages.ghc98.ghcid;
      stan = nixpkgs.haskell.packages.ghc912.stan;
    };
    ghc912 = let haskellPackages = nixpkgs.haskell.packages.ghc912; in {
      cabal-fmt = nixpkgs.haskell.packages.ghc912.cabal-fmt;
      ghcide = nixpkgs.haskell.packages.ghc912.ghcide;
      doctest = nixpkgs.haskell.packages.ghc912.doctest;
      krank = (nixpkgs.haskell.packages.ghc912.override {
        overrides = self: super: rec {
          pcre-heavy = lib.dontCheck super.pcre-heavy;
          PyF = lib.dontCheck super.PyF;
        };
      }).callCabal2nix "krank" (builtins.fetchGit {
        url = "https://github.com/guibou/krank.git";
        ref = "main";
      }) {};
      # https://github.com/jhrcek/stylish-haskell/pull/3
      stylish-haskell = lib.dontCheck (
        nixpkgs.haskell.packages.ghc912.callCabal2nix "stylish-haskell" (builtins.fetchGit {
          url = "https://github.com/jhrcek/stylish-haskell.git";
          ref = "jhrcek/ghc-9.10";
        }) {}
      );
      implicit-hie = nixpkgs.haskell.packages.ghc912.implicit-hie;
      hoogle = nixpkgs.haskell.packages.ghc912.hoogle;
      hpack = nixpkgs.haskell.packages.ghc912.hpack;
      haskell-language-server = nixpkgs.haskell.packages.ghc912.haskell-language-server;
      hasktags = nixpkgs.haskell.packages.ghc912.hasktags;
      ghci-dap = nixpkgs.haskell.packages.ghc912.ghci-dap;
      haskell-debug-adapter = nixpkgs.haskell.packages.ghc912.haskell-debug-adapter;
      cabal-install = nixpkgs.cabal-install; # TODO: 3.14.1.0
      stack = lib.doJailbreak nixpkgs.haskell.packages.ghc98.stack; # 2024-11-09 not ready yet
      hlint = nixpkgs.haskell.packages.ghc98.hlint; # 2024-11-09 not ready yet
      weeder = lib.dontCheck (lib.doJailbreak nixpkgs.haskell.packages.ghc912.weeder); # 2024-11-09 not ready yet
      apply-refact = nixpkgs.haskell.packages.ghc98.apply-refact; # 2024-11-09 not ready yet
      # https://github.com/haskell-fswatch/hfsnotify/issues/115
      ghcid = nixpkgs.haskell.packages.ghc98.ghcid;
      stan = nixpkgs.haskell.packages.ghc912.stan;
    };
  };
in
compiler: rec {
  # A lot of these packages must be built using the ghc version in use.
  haskellPackages = nixpkgs.haskell.packages.${compiler};
  defaultBuildTools = with haskellPackages; [
    perCompiler.${compiler}.apply-refact
    perCompiler.${compiler}.cabal-fmt
    perCompiler.${compiler}.cabal-install
    perCompiler.${compiler}.doctest
    perCompiler.${compiler}.ghci-dap
    perCompiler.${compiler}.ghcid
    perCompiler.${compiler}.ghcide
    haskell-dap
    perCompiler.${compiler}.haskell-debug-adapter
    perCompiler.${compiler}.haskell-language-server
    perCompiler.${compiler}.hasktags
    perCompiler.${compiler}.hlint
    perCompiler.${compiler}.hoogle
    perCompiler.${compiler}.hpack
    # (ghc.callCabal2nix "hpack-convert" (builtins.fetchGit {
    #   url = "https://github.com/yamadapc/hpack-convert.git";
    #   ref = "hpack-convert";
    # }) {}) # broken in all versions
    perCompiler.${compiler}.implicit-hie
    perCompiler.${compiler}.krank
    perCompiler.${compiler}.stack
    perCompiler.${compiler}.stan # broken in all versions
    perCompiler.${compiler}.stylish-haskell
    perCompiler.${compiler}.weeder
  ];
  optionalBuildTools = with haskellPackages; [
    selenium-server-standalone
  ];
}
