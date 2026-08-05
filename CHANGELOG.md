# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- **`SKILL.md`** — the agent skill: storyboard from the app's real
  keybindings → pty smoke → record → verify every coalesced frame →
  publish to `docs/media/`. Distilled from the session that produced
  pane's three README demos unattended.
- **`assets/drive.py`** — unattended pty operator for `record.sh` (or, with
  `--smoke`, any command): timed `delay:keys` script grammar with named
  keys, long tail wait for agg, `--record` flag plumbing.
- **Repository frame** per scaffold-repo: AGENTS.md, governance files,
  GitHub posture (rulesets, `Check` CI with shellcheck), self-documenting
  Makefile for the standalone layout.

### Changed

- **Standalone paths.** Usage text and Makefile no longer assume the
  toolkit lives at `scripts/recording/` inside another repo.
- **`--print-config` works without asciinema/agg** — the tool check now
  applies only to actual recording, so `make doctor` and CI run clean on a
  bare box.

## [0.1.0] - 2026-07-04

### Added

- Initial recording toolkit: `record.sh` (asciinema capture, path
  scrubbing, line pacing, tail trim, agg GIF render), leather-flavored
  `record-demo.sh`, and `record-example.sh` for numbered leather examples.
  GPL-3.0.
