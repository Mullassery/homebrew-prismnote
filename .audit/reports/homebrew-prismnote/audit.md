# Audit Report: homebrew-prismnote

**Audit Date:** 2026-10-27  
**Repository:** `/Users/georgimullassery/Desktop/Projects/homebrew-prismnote`  
**Commit:** `ffc3a8e4fa8038e6d38033804a7e6308d3222859` (2026-10-25)  
**Audit Type:** Read-only systems design audit  
**Scope:** Single Homebrew formula, tap documentation, release metadata, and repository automation. Formula installation was not executed; `brew style` and Ruby syntax checks were run.

## Executive Summary

A small, focused official tap for PrismNote. The formula is easy to read, pins a SHA-256 checksum, restricts installation to macOS Ventura+ on Apple Silicon, and has a livecheck. There is no post-install network fetch or opaque shell pipeline.

The main weakness is release/version maintenance. The formula pins v1.11.0 while the latest PrismNote release is v1.12.7; the three most recent releases have no assets at all, while v1.12.0 does have a macOS arm64 binary and checksum. As written, `livecheck` points at an assetless latest tag, so a naive automated bump would create a broken formula. The formula test is also inherently flaky: it sleeps a fixed two seconds, depends on fixed port 8000, does not verify that the process owns the responding server, has no curl timeout, and waits indefinitely after `TERM`. There is no CI to catch any of this.

**Finding counts:** 0 Critical, 0 High, 3 Medium, 3 Low.

## Overview

- **Type:** Single-formula Homebrew tap.
- **Purpose:** Install PrismNote, a local-first SQL/notebook application, from a raw macOS Apple Silicon release binary.
- **Platform:** macOS Ventura or later, Apple Silicon only; Intel is explicitly disabled.
- **Release source:** GitHub Releases, raw `prismnote-macos-arm64` binary.
- **Maintenance status:** README describes the tap as official and maintained, with a known blocked item to catch up to a newer PrismNote version.

## Architecture

- `Formula/prismnote.rb` downloads one raw arm64 Mach-O binary from a version-pinned GitHub release URL and verifies SHA-256.
- Install renames the asset to `prismnote`, places it in `bin`, and sets mode `0755`.
- The application has no CLI flags; starting it unconditionally launches a local notebook server on port 8000.
- `livecheck` uses `url :stable` plus `strategy :github_latest`.
- Repository automation is absent: there is no `.github/` workflow, no formula test job, and no release/version consistency check.
- Internal documentation under `docs/internal/` records a prior audit, competitive intelligence policy, and queue status; none of it is executable validation.

## Entry Points

- `brew tap mullassery/prismnote https://github.com/Mullassery/homebrew-prismnote.git`
- `brew install prismnote`
- `prismnote` (starts the local server on port 8000)
- `brew upgrade prismnote`
- `brew uninstall prismnote`
- `brew test prismnote` (formula smoke test)
- `brew livecheck prismnote`

## Dependencies

- **Runtime:** macOS Ventura or later; Apple Silicon CPU; no declared runtime libraries beyond the bundled application.
- **Build:** None; the formula installs a prebuilt raw binary.
- **Formula test:** Ruby `fork`, `exec`, `Process`, and macOS `curl`.
- **CI:** None.
- **Release metadata:** GitHub Releases API and `SHA256SUMS.txt` on releases that publish assets.

## Module Structure

- `Formula/prismnote.rb` — formula, install method, architecture guard, livecheck, and smoke test.
- `README.md` — installation, behavior, platform limits, known issues, version, and project links.
- `docs/internal/AUDIT_FINDINGS.md` — prior dated audit notes.
- `docs/internal/QUEUE_STATUS.md` — shipped/blocked/rejected work list.
- `docs/internal/COMPETITIVE_INTELLIGENCE.md` — process policy for roadmap decisions.
- `LICENSE`, `USE_CASES.md` — repository boilerplate and positioning.

## Data, State, APIs, and Contracts

