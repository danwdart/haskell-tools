{
  nixpkgs ? import <nixpkgs> {},
  compiler ? "ghc924"
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
  availableBuildTools = with ghc; {
    apply-refact                = ghc902.apply-refact;
    cabal-install               = cabal-install;
    doctest                     = doctest;
    ghcid                       = ghcid;
    ghcide                      = ghc902.ghcide;
    ghci-dap                    = ghci-dap;
    haskell-dap                 = haskell-dap;
    haskell-debug-adapter       = haskell-debug-adapter;
    haskell-language-server     = ghc902.haskell-language-server;
    hasktags                    = hasktags;
    hlint                       = hlint;
    implicit-hie                = implicit-hie;
    krank                       = (ghc.override {
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
            doctest = self.callHackage "doctest" "0.20.0" {};
          };
        }).callHackage "relude" "1.1.0.0" {};
      };
    # https://github.com/kowainik/stan/issues/423
    }).callCabal2nix "stan" (builtins.fetchGit {
      url = "https://github.com/tomjaguarpaw/stan.git";
      ref = "9.4-compat";
      rev = "70c14718486f399c11209580d4762b73499cd0e3";
    }) {});
    stylish-haskell             = ghc902.stylish-haskell;
    weeder                      = weeder;
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
