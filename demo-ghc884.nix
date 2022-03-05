{ nixpkgs ? import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {},
  compiler ? "ghc884",
  demo-abstract ? import ./default.nix {}
}:
let
  options = demo-abstract compiler;
  shell = options.ghc.shellFor {
    packages = p: [];
    buildTools = options.availableBuildTools;
  };
in
{
  inherit shell;
}
