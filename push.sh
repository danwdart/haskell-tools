#!/bin/sh
set -euo pipefail

nix-store -qR --include-outputs $(nix-instantiate --argstr compiler ghc94 demo.nix --add-root result/nixpkgs/ghc94 --indirect) | cachix push haskell-tools
nix-store -qR --include-outputs $(nix-instantiate --argstr compiler ghc92 demo.nix --add-root result/nixpkgs/ghc92 --indirect) | cachix push haskell-tools
nix-store -qR --include-outputs $(nix-instantiate --argstr compiler ghc90 demo.nix --add-root result/nixpkgs/ghc90 --indirect) | cachix push haskell-tools