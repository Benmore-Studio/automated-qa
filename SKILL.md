---
name: frontend-verify
description: Verify a frontend with evidence-backed static analysis, browser measurements, coverage gaps, and focused retesting. Use for broken or stale data, cross-route consistency, pre-release QA, and sustained QA runs.
---

# Frontend Verify

Use the installed `qa` CLI as an instrument against an application repository.
Do not run the application under test against this distribution repository.

## Start with a bounded measurement

```bash
qa run /absolute/path/to/app --base http://127.0.0.1:3000 --once
```

Use `qa verify /path/to/app` for static-only evidence or add `--base URL` for
browser evidence. Run `qa help --phases` or `qa help <command>` instead of
guessing flags.

## Full analysis and graph workflow

The public CLI runs the same analysis and compiled planning engine as the
private build. Use the generated artifacts rather than recreating its logic:

```bash
qa init --analysis /absolute/path/to/app
qa show analysis /absolute/path/to/app
qa measure coherence /absolute/path/to/app --views
qa show graph /absolute/path/to/app --format mermaid
qa show graph /absolute/path/to/app --kind transition --format json
qa dev validate /absolute/path/to/app
```

For a complete autonomous pass, use `qa run ... --once` or a bounded `--hours`
run. It performs preflight, source study, baseline verification, compiled
planning and scoring, coherence and invariant measurements, graph generation,
prioritized handoff, retesting, and HTML reporting. Features that require
application-owned roles, journeys, mutation flows, or authoritative readback
remain explicitly unmeasured until the application declares them.

## Evidence contract

- Exit `0` means clean only within the measured scope.
- Exit `1` means measured gating findings.
- Exit `2` means invalid, inconclusive, or unable to run; never report it as a pass.
- Preserve every denominator and named unmeasured gap.
- Distinguish source evidence, mocks, local runtime, staging, and production.

Read `.verify/next.md` and the referenced archived run before editing. Trace the
finding to its shared root cause, inspect callers, make the smallest complete
fix, run the application's own focused checks, and rerun the affected `qa`
measurement. The host agent owns application edits and commits; `qa` measures
and hands off evidence.

## Safety

Never mutate production. Runtime writes require the user's explicit authority,
`--mutate`, a committed flow declaring `production: false`, an authorized lane,
a positive budget, isolated fixtures, and cleanup capability.

Treat `.verify/capture/` screenshots as user data. Do not publish screenshots,
credentials, cookies, tokens, request payloads, or private source. Report the
exact command, exit code, measured denominator, remaining gaps, and evidence
location.
