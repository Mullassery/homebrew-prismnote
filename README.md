# Homebrew Tap for PrismNote

Official Homebrew tap for [PrismNote](https://github.com/Mullassery/prismnote), a local-first
SQL/notebook environment with integrated AI assistance.

## Installation

```bash
# Add the tap
brew tap mullassery/prismnote https://github.com/Mullassery/homebrew-prismnote.git

# Install PrismNote
brew install prismnote

# Run PrismNote
prismnote
```

Installed and run end-to-end as part of this pass: the binary starts a
local server on `http://localhost:8000` (see Quick Start).

## About PrismNote

PrismNote is a local-first SQL/Spark notebook with integrated AI. Work offline, use any
database, and speed up data exploration with AI assistance. It is Jupyter-compatible and
supports multiple language kernels.

## Features

- **Multi-Language Kernels:** Python, R, Julia, Rust, C++, Go, Zig, CUDA, SQL, and more
- **Multi-Terminal Splits:** Vertical and horizontal panes for complex workflows
- **AI-Assisted Code:** Pluggable AI provider support, including local models via Ollama for
  fully offline use
- **Local-First:** Everything runs on your machine, no cloud service required
- **Broad Database Support:** Direct SQL support for PostgreSQL, MySQL, and other popular
  databases

## Quick Start

```bash
prismnote
# Opens a local server at http://localhost:8000
```

The binary takes no command-line arguments as of v1.11.0 — running
`prismnote` (with or without extra args) always starts the same local
server on port 8000. There is no separate `new`/`run` subcommand and no
`--version`/`--help` output; any flags shown in older docs describe a
CLI surface this release doesn't have.

## Supported Platforms

- macOS, Apple Silicon only

Only one release asset is published as of v1.11.0: a raw Apple Silicon
(arm64) binary. There is no Intel build, no Linux build, and no Windows
build currently available through this tap, despite what earlier
versions of this README claimed.

## Known issues and deferred work

**Blocked / failed:**
- Formula 1.11.0 lags PrismNote 1.12.3; needs a lockstep bump.
- Linux/Intel installs unavailable.

**Rejected / deferred:**
- Linux formula until a Linux release asset exists.

Full shipped/blocked/rejected detail: [`docs/internal/QUEUE_STATUS.md`](docs/internal/QUEUE_STATUS.md).

## Documentation

- [Getting Started Guide](https://github.com/Mullassery/prismnote/blob/main/docs/guides/GETTING_STARTED.md)
- [Multi-Language Support](https://github.com/Mullassery/prismnote/blob/main/docs/guides/MULTI_LANGUAGE_SUPPORT.md)
- [Main Project README](https://github.com/Mullassery/prismnote)

These links point at the main PrismNote project repository. Verified (200 OK) as part of
this tap audit; the previous paths (`GETTING_STARTED.md` at repo root and
`docs/MULTI_LANGUAGE_SUPPORT.md`) were wrong — both files actually live under
`docs/guides/`.

## Known Issues

- Only an Apple Silicon build is published; Intel and Linux users cannot
  install via this tap.
- The binary has no CLI argument handling — you cannot pick a port, bind
  address, or notebook file from the command line. If you need a different
  port, you'll need to check the main project's configuration docs (not
  verified as part of this tap audit).

## License

This tap is licensed under the [Apache License 2.0](LICENSE). PrismNote itself is also
Apache-2.0 licensed; see the [main repository's LICENSE](https://github.com/Mullassery/prismnote/blob/main/LICENSE)
for its terms.

## Support

- GitHub Issues: https://github.com/Mullassery/prismnote/issues
- GitHub Discussions is not enabled on the main PrismNote repository (verified via the
  GitHub API as part of this tap audit); use Issues for questions and bug reports instead.

## Version

Current formula version: **1.11.0**

- Install: `brew install prismnote`
- Upgrade: `brew upgrade prismnote`
- Uninstall: `brew uninstall prismnote`

## Related projects

Part of the Mullassery open-source family:

- [PrismNote](https://github.com/Mullassery/prismnote) — the local-first SQL/notebook environment this tap installs
- [TinyBridge](https://github.com/Mullassery/tinybridge) — macOS-native Linux VM runtime
- [homebrew-tinybridge](https://github.com/Mullassery/homebrew-tinybridge) — Homebrew tap for TinyBridge
- [SyncFleet](https://github.com/Mullassery/SyncFleet) — peer-to-peer state synchronization for robotics fleets
- [Browse all projects →](https://github.com/Mullassery?tab=repositories)
