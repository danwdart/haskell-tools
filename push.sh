#!/bin/sh
set -euo pipefail

nix-store -qR --include-outputs $(nix-instantiate --argstr compiler ghc942 demo.nix --add-root result/nixpkgs/ghc942 --indirect) | cachix push websites
nix-store -qR --include-outputs $(nix-instantiate --argstr compiler ghc924 demo.nix --add-root result/nixpkgs/ghc924 --indirect) | cachix push websites
nix-store -qR --include-outputs $(nix-instantiate --argstr compiler ghc902 demo.nix --add-root result/nixpkgs/ghc902 --indirect) | cachix push websites