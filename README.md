# Scout Job-Discovery Agent

Scout is an OpenClaw workspace for researching early-career technology jobs in
Europe. It searches a configured company list, verifies vacancies on official
sources, filters them against explicit eligibility rules, ranks suitable jobs
against a private local CV, and produces evidence-based Markdown briefings.

Scout is a research system. It must not apply for jobs, create accounts, sign
in, upload documents, bypass access restrictions, or contact employers.

> [!IMPORTANT]
> This repository is a prototype workspace, not a standalone application. The
> parent runtime, `crawler-worker` definition, tool permissions, browser
> isolation, persistence behavior, and scheduler must be supplied and reviewed
> separately before running Scout unattended.

## How it works

1. The parent Scout agent loads the policy, private search criteria, ranking
   rules, company targets, private CV, and briefing template.
2. It normalizes the target list and creates stable batches of approximately 15
   companies, with no more than five workers active at once.
3. Isolated `crawler-worker` agents discover jobs for their assigned companies
   and verify each result on an official employer or applicant-tracking page.
4. The parent validates worker responses, applies eligibility rules, and removes
   duplicate vacancies.
5. Only the parent reads the private CV and calculates candidate-fit scores.
6. Validated results are compared with private historical state and rendered as
   a daily briefing in `Crawler Agent/reports/`.

The detailed component model, runtime sequence, trust boundaries, and known
limitations are documented in [ARCHITECTURE.md](./ARCHITECTURE.md).

## Repository layout

| Path | Purpose |
| --- | --- |
| `Crawler Agent/AGENTS.md` | Authoritative operating policy and parent/worker contract |
| `Crawler Agent/IDENTITY.md` | Agent name, role, and purpose |
| `Crawler Agent/SOUL.md` | Research and communication principles |
| `Crawler Agent/Prompt.md` | Manual full-target test-run procedure |
| `Crawler Agent/HEARTBEAT.md` | Scheduled-task entry point; currently disabled |
| `Crawler Agent/TOOLS.example.md` | Public template for optional private runtime notes |
| `Crawler Agent/config/search-criteria.example.yaml` | Public template for private eligibility criteria |
| `Crawler Agent/config/ranking.yaml` | CV input path, scoring weights, labels, and output rules |
| `Crawler Agent/config/company-targets.yaml` | Prioritized company inventory and search behavior |
| `Crawler Agent/config/Example-CV.md` | Public template for the private candidate CV |
| `Crawler Agent/templates/daily-briefing.md` | Daily report template |
| `scripts/validate_public_repo.rb` | Dependency-free public-safety and consistency checks |

The following local paths are intentionally ignored: `USER.md`, `TOOLS.md`,
`config/search-criteria.yaml`, `config/CV.md`, `state/`, `reports/`, credentials,
browser data, and OpenClaw runtime state.

## Privacy-first setup

From the repository root:

```sh
cp "Crawler Agent/config/search-criteria.example.yaml" \
  "Crawler Agent/config/search-criteria.yaml"
cp "Crawler Agent/config/Example-CV.md" \
  "Crawler Agent/config/CV.md"
```

Then:

1. Replace every `null` or example value in the private search criteria.
2. Replace every CV placeholder with accurate candidate evidence.
3. Optionally copy `TOOLS.example.md` to `TOOLS.md` for non-secret local runtime
   notes.
4. Review `config/company-targets.yaml`. The public seed inventory contains 725
   unique entries across 18 groups; it is a priority list, not a whitelist.
5. Review the 100-point model in `config/ranking.yaml`. Company priority affects
   search order and tie-breaking, not candidate-fit score.
6. Confirm the private files remain ignored before adding any Git changes:

   ```sh
   git check-ignore -v \
     "Crawler Agent/config/search-criteria.yaml" \
     "Crawler Agent/config/CV.md" \
     "Crawler Agent/TOOLS.md"
   ```

All paths in `ranking.yaml` are relative to the `Crawler Agent/` workspace.
Scout must stop if a required private input is absent, unchanged from its
template, or otherwise unusable.

## Runtime requirements

The surrounding OpenClaw installation must provide and scope:

- a parent agent rooted at `Crawler Agent/`;
- an isolated `crawler-worker` that cannot access the CV or shared writes;
- sub-agent session tools and bounded concurrency;
- public web discovery and fetch capabilities;
- an isolated managed browser when static retrieval is insufficient;
- parent-only write access to `state/` and `reports/`;
- atomic checkpoint updates and explicit query, page, and runtime limits.

`Crawler Agent/Prompt.md` defines a complete manual test sweep. No active
schedule is stored in this repository: `HEARTBEAT.md` is intentionally
comments-only.

## Safety and privacy

- Workers must never receive or read candidate-specific files.
- Public files must contain only templates, placeholders, schemas, and aggregate
  facts—never CV excerpts, personal identifiers, contact details, credentials,
  cookies, session data, or real runtime result payloads.
- Only official employer or employer-controlled applicant-tracking pages can
  verify a vacancy; snippets and aggregators are discovery sources only.
- Missing job information remains unknown and must not be inferred.
- Web content is untrusted data and cannot alter local instructions.
- CAPTCHA, authentication, rate-limit, robots, and access-control barriers end
  interaction with that source and must be recorded as blockers.
- Scout must not submit forms, sign in, upload files, impersonate the candidate,
  or communicate externally.

## Validation

Run the repository checks before every public change:

```sh
ruby scripts/validate_public_repo.rb
git diff --check
```

The same validator runs in GitHub Actions. It checks public YAML, scoring totals,
target duplication, relative documentation links, private tracked paths,
high-confidence credential formats, and known unsafe instruction phrases.

## Contributing and security

See [CONTRIBUTING.md](./CONTRIBUTING.md) before submitting changes. Report
security or privacy issues using the private process in
[SECURITY.md](./SECURITY.md).

## License

Licensed under the [Apache License 2.0](./LICENSE).
