#!/usr/bin/env bash
# dyt.sh — core dictation logic for the dyt.tmux plugin.
#
# Flow:
#   1. Re-entrancy guard via lockfile.
#   2. Capture the origin pane before the popup opens.
#   3. Run `dyt --record` in a tmux popup (stderr → popup tty, stdout → tmpfile).
#   4. Load the transcript into a tmux buffer and paste into the origin pane.
#
# Requires: dyt on PATH, dyt-daemon running, tmux >= 3.2.

set -uo pipefail

# --- config ---
DAEMON="$(tmux show-option -gv @dyt-daemon 2>/dev/null)"
[[ -z "$DAEMON" ]] && DAEMON="http://127.0.0.1:3030"

# --- re-entrancy guard ---
LOCKFILE="${XDG_RUNTIME_DIR:-/tmp}/dyt-tmux.lock"
if [[ -f "$LOCKFILE" ]]; then
    tmux display-message "[dyt] Already recording."
    exit 0
fi

TMPFILE="$(mktemp /tmp/dyt-XXXXXX.txt)"
touch "$LOCKFILE"
trap 'rm -f "$LOCKFILE" "$TMPFILE"' EXIT

# --- save origin pane before popup steals focus ---
ORIGIN_PANE="$(tmux display-message -p '#{pane_id}')"

# --- record in a popup ---
# stderr stays on the popup tty so the user sees "Recording... press Enter to stop."
# stdout (the transcript) is redirected to TMPFILE.
tmux display-popup -E -w 80 -h 6 \
    "dyt --no-clipboard --record --daemon '$DAEMON' > '$TMPFILE' 2>/dev/tty"

# --- inject transcript ---
TRANSCRIPT="$(<"$TMPFILE")"
if [[ -z "$TRANSCRIPT" ]]; then
    tmux display-message "[dyt] No transcript received."
    exit 0
fi

# set-buffer -- guards against transcripts beginning with '-'
tmux set-buffer -- "$TRANSCRIPT"
tmux paste-buffer -t "$ORIGIN_PANE"
tmux display-message "[dyt] Dictation pasted."
