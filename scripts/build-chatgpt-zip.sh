#!/usr/bin/env bash
# Builds ChatGPT plugin ZIPs from plugins/lexagent, leaving out the Claude-only manifest:
#   dist/lexagent-chatgpt.zip             for a workspace upload (Admin console)
#   dist/lexagent-chatgpt-submission.zip  for platform.openai.com/plugins, with the review
#                                         and publication settings from openai/submission.json
# A workspace upload rejects the review block, so it only goes into the submission ZIP.
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
plugin="$root/plugins/lexagent"
dist="$root/dist"
stage="$(mktemp -d)"
trap 'rm -rf "$stage"' EXIT

mkdir -p "$dist"

build() {
    local out="$1"
    rm -f "$out"
    (cd "$stage" && zip -qr "$out" plugin.json mcp.json skills assets -x '*.DS_Store')
    echo "$out"
}

cp -R "$plugin/mcp.json" "$plugin/skills" "$plugin/assets" "$stage/"
cp "$plugin/plugin.json" "$stage/plugin.json"
build "$dist/lexagent-chatgpt.zip"

python3 - "$plugin/plugin.json" "$root/openai/submission.json" "$stage/plugin.json" <<'PY'
import json, sys
manifest = json.load(open(sys.argv[1]))
manifest['extensions']['com.openai'].update(json.load(open(sys.argv[2])))
json.dump(manifest, open(sys.argv[3], 'w'), indent=2, ensure_ascii=False)
PY
build "$dist/lexagent-chatgpt-submission.zip"
