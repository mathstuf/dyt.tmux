#!/usr/bin/env bash
# dyt.tmux — TPM entry point for DictateYourTerms
# Reads @dyt-key and @dyt-daemon options from tmux.conf, registers the keybinding.

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

key="$(tmux show-option -gv @dyt-key 2>/dev/null)"
[[ -z "$key" ]] && key="v"

tmux bind-key "$key" run-shell "$CURRENT_DIR/scripts/dyt.sh"
