# dyt.tmux

tmux plugin for [DictateYourTerms](https://github.com/nicolasayotte/dictate-your-terms) — zero-latency voice dictation in any pane.

Opens a small popup running `dyt --record`, waits for you to speak and press Enter, auto-closes the popup, then pastes the transcript into the originating pane.

## Requirements

- [`dyt`](https://github.com/nicolasayotte/dictate-your-terms) binary on `PATH`.
- `dyt-daemon` running before invoking the keybinding.
- tmux >= 3.2 (`display-popup` support).

## Installation

### TPM (recommended)

Add to `~/.tmux.conf`:

```tmux
set -g @plugin 'nicolasayotte/dyt.tmux'
```

Then press `prefix + I` to install.

### Manual

```bash
git clone https://github.com/nicolasayotte/dyt.tmux ~/.tmux/plugins/dyt.tmux
```

Add to `~/.tmux.conf`:

```tmux
run '~/.tmux/plugins/dyt.tmux/dyt.tmux'
```

## Configuration

All options are optional. Set them in `~/.tmux.conf` **before** the `run` or TPM initialisation line.

| Option | Default | Description |
|---|---|---|
| `@dyt-key` | `v` | Key bound as `prefix + <key>` |
| `@dyt-daemon` | `http://127.0.0.1:3030` | HTTP base URL of the running `dyt-daemon` |

```tmux
set -g @dyt-key 'v'
set -g @dyt-daemon 'http://127.0.0.1:3030'
```

## Behaviour

1. Press `prefix + v` (or your configured key).
2. A popup opens running `dyt --record`. Speak, then press Enter to stop.
3. The popup closes automatically.
4. The transcript is pasted into the pane that was active when you pressed the keybinding.
5. A re-entrancy guard prevents a second invocation while the popup is open.
6. If `dyt` exits with no output, a status-bar message explains why.

## License

MIT
