#!/bin/sh
set -euo pipefail

#HASKELL_UPDATES=https://github.com/NixOS/nixpkgs/archive/haskell-updates.tar.gz
#MASTER=https://github.com/NixOS/nixpkgs/archive/master.tar.gz
#UNSTABLE=https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz # channel:unstable
#NIXPKGS=https://nixos.org/channels/nixos-22.11/nixexprs.tar.xz # channel:nixpkgs

# "Cabal 3.8.0.20220526 supports 'ghc' version < 9.4"

# nix-build --argstr compiler ghc942 -I nixpkgs=$HASKELL_UPDATES demo.nix -o result/haskell-updates/ghc942 --show-trace
# nix-build --argstr compiler ghc942 -I nixpkgs=$MASTER demo.nix -o result/master/ghc942 --show-trace
# No cabal: nix-build --argstr compiler ghc942 -I nixpkgs=$UNSTABLE demo.nix -o result/unstable/ghc942 --show-trace
# No cabal: nix-build --argstr compiler ghc942 -I nixpkgs=$NIXPKGS demo.nix -o result/nixpkgs/ghc942 --show-trace
nix-build --argstr compiler ghc942 demo.nix -o result/nixpkgs/ghc942 --show-trace 2>&1 | sed 's/^/ghc942: /g'
nix-store -qR --include-outputs $(nix-instantiate --argstr compiler ghc942 demo.nix --add-root result/nixpkgs/ghc942 --indirect) | cachix push websites

# nix-build --argstr compiler ghc924 -I nixpkgs=$HASKELL_UPDATES demo.nix -o result/haskell-updates/ghc924 --show-trace
# nix-build --argstr compiler ghc924 -I nixpkgs=$MASTER demo.nix -o result/master/ghc924 --show-trace
# nix-build --argstr compiler ghc924 -I nixpkgs=$UNSTABLE demo.nix -o result/unstable/ghc924 --show-trace
nix-build --argstr compiler ghc924 demo.nix -o result/nixpkgs/ghc924 --show-trace 2>&1 | sed 's/^/ghc924: /g'
nix-store -qR --include-outputs $(nix-instantiate --argstr compiler ghc924 demo.nix --add-root result/nixpkgs/ghc924 --indirect) | cachix push websites

# nix-build --argstr compiler ghc902 -I nixpkgs=$HASKELL_UPDATES demo.nix -o result/haskell-updates/ghc902 --show-trace
# nix-build --argstr compiler ghc902 -I nixpkgs=$MASTER demo.nix -o result/master/ghc902 --show-trace
# nix-build --argstr compiler ghc902 -I nixpkgs=$UNSTABLE demo.nix -o result/unstable/ghc902 --show-trace
nix-build --argstr compiler ghc902 demo.nix -o result/nixpkgs/ghc902 --show-trace 2>&1 | sed 's/^/ghc902: /g'
nix-store -qR --include-outputs $(nix-instantiate --argstr compiler ghc902 demo.nix --add-root result/nixpkgs/ghc902 --indirect) | cachix push websites


