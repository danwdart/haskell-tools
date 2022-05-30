{ nixpkgs ? import <unstable> {},
  haskell-tools ? import ./default.nix {},
  compiler ? "ghc923"
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
