#!/bin/sh
set -euo pipefail

nix-channel --update
nix-build --argstr compiler ghc94 demo.nix -o result/nixpkgs/ghc94 --show-trace 2>&1 | sed 's/^/ghc94: /g'
nix-build --argstr compiler ghc92 demo.nix -o result/nixpkgs/ghc92 --show-trace 2>&1 | sed 's/^/ghc92: /g'
nix-build --argstr compiler ghc90 demo.nix -o result/nixpkgs/ghc90 --show-trace 2>&1 | sed 's/^/ghc90: /g'

