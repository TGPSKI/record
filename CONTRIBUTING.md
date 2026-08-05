# Contributing

## Setup

```bash
git clone git@github.com:TGPSKI/record.git
cd record
make check
```

`make check` runs with nothing but bash and Python 3 installed. To actually
record you need `asciinema`, `agg`, and `zsh`; frame verification uses
ImageMagick (`magick`). `shellcheck` is optional locally but CI runs it —
install it to see what CI sees.

## Development commands

| Command | What it does |
|---|---|
| `make check` | lint + doctor + drive.py compile/help/grammar gates — what CI runs |
| `make lint` | `bash -n` every script, shellcheck when present, SKILL.md asset references |
| `make doctor DIR=…` | `record.sh --print-config` — resolves config without recorder tools |
| `make demo DIR=… CMD=…` | interactive recording of DIR with CMD preloaded |

## Making changes

- **`record.sh`**: keep it one portable script — new knobs are a flag *and*
  a `RECORD_*` env var, documented in the usage heredoc. Anything touching
  the render pipeline (scrub, pacing, trim, agg flags) ships with a real
  take whose coalesced frames you actually read.
- **`assets/drive.py`**: stdlib-only, POSIX-only. New named keys go in the
  `NAMED` table; the script-grammar assertion in `make check` grows with
  them.
- **`SKILL.md`**: this repo is symlinked into `~/.agents/skills/`, so a
  SKILL.md edit changes live agent behavior. Each phase guard exists
  because of a specific bad take — replace guards, don't silently drop
  them. `make lint` verifies every `assets/…` path the skill references.
- **Wrappers**: leather-specific defaults stay in the wrappers, never in
  `record.sh`.

## PRs

- CI must pass — the required check is `Check` (ubuntu, shellcheck
  installed, so warnings skipped locally fail there).
- Update `CHANGELOG.md` under `## [Unreleased]`.
- Commits are signed (enforced by ruleset on `main`).
