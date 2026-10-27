#!/bin/sh
# OC5: re-point the records drifting by OC5's edits only. The drift list is filtered to the paths OC5 changed
# (Becoming.GrammarPath, the root module, the checker's scope, the package README rows, 07-SIGNIFICANCE, 08-METHOD, the
# study and the philosophers' dossier), so another session's drift stays with its owner; each changed source was read
# before re-pointing. GrammarPath's proof bindings are rebound to the OC5 receipt.
# usage (from the checkout root, after make_record_oc5.py): sh repoint_oc5.sh RECEIPT_ID
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
RF=_process/research/2026-10-05-generative-foundation-review/root-foundation
D=$(mktemp); F=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 - "$D" "$F" "$P" "$RF" <<'PY'
import json, sys
d, f, P, RF = sys.argv[1:5]
text = open(d).read()
data = json.loads(text[text.index('{'):text.rindex('}') + 1])
mine = {f'{P}/Becoming/GrammarPath.lean', f'{P}/Becoming.lean', f'{P}/check_becoming.py', f'{P}/README.md',
        f'{P}/README.zh.md', 'theories/becoming/chapters/07-SIGNIFICANCE.md', 'theories/becoming/chapters/08-METHOD.md',
        f'{RF}/BECOMING-RENEWAL-READING.md', 'theories/becoming/review/PHILOSOPHY.md'}
kept = [x for x in data.get('source_drift', []) if x['path'] in mine]
left = [(x['id'], x['path']) for x in data.get('source_drift', []) if x['path'] not in mine]
json.dump({'source_drift': kept}, open(f, 'w'))
print('re-pointing', len(kept), 'pairs:', sorted({(x['id'], x['path'].split('/')[-1]) for x in kept}))
print('left to their owners:', left)
PY
python3 -B tools/research/repoint.py --reason "OC5: the crux's structure as laws. Becoming.GrammarPath gained «后皆同类则后皆续», «后皆续当且仅当后皆同类», «后皆续则所缘同于», «后皆续当且仅当自与线皆闭», «亡而网续则后不皆续», «本类常当且仅当与己相随», «外分唯系己出之同», the witnesses OtherLeaves and FiniteFamilies.member_no_reach, and FinerWake.finer_class, earlier statements unchanged («本类常闭则后皆续» and «闭则外分无关» now derived from the new laws), with OC3's and OC4's deferred comment fixes; 07-SIGNIFICANCE §4.6 (the home section and its title, P2, the conclusion, the denial of P2, which class P2 reads), P-20, 08-METHOD's receipt and counts, the study, the root module's bullet, the checker's scope and the package README rows; read before re-pointing" \
  --drift-json "$F" \
  --receipt "$P/becoming-checks/$1/verification.json" --lean "$P/Becoming/GrammarPath.lean" --apply
rm -f "$D" "$F"
