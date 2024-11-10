{ nixpkgs ? import <nixpkgs> {},
  haskell-tools ? import ./default.nix {
    nixpkgs = nixpkgs;
    compiler = compiler;
  },
  compiler ? "ghc910"
}:
let
  tools = haskell-tools compiler;
  shell = tools.haskellPackages.shellFor {
    packages = p: [];
    buildInputs = tools.defaultBuildTools;
  };
in
{
  inherit shell;
}
