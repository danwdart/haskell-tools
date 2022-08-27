{ nixpkgs ? import <nixpkgs> {},
  haskell-tools ? import ./default.nix {
    nixpkgs = nixpkgs;
    compiler = compiler;
  },
  compiler ? "ghc924"
}:
let
  tools = haskell-tools compiler;
  shell = tools.ghc.shellFor {
    packages = p: [];
    buildTools = tools.defaultBuildTools;
  };
in
{
  inherit shell;
}
