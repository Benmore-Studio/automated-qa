# Automated QA

[![distribution](https://github.com/Benmore-Studio/automated-qa/actions/workflows/distribution.yml/badge.svg)](https://github.com/Benmore-Studio/automated-qa/actions/workflows/distribution.yml)

Automated QA is an evidence-first frontend verification CLI. It inventories an
application, finds source-decidable defects, exercises real browser behavior,
and reports both findings and what was not measured.

This is the public **distribution repository**. It contains installation and
support material only. The private development repository, mathematical model,
derivations, notebooks, audits, benchmarks, and kernel source are not published.

## Public beta status

Public installation is temporarily paused while the execution boundary is
redesigned so proprietary implementation does not ship to user machines.
There is currently no supported Homebrew, npm, or direct-download install.

## Quick start

```bash
# Static inventory and source checks
qa verify /absolute/path/to/frontend

# Add runtime browser evidence
qa verify /absolute/path/to/frontend --base http://127.0.0.1:3000

# Inspect findings and coverage gaps
qa show /absolute/path/to/frontend
qa show next /absolute/path/to/frontend
```

Exit codes are part of the public contract:

- `0`: clean within the scope actually measured;
- `1`: measured gating findings;
- `2`: invalid, inconclusive, or required evidence could not run.

Exit `2` is never a pass. Every clean result carries its denominator.

## What is public and private

| Public distribution | Kept private |
| --- | --- |
| Installer, usage documentation, checksums | Development Git history and internal issue tracker |
| Minified operational JavaScript required to run locally | Readable Rust kernel source |
| Signed universal macOS kernel binary | Mathematical specifications and derivations |
| JSON schemas needed to validate artifacts | Notebooks, figures, formal audits, benchmark oracles |

The mathematical source is not present in this repository or its release
archive. As with any locally installed software, compiled binaries and minified
runtime code can be reverse engineered; this distribution boundary prevents
ordinary source disclosure, not forensic extraction.

## Data and safety

- The CLI runs locally; there is no hosted service receiving your repository.
- It never authorizes production mutations.
- Runtime writes require explicit opt-in, a committed non-production flow,
  loopback or an explicit override, a mutation budget, fixture isolation, and
  cleanup capability.
- Do not publish `.verify/capture/` screenshots without reviewing them; they may
  contain application data.

## Support

Use [GitHub Issues](https://github.com/Benmore-Studio/automated-qa/issues) for
bugs and feature requests. Do not attach credentials, cookies, tokens, request
payloads, private source, or unreviewed screenshots.

Report vulnerabilities through a
[private security advisory](https://github.com/Benmore-Studio/automated-qa/security/advisories/new).

## License

The installer and official binary distribution are covered by [LICENSE](LICENSE).
No source-code or mathematical-model license is granted.
