#!/bin/sh
# run_cx.sh BRIEF SCHEMA PACKET OUTDIR : one GPT run (gpt-6-astra, high effort), the packet given inline in the prompt
# (one turn, no file reads); blind: a fresh scratch dir, `cx --fresh --clean` (no user configuration, no prior thread).
# FC1's run_codex_inline.sh pattern; retries a capacity or transient failure with backoff.
BRIEF=$1; SCHEMA=$2; PACKET=$3; OUT=$4
name=$(basename "$PACKET" .json)
mkdir -p "$OUT"
[ -s "$OUT/$name.json" ] && { echo "skip $name"; exit 0; }
base=${SC1_SCRATCH:-/private/tmp/claude-501/-Users-ren-theories/ab4fc732-b2ac-420a-aa49-cf63c999271c/scratchpad}/sc1-cx
mkdir -p "$base"
work=$(mktemp -d "$base/run.XXXXXX")
cp "$SCHEMA" "$work/schema.json"
{ cat "$BRIEF"; printf '\n\n## The packet\n\nAnswer from the packet below only; do not run commands or open files. Answer for every item.\n\n```json\n'; cat "$PACKET"; printf '\n```\n'; } > "$work/brief.md"
i=0
while :; do
  ( cd "$work" && cx --fresh --clean -m astra -e high --schema schema.json -C . < brief.md > raw.txt 2>&1 )
  grep -q '── cx · ok' "$work/raw.txt" && break
  i=$((i+1)); [ $i -ge 6 ] && break
  sleep $((60 * i))
done
echo "$name attempts=$((i+1))" >> "$OUT/runs.log"
python3 -I - "$work/raw.txt" "$OUT/$name.json" <<'PY'
import json, sys
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
