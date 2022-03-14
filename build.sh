#!/bin/sh
nix-build --argstr compiler ghc922 demo.nix -o result-ghc922
nix-build --argstr compiler ghc902 demo.nix -o result-ghc902
nix-build --argstr compiler ghc8107 demo.nix -o result-ghc8107
nix-build --argstr compiler ghc884 demo.nix -o result-ghc884