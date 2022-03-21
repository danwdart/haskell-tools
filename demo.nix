{ nixpkgs ? import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/haskell-updates.tar.gz") {},
  haskell-tools ? import ./default.nix {},
  compiler ? "ghc922"
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
