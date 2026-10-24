#!/bin/sh
# run_code_gpt.sh : the GPT coder on all twelve packets, at most four runs at a time (FC1 codebook v1.1 and schema)
K=$(cd "$(dirname "$0")" && pwd)
FC1=$K/../zhonghua/fidelity
ls "$K"/data/code_packets/code_*.json | xargs -P 4 -I{} sh "$K/run_cx.sh" "$FC1/briefs/code.md" "$FC1/briefs/code.schema.json" {} "$K/data/coded/gpt"
