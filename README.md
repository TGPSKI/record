# record

Terminal-demo recording for the PATE stack: asciinema capture rendered to
polished, README-ready GIFs — with reproducible prompts, themes, and
dimensions — plus an agent skill that produces those demos **unattended**,
driving the recorder inside a pseudo-terminal with a timed key script and
verifying the result frame by frame.

Every animated demo in the portfolio's READMEs
([pane](https://github.com/TGPSKI/pane),
[leather](https://github.com/TGPSKI/leather)'s examples) was made with this
toolkit; pane's three were recorded by an agent using exactly the workflow
`SKILL.md` encodes.

## What's here

| File | Role |
|---|---|
| [`record.sh`](./record.sh) | The recorder: asciinema capture → path scrubbing → optional line pacing → tail trim → agg GIF render. Works on any repo or directory. |
| [`assets/drive.py`](./assets/drive.py) | Unattended operator: runs `record.sh` (or any command) in a pty and plays a timed key script — `"6:ENTER 3.5:v 1.5:/ 0.6:scan 0.8:ENTER 3:q 1.5:CTRL_D"` |
| [`SKILL.md`](./SKILL.md) | The agent skill: storyboard from the app's real keybindings → smoke → record → **verify every frame** → publish to `docs/media/` |
| [`record-demo.sh`](./record-demo.sh) | Leather-flavored wrapper (prompt/theme defaults, legacy `LEATHER_RECORD_*` env names) |
| [`record-example.sh`](./record-example.sh) | Records a numbered leather example via `make example-NN` |

## Requirements

`asciinema`, `agg`, `zsh`. The unattended driver needs Python 3 (stdlib
only); frame verification uses ImageMagick. `./record.sh --print-config`
and `make check` run without any of them installed.

## Quick start

Record interactively — the command is preloaded into the prompt buffer, you
press Enter and drive:

```bash
./record.sh ~/git/myproj make demo
./record.sh . --title "release demo" --basename release-demo -- npm test
```

Record unattended — an agent (or a script) plays the keys:

```bash
assets/drive.py \
  --record ./record.sh --dir ~/git/myproj \
  --basename demo --cols 120 --rows 30 --font-size 16 \
  --script "6:ENTER 3.5:v 2.5:j 1.5:/ 0.6:scan 0.8:ENTER 3:q 1.5:CTRL_D"
```

Then verify before publishing (`-coalesce` is mandatory — raw extraction
yields inter-frame diffs that read as corruption):

```bash
magick recordings/demo.gif -coalesce frame_%02d.png
```

Resolve configuration without recording:

```bash
make doctor DIR=~/git/myproj      # or: ./record.sh --print-config DIR
```

## The skill

`SKILL.md` routes an agent through five phases: **storyboard** (read the
app's `handle_key` — never guess bindings, pin the startup view), **smoke**
(rehearse the key script in a pty before spending a take), **record**,
**verify** (read every coalesced frame; a tab overshoot or a surprise
picker is invisible any other way), **publish** (curated GIF committed to
`docs/media/`, raw takes gitignored, alt text that narrates the
storyboard).

Install by symlinking the repo into your skills directory:

```bash
ln -s ~/git/TGPSKI/record ~/.agents/skills/record
```

## Behavior worth knowing

- **The prompt buffer, not a pipe.** The demo command is preloaded via a
  zle hook so TTY-aware programs (curses apps, progress bars) behave
  exactly as they would for a human. Piping input would break them.
- **Paths are scrubbed.** The working directory and project root are
  rewritten to short labels in the cast before rendering, so a recording
  never leaks `/home/you/...`. Check what a recording shows before
  publishing regardless — repo names and data have visibility too.
- **The cast is trimmed and pace-able.** Trailing prompt-redraw noise is
  removed; `--line-delay/--line-chunk` pace long single-burst output so the
  GIF stays readable without slowing the command itself.
- **Every knob is a flag and a `RECORD_*` env var** — see `./record.sh
  --help` for the full table (geometry, fonts, theme, idle limit, select
  range, last-frame pause).

## Development

```bash
make help     # self-documenting targets
make check    # lint + doctor + drive.py gates (what CI runs)
make lint     # bash -n, shellcheck when present, SKILL.md asset refs
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). The bar for changes: `record.sh`
stays a single portable script, the driver stays stdlib-only, and anything
that changes what a recording shows gets re-verified frame by frame.

## License

GPL-3.0 — see [LICENSE](LICENSE).
