# Queue status — 2026-10-19

This file records what was shipped, what is blocked/failed, and what is rejected for this repository. It complements `AUDIT_FINDINGS.md`.

## Shipped
- Docs aligned with the existing tap.

## Blocked / failed
- Formula 1.11.0 lags PrismNote 1.12.3; needs a lockstep bump.
- Linux/Intel installs unavailable.

## Rejected / deferred
- Linux formula until a Linux release asset exists.

## Policy

Any future feature or upgrade must check `AUDIT_FINDINGS.md` and this file before implementation. A blocked item is retried only when its external dependency is available; a rejected item needs new user evidence or a design change to reopen.
