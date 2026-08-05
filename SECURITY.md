# Security Policy

## Reporting a Vulnerability

Open a GitHub issue. `record` runs locally, records only what you point it
at, and has no network code or telemetry; most reports can be public. If
the details shouldn't be (e.g. a leak affecting already-published
recordings), use GitHub's private vulnerability reporting on this
repository.

## What counts as a vulnerability here

The product of this toolkit is a **published artifact** — recordings are
made to be committed and served. The security surface is what leaks into
them and what the recorder executes:

- **Scrub bypasses.** `record.sh` rewrites the working directory and
  project root into labels before rendering. A path, hostname, or
  environment value that survives into the cast or GIF through a code path
  the scrub misses is in scope.
- **Env handling.** The recorder auto-sources `<project-root>/.env` (and
  `--env-file`) into the recorded shell. That is by design — demos need
  their config — but any way those values end up *rendered* (echoed by the
  recorder itself, leaked into the banner) rather than merely available is
  in scope.
- **Command execution.** `record.sh` and `assets/drive.py` execute exactly
  the command you hand them, in a pty, as you. That is the documented job,
  not a finding — but argument-parsing confusion that executes something
  *other* than what was passed would be.

Recordings of private material are the operator's responsibility: the
skill's publish phase requires checking what a take shows (repo names,
data, hostnames) before it lands in a README.

## Response

Acknowledged within a week. Fixes land on `main`; if a flaw affects
already-published recordings, the advisory says what to re-check in them.

## Supported versions

`main` only. Consumers use the scripts directly or via the
`~/.agents/skills/` symlink; there are no release branches.
