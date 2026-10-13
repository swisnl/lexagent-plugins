#!/usr/bin/env bash
# Builds the ZIP uploaded at platform.openai.com/plugins from plugins/lexagent, leaving out the
# Claude-only manifest so the OpenAI validator sees a single plugin.json.
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
plugin="$root/plugins/lexagent"
out="$root/dist/lexagent-chatgpt.zip"

mkdir -p "$root/dist"
rm -f "$out"
(cd "$plugin" && zip -qr "$out" plugin.json mcp.json skills assets -x '*.DS_Store')
echo "$out"
