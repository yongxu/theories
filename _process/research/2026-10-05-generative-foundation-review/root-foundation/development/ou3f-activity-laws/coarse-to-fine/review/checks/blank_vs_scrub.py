"""Check 3c: blank_comments against the catalogue's scrub (tools/research/lean_catalogue.py) on every module of HEAD's
receipt, the string delimiters aside (blank_comments keeps them, scrub blanks them); and a census of the lexical cases
that could trip it: raw strings, char literals, quotes, «» names holding -- or /- or a quote, /--/ (read-only)."""
import importlib.util, json, re, sys
from pathlib import Path
sys.dont_write_bytecode = True
ROOT = Path.cwd()
sys.path.insert(0, str(ROOT))
from tools.research import lean_catalogue
REL = ('_process/research/2026-10-05-generative-foundation-review/root-foundation/development/'
       'ou3b-master-laws-on-the-grammar/kit/signatures_ou3b.py')
spec = importlib.util.spec_from_file_location('s3b_new', ROOT / REL)
new = importlib.util.module_from_spec(spec); spec.loader.exec_module(new)
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
receipt = json.loads((PKG / 'becoming-verification.json').read_text())
differ, census = [], {'raw_string': [], 'char_literal': [], 'code_quote_lines': 0, 'guillemet_specials': [],
                      'slash_dash_dash_slash': [], 'prime_window': 0}
for m in receipt['modules']:
    text = (PKG.parent / receipt['source_paths'][m['module']]).read_text(encoding='utf-8')
    a = new.blank_comments(text)
    assert len(a) == len(text) and a.count('\n') == text.count('\n'), m['module']
    b = lean_catalogue.scrub(text)
    if a.replace('"', ' ') != b:
        i = next(k for k, (x, y) in enumerate(zip(a.replace('"', ' '), b)) if x != y)
        differ.append((m['module'], text.count('\n', 0, i) + 1, text[max(0, i - 30):i + 30]))
    if re.search(r'\br#*"', a):
        census['raw_string'].append(m['module'])
    for x in re.finditer(r"'(?:\\.|[^\\'\n])'", a):
        census['char_literal'].append((m['module'], x.group()))
    census['code_quote_lines'] += sum('"' in line for line in a.split('\n'))
    for x in re.finditer(r'«[^»]*»', text):
        if any(s in x.group() for s in ('--', '/-', '-/', '"', "'")):
            census['guillemet_specials'].append((m['module'], x.group()))
    if '/--/' in text or '/-!/' in text:
        census['slash_dash_dash_slash'].append(m['module'])
    census['prime_window'] += len(re.findall(r"[A-Za-z0-9_]'[^\\'\n]'", text))
print(json.dumps({'modules': len(receipt['modules']), 'differ_from_scrub': differ[:20], 'differ_count': len(differ),
                  'census': {k: (v if not isinstance(v, list) else v[:12]) for k, v in census.items()},
                  'census_counts': {k: (len(v) if isinstance(v, list) else v) for k, v in census.items()}},
                 indent=1, ensure_ascii=False))
