{ nixpkgs ? import <nixpkgs> {},
  haskell-tools ? import ./default.nix {},
  compiler ? "ghc941"
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
