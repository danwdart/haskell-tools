#!/bin/sh
nix-build --argstr compiler ghc921 demo.nix -o result-ghc921
nix-build --argstr compiler ghc902 demo.nix -o result-ghc902
nix-build --argstr compiler ghc8107 demo.nix -o result-ghc8107
nix-build --argstr compiler ghc884 demo.nix -o result-ghc884