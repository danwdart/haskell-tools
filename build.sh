#!/bin/sh
set -euo pipefail

nix-build --argstr compiler ghc942 demo.nix -o result/nixpkgs/ghc942 --show-trace 2>&1 | sed 's/^/ghc942: /g'
nix-build --argstr compiler ghc924 demo.nix -o result/nixpkgs/ghc924 --show-trace 2>&1 | sed 's/^/ghc924: /g'
nix-build --argstr compiler ghc902 demo.nix -o result/nixpkgs/ghc902 --show-trace 2>&1 | sed 's/^/ghc902: /g'

