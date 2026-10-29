#!/usr/bin/env python3
"""WRP2 (WRT2's repoint_wrt2.py): re-point the records drifting by WRP2's edits only.
The drift list of `research.py check` is filtered to the paths WRP2 changes, so another session's drift stays with its
owner and is printed for it. Two kinds are kept:
* records citing Becoming.GrammarLaws or Becoming.GrammarTransport, whose bytes changed with no landed statement or
  body changed (the signature audit, signatures.json): their references re-pointed and their proof bindings of the
  two files rebound to the receipt;
* records whose cited sections WRP2's texts write (EXPECTED below); a pair outside them stops the script, to be read
  and settled by hand.
Before anything is written, every kept (record, path) pair is listed with its changed sections. Then
tools/research/repoint.py re-points exactly those pairs. The new record must not drift.
usage (from the checkout root, after texts_wrp2.py and make_records_wrp2.py):
  python3 -B <kit>/repoint_wrp2.py RECEIPT [--apply]"""
import json
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path.cwd()
RECEIPT_ID = sys.argv[1]
APPLY = '--apply' in sys.argv[2:]
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
NEW = {'processes-represented-both-ways'}
LEAN = [f'{PKG}/Becoming/GrammarLaws.lean', f'{PKG}/Becoming/GrammarTransport.lean']
OTHER = [f'{PKG}/Becoming.lean', f'{PKG}/README.md', f'{PKG}/README.zh.md', f'{PKG}/check_becoming.py',
         f'{PKG}/becoming-verification.json',
         'theories/becoming/chapters/01-ROOT.md', 'theories/becoming/chapters/08-METHOD.md',
         'theories/becoming/THE-THEORY-OF-BECOMING.md', 'theories/becoming/review/LOGIC.md',
         'theories/becoming/ONE-PAGE.md', 'theories/becoming/ONE-PAGE.zh.md', 'GLOSSARY.md',
         'theories/becoming/results/data/regions.json',
         f'{RF}/BECOMING-RENEWAL-READING.md', f'{RF}/THEOREM-CONNECTIVITY.json', f'{RF}/THEOREM-CONNECTIVITY-APART.json']
# the sections WRP2's texts change, as research.py check names them (a heading, or the anchor a record cites),
# compared without their leading #s
EXPECTED = {
    'theories/becoming/chapters/01-ROOT.md': {'(before the first heading)', 'The root: continuation relative to a class',
                                              'the-root-continuation-relative-to-a-class',
                                              '7. What the grammar can say and what it derives',
                                              'expressible-and-derived', 'r-master-laws-on-the-grammar',
                                              '8. The models', 'models', '8.1 Processes, steps, occurrences',
                                              'models-table', '8.6 The World model in the grammar',
                                              'the-world-model-in-the-grammar', 'instances',
                                              'r-the-world-represented-both-ways', 'Open', 'open'},
    'theories/becoming/chapters/08-METHOD.md': {'Open', 'open', '3. The pure core and the periphery',
                                                '3-the-pure-core-and-the-periphery', 'pure-core-and-periphery'},
    'theories/becoming/THE-THEORY-OF-BECOMING.md': {'1. The root: continuation relative to a class',
                                                    '1-the-root-continuation-relative-to-a-class',
                                                    '10. What is not shown, and what is open',
                                                    '10-what-is-not-shown-and-what-is-open'},
    'theories/becoming/review/LOGIC.md': {'L-21 Expressible is not derived; the World as a model', 'l-21'},
    'GLOSSARY.md': {'The root', 'the-root'},
}
REASON = ("WRP2 landed: Becoming.GrammarLaws and Becoming.GrammarTransport extended, only additions and six proofs of «迭» "
          "changed, every landed statement and body unchanged (the signature audit); Becoming.ProcessRepresentation "
          "joined as a leaf (the root module's imports and doc, the checker's core list and scope, the package README "
          "rows EN and ZH); 01 §8.1 (the theorem of processes-represented-both-ways and the table's process row), 01's "
          "bases line, thesis, claims paragraph and Open entry, §8.6's not-shown line, 01 §7's finite runs for «历»; 08's "
          "Open entry and counts; the overview's two sentences on faithful representation; L-21's weakness line; the "
          "one page in both editions; the glossary; the study; regions.json; the connectivity; read before re-pointing")


def run_repoint(args):
    result = subprocess.run([sys.executable, '-B', 'tools/research/repoint.py'] + args + (['--apply'] if APPLY else []),
                            cwd=ROOT, capture_output=True, text=True)
    print(result.stdout[-4000:], result.stderr[-2000:])
    assert result.returncode == 0, result.returncode
    return json.loads(result.stdout)


out = subprocess.run([sys.executable, '-B', 'tools/research/research.py', 'check'], cwd=ROOT, capture_output=True,
                     text=True).stdout
data = json.loads(out[out.index('{'):out.rindex('}') + 1])
drift = data.get('source_drift', [])
assert not [x for x in drift if x['id'] in NEW], 'the new record drifts: write it after the texts'
lean = [x for x in drift if x['path'] in LEAN]
texts = [x for x in drift if x['path'] in OTHER]
left = [(x['id'], x['path']) for x in drift if x['path'] not in set(LEAN) | set(OTHER)]
unexpected = []
for x in texts:
    sections = {sct.lstrip('#').strip() for sct in (x.get('changed_sections') or [])}
    allowed = EXPECTED.get(x['path'])
    if allowed is None or not sections or not sections <= allowed:
        unexpected.append((x['id'], x['path'], sorted(sections)))
print(f're-pointing {len(lean)} Lean pairs in {len({x["id"] for x in lean})} records:')
for x in lean:
    print('  ', x['id'], x['path'])
print(f're-pointing {len(texts)} text pairs in {len({x["id"] for x in texts})} records:')
for x in texts:
    print('  ', x['id'], x['path'], x.get('changed_sections'))
print('left to their owners:', left)
assert not unexpected, ("drift outside the sections WRP2 writes: read it, then settle it by hand", unexpected)

for label, pairs, extra in (('texts', texts, []), ('Lean', lean, ['--receipt', RECEIPT, '--lean'] + LEAN)):
    if not pairs:
        print(f'repoint ({label}): nothing to re-point')
        continue
    with tempfile.NamedTemporaryFile('w', suffix='.json', delete=False) as f:
        json.dump({'source_drift': pairs}, f)
    summary = run_repoint(['--reason', REASON, '--drift-json', f.name] + extra)
    Path(f.name).unlink()
    print(f'repoint ({label}):', summary['records'], 'records', 'written' if APPLY else '(dry run)')
