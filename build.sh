#!/bin/sh
nix-build --argstr compiler ghc923 demo.nix -o result-ghc923
nix-build --argstr compiler ghc902 demo.nix -o result-ghc902