#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SRC="${1:-}"
DST="$ROOT/system/hardware-configuration.nix"

is_real_hw() {
  local p="$1"
  [ -f "$p" ] || return 1
  ! grep -q 'This is a safety placeholder' "$p"
}

copy_hw() {
  local p="$1"
  is_real_hw "$p" || return 1
  # Never accidentally copy the destination onto itself.
  if [ "$(readlink -f "$p")" = "$(readlink -f "$DST")" ]; then
    return 1
  fi
  cp -f -- "$p" "$DST"
  echo "hardware config <- $p"
  return 0
}

copy_lock() {
  local p="$1"
  [ -f "$p" ] || return 1
  cp -f -- "$p" "$ROOT/flake.lock"
  echo "flake.lock <- $p"
}

if [ -n "$SRC" ]; then
  copy_hw "$SRC/system/hardware-configuration.nix" || {
    echo "No real hardware-configuration.nix under: $SRC/system" >&2
    exit 1
  }
  copy_lock "$SRC/flake.lock" || true
else
  found=0
  for base in \
    "$HOME/v11-test/v11_3_2" \
    "$HOME/v11-test/v11_3" \
    "$HOME/v11-test/v11_2" \
    "$HOME/nixos-config" \
    "$HOME/nixos-thinkpad-dwm" \
    "$HOME/v11_3_2" \
    "$HOME/v11_3" \
    "$HOME/v11_2" \
    "$HOME/v10/v10-fixed" \
    "$HOME/v10-fixed"
  do
    if copy_hw "$base/system/hardware-configuration.nix"; then
      copy_lock "$base/flake.lock" || true
      found=1
      break
    fi
  done

  if [ "$found" -eq 0 ] && copy_hw /etc/nixos/hardware-configuration.nix; then
    found=1
  fi

  if [ "$found" -eq 0 ]; then
    echo "Could not find the T440's real hardware-configuration.nix." >&2
    echo "Pass the old config explicitly, e.g.:" >&2
    echo "  ./prepare.sh ~/v10/v10-fixed" >&2
    echo "or generate on THIS T440:" >&2
    echo "  nixos-generate-config --show-hardware-config > system/hardware-configuration.nix" >&2
    exit 1
  fi
fi

cd "$ROOT"
# Always reconcile the lock file with the inputs declared by this version.
nix flake lock

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git add system/hardware-configuration.nix flake.lock 2>/dev/null || true
fi

printf '\nPrepared. Next commands:\n'
printf '  nix flake check\n'
printf '  touch ~/.disable-gui\n'
printf '  sudo nixos-rebuild test --flake .#thinkpad\n'
