# AGENTS.md

`record` is the PATE-stack terminal-demo toolkit: `record.sh` (asciinema →
scrub → pace → trim → agg GIF), `assets/drive.py` (unattended pty
operator), and `SKILL.md` (the five-phase demo workflow agents follow).
This repo is symlinked into `~/.agents/skills/`, so **SKILL.md is a live
routing surface** — edits to it change agent behavior everywhere,
immediately.

## Working principles

- **`record.sh` is one portable bash script.** No config files, no
  dependencies beyond asciinema/agg/zsh, every knob doubled as a flag and a
  `RECORD_*` env var. New behavior follows that pattern or lives in a
  wrapper.
- **`--print-config` must work with nothing installed.** It is the CI
  doctor probe and the `make doctor` path; the asciinema/agg check is
  deliberately gated behind `PRINT_CONFIG == 0` — don't hoist it back up.
- **Path scrubbing is a privacy control, not cosmetics.** The sed pass that
  rewrites `WORK_DIR`/`PROJECT_ROOT` into labels keeps recordings
  publishable. Any new output path or banner line goes through the same
  scrub.
- **The prompt-buffer preload is load-bearing.** The demo command enters
  via a zle `zle-line-init` hook so curses apps and progress bars see a
  real TTY interaction. Never "simplify" it into piped stdin.
- **`assets/drive.py` is stdlib-only and POSIX-only**, same shape as pane's
  `pty_smoke`: pty fork, timed drain/write loop, long tail wait for agg.
  Script grammar is `delay:keys` with named keys in `NAMED` — extend the
  table rather than inventing per-call syntax.
- **SKILL.md changes are behavior changes.** The five phases (storyboard →
  smoke → record → verify → publish) each exist because skipping them
  produced a bad take the day the skill was written (surprise facet
  picker, tab overshoot from a state-dependent start view, un-coalesced
  frame extraction misread as corruption). Don't remove a guard without
  naming what replaced it.

## Layout

```
record.sh            the recorder (root — it predates and outranks everything)
record-demo.sh       leather-flavored wrapper (legacy LEATHER_RECORD_* env)
record-example.sh    records leather's make example-NN
assets/drive.py      unattended pty driver (--record and --smoke modes)
SKILL.md             the agent skill; assets/ paths referenced from it are
                     lint-checked by make lint
```

## Development workflow

```bash
make check    # what CI runs: lint + doctor + drive.py compile/help/grammar
make lint     # bash -n all scripts; shellcheck if present; SKILL.md asset refs
make doctor   # record.sh --print-config (no recorder tools needed)
```

CI (`Check`) runs `make check` on ubuntu with shellcheck installed — a
shellcheck warning that's silently skipped locally will fail there.

## Verification bar for changes

- Anything touching `record.sh`'s render pipeline (pacing, trimming,
  scrubbing, agg flags): record a real take and read the coalesced frames
  (`magick out.gif -coalesce f_%02d.png`) before calling it done.
- Anything touching `drive.py`: `make check` covers grammar and compile;
  an end-to-end `--record` run against a repo with a `make demo` target
  covers the integration.
- SKILL.md edits: `make lint` must pass (asset references resolve), and the
  workflow must still read as five phases with their failure stories.

## Contributing summary

- `make check` green, CHANGELOG.md updated under `## [Unreleased]`.
- Recorder behavior changes ship with a re-verified recording.
- Commits are signed (ruleset-enforced on `main`).
