{ nixpkgs ? import <nixpkgs> {},
  haskell-tools ? import (builtins.fetchTarball "https://github.com/danwdart/haskell-tools/archive/master.tar.gz") {
    nixpkgs = nixpkgs;
    compiler = compiler;
  },
  compiler ? "ghc910"
}:
let
  tools = haskell-tools compiler;
  shell = tools.haskellPackages.shellFor {
    packages = p: [];
    buildTools = tools.defaultBuildTools;
  };
in
{
  inherit shell;
}
