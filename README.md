# Recording Tools

This directory holds a small terminal-recording toolkit built around
[`asciinema`](https://asciinema.org/) for capture and `agg` for GIF rendering.

The center of gravity is [`record.sh`](./record.sh). The other scripts are thin
wrappers:

- [`record.sh`](./record.sh): general-purpose recorder for any repo or working tree
- [`record-demo.sh`](./record-demo.sh): Leather-flavored wrapper with Leather prompt/theme defaults
- [`record-example.sh`](./record-example.sh): Leather example wrapper that records `make example-NN`

## Requirements

- `asciinema`
- `agg`
- `zsh`

## Quick Start

Record the current repo and preload a command:

```bash
./scripts/recording/record.sh . leather run --pretty tanning/agents/go-release-prep.agent.md
```

Record with Leather defaults:

```bash
./scripts/recording/record-demo.sh . leather run --pretty tanning/agents/go-release-prep.agent.md
```

Record a numbered example:

```bash
./scripts/recording/record-example.sh 01
```

## Local Makefile

There is a directory-local Makefile for common flows:

```bash
make -C scripts/recording help
make -C scripts/recording doctor
make -C scripts/recording demo DIR=. CMD='leather run --pretty tanning/agents/go-release-prep.agent.md'
make -C scripts/recording example NN=09-live
```

`doctor` is useful when you want to see the resolved output paths and defaults
without launching an interactive recording.

## Shared CLI

`record.sh` accepts:

```text
scripts/recording/record.sh [options] DIR [CMD ...]
```

Useful flags:

- `--print-config`
- `--env KEY=VALUE`
- `--env-file PATH`
- `--no-env-file`
- `--title TEXT`
- `--demo-name TEXT`
- `--label TEXT`
- `--basename NAME`
- `--out-dir DIR`
- `--prompt-label TEXT`
- `--prompt-color HEX`
- `--font-size PT`
- `--cols N`
- `--rows N`
- `--select RANGE`
- `--idle-time-limit SEC`
- `--last-frame-duration SEC`
- `--line-delay SEC`
- `--line-chunk N`
- `--source-zshrc`

See full help:

```bash
./scripts/recording/record.sh --help
```

## Environment Variables

The shared recorder supports these `RECORD_*` variables:

- `RECORD_ENV_FILE`
- `RECORD_OUT_DIR`
- `RECORD_OUT_BASENAME`
- `RECORD_TITLE`
- `RECORD_DEMO_NAME`
- `RECORD_WORKDIR_LABEL`
- `RECORD_PROMPT_LABEL`
- `RECORD_PROMPT_COLOR`
- `RECORD_FONT_SIZE`
- `RECORD_COLS`
- `RECORD_ROWS`
- `RECORD_SELECT`
- `RECORD_IDLE_LIMIT`
- `RECORD_LAST_FRAME_DURATION`
- `RECORD_LINE_DELAY`
- `RECORD_LINE_CHUNK`
- `RECORD_SOURCE_ZSHRC`
- `RECORD_AGG_THEME`
- `RECORD_TEXT_FONTS`

The Leather wrappers also preserve the older `LEATHER_RECORD_*` names.

## Output

By default the generated files land in:

```text
<project-root>/recordings/<timestamp>.cast
<project-root>/recordings/<timestamp>.gif
```

You can override the directory and basename with `--out-dir` and `--basename`.

## Notes

- The recorder preloads the command into the prompt buffer instead of piping it
  into the shell. That keeps TTY-aware output like `leather run --pretty`
  working normally.
- Long single-event output can be paced with `--line-delay` and `--line-chunk`
  so the GIF remains readable without slowing the command itself.
- The cast is trimmed to remove the final prompt redraw and Ctrl-D newline noise
  before GIF rendering.
