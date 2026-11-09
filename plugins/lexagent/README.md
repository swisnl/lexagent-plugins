# LexAgent

LexAgent gives Claude the official texts of Dutch and EU law, so answers rest on the source instead of
memory. It reads national legislation from wetten.overheid.nl article by article and for any date,
local regulations of municipalities, provinces and water boards, official publications (Staatsblad,
Staatscourant, Gemeenteblad, parliamentary papers) and Dutch case law from Rechtspraak. On the EU side
it reads EUR-Lex legislation and treaty articles with their consolidated versions, and CJEU case law
down to the numbered point. It also covers council information of Dutch municipalities, provinces
and water boards: proposals, motions with their outcome and votes, decision lists and minutes. Every
document comes with a citation and a link to the official source.

## What this plugin contains

- **The LexAgent MCP server** (`.mcp.json`): one remote server at `https://lexagent.nl/mcp`, read-only.
- **dutch-legal-research**: a skill on which sources to read, in what order, and how to report and
  cite them.
- **check-legal-claims**: a skill that gives a verdict per legal claim in a document (klopt, onjuist,
  twijfel, niet gevonden, niet te controleren), each resting on the official source.

The plugin runs no local code: it has no hooks, scripts or local MCP servers.

## What it connects to

The only connection is the LexAgent MCP server at `https://lexagent.nl/mcp`, run by SWIS. You sign in
with a LexAgent account through OAuth the first time Claude uses a LexAgent tool. Claude sends that
server the search terms and document identifiers of its tool calls. The server fetches the texts from
public open-data sources (KOOP, Rechtspraak, the EU Publications Office and OpenBesluitvorming); it
sends no user data to them and changes nothing there.

## Other files

`plugin.json` and `mcp.json` in this folder are the manifest and server entry for the ChatGPT version
of the same plugin. Claude reads `.claude-plugin/plugin.json` and `.mcp.json`.

## Links

- Website and documentation: https://lexagent.nl
- Support: https://lexagent.nl/support
- Privacy: https://lexagent.nl/privacy
- Terms: https://lexagent.nl/voorwaarden

Licensed under Apache-2.0, see `LICENSE`.
