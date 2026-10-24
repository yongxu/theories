#!/bin/sh
# ZE: the GPT coder on the sample's packets (data/packets/gpt_zh, gpt_ce), FC1's inline runner, at most 4 at once.
#     sh run_gpt.sh        (from this kit)
F=../zhonghua/fidelity
run() { sh $F/run_codex_inline.sh $F/briefs/code.md $F/briefs/code.schema.json "$1" "data/coded/codex/$(basename $(dirname $1))"; }
set -- data/packets/gpt_zh/*.json data/packets/gpt_ce/*.json
n=0
for p in "$@"; do
  run "$p" &
  n=$((n+1))
  [ $((n % 4)) -eq 0 ] && wait
done
wait
