#!/usr/bin/env bash
# onCreateCommand of both configs: `on-create.sh nix` or `on-create.sh nixty`.
#
# Runs when the codespace is created (no prebuilds), before the editor opens, so everything a
# participant's first build, run or dev shell needs is already in the Nix store. Same steps for both
# tools except the Nixty-specific ones.
set -euo pipefail

tool="${1:?usage: on-create.sh nix|nixty}"
cd "$(dirname "$0")/../../$tool"

# The Nix feature starts the daemon in the container's entrypoint; wait until it answers.
for _ in $(seq 60); do
  nix store info >/dev/null 2>&1 && break
  sleep 1
done
nix store info

json() { node -p "JSON.parse(require('fs').readFileSync('$1', 'utf8'))$2"; }

rev=$(json flake.lock .nodes.nixpkgs.locked.rev)

# `nix develop` takes bashInteractive from the flake's `nixpkgs` input only when it is a flake; the
# Nixty flake declares it with `flake = false`, so Nix falls back to the `nixpkgs` registry entry.
# Pin that entry to the locked commit (the global registry is off in nix.conf), so both tools use the
# same nixpkgs and nothing is downloaded when a participant enters a dev shell.
nix registry pin nixpkgs "github:NixOS/nixpkgs/$rev"

# nixd and nixfmt from the same nixpkgs commit the flake is locked to.
nix profile add "github:NixOS/nixpkgs/$rev#nixd" "github:NixOS/nixpkgs/$rev#nixfmt"

case "$tool" in
  nix)
    # nixpkgs, stdenv, makeWrapper, curl, jq.
    nix build --no-link
    # bashInteractive (from the locked nixpkgs) and the build environment, used by `nix develop`.
    nix develop --command true
    ;;
  nixty)
    npm ci --no-audit --no-fund
    # Participants type `nixty ...`: the global CLI hands over to the copy in node_modules.
    npm install --global --no-audit --no-fund "nixty-lib@$(json package.json '.devDependencies["nixty-lib"]')"
    # Also warms the type-check (nixty generate runs the tsc bundled with nixty-lib).
    nixty build weathercli --no-link
    nix develop .#weathercli --command true
    ;;
  *)
    echo "unknown tool: $tool" >&2
    exit 2
    ;;
esac

# The participant must find their folder as it is in the repo (flake.nix not regenerated differently,
# no stray files). Only this folder: the rest of the repo is hidden from them.
if [[ -n "$(git status --porcelain -- .)" ]]; then
  echo "on-create.sh left $tool/ dirty:" >&2
  git status --short -- . >&2
  exit 1
fi
