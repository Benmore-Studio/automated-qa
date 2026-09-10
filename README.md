# Automated QA

[![distribution](https://github.com/Benmore-Studio/automated-qa/actions/workflows/distribution.yml/badge.svg)](https://github.com/Benmore-Studio/automated-qa/actions/workflows/distribution.yml)

Automated QA is an evidence-first frontend verification CLI. It inventories an
application, finds source-decidable defects, exercises real browser behavior,
and reports both findings and what was not measured.

This is the public **distribution repository**. It contains installation and
support material only. The private development repository, mathematical model,
derivations, notebooks, audits, benchmarks, and kernel source are not published.

## Install

### Homebrew

```bash
brew install benmore-studio/benmore/qa
```

### npm

```bash
npm install --global https://github.com/Benmore-Studio/automated-qa/releases/download/v0.11.0/automated-qa-0.11.0.tgz
```

The npmjs.com short name is pending publish-grade 2FA on the maintainer account.

### Direct installer

```bash
git clone --depth 1 https://github.com/Benmore-Studio/automated-qa.git
bash automated-qa/install.sh
```

Requirements: macOS or Linux on x64 or arm64, Node.js 18 or newer, and Bash.
Playwright and Chromium are fetched on first runtime use. Static verification
does not need a browser.

All three methods install `qa`, `automated-qa`, and `qa-install-skill`.
The direct installer registers the skill automatically; after Homebrew or npm,
run `qa-install-skill` once.

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
| Installer, sanitized skill, usage documentation, checksums | Development Git history and internal issue tracker |
| Minified operational runtime required for local execution | Readable implementation and Rust kernel source |
| Compiled macOS/Linux kernels and artifact schemas | Mathematical specifications and derivations |
| Public CLI and evidence contracts | Notebooks, figures, formal audits, tests, and benchmark oracles |

Compiled and minified software can be reverse engineered. This owner-approved
distribution boundary prevents ordinary source disclosure; it is not a claim
of cryptographic secrecy.

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

The installer and official runtime distribution are covered by
[LICENSE](LICENSE). No readable source-code or mathematical-model license is
granted.
