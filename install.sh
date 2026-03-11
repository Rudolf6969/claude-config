#!/usr/bin/env bash
# Claude Config Installer
# Usage: bash install.sh
# Copies all Claude config files to ~/.claude/

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "Installing Claude config from $REPO_DIR → $CLAUDE_DIR"

mkdir -p "$CLAUDE_DIR/skills" "$CLAUDE_DIR/agents" "$CLAUDE_DIR/commands" "$CLAUDE_DIR/get-shit-done"

# CLAUDE.md
cp "$REPO_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
echo "✓ CLAUDE.md"

# Agents
cp -r "$REPO_DIR/agents/." "$CLAUDE_DIR/agents/"
echo "✓ agents"

# Commands (GSD + extras)
cp -r "$REPO_DIR/commands/." "$CLAUDE_DIR/commands/"
echo "✓ commands"

# GSD Framework
cp -r "$REPO_DIR/get-shit-done/." "$CLAUDE_DIR/get-shit-done/"
echo "✓ get-shit-done (GSD framework)"

# Skills
cp -r "$REPO_DIR/skills/." "$CLAUDE_DIR/skills/"
echo "✓ skills ($(ls $REPO_DIR/skills | wc -l) skills)"

# Install web-fetch deps
if command -v bun &>/dev/null && [ -f "$CLAUDE_DIR/skills/web-fetch/fetch.ts" ]; then
  echo "Installing web-fetch dependencies..."
  cd "$CLAUDE_DIR/skills/web-fetch"
  bun add linkedom turndown &>/dev/null && echo "✓ web-fetch deps"
fi

echo ""
echo "Done! Restart Claude Code for changes to take effect."
echo "Skills available: $(ls $CLAUDE_DIR/skills | tr '\n' ' ')"
