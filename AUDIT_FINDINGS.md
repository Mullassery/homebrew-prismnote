# Audit findings — 2026-10-19

This file records the repository-specific findings from the portfolio audit
conducted on 2026-10-19. It is documentation only; no code or release artifacts
were changed in this pass unless explicitly noted under "Implementation status".

Sources: the repository's own README/source/workflows, GitHub metadata and
Actions runs, PyPI metadata, and official competitor documentation. Claims are
marked as verified, inferred, or open questions. "Absent" means not found in the
inspected repository/docs, not proof that it cannot exist.

## What it is

Homebrew tap for PrismNote.

## Verified strengths

- Simple arm64 formula; livecheck; service caveats.
- Works for the published macOS arm64 asset.

## Verified gaps and user-facing risks

- Pinned v1.11.0 while PyPI/GitHub are 1.12.3/1.12.0; arm64 only; no CLI argument handling.
- Linux/Intel users cannot use the tap.

## Direct competitors

- uv/pipx installs of marimo/Jupyter; Homebrew core.

## Ranked next actions

- P1: lockstep bump + version consistency check (S).
- P1: publish PrismNote Linux/Windows binaries first, then decide on a Linux formula.

## Do not build

- Linux formula until a Linux release asset exists.

## Evidence gaps / validation needed

- No clean-machine install/upgrade test.

## Recommended disposition

Maintain; stale but low-risk.

## Implementation status

No code changes in this pass.
