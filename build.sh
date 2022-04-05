#!/bin/sh
nix-build --argstr compiler ghc922 demo.nix -o result-ghc922
nix-build --argstr compiler ghc902 demo.nix -o result-ghc902