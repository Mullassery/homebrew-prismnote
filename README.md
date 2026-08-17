# Homebrew Tap for PrismNote

Official Homebrew tap for [PrismNote](https://github.com/Mullassery/prismnote), a local-first
SQL/notebook environment with integrated AI assistance.

## Installation

```bash
# Add the tap
brew tap Mullassery/prismnote

# Install PrismNote
brew install prismnote

# Run PrismNote
prismnote
```

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
# Create a new notebook
prismnote new my-notebook

# Run an existing notebook
prismnote my-notebook

# Open in browser (auto-launched on port 3000)
# http://localhost:3000
```

## Supported Platforms

- macOS (Intel and Apple Silicon: M1, M2, M3, M4, etc.)
- Linux
- Windows (WSL2)

## Documentation

- [Getting Started Guide](https://github.com/Mullassery/prismnote/blob/main/GETTING_STARTED.md)
- [Multi-Language Support](https://github.com/Mullassery/prismnote/blob/main/docs/MULTI_LANGUAGE_SUPPORT.md)
- [Main Project README](https://github.com/Mullassery/prismnote)

These links point at the main PrismNote project repository and were not independently
verified as part of this tap audit.

## Known Issues

- The current `Formula/prismnote.rb` has placeholder `sha256` values
  (`PLACEHOLDER_ARM64_SHA256`, `PLACEHOLDER_X86_64_SHA256`, `PLACEHOLDER_LINUX_SHA256`) for all
  three release artifacts. As written, `brew install prismnote` will fail a checksum check
  until these are replaced with the real checksums of published release assets.

## License

This tap is released under a proprietary, attribution-required license — see
[LICENSE](LICENSE) in this repository for the full terms. PrismNote itself is proprietary
software; see the [main repository's LICENSE](https://github.com/Mullassery/prismnote/blob/main/LICENSE)
for its terms.

## Support

- GitHub Issues: https://github.com/Mullassery/prismnote/issues
- GitHub Discussions: https://github.com/Mullassery/prismnote/discussions

## Version

Current formula version: **1.7.0**

- Install: `brew install prismnote`
- Upgrade: `brew upgrade prismnote`
- Uninstall: `brew uninstall prismnote`
