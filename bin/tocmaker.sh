#!/usr/bin/env bash

# Run from repo base base, eg. ETCDEVTeam/knowledge/

set -e
tocpath=./toc.md
echo "### Table of Contents" > "$tocpath"
echo "\`\`\`" >> $tocpath
tree >> $tocpath # --dirsfirst -alLhtDFC 4 -I .git
echo "\`\`\`" >> $tocpath
echo

