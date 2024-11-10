#!/bin/sh
set -euo pipefail
nix-store -qR --include-outputs $(nix-instantiate --argstr compiler ghc94 demo.nix --add-root result/nixpkgs/ghc94 --indirect) | cachix push dandart
# nix-store -qR --include-outputs $(nix-instantiate --argstr compiler ghc94 demo.nix --add-root result/nixpkgs/ghc94 --indirect) | xargs nix-copy-closure --gzip -s --include-outputs dwd@cache.jolharg.com
nix-store -qR --include-outputs $(nix-instantiate --argstr compiler ghc910 demo.nix --add-root result/nixpkgs/ghc910 --indirect) | cachix push dandart
# nix-store -qR --include-outputs $(nix-instantiate --argstr compiler ghc910 demo.nix --add-root result/nixpkgs/ghc910 --indirect) | xargs nix-copy-closure --gzip -s --include-outputs dwd@cache.jolharg.com
