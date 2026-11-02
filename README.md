# Agentic team kit

A starter for a company repository whose team uses AI coding agents across Claude
Code, Cursor, Copilot and Codex. Copy it into a product repository, fill in the
placeholders, and the team has one way of working with agents: specs for risky
work, and every change seen working before anyone reviews its code.

It installs the five skills from
[agentic-skills](https://github.com/hivinaynair/agentic-skills): decide, journeys,
tasks, build and verify. This repository holds what a team adds around them.

## What a pull request looks like

1. **The agent routes the change** by risk (`docs/ai-workflow.md`). Only money,
   permissions, customer data and cross-feature work get a spec: decide, then
   journeys, then tasks.
2. **It builds test-first** with the build skill, one task per pull request.
3. **It checks the change in a real browser before opening the PR.** The verify
   skill drives [agent-browser](https://github.com/vercel-labs/agent-browser):
   it checks every success criterion on screen with a screenshot, fixes the
   product code and checks everything again (at most three rounds), and for risky
   changes explores around them with agent-browser's `dogfood` skill. Only when all
   pass does it record one clean video, under a minute, of the main path and a
   failure case.
4. **The PR carries the evidence.** The template's Walkthrough section holds that
   video and one line per criterion with its result and screenshot; the Exploratory
   check section holds the sorted dogfood findings.
5. **CI proves it again on every push.** Playwright journey tests in
   `e2e/journeys/`, named after the journey or rule they prove, run with video and
   a step-by-step trace, and a bot comment lists each journey's result with its
   recordings. A second job checks the specs.
6. **A person reviews:** watches the walkthrough first, then reads the risky code.

The two recordings do different jobs. The verify video is the agent showing the
change works before review, including after its own fixes. The Playwright
recordings show the rules still hold on every later push.

## What is in it

| File | What it does |
|---|---|
| `AGENTS.md` | The one set of instructions every agent reads. Fill in the `<…>` parts. |
| `.github/copilot-instructions.md` | Points Copilot at `AGENTS.md`. |
| `docs/ai-workflow.md` | The team guide: the five layers and which changes take which path. |
| `.github/pull_request_template.md` | Route, spec IDs implemented, Walkthrough, Exploratory check, evidence. |
| `.github/workflows/specs.yml` | Checks specs on PRs that change them. |
| `e2e/playwright.config.ts` | Journey tests that record video and a trace of every run. |
| `.github/workflows/journeys.yml` | Runs the journey tests on every PR and comments the results. |
| `scripts/journey-report.mjs` | Builds that comment from Playwright's results. |
| `scripts/install-skills.sh` | Installs the five skills into `.agents/skills` and links them for each tool. |

Claude Code (2.1.277 or later), Cursor and Codex read `AGENTS.md` directly; check
that your versions do. Claude Code reads it only when there is no `CLAUDE.md`, so
do not add one: put every instruction in `AGENTS.md`.

## Install

Use this repository as a template on GitHub, or from the product repository's root:

```sh
git clone --depth 1 https://github.com/hivinaynair/agentic-team-kit.git /tmp/kit
rm -rf /tmp/kit/.git /tmp/kit/README.md /tmp/kit/LICENSE && cp -R /tmp/kit/. .
sh scripts/install-skills.sh
```

`AGENTIC_SKILLS_REF=<tag>` pins the skills to a release; re-run the script to update.
Then fill in `AGENTS.md`, read `docs/ai-workflow.md` with the team, and commit.
The spec check in CI needs nothing but Bun, which the workflow installs.

For the verify skill, each developer installs agent-browser 0.41.0
(`npm i -g agent-browser@0.41.0`) and `ffmpeg`.

For recordings in CI, add Playwright to the project (`npm i -D @playwright/test`),
put journey tests in `e2e/journeys/`, and add these lines to `.gitignore`:

```
.verify/
e2e/report/
```

Set the repository variables `E2E_START_COMMAND` (how CI starts the app; default
`npm run dev`) or `E2E_BASE_URL` (a deployed preview to test instead).

## What it deliberately leaves out

Framework skills (for Medusa, `medusajs/medusa-agent-skills`) and an engineering
workflow such as Superpowers are installed per developer through their tool's
plugin system; `docs/ai-workflow.md` says which ones the team uses.

MIT licensed.
