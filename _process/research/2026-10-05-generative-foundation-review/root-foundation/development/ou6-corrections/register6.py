#!/usr/bin/env python3
"""OU6: register the new apart roots of Grammar, GrammarReadings and GrammarMap with their reasons, and remove the
entries no longer apart roots (the renamed and removed declarations). Reads both lists from the connectivity log.
usage (from the checkout root): python3 -B register6.py CONNECTIVITY_LOG"""
import ast
import json
import re
import sys
from pathlib import Path

F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
GENERAL = 'a law of every relation on any carrier; the base supplies no reading of continuation relative to a class yet'
MAP = 'a law of every relation read at a fine and a coarse class on any carrier; the base supplies no reading of the two grains yet'
CAL = ('the exact logical principle a stated law of the grammar needs (excluded middle); a lemma of the item that needs it')
REASONS = {
    'Becoming.«位同则生亡同»': ('Becoming.Grammar', 'general-structure', 'for a class, what shares a position under the two-way core shares beginning and ending; ' + GENERAL),
    'Becoming.«火薪相须»': ('Becoming.Grammar', 'model-witness', 'the one-flame witness: "flame or not" and "the same fuel left" need each other through the core'),
    'Becoming.«火之见证不择类»': ('Becoming.Grammar', 'model-witness', 'the one-flame witness picks no class: every class that with "flame or not" tells the moments apart suffices'),
    'Becoming.«两火以薪定理»': ('Becoming.Grammar', 'model-witness', 'the two-flame witness: the fuel left suffices while relating two distinct occurrences'),
    'Becoming.«两火同火不足以定理»': ('Becoming.Grammar', 'model-witness', 'the two-flame witness: sameness of flame does not suffice'),
    'Becoming.«不复生则息»': ('Becoming.Grammar', 'general-structure', 'where nothing on the line renews, the occurrence ceases (the earlier reading of 息 implies the inductive one); ' + GENERAL),
    'Becoming.«一之下无复生»': ('Becoming.Grammar', 'general-structure', 'under the one nothing begins from a condition, so nothing renews (no longer used by the proof of «一之下皆息», which is now by construction); ' + GENERAL),
    'Becoming.«生生则复生»': ('Becoming.Grammar', 'general-structure', 'renewal without end renews (no longer used by the proof of «生生不息», which is now by induction); ' + GENERAL),
    'Becoming.«有常则往不穷»': ('Becoming.GrammarReadings', 'general-structure', 'under a constant class a line with a past never ends going; ' + GENERAL),
    'Becoming.«两向有常则通»': ('Becoming.GrammarReadings', 'general-structure', 'constant both ways, what abides passes through (通, going and coming); ' + GENERAL),
    'Becoming.«有常而不通»': ('Becoming.GrammarReadings', 'model-witness', 'counting up from zero: constant one way, going never ends, and coming ends: not 通'),
    'Becoming.«昼夜往来不穷»': ('Becoming.GrammarReadings', 'model-witness', 'day and night go and come without end'),
    'Becoming.«不穷有终之定当且仅当排中»': ('Becoming.GrammarMap', 'calibration', CAL),
    'Becoming.«全三域之定当且仅当排中»': ('Becoming.GrammarMap', 'calibration', CAL),
    'Becoming.«生生即延»': ('Becoming.GrammarMap', 'general-structure', 'renewal without end is going on along some branch of renewing into, read under the one; ' + GENERAL),
    'Becoming.«息即尽»': ('Becoming.GrammarMap', 'general-structure', 'ceasing is ending on every branch of renewing into, read under the one; ' + GENERAL),
    'Becoming.«位同则住同»': ('Becoming.Grammar', 'general-structure', 'for a class, what shares a position under the two-way core shares abiding; ' + GENERAL),
    'Becoming.«自不复生则息»': ('Becoming.Grammar', 'general-structure', 'what does not itself renew ceases; ' + GENERAL),
}

log = Path(sys.argv[1]).read_text()
m = re.search(r"apart roots without a reason in THEOREM-CONNECTIVITY-APART.json: (\[.*?\]); "
              r"register entries no longer apart roots: (\[.*?\])", log)
roots, stale = (ast.literal_eval(m.group(1)), ast.literal_eval(m.group(2))) if m else ([], [])
data = json.loads(F.read_text(encoding='utf-8'))
section = next(k for k, v in data.items() if isinstance(v, dict) and 'Becoming.«生生不息»' in v)
for name in stale:
    assert name in data[section], name
    del data[section][name]
for name in roots:
    assert name in REASONS, f'no reason written for {name}'
    module, category, reason = REASONS[name]
    data[section][name] = {'module': module, 'category': category, 'reason': reason}
F.write_text(json.dumps(data, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('removed', stale, 'registered', roots)
