{
  nixpkgs ? import <nixpkgs> {},
  haskellUpdates ? import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/haskell-updates.tar.gz") {},
  compiler ? "ghc942"
}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  haskell = nixpkgs.pkgs.haskell;
  haskellPackages = haskell.packages;
  lib = haskell.lib;
  ghc924 = haskellPackages.ghc924;
  ghc902 = haskellPackages.ghc902;
in
compiler: rec {
  ghc = haskellPackages.${compiler};
  toolsPerGHC = with ghc; {
    ghc902 = {
      ghcid = ghcid;
      ghcide = ghcide;
      haskell-language-server = haskell-language-server;
      stylish-haskell = stylish-haskell;
    };
    ghc924 = {
      ghcid = ghcid;
      ghcide = ghcide;
      haskell-language-server = haskell-language-server;
      stylish-haskell = stylish-haskell;
    };
    ghc942 = {
      ghcid = (ghc.override {
        overrides = self: super: rec {
          hspec-contrib = self.callCabal2nixWithOptions "hspec-contrib" (builtins.fetchGit {
            url = "https://github.com/hspec/hspec.git";
            rev = "734fd87231626bee978d34700505a11c53fff65c";
          }) "--subpath hspec-contrib" {};
        };
      }).ghcid;
      ghcide = (ghc.override {
        overrides = self: super: rec {
          ghc-check = lib.dontHaddock super.ghc-check;
        };
      }).ghcide;
      haskell-language-server = (haskellUpdates.haskell.packages.ghc942.override {
        overrides = self: super: rec {
          # not yet released
          streaming-commons = self.callCabal2nix "streaming-commons" (builtins.fetchGit {
            url = "https://github.com/fpco/streaming-commons.git";
            rev = "eb65c96c28e39a352023c24e2517880f0bf246c5";
          }) {};
        };
      }).haskell-language-server;
      stylish-haskell = ghc924.stylish-haskell; # lib.enableCabalFlag ghc.stylish-haskell "ghc-lib";
      #stylish-haskell = (ghc.override {
      #  overrides = self: super: rec {
      #    ormolu = lib.doJailbreak super.ormolu;
      #    ghc-lib-parser = lib.doJailbreak (self.callHackage "ghc-lib-parser" "9.4.2.20220822" {});
      #    hls-hlint-plugin = lib.doJailbreak super.hls-hlint-plugin;
      #    fourmolu = lib.doJailbreak super.fourmolu;
      #  };
      # }).stylish-haskell;
    };
  };
  availableBuildTools = with ghc; {
    apply-refact                = ghc902.apply-refact;
    cabal-install               = cabal-install;
    doctest                     = ghc.callCabal2nix "doctest" (builtins.fetchGit {
      url = "https://github.com/sol/doctest.git";
      rev = "495a76478d63a31c61523b1a539f49340e6be122";
    }) {};
    # 0.5.1.1 not yet released
    ghcid                       = toolsPerGHC.${compiler}.ghcid;
    # Must be compiled using same version of ghc
    ghcide                      = toolsPerGHC.${compiler}.ghcide;
    # Could not find module ‘GHCi.GhcApiCompat’
    ghci-dap                    = ghc924.ghci-dap;
    haskell-dap                 = haskell-dap;
    # https://github.com/hspec/hspec/issues/747
    haskell-debug-adapter       = ghc924.haskell-debug-adapter;
    haskell-docs-cli            = (ghc.override {
      overrides = self: super: rec {
        haskell-docs-cli = self.callCabal2nix "haskell-docs-cli" (builtins.fetchGit {
          url = "https://github.com/lazamar/haskell-docs-cli.git";
          rev = "6c40bd41f0f6be5f06afae2836c42710dc05cd87";
        }) {};
      };
    }).haskell-docs-cli;
    # ghc-source-gen-0.4.3.0 broken
    # Must be compiled using same version of ghc
    haskell-language-server     = toolsPerGHC.${compiler}.haskell-language-server; # 
    # text >=0.11 && <1.3
    hasktags                    = ghc924.hasktags;
    # ghc-lib-parser >=9.0 && <9.1, ghc-lib-parser-ex >=9.0.0.4 && <9.0.1
    hlint                       = ghc924.hlint;
    hoogle                      = hoogle;
    implicit-hie                = implicit-hie;
    # https://github.com/hspec/hspec/issues/747
    krank                       = (ghc924.override {
      overrides = self: super: rec {
        PyF = self.callHackage "PyF" "0.11.1.0" {};
      };
    }).callCabal2nix "krank" (builtins.fetchGit {
      url = "https://github.com/guibou/krank.git";
      rev = "dd799efa1f2d1fac4ce0f80c4f47731b32e6fcaf";
    }) {};
    selenium-server-standalone  = selenium-server-standalone;
    stan                        = lib.dontCheck ((ghc924.override {
      overrides = self: super: rec {
        # https://github.com/kowainik/extensions/issues/74
        extensions = lib.doJailbreak (self.callCabal2nix "extensions" (builtins.fetchGit {
          url = "https://github.com/tomjaguarpaw/extensions.git";
          ref = "9.4";
          rev = "6748ccbcea0d06488b6e288e9b68233fe4d73eb7";
        }) {});
        # https://github.com/kowainik/trial/issues/67
        trial-tomland = lib.doJailbreak (self.callCabal2nixWithOptions "trial-tomland" (builtins.fetchGit {
          url = "https://github.com/tomjaguarpaw/trial.git";
          ref = "9.4";
        }) "--subpath trial-tomland" {});
        clay = lib.doJailbreak super.clay;
        slist = lib.doJailbreak super.slist;
        relude = (ghc924.override {
          overrides = self: super: rec {
            doctest = self.callCabal2nix "doctest" (builtins.fetchGit {
              url = "https://github.com/sol/doctest.git";
              rev = "495a76478d63a31c61523b1a539f49340e6be122";
            }) {};
          };
        }).callHackage "relude" "1.1.0.0" {};
      };
    # https://github.com/kowainik/stan/issues/423
    }).callCabal2nix "stan" (builtins.fetchGit {
      url = "https://github.com/tomjaguarpaw/stan.git";
      ref = "9.4-compat";
      rev = "70c14718486f399c11209580d4762b73499cd0e3";
    }) {});
    # base >=4.14 && <4.17, ghc-prim >0.2 && <0.9, time >=1.4 && <1.12
    stylish-haskell             = toolsPerGHC.${compiler}.stylish-haskell;
    weeder                      = ghc924.weeder;
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
