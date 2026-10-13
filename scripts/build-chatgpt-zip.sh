#!/usr/bin/env bash
# Builds ChatGPT plugin ZIPs from plugins/lexagent, leaving out the Claude-only manifest.
#
#   scripts/build-chatgpt-zip.sh
#       dist/lexagent-chatgpt-submission.zip  for platform.openai.com/plugins ("With MCP"): mcp.json
#                                             plus the review and publication settings from
#                                             openai/submission.json
#
#   scripts/build-chatgpt-zip.sh --workspace-app asdk_app_...
#       dist/lexagent-chatgpt-workspace.zip   for a workspace upload or import: an .app.json pointing
#                                             at LexAgent registered as an app in that workspace
#
# ChatGPT marks an uploaded or imported plugin that declares its MCP server in mcp.json as
# "Desktop only", even for a remote server, while the public submission refuses .app.json; hence
# two variants. The app id is the plugin_asdk_app_... id from the registered app's URL without
# its "plugin_" prefix.
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
plugin="$root/plugins/lexagent"
dist="$root/dist"
stage="$(mktemp -d)"
trap 'rm -rf "$stage"' EXIT

app_id=""
if [ "${1:-}" = "--workspace-app" ]; then
    app_id="${2:?usage: $0 [--workspace-app asdk_app_...]}"
    if [[ ! "$app_id" =~ ^(asdk_app_|connector_)[A-Za-z0-9][A-Za-z0-9_-]*$ ]]; then
        echo "Expected an app id starting with asdk_app_ or connector_ (drop the plugin_ prefix)." >&2
        exit 1
    fi
fi

mkdir -p "$dist"
cp -R "$plugin/skills" "$plugin/assets" "$stage/"

if [ -n "$app_id" ]; then
    printf '{\n  "apps": {\n    "lexagent": { "id": "%s", "required": true }\n  }\n}\n' "$app_id" > "$stage/.app.json"
    python3 - "$plugin/plugin.json" "$stage/plugin.json" <<'PY'
import json, sys
manifest = json.load(open(sys.argv[1]))
manifest['extensions']['com.openai']['apps'] = './.app.json'
json.dump(manifest, open(sys.argv[2], 'w'), indent=2, ensure_ascii=False)
PY
    out="$dist/lexagent-chatgpt-workspace.zip"
    files=(plugin.json .app.json skills assets)
else
    cp "$plugin/mcp.json" "$stage/"
    python3 - "$plugin/plugin.json" "$root/openai/submission.json" "$stage/plugin.json" <<'PY'
import json, sys
manifest = json.load(open(sys.argv[1]))
manifest['extensions']['com.openai'].update(json.load(open(sys.argv[2])))
json.dump(manifest, open(sys.argv[3], 'w'), indent=2, ensure_ascii=False)
PY
    out="$dist/lexagent-chatgpt-submission.zip"
    files=(plugin.json mcp.json skills assets)
fi

rm -f "$out"
(cd "$stage" && zip -qr "$out" "${files[@]}" -x '*.DS_Store')
echo "$out"
