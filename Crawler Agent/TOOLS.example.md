# Scout environment notes template

Copy this file to `TOOLS.md` when the local OpenClaw runtime needs
environment-specific notes. The destination file is ignored by Git.

Document only non-secret capability details that Scout needs, for example:

- the names of granted web-search and fetch tools;
- the name of the isolated, runtime-managed browser profile;
- scoped state and report output locations;
- known capability limits that should produce a blocked result.

Never store credentials, tokens, cookies, private hostnames, personal browser
profiles, or instructions for bypassing access restrictions in this file.
