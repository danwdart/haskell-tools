#!/bin/sh
nix-build --argstr compiler ghc923 demo.nix -o result-ghc923 --show-trace
nix-build --argstr compiler ghc902 demo.nix -o result-ghc902 --show-trace