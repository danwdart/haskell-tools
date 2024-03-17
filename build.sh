#!/bin/sh
set -euo pipefail

nix-channel --update
nix-build --argstr compiler ghc94 demo.nix -o result/nixpkgs/ghc94 --show-trace 2>&1 | sed 's/^/ghc94: /g'
nix-build --argstr compiler ghc96 demo.nix -o result/nixpkgs/ghc96 --show-trace 2>&1 | sed 's/^/ghc96: /g'
nix-build --argstr compiler ghc98 demo.nix -o result/nixpkgs/ghc98 --show-trace 2>&1 | sed 's/^/ghc98: /g'
