#!/bin/sh
# run_codex.sh BRIEF SCHEMA PACKET OUTDIR : one Codex coder run on one packet (blind: a scratch dir, no user config)
BRIEF=$1; SCHEMA=$2; PACKET=$3; OUT=$4
name=$(basename "$PACKET" .json)
work=$(mktemp -d /private/tmp/claude-501/-Users-ren-theories/ab4fc732-b2ac-420a-aa49-cf63c999271c/scratchpad/fc-codex/run.XXXXXX)
cp "$PACKET" "$work/packet.json"; cp "$SCHEMA" "$work/schema.json"
{ cat "$BRIEF"; printf '\n\nThe packet is the file packet.json in your working directory. Read it in full and answer for every item.\n'; } > "$work/brief.md"
( cd "$work" && cx --fresh --clean -m astra -e high --schema schema.json -C . < brief.md > raw.txt 2>&1 )
python3 -I - "$work/raw.txt" "$OUT/$name.json" <<'PY'
import json, sys, re
t = open(sys.argv[1], encoding='utf-8').read()
body = t.split('\n── cx ·')[0].strip()
i = body.find('{')
try:
    obj = json.loads(body[i:])
    open(sys.argv[2], 'w', encoding='utf-8').write(json.dumps(obj, ensure_ascii=False, indent=1))
    print('ok', sys.argv[2])
except Exception as e:
    open(sys.argv[2] + '.err', 'w').write(t[-4000:]); print('FAILED', sys.argv[2], e)
PY
cp "$work/raw.txt" "$OUT/$name.raw.txt"