- **Install contract:** A single checksum-pinned raw binary is installed as `bin/prismnote`. There is no daemon, service, config file, or post-install hook managed by Homebrew.
- **Runtime contract:** The binary ignores all arguments and starts a local HTTP service on a fixed `localhost:8000`. Users cannot select a port, bind address, or notebook path from the CLI.
- **Test contract:** The formula test asserts that an HTTP GET to `http://localhost:8000/` returns `200` within two seconds, then sends `TERM` and waits for the child.
- **Update contract:** `livecheck` asks GitHub for the latest release tag. The formula itself hardcodes both the release version URL and `version`.
- **State:** Application data is not managed by the formula; no `service`, `caveats`, `zap`, or persistent Homebrew-managed state exists.

## Security Observations

### Positive controls

- Artifact is pinned by SHA-256; Homebrew verifies it before install.
- No post-install network download, `curl | bash`, or arbitrary Ruby execution.
- Architecture/OS guards prevent Intel installs and declare macOS Ventura as the minimum.
- Install uses a simple rename and explicit mode change; no privilege escalation.
- No secrets, tokens, or credentials are handled by the formula.
- `livecheck` exists, providing a path to update detection if paired with asset validation.

### Risk themes

1. **Release drift and asset mismatch:** Formula v1.11.0 vs latest tag v1.12.7. The current latest, v1.12.6, and v1.12.5 releases expose zero assets; v1.12.0 has a macOS binary and checksum but is not used. A livecheck-driven bump to the latest tag would fail or produce a formula with no valid URL.
2. **Flaky smoke test:** Fixed sleep, fixed port, no ownership/identity check, no curl timeout, and unbounded post-TERM wait make the test capable of false failures, false successes, and hangs.
3. **No CI:** Nothing validates style, audit, install, or test before merge.
4. **Documentation drift:** README and internal audit notes refer to version 1.12.3 and “service caveats” that no longer exist in the formula.
5. **Operational UX:** A long-running local server has no `service` block or caveats, so `brew services` cannot manage it and users must keep a terminal open.

## Tests and CI

- No CI configuration exists in the repository.
- `ruby -c Formula/prismnote.rb` succeeds.
- `brew style Formula/prismnote.rb` reports two offenses:
  - `version` must appear before `sha256` (`Formula/prismnote.rb:5-7`);
  - the test uses a `%{http_code}` template token instead of an annotated token (`Formula/prismnote.rb:31`).
- No `brew audit`, `brew install`, or `brew test` was executed. The test’s behavior is assessed statically.
- Release checks on the audit date:
  - latest tag: `v1.12.7`, zero assets;
  - `v1.12.6` and `v1.12.5`: zero assets;
  - `v1.12.0`: `prismnote-macos-arm64` plus `SHA256SUMS.txt`;
  - formula: `v1.11.0` raw binary, still reachable;
  - PyPI reports PrismNote 1.12.7.

## Findings

