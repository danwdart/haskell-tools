{
  nixpkgs ? import <nixpkgs> {},
  compiler ? "ghc94"
}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  haskell = nixpkgs.pkgs.haskell;
  haskellPackages = haskell.packages;
  lib = haskell.lib;
  ghc94 = haskellPackages.ghc94;
  ghc92 = haskellPackages.ghc92;
  ghc90 = haskellPackages.ghc90;
in
compiler: rec {
  ghc = haskellPackages.${compiler};
  toolsPerGHC = with ghc; {
    ghc90 = {
      ghcid = ghcid;
      stylish-haskell = stylish-haskell;
      apply-refact = apply-refact;
      haskell-debug-adapter = haskell-debug-adapter;
    };
    ghc92 = {
      ghcid = ghcid;
      stylish-haskell = stylish-haskell;
      apply-refact = apply-refact;
      haskell-debug-adapter = haskell-debug-adapter;
    };
    ghc94 = {
      ghcid = (ghc.override {
        overrides = self: super: rec {
          # not in nix yet
          hspec-contrib = self.callHackage "hspec-contrib" "0.5.1.1" {};
        };
      }).ghcid;
      # ghc-lib-parser: base >=4.14 && <4.17, ghc-prim >0.2 && <0.9, time >=1.4 && <1.12
      stylish-haskell = ghc92.stylish-haskell;
      # ghc-exactprint: base >=4.8 && <4.16, ghc >=7.10.2 && <9.2
      apply-refact = ghc92.apply-refact;
      haskell-debug-adapter = (ghc.override {
        overrides = self: super: rec {
          # not in nix yet
          hspec-contrib = self.callHackage "hspec-contrib" "0.5.1.1" {};
        };
      }).haskell-debug-adapter;
    };
  };
  availableBuildTools = with ghc; {
    # These must be compiled using same version of ghc
    ghcide                      = ghcide;
    haskell-language-server     = haskell-language-server;
    # these don't matter quite so much
    hoogle                      = hoogle;
    implicit-hie                = implicit-hie;
    ghci-dap                    = ghci-dap;
    haskell-dap                 = haskell-dap;
    selenium-server-standalone  = selenium-server-standalone;
    cabal-install               = cabal-install;
    doctest                     = doctest;
    # stuff that has to be compiled differently depending on the ghc
    apply-refact                = toolsPerGHC.${compiler}.apply-refact;
    ghcid                       = toolsPerGHC.${compiler}.ghcid;
    haskell-debug-adapter       = toolsPerGHC.${compiler}.haskell-debug-adapter;
    stylish-haskell             = toolsPerGHC.${compiler}.stylish-haskell;
    # text >=0.11 && <1.3
    hasktags                    = ghc92.hasktags;
    # ghc-lib-parser >=9.0 && <9.1, ghc-lib-parser-ex >=9.0.0.4 && <9.0.1
    hlint                       = ghc92.hlint;
    # dhall 1.40.2: aeson >=1.0.0.0 && <2.1, template-haskell >=2.13.0.0 && <2.19
    weeder                      = ghc92.weeder;
    # not yet in nix
    krank                       = (ghc.override {
      overrides = self: super: rec {
        # nor is this
        PyF = self.callHackage "PyF" "0.11.1.0" {};
        # and nor is this
        req = self.callHackage "req" "3.13.0" {};
      };
    })
    # 0.3.0 not yet in nix
    .callCabal2nix "krank" (builtins.fetchGit {
      url = "https://github.com/guibou/krank.git";
      rev = "33df2bf090b7f5c646ec770a4f3a8894ba6dce00";
    }) {};
    # also: https://github.com/kowainik/slist/issues/55
    stan                        = lib.doJailbreak ((ghc94.override {
      overrides = self: super: rec {
        # https://github.com/kowainik/extensions/issues/74
        # extensions = ghc.callHackage "extensions" "0.1.0.0" {};
        # https://github.com/kowainik/trial/issues/67
        trial-tomland = lib.doJailbreak (lib.markUnbroken super.trial-tomland);
        clay = lib.doJailbreak super.clay;
        # not released
        slist = self.callCabal2nix "slist" (builtins.fetchGit {
          url = "https://github.com/kowainik/slist.git";
          rev = "09e7c4279f954db18e27a60aa8569dc3458b24ad";
        }) {};
        # relude 1.0.0.1: Module ‘Data.Semigroup’ does not export ‘Option(..)’ if using ghc94
        # 1.1.0.0 not yet in nix
        relude = lib.doJailbreak (self.callHackage "relude" "1.1.0.0" {});
      };
    # https://github.com/kowainik/stan/issues/423
    }).callCabal2nix "stan" (builtins.fetchGit {
      url = "https://github.com/tomjaguarpaw/stan.git";
      ref = "9.4-compat";
      rev = "ebb791cbf587a93b1b2832caa8d89b3b867d1cfd";
    }) {});
    # not in hackage at all
    haskell-docs-cli            = (ghc.override {
      overrides = self: super: rec {
        haskell-docs-cli = self.callCabal2nix "haskell-docs-cli" (builtins.fetchGit {
          url = "https://github.com/lazamar/haskell-docs-cli.git";
          rev = "6c40bd41f0f6be5f06afae2836c42710dc05cd87";
        }) {};
      };
    }).haskell-docs-cli;
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
    haskell-docs-cli
    haskell-language-server
    hasktags
    hlint
    hoogle
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
