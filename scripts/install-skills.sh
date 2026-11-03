#!/bin/sh
# Installs the decide, journeys, tasks, build and verify skills into .agents/skills.
# Re-run to update; set AGENTIC_SKILLS_REF to a tag to pin a version.
set -eu
repo=${AGENTIC_SKILLS_REPO:-https://github.com/hivinaynair/agentic-skills.git}
ref=${AGENTIC_SKILLS_REF:-main}
tmp=$(mktemp -d "${TMPDIR:-/tmp}/agentic-skills.XXXXXX")
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
git clone --quiet --depth 1 --branch "$ref" "$repo" "$tmp/src"
mkdir -p .agents/skills
for name in decide journeys tasks build verify; do
  rm -rf ".agents/skills/$name"
  cp -R "$tmp/src/skills/$name" ".agents/skills/$name"
  rm -rf ".agents/skills/$name/evals" # the skills' own test cases stay in agentic-skills
done
echo "Installed decide, journeys, tasks, build and verify into .agents/skills from $repo@$ref."
