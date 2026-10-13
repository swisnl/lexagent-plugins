# LexAgent plugins

LexAgent gives AI assistants the official texts of Dutch and EU law. It reads national legislation
from wetten.overheid.nl and local regulations of municipalities, provinces and water boards. It
also reads official publications, Rechtspraak case law, EUR-Lex legislation, CJEU case law and the
information of Dutch councils. Every document comes with a citation and a link to the official
source.

This repository holds the plugin for Claude (Claude Code and Cowork) and for ChatGPT. Each one
connects to the hosted LexAgent MCP server at `https://lexagent.nl/mcp` and adds two skills:

- **dutch-legal-research**: which sources to read, in what order, and how to report and cite them.
- **check-legal-claims**: a verdict per legal claim in a document (klopt, onjuist, twijfel, niet
  gevonden, niet te controleren), each resting on the official source.

The MCP server is read-only. You need a LexAgent account; you sign in through OAuth the first time
the assistant uses a LexAgent tool.

## Install in Claude Code

```bash
claude plugin marketplace add swisnl/lexagent-plugins
claude plugin install lexagent@lexagent
```

Then run `/mcp` and sign in to LexAgent. To use only the MCP server without the skills:

```bash
claude mcp add --transport http lexagent https://lexagent.nl/mcp
```

In claude.ai, Claude Desktop and ChatGPT, add LexAgent from the connector or plugin directory, or as
a custom connector with the URL `https://lexagent.nl/mcp`.

## Layout

```
.claude-plugin/marketplace.json     Claude marketplace listing this repository's plugin
plugins/lexagent/
  .claude-plugin/plugin.json        Claude plugin manifest
  .mcp.json                         Claude MCP server entry
  plugin.json                       ChatGPT (Agent Plugins) manifest and listing
  mcp.json                          ChatGPT MCP server entry
  skills/                           Skills shared by both
  assets/                           Icon
openai/submission.json              Review cases and publication settings for the ChatGPT directory
scripts/build-chatgpt-zip.sh        Builds the ChatGPT ZIPs: one for a workspace, one for submission
```

Raise `version` in both `plugin.json` files with every release. Validate the Claude plugin with
`claude plugin validate ./plugins/lexagent` before pushing.

## Licence

Apache-2.0, see `LICENSE` and `NOTICE`. The legal texts LexAgent serves come from the Dutch
government and the EU under their own open-data terms.
