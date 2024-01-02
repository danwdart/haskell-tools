{ nixpkgs ? import <nixpkgs> {},
  haskell-tools ? import ./default.nix {
    nixpkgs = nixpkgs;
    compiler = compiler;
  },
  compiler ? "ghc96"
}:
let
  tools = haskell-tools compiler;
  shell = tools.ghc.shellFor {
    packages = p: [];
    buildInputs = tools.defaultBuildTools;
  };
in
{
  inherit shell;
}
