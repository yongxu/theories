#!/bin/zsh
# WL2 landing, as run on 22 October 2026 (from the checkout root, the Lean and module text already committed):
#   zsh land.sh check   # the core checker (writes the receipt), then connectivity
#   zsh land.sh text    # register, landing text, records, the 中华本, re-point, render, check, links, test
set -e
D=_process/research/2026-10-05-generative-foundation-review/root-foundation
K=$D/development/wl2-wenli-laws
Z=$D/development/zhonghua
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
case $1 in
check)
  (cd $P && python3 -B check_becoming.py) > $K/checker2.log 2>&1
  python3 -B $D/THEOREM-CONNECTIVITY.py --check > $K/connectivity.log 2>&1 || true
  ;;
text)
  R=$(python3 -c "import json;print(json.load(open('$P/becoming-verification.json'))['utc'])")
  BASE=$(python3 -c "import json;print(json.load(open('$P/becoming-checks/$R/verification.json'))['source_commit']['main'])")
  python3 -B $K/register.py
  python3 -B $D/THEOREM-CONNECTIVITY.py --check > $K/connectivity.log 2>&1 || true
  python3 -B $K/apply_text_wl2.py $R $K/connectivity.log $BASE > $K/apply_text.log
  N=$(awk '/^STUDY_SECTION/ {print $2}' $K/apply_text.log)
  SLUG=$(awk '/^STUDY_SLUG/ {print $2}' $K/apply_text.log)
  # PREVIOUS: the receipt main pointed to before the run (20261022T103619.721318Z on 22 October)
  python3 -B $K/make_records_wl2.py $R $N "$SLUG" 20261022T103619.721318Z > $K/make_records.log
  python3 -B $K/wen1_edit.py
  python3 -I $Z/finish.py > $K/finish.log 2>&1
  make research-render > $K/render.log 2>&1 || true
  make research-check > $K/check.log 2>&1 || true
  # read each drifting source first (RESULT-WORKFLOW, "Hashes"); the drift is this landing's own edits
  # (save the check's JSON as $K/drift.json), then:
  #   python3 -B tools/research/repoint.py --reason ... --drift-json $K/drift.json \
  #     --receipt $P/becoming-checks/$R/verification.json --lean $P/Becoming/IdentificationRuns.lean $P/Becoming/SharedCodes.lean --apply
  make research-render > $K/render.log 2>&1
  make research-check > $K/check.log 2>&1
  make research-links > $K/links.log 2>&1
  make research-test > $K/test.log 2>&1
  python3 -B $D/THEOREM-CONNECTIVITY.py --write > $K/connectivity_write.log 2>&1
  ;;
esac
# 22 October 2026: FL1 landed on main with study section 348 while this landing was in progress; on merging main the
# WL2 section became 349, and its citations (chapter EN/ZH, WENLI fragments, records, round 8's notes, board) were
# renumbered; the logs in this folder from the first pass still show 348.
