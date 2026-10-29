#!/bin/bash
# OU3f's coarse-to-fine pair: the landing steps, in the landing worktree, once the head is claimed and main merged.
# Each stage stops at the first failure (no pipe hides one) and keeps its output in kit/landing/, committed with
# the landing as evidence.
#   run      the measure on main, integrate, the core checker (receipt into the repository), the signature audit,
#            the connectivity check and the measure again, which must not move
#   texts    08's counts and the study section, numbered after the study's last
#   records  the records check; the re-point of the records pinning Persistence, refused unless the drift is
#            exactly the four read for this landing; a recheck showing no drift; the connectivity data written
#   board    QUEUE_TEXT LANDED_CLAUSE: the queue's landed clause, the latest receipt, OU3f's row to the history file
# usage (from the checkout root of the landing worktree): bash <kit>/land_ctf.sh run|texts|records|board ...
set -euo pipefail
KIT=$(cd "$(dirname "$0")" && pwd)
OUT=$KIT/landing
PKG=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
RF=_process/research/2026-10-05-generative-foundation-review/root-foundation
STUDY=$RF/BECOMING-RENEWAL-READING.md
DRIFT_EXPECTED='continuation-relative-to-a-class identity-across-steps master-laws-on-the-grammar the-world-represented-both-ways'
mkdir -p "$OUT"
[ -z "$(git ls-files -u)" ] && [ ! -e "$(git rev-parse --git-dir)/MERGE_HEAD" ] || { echo 'a merge is in progress'; exit 1; }

receipt() { python3 -c "import json; print(json.load(open('$PKG/becoming-verification.json'))['utc'])"; }
section() { python3 -c "
import re; print(max(int(x) for x in re.findall(r'^## (\d+)\. ', open('$STUDY', encoding='utf-8').read(), re.M)) + 1)"; }
ours() {  # the study's last section, which must be this landing's
    local n=$(( $(section) - 1 ))
    grep -q "^## $n\. The coarse-to-fine pair" "$STUDY" || { echo "the study's last section is not this landing's" >&2; exit 1; }
    echo "$n"
}

case "${1:-}" in
run)
    MEASURE="$RF/development/ou3b-master-laws-on-the-grammar/measure_grammar.py"
    python3 -B "$MEASURE" --json "$OUT/measure-main.json" > "$OUT/measure-main.log" 2>&1
    python3 -B "$KIT/integrate_ctf.py"
    (cd "$PKG" && python3 -B check_becoming.py) > "$OUT/checker.log" 2>&1
    R=$(receipt)
    BEFORE=$(git show "HEAD:$PKG/becoming-verification.json" | python3 -c "import json, sys; print(json.load(sys.stdin)['utc'])")
    [ "$R" != "$BEFORE" ] || { echo "the checker wrote no new receipt ($R is HEAD's)"; exit 1; }
    python3 - "$PKG/becoming-verification.json" <<'EOF'
import json, sys
d = json.load(open(sys.argv[1]))
assert d['status'] == 'passed' and d['core_compiles_from_prelude'] is True, d['status']
assert not [m['module'] for m in d['modules'] if any(m['axiom_dependencies'].values())], 'an axiom report is not empty'
assert all(name.endswith('.injEq') and axioms == ['propext'] for name, axioms in d['generated_axiom_dependencies'].items())
EOF
    echo "receipt $R" | tee -a "$OUT/checker.log"
    python3 -B "$KIT/signatures_ctf.py" "$R" > "$OUT/signatures.log" 2>&1
    tail -3 "$OUT/signatures.log"
    python3 -B "$RF/THEOREM-CONNECTIVITY.py" --check > "$OUT/conn-check.log" 2>&1
    python3 -B "$MEASURE" --json "$OUT/measure-landing.json" > "$OUT/measure.log" 2>&1
    python3 - "$OUT/measure-main.json" "$OUT/measure-landing.json" <<'EOF'
import json, sys
keys = ('central_declarations', 'reaching_the_grammar', 'distinct_central_declarations', 'distinct_by_dependence',
        'distinct_by_category', 'distinct_gaps')
a, b = ({k: json.load(open(p))[k] for k in keys} for p in sys.argv[1:3])
print('measure:', b['reaching_the_grammar'], 'of', b['central_declarations'], b['distinct_by_dependence'], 'gaps', b['distinct_gaps'])
assert a == b, f'the measure moved: {a} -> {b}'
EOF
    ;;
texts)
    R=$(receipt); N=$(section)
    python3 -B "$KIT/texts_ctf.py" "$R" "$N"
    ;;
records)
    R=$(receipt)
    # The check exits 1 while generated views lag; the drift is what this stage reads.
    python3 -B tools/research/research.py check > "$OUT/drift.json" 2> "$OUT/check.err" || true
    python3 - "$OUT/drift.json" "$DRIFT_EXPECTED" <<'EOF'
import json, sys
d = json.load(open(sys.argv[1]))
pairs = sorted((x['id'], x['path'].rsplit('/', 1)[-1]) for x in d['source_drift'])
want = sorted((i, 'Persistence.lean') for i in sys.argv[2].split())
assert pairs == want, f'drift is not the four records read for this landing: {pairs}'
assert not d['unrelated_source_drift'], d['unrelated_source_drift']
print('drift: the four records pinning Persistence, nothing else')
EOF
    N=$(ours)
    REASON="OU3f's coarse-to-fine pair (§$N): Persistence's wang_state_of_change and sheng_state_of_change read from «亡于粗则亡于细» and «生于粗则生于细» and its header naming steady_held by closure, statements unchanged; no record's claim changes"
    python3 -B tools/research/repoint.py --reason "$REASON" --drift-json "$OUT/drift.json" \
        --receipt "$PKG/becoming-checks/$R/verification.json" --lean "$PKG/Becoming/Persistence.lean" > "$OUT/repoint-dry.log" 2>&1
    python3 -B tools/research/repoint.py --reason "$REASON" --drift-json "$OUT/drift.json" \
        --receipt "$PKG/becoming-checks/$R/verification.json" --lean "$PKG/Becoming/Persistence.lean" --apply > "$OUT/repoint.log" 2>&1
    python3 -B tools/research/research.py check --ids $DRIFT_EXPECTED > "$OUT/drift2.json" 2> "$OUT/check2.err" || true
    python3 - "$OUT/drift2.json" <<'EOF'
import json, sys
d = json.load(open(sys.argv[1]))
assert not d['source_drift'], d['source_drift']
left = [e for e in d.get('errors') or [] if not e.startswith('generated view differs')]
assert not left, left
print('re-pointed: no drift, no error but generated views, which the render rewrites')
EOF
    python3 -B "$RF/THEOREM-CONNECTIVITY.py" --write > "$OUT/conn-write.log" 2>&1
    ;;
board)
    R=$(receipt); N=$(ours)
    python3 -B "$KIT/board_ctf.py" land "$R" "$N" "$2" "$3"
    ;;
*)
    sed -n '2,11p' "$0"; exit 2
    ;;
esac
