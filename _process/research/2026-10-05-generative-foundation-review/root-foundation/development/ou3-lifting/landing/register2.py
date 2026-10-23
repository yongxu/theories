"""OU2 + OU3a: remove the register entries of grammar theorems that base theorems now use (no longer apart roots),
and register the new apart roots. Textual edits, the rest of the file byte for byte.
usage (from the checkout root): python3 -B register2.py"""
import json
import re
from pathlib import Path
F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
t = F.read_text(encoding='utf-8')
STALE = ['Becoming.«一之下无复生»', 'Becoming.«亡于粗则亡于细»', 'Becoming.«任一缘可为续»', 'Becoming.«则之自反»',
         'Becoming.«四相之定当且仅当排中»', 'Becoming.«四相无自立»', 'Becoming.«无环则及为序»', 'Becoming.«有亡之续则不有常»',
         'Becoming.«有常则相续不尽»', 'Becoming.«根»', 'Becoming.«生生则复生»', 'Becoming.«相续含于及»', 'Becoming.«蜡烛之合»']
for name in STALE:
    pat = re.compile(r'  "' + re.escape(name) + r'": \{\n(?:   [^\n]*\n)*?  \},?\n')
    m = pat.search(t)
    assert m, name
    t = t[:m.start()] + t[m.end():]
# a removed last entry would leave a trailing comma before the closing brace of roots
t = t.replace('  },\n },\n "instances": {', '  }\n },\n "instances": {')
GS = 'general-structure'
STEPS = 'a law of every predicate along the step index read through the grammar; the base supplies no reading of the predicate'
REL = 'a law of every continuation relation on (step, relatum) occurrences read through the grammar; it reads no web'
GR = 'a law of every relation on any carrier; '
entries = {
    'Becoming.«一之下皆息»': ('Becoming.Grammar', GS, GR + 'under the full class everything ceases'),
    'Becoming.«因于则因于核»': ('Becoming.Grammar', GS, GR + 'leaning-on through constancy is leaning-on through the core'),
    'Becoming.«相须则相须核»': ('Becoming.Grammar', GS, GR + 'mutual need through constancy is mutual need through the core'),
    'Becoming.«相须之对称»': ('Becoming.Grammar', GS, GR + 'mutual need is symmetric'),
    'Becoming.«无自相须»': ('Becoming.Grammar', GS, GR + 'nothing needs itself'),
    'Becoming.«生生不息»': ('Becoming.Grammar', GS, GR + 'renewal without end does not cease'),
    'Becoming.«火因于薪»': ('Becoming.Grammar', 'model-witness', 'the flame witness: its regularity lies in fire and fuel'),
    'Becoming.«化之二说同形»': ('Becoming.GrammarReadings', GS, GR + 'the 墨经 and 荀子 readings of 化 are one form'),
    'Becoming.«化为有缘之成坏»': ('Becoming.GrammarReadings', GS, GR + '化 is 成坏 along 缘'),
    'Becoming.«同于为类»': ('Becoming.GrammarReadings', GS, GR + 'sameness in belonging is a class where belonging is single'),
    'Becoming.«同于不必传递»': ('Becoming.GrammarReadings', 'model-witness',
                             'one constructed relation on numbers where belonging to two makes sameness intransitive'),
    'Becoming.«复者住»': ('Becoming.GrammarReadings', GS, GR + 'what returns abides'),
    'Becoming.«有常则通»': ('Becoming.GrammarReadings', GS, GR + 'under a constant class a line with a past never ends'),
    'Becoming.«非一非异»': ('Becoming.GrammarReadings', GS, GR + 'continuation is neither identity nor mere difference'),
    'Becoming.«因灭而续»': ('Becoming.GrammarReadings', GS, GR + 'the conditioning occurrence ends under identity while the line continues under a coarser class'),
    'Becoming.CeasesToBe.not_comes_by_grammar': ('Becoming.Change', 'restates', 'CeasesToBe.not_comes derived through the grammar'),
    'Becoming.ComesToBe.not_ceases_by_grammar': ('Becoming.Change', 'restates', 'ComesToBe.not_ceases derived through the grammar'),
    'Becoming.persists_by_grammar': ('Becoming.Change', 'restates', 'persists derived through persists_of_positions'),
    'Becoming.persists_of_em_by_grammar': ('Becoming.Change', 'restates', 'persists_of_em derived through persists_of_positions'),
    'Becoming.still_stays_of_constant': ('Becoming.Change', GS, STEPS + ' (constancy never lets the line end)'),
    'Becoming.still_of_buqiong': ('Becoming.Change', GS, STEPS + ' (a line that never ends stays still)'),
    'Becoming.buqiong_of_stays_failing': ('Becoming.Change', GS, STEPS + ' (a predicate that stays false never ends its line)'),
    'Becoming.continues_in_core_iff_buqiong': ('Becoming.Change', GS, STEPS + ' (continuing under the core is never ending)'),
    'Becoming.positions_iff_change': ('Becoming.Change', GS, STEPS + ' (deciding a position is deciding a change)'),
    'Becoming.Steps.alike_class': ('Becoming.Arising', 'support', 'alike in a predicate is a class: a one-line unpacking'),
    'Becoming.Steps.sheng_zero': ('Becoming.Arising', 'support', 'the first step begins: a one-line unpacking'),
    'Becoming.Steps.along_sheng_zero': ('Becoming.Arising', 'support', 'along a relatum the first step begins: a one-line unpacking'),
    'Becoming.Web.begins_at_zero': ('Becoming.Identity', 'support', 'along a continuation the first step begins: a one-line unpacking'),
    'Becoming.Web.nothing_continues_under_identity': ('Becoming.Identity', GS, REL + ' (nothing continues under identity)'),
    'Becoming.Web.positions_not_self_standing': ('Becoming.Identity', GS, REL + ' (no position stands by itself)'),
    'Becoming.Web.reach_strict_order': ('Becoming.Identity', GS, REL + ' (reach along steps is a strict order)'),
    'Becoming.Web.linked_iff_line': ('Becoming.ContinuedClasses', GS, REL + ' (links are lines under the one)'),
}
block = ''
for name, (mod, cat, reason) in entries.items():
    assert f'"{name}"' not in t, name
    block += ('  "' + name + '": {\n   "module": "' + mod + '",\n   "category": "' + cat + '",\n'
              '   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
anchor = '  }\n },\n "instances": {'
assert t.count(anchor) == 1
t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
d = json.loads(t)
assert not any(n in d['roots'] for n in STALE)
F.write_text(t, encoding='utf-8')
print('register2: removed', len(STALE), 'added', len(entries))
