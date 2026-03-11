# Claude Config

Global Claude Code configuration — skills, agents, GSD framework, commands.

## Install (nový počítač)

```bash
git clone https://github.com/rudolf6969/claude-config
cd claude-config
bash install.sh
```

## Obsah

- `CLAUDE.md` — Hlavné inštrukcie (načíta sa automaticky pri každom `claude`)
- `skills/` — Globálne skills (xlsx, pdf, docx, pptx, web-fetch, react-best-practices, csv-summarizer, atď.)
- `agents/` — code-reviewer, debugger, technical-researcher, context-manager, test-automator
- `commands/gsd/` — GSD Framework (31 commands: /gsd:new-project, /gsd:execute-phase, atď.)
- `commands/evaluate-repository.md` — Security audit pre repo
- `get-shit-done/` — GSD workflows, templates, agents

## Trading Skills

Trading skills sú v **GoldTrading repo** (`gold-web-terminal/.claude/`):
→ `git clone https://github.com/rudolf6969/GoldTrading`

Obsahuje 27 trading skills: alpha-vantage, aeon, pymoo, pymc, crypto-signal-generator, crypto-derivatives-tracker, atď.
