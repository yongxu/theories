"""Check 3f: does a comment edit inside a definition read as a rewrite under blank_comments? Blanket's structure Parts
has field docstrings; edit one, keeping and changing its length (read-only; the edit is in memory)."""
import importlib.util, sys
from pathlib import Path
sys.dont_write_bytecode = True
ROOT = Path.cwd()
spec = importlib.util.spec_from_file_location('s3b', ROOT / '_process/research/2026-10-05-generative-foundation-review/'
                                              'root-foundation/development/ou3b-master-laws-on-the-grammar/kit/signatures_ou3b.py')
s = importlib.util.module_from_spec(spec); spec.loader.exec_module(s)
src = (ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Blanket.lean').read_text(encoding='utf-8')
old = '/-- The internal part. -/'
assert src.count(old) == 1
new = '/-- The interior part. -/'
assert len(new) == len(old)
same_len = src.replace(old, new)
longer = src.replace(old, '/-- The internal part, read as one. -/')
base = s.definitions(src)['Becoming.Blanket.Parts']
print('same-length edit reads as a rewrite:', s.definitions(same_len)['Becoming.Blanket.Parts'] != base)
print('length-changing edit reads as a rewrite:', s.definitions(longer)['Becoming.Blanket.Parts'] != base)
norm = lambda t: ' '.join(t.split())
print('with whitespace normalized, length-changing edit reads as a rewrite:',
      norm(s.definitions(longer)['Becoming.Blanket.Parts']) != norm(base))