| Severity | Finding | Evidence | Impact | Root Cause Hypothesis | Recommendation |
|----------|---------|----------|--------|----------------------|---------------|
| Medium | Livecheck/version policy points at releases that have no installable asset | `Formula/prismnote.rb:4-12` pins v1.11.0 and livechecks `github_latest`; GitHub API shows v1.12.7/v1.12.6/v1.12.5 have zero assets, while v1.12.0 has a macOS binary and `SHA256SUMS.txt`; PyPI reports 1.12.7 | Users remain on 1.11.0 and miss fixes; an automated livecheck bump to 1.12.7 would create a formula whose URL has no asset; maintainers cannot simply “bump and ship.” | Release publishing and tap versioning are decoupled; livecheck detects tags rather than installable release assets. | Pin to the newest release with a verified asset (currently v1.12.0) or publish assets for the current tag; change livecheck to validate asset availability; add an automated version/checksum update workflow with a pre-merge install test. |
| Medium | Formula smoke test is flaky and can produce false results or hang | `Formula/prismnote.rb:24-36` uses fixed `sleep 2`, assumes port 8000, does not check that the forked process is alive or owns the listener, runs `curl` without `--max-time`, and calls `Process.wait` after `TERM` with no timeout or `KILL` fallback | A slow start fails; a leftover/unrelated server on 8000 can make the test pass against the wrong service; a hung binary or ignored TERM can hang CI indefinitely; an early exit can raise `Errno::ESRCH` in `ensure` and obscure the real failure. | The application has no configurable port or health endpoint, so the test was written as a minimal fixed-delay HTTP probe. | Reserve/check port 8000 before launch; fail immediately if occupied; poll with a bounded timeout and verify process liveness; assert an application-specific response rather than any `200`; use `curl --max-time`; TERM then KILL after a grace period; always reap. If a stable test is impossible, replace it with an install/file/architecture validation and document the manual runtime check. |
| Medium | No formula CI or release validation | No `.github/` workflow; no style/audit/install/test automation; `brew style` currently reports two offenses | Formula/style regressions and broken releases can merge unnoticed; release asset gaps are only discovered manually. | Repository was created as a minimal tap without validation infrastructure. | Add a macOS arm64 workflow running `brew style`, `brew audit --strict`, `brew install --build-from-source`, `brew test`, and a livecheck/asset-consistency check. |
| Low | Documentation and internal audit are stale | `README.md:60-64` says the formula lags 1.12.3 and needs a lockstep bump; latest tag/PyPI are 1.12.7; `docs/internal/AUDIT_FINDINGS.md:18` claims “service caveats,” but the formula has no `service` or `caveats` block; `docs/internal/QUEUE_STATUS.md:8-10` repeats the stale version | Maintainers and users get incorrect guidance about the current version and capabilities; the “blocked” item understates that recent releases have no assets. | Documentation was written at an earlier date and not refreshed with release state or formula changes. | Update README and internal notes to the current release/assets; distinguish “newer tag exists” from “newer installable asset exists”; add a release-state check to the maintenance checklist. |
| Low | Long-running server has no Homebrew service or caveats | `Formula/prismnote.rb:19-22` only installs the binary; no `service` or `caveats`; README tells users to run `prismnote` manually; internal audit claims service caveats | `brew services` cannot manage the notebook server; users must keep a terminal session open and have no standard log/start-at-login behavior. This may be intentional, but the documentation says otherwise. | Formula models PrismNote as a plain CLI even though it is a foreground local server. | Decide explicitly: add a `service` block/caveats for foreground execution, or remove the stale “service caveats” claim and document that the app is terminal-managed. |
| Low | Formula style/metadata debt | `brew style` reports `version` after `sha256` and an unannotated `%{http_code}` format token; `Formula/prismnote.rb:5-7,31` | Cosmetic failures will block a future strict CI gate and make the formula look unmaintained. | Hand-written formula without style enforcement. | Run `brew style --fix`, then enforce style in CI. |

## Strengths

- Minimal, auditable formula with a single pinned artifact and checksum.
- No post-install network access or opaque shell provisioning.
- Clear Apple Silicon/Ventura platform contract with an explicit Intel disable.
- `livecheck` is present, unlike many small taps.
- The runtime binary is installed without wrappers or environment mutation.
- Documentation is candid about missing Intel/Linux support and lack of CLI flags.
- No privileged operations, secrets, or credential handling.

## Limitations

- Apple Silicon macOS only; Intel/Linux/Windows are unsupported.
- The application has no CLI configuration surface, making the smoke test harder to isolate.
- No install/test was executed during this audit; runtime claims are based on formula, README, and release metadata.
- Release assets were checked via GitHub API/URL availability, not downloaded and checksum-verified.
- The tap’s long-term release process is outside this repository, so the asset gap cannot be fixed in the formula alone.

## Prioritized Recommendations

1. **Medium:** Choose a release with a verified asset (v1.12.0 currently) or publish assets for the latest tag; update livecheck to detect installable releases and add checksum/install validation.
2. **Medium:** Replace the fixed-sleep/fixed-port smoke test with a bounded, ownership-aware test, or reduce it to deterministic install/architecture validation if the server cannot be isolated.
3. **Medium:** Add macOS arm64 CI for style, audit, install, test, and release-asset consistency.
4. **Low:** Refresh README/internal docs to the actual release state and remove the nonexistent “service caveats” claim.
5. **Low:** Decide whether PrismNote should have a Homebrew `service` block; document the terminal-managed behavior if not.
6. **Low:** Apply style fixes and enforce them in CI.
