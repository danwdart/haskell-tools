#!/bin/sh
set -euo pipefail

nix-store -qR --include-outputs $(nix-instantiate --argstr compiler ghc96 demo.nix --add-root result/nixpkgs/ghc96 --indirect) | cachix push dandart
nix-store -qR --include-outputs $(nix-instantiate --argstr compiler ghc96 demo.nix --add-root result/nixpkgs/ghc96 --indirect) | xargs nix-copy-closure --gzip -s --include-outputs dwd@cache.jolharg.com
nix-store -qR --include-outputs $(nix-instantiate --argstr compiler ghc94 demo.nix --add-root result/nixpkgs/ghc94 --indirect) | cachix push dandart
nix-store -qR --include-outputs $(nix-instantiate --argstr compiler ghc94 demo.nix --add-root result/nixpkgs/ghc94 --indirect) | xargs nix-copy-closure --gzip -s --include-outputs dwd@cache.jolharg.com
nix-store -qR --include-outputs $(nix-instantiate --argstr compiler ghc92 demo.nix --add-root result/nixpkgs/ghc92 --indirect) | cachix push dandart
nix-store -qR --include-outputs $(nix-instantiate --argstr compiler ghc92 demo.nix --add-root result/nixpkgs/ghc92 --indirect) | xargs nix-copy-closure --gzip -s --include-outputs dwd@cache.jolharg.com
nix-store -qR --include-outputs $(nix-instantiate --argstr compiler ghc90 demo.nix --add-root result/nixpkgs/ghc90 --indirect) | cachix push dandart
nix-store -qR --include-outputs $(nix-instantiate --argstr compiler ghc90 demo.nix --add-root result/nixpkgs/ghc90 --indirect) | xargs nix-copy-closure --gzip -s --include-outputs dwd@cache.jolharg.com