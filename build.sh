#!/bin/sh
set -euo pipefail

nix-channel --update
nix-build --argstr compiler ghc912 demo.nix -o result/nixpkgs/ghc912 --show-trace 2>&1 | sed 's/^/ghc912: /g'
nix-build --argstr compiler ghc910 demo.nix -o result/nixpkgs/ghc910 --show-trace 2>&1 | sed 's/^/ghc910: /g'
