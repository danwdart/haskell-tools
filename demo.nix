{ nixpkgs ? import <nixpkgs> {},
  haskell-tools ? import ./default.nix {
    inherit nixpkgs;
    inherit compiler;
  },
  compiler ? "ghc912"
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
