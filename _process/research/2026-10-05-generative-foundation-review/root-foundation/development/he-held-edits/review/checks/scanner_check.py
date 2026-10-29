"""Item 7: how each source scanner reads GrammarPath before and after the reflow (read-only; -B, no bytecode).
usage: python3 -B scanner_check.py SCRATCH_WORKTREE NEW_RECEIPT"""
import importlib.util, json, re, subprocess, sys
from pathlib import Path
S, NEW = Path(sys.argv[1]), sys.argv[2]
sys.dont_write_bytecode = True
sys.path.insert(0, str(S))
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
new_src = (S / PKG / 'Becoming/GrammarPath.lean').read_text(encoding='utf-8')
old_src = subprocess.run(['git', '-C', str(S), 'show', f'a15457b2e:{PKG}/Becoming/GrammarPath.lean'], capture_output=True, text=True, check=True).stdout
spec = importlib.util.spec_from_file_location('s3b', S / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3b-master-laws-on-the-grammar/kit/signatures_ou3b.py')
s3b = importlib.util.module_from_spec(spec); spec.loader.exec_module(s3b)
real = {d['name'] for m in json.load(open(NEW))['modules'] if m['module'] == 'Becoming.GrammarPath' for d in m['declarations']}
dn, do = s3b.definitions(new_src), s3b.definitions(old_src)
print('1. OU3b definitions(): names scanned that are no declaration of the receipt')
print('   old source:', sorted(n for n in do if n not in real))
print('   new source:', sorted(n for n in dn if n not in real))
print('   column-0 docstring lines starting with "class " in the new source:',
      [l[:40] for l in new_src.split('\n') if l.startswith('class ')])
from tools.research import registry, lean_catalogue
def decl_lines(src):
    return [(src.count('\n', 0, m.start()) + 1, m.group(1)) for m in registry.DECLARATION.finditer(src)]
dl_new, dl_old = decl_lines(new_src), decl_lines(old_src)
lines = new_src.split('\n')
on_doc = [(n, name) for n, name in dl_new if not re.match(r"\s*(?:@\[[^\]\n]*\]\s*)*(?:(?:protected|private|noncomputable)\s+)*(?:theorem|lemma|def|abbrev|structure|inductive|instance)\b", lines[n - 1]) or lines[n - 1].startswith('class ')]
print('2. research check (registry.DECLARATION on raw text; keywords theorem|lemma|def|abbrev|structure|inductive|instance, no "class"):',
      'matches', len(dl_new), 'new /', len(dl_old), 'old; same names both ways:', sorted(x for _, x in dl_new) == sorted(x for _, x in dl_old),
      '| matches on a "class ..." docstring line:', on_doc)
cat = lean_catalogue.parse_lean(new_src.encode())
print('3. Lean index/catalogue (lean_catalogue.parse_lean, comments and strings blanked first): names',
      len(cat['declarations']), '| "constant" among them:', any(d['name'] == 'constant' for d in cat['declarations']),
      '| top-level "Becoming.constant":', any(d['qualified_name_hint'] == 'Becoming.constant' for d in cat['declarations']))
print('4. the checker\'s registry in the receipt (audit_support.scan; every name is #print axioms\'d): "Becoming.constant" listed:',
      'Becoming.constant' in real, '| real Becoming.Unclosed.constant listed:', 'Becoming.Unclosed.constant' in real)
