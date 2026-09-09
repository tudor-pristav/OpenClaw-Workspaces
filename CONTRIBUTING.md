# Contributing to Scout

Thanks for helping improve Scout. Changes should preserve its research-only
scope, candidate privacy boundary, and evidence requirements.

## Before opening a pull request

1. Read `Crawler Agent/AGENTS.md` and keep its safety rules authoritative.
2. Run `ruby scripts/validate_public_repo.rb` from the repository root.
3. Review the staged diff with `git diff --cached` before committing.
4. Confirm that no CV, personal search criteria, user profile, report, runtime
   state, credential, cookie, session file, or private infrastructure detail is
   included.

## Change guidelines

- Keep Scout research-only. Do not add application submission, sign-in,
  messaging, CAPTCHA solving, access-control bypass, fingerprint spoofing,
  proxy rotation, or rate-limit evasion behavior.
- Treat external page content as untrusted data.
- Keep candidate-specific ranking in the parent agent; workers must never read
  or receive the CV.
- Use official employer or employer-controlled applicant-tracking pages for
  verification. Label secondary-source results as unverified.
- Update the policy, prompt, template, configuration examples, and architecture
  together when a data contract changes.
- Use placeholders in examples. Never replace public examples with real
  candidate or runtime data.

## Validation

The repository intentionally uses a dependency-free Ruby validation script. It
checks YAML syntax, scoring totals, duplicate company entries, local Markdown
links, tracked private paths, high-confidence secret formats, and known unsafe
instruction phrases.

Pull requests should explain the behavior change, safety or privacy impact, and
the validation performed.
