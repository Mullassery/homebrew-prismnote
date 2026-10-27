# Audit Findings - homebrew-prismnote

**Audit Date:** 2026-10-27  
**Commit:** `ffc3a8e4fa8038e6d38033804a7e6308d3222859`  
**Audit Type:** Read-only systems design audit  
**Detailed report:** [../.audit/reports/homebrew-prismnote/audit.md](../.audit/reports/homebrew-prismnote/audit.md)

## Summary

`homebrew-prismnote` is a focused single-formula tap for PrismNote. The formula is simple and safe in shape: one checksum-pinned macOS arm64 binary, no post-install downloads, an explicit Ventura/Apple Silicon guard, and a livecheck.

The main problems are release maintenance and test reliability. The formula pins v1.11.0 while the latest tag and PyPI release are v1.12.7; the latest three GitHub releases have no assets, while v1.12.0 has a valid binary and checksum. The smoke test uses a fixed two-second sleep, fixed port 8000, no ownership check, no curl timeout, and an unbounded wait after `TERM`. There is no CI.

**Counts:** 0 Critical, 0 High, 3 Medium, 3 Low.

## Quick Findings

- **Medium - Release/livecheck asset mismatch:** Formula v1.11.0; latest tag/PyPI v1.12.7; v1.12.7/v1.12.6/v1.12.5 have zero assets; v1.12.0 has a macOS binary and `SHA256SUMS.txt`.
- **Medium - Flaky/hanging smoke test:** fixed `sleep 2`; fixed port 8000; any HTTP 200 passes; no process/ownership check; `curl` has no timeout; `Process.wait` after TERM has no timeout/KILL fallback.
- **Medium - No CI:** no style/audit/install/test workflow; `brew style` reports two offenses.
- **Low - Stale docs:** README says 1.12.3; actual latest is 1.12.7. Internal audit claims “service caveats,” but the formula has no `service`/`caveats`.
- **Low - No service management:** a long-running local server is installed without a Homebrew service or caveats.
- **Low - Style debt:** `version` ordering and an unannotated `%{http_code}` token.

## Findings

| Severity | Finding | Evidence | Impact | Recommendation |
|----------|---------|----------|--------|----------------|
| Medium | Livecheck targets tags without installable assets | `Formula/prismnote.rb:4-12`; GitHub API: v1.12.7/v1.12.6/v1.12.5 have 0 assets, v1.12.0 has the binary + SHA256SUMS; PyPI 1.12.7 | Users stay on 1.11.0; naive livecheck automation would produce a broken URL; release and tap versioning are decoupled. | Pin to the newest verified asset (v1.12.0) or publish assets for the latest tag; validate asset presence in livecheck; automate checksum/version updates with install tests. |
| Medium | Formula test is flaky and can hang | `Formula/prismnote.rb:24-36` | Slow start fails; an unrelated server on 8000 can false-pass; curl can hang; ignored TERM can hang forever; early exit can raise in `ensure`. | Reserve/check the port, poll with timeout, verify process liveness and app identity, use curl `--max-time`, TERM then KILL, always reap. Fall back to deterministic install/architecture checks if the server cannot be isolated. |
| Medium | No formula CI | No `.github/`; `brew style` reports 2 offenses | Breakage and style debt can merge undetected; release asset gaps require manual discovery. | Add macOS arm64 CI for style, audit, install, test, and asset consistency. |
| Low | README/internal docs are stale | `README.md:60-64`; `docs/internal/AUDIT_FINDINGS.md:18`; `docs/internal/QUEUE_STATUS.md:8-10` | Incorrect current version and capability claims; “service caveats” do not exist; blocked status understates the asset gap. | Refresh docs to current release/assets and distinguish tags from installable releases. |
| Low | No service/caveats for a long-running server | `Formula/prismnote.rb:19-22`; README manual `prismnote` run | `brew services` cannot manage the server; users must keep a terminal open; docs claim otherwise. | Decide explicitly: add a service/caveats block, or remove the claim and document terminal-managed behavior. |
| Low | Formula style/metadata debt | `Formula/prismnote.rb:5-7,31`; `brew style` | Cosmetic failures block strict CI and signal lack of maintenance. | Run `brew style --fix` and enforce in CI. |

## Positive Controls

- Single SHA-256-pinned artifact.
- No post-install network fetch or `curl | bash`.
- Explicit macOS Ventura + Apple Silicon requirements, with Intel disabled.
- `livecheck` exists.
- No privileged operations, secrets, or credential handling.
- README is candid about platform and CLI limitations.

## Recommended Sequence

1. Choose a release with a verified asset and align formula/livecheck/release automation.
2. Replace the flaky test with a bounded, ownership-aware smoke test or deterministic validation.
3. Add formula CI.
4. Refresh docs and decide the service-management policy.
5. Apply style fixes.
