#!/usr/bin/env python3
"""HE2: compare every declaration of the modules HE2 changes between main's receipt (the one HEAD holds) and HE2's (or a
rehearsal's) receipt, against what the items' kits say they change, two ways:
  printed: theorems as the checker's signature logs print them (`#check @name`, default options);
  as written: from the sources, comments blanked, each theorem's statement up to its `:=` or first equation, and every
    other command whole (definitions, instances, sections, variables and the rest), since default printing drops
    binder types, universes and implicit arguments.
The expectations: items 2 to 4's added names from he2_u4.NEW and items 6 and 7's added and renamed names from
he2_core_li.py, so a revised kit is followed; item 1's one changed statement («两端分则中有标») and item 5's three moved
laws (MapRegions to GrammarMap, nothing added) are fixed here (ITEM1_CHANGED, ITEM5_MOVED), so a revision of those
kits fails the audit until this file follows it. Also checked: each new statement of a renamed name is the old one
renamed; the definitions differ only by the renames; every added theorem sits in GrammarLaws, and the only other
commands added are GrammarLaws' sections and variables; the tree's sources are the run's (source_sha256); no Lean
file of the package changed but the 13 and the root module, whose code differs only by the renames; every axiom
report of the 13 is empty.
Run it before any commit that carries the new becoming-verification.json, since its baseline is the receipt HEAD
holds; save its output, which he2_texts.py reads.
usage (from the checkout root, after the checker): python3 -B <kit>/he2_signatures.py [RECEIPT_ID | --dir RUN_DIR] > LOG"""
import hashlib
import importlib.util
import json
import re
import subprocess
import sys
from collections import Counter
from pathlib import Path

ROOT = Path.cwd()
DEV = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development'


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


s3b = load('s3b', DEV / 'ou3b-master-laws-on-the-grammar/kit/signatures_ou3b.py')
k67 = load('k67', DEV / 'rv21-one-sense/kit/he2_core_li.py')
k24 = load('k24', DEV / 'u4-one-root-to-its-edge/he2-items-2-to-4/he2_u4.py')
k1 = load('k1', DEV / 'ou3f-activity-laws/he2-item1/kit/apply_he2_item1.py')
PKG = s3b.PKG

CHANGED = ('Grammar', 'GrammarLaws', 'GrammarRegularity', 'GrammarScope', 'GrammarCandidates', 'GrammarMap',
           'MapRegions', 'WideningOnTheMap', 'HeldPossible', 'PatternPassing', 'Sampling', 'Response', 'SelectionPool')
ITEM1_CHANGED = {'Becoming.«两端分则中有标»'}
# Item 5 (he2_item5.py, branch he2-item5): MapRegions' three reach laws move to GrammarMap whole, names, statements
# and proofs unchanged; nothing is added.
ITEM5_ADDED = set()
ITEM5_MOVED = {f'Becoming.Map.{n}': ('MapRegions', 'GrammarMap') for n in ('step_reached_le', 'step_reaches',
                                                                          'step_reaches_of_le')}
ADDED = ({k24.full(n) for n in k24.NEW} | {k67.full(n) for n in k67.NEW_LAWS} | ITEM5_ADDED
         | {k67.full(n) for n in k67.RENAMES.values()})
GONE = {k67.full(n) for n in k67.RENAMES}


def renamed(text):
    for old, new in k67.RENAMES.items():
        text = text.replace('«' + old + '»', '«' + new + '»')
    return text


DECL = re.compile(r'^(?:@\[[^\]]*\]\s*)?(?:private |protected |noncomputable )*'
                  r'(theorem|lemma|def|abbrev|structure|inductive|class|instance|opaque|example)\b\s*(\S*)')
OPEN, CLOSE = '([{⟨', ')]}⟩'


def statement(lines):
    """A theorem's statement: its command up to the top-level `:=`, or to its first equation (a line starting `|`)."""
    depth, out = 0, []
    for k, line in enumerate(lines):
        if k and depth == 0 and line.lstrip().startswith('|'):
            break
        for i, c in enumerate(line):
            if c in OPEN:
                depth += 1
            elif c in CLOSE:
                depth -= 1
            elif depth == 0 and line[i:i + 2] == ':=':
                out.append(line[:i])
                return ' '.join(' '.join(out).split())
        out.append(line)
    return ' '.join(' '.join(out).split())


def commands(text, where):
    """The source read command by command, comments blanked (s3b.blank_comments): every named declaration as
    full name -> (kind, text), a theorem's text its statement only, every other declaration's its whole command; and
    the other commands (variable, open, attribute, set_option, universe, section, ...) counted with the namespace
    they sit in."""
    named, other, ns, cur = {}, Counter(), [], None
    lines = s3b.blank_comments(text, where).split('\n')

    def close():
        if cur:
            kind, name, body = cur
            if kind is None:
                other[(tuple(ns), ' '.join(' '.join(body).split()))] += 1
            else:
                key = '.'.join(ns + [name]) if name else f'{kind}@{len(named)}'
                named[key] = (kind, statement(body) if kind in ('theorem', 'lemma') else ' '.join(' '.join(body).split()))
    for line in lines:
        if line and not line[0].isspace() and line[0] != '|':
            close()
            cur = None
            word = line.split()[0]
            if word == 'namespace':
                ns.append(line.split()[1])
            elif word == 'end' and len(line.split()) > 1 and ns and line.split()[1] == ns[-1]:
                ns.pop()
            elif (m := DECL.match(line)):
                cur = (m.group(1), m.group(2) if m.group(1) not in ('example',) else '', [line])
            else:
                cur = (None, None, [line])
        elif cur is not None and line.strip():
            cur[2].append(line)
    close()
    return named, other


if len(sys.argv) > 2 and sys.argv[1] == '--dir':
    runs = sorted(p for p in Path(sys.argv[2]).iterdir() if (p / 'verification.json').exists())
    assert runs, sys.argv[2]
    new_r = json.loads((runs[-1] / 'verification.json').read_text())
else:
    new_r = s3b.receipt(sys.argv[1] if len(sys.argv) > 1 else None)
old_r = s3b.receipt_at_head()
assert new_r['status'] == 'passed', new_r['status']
old, new, defs_old, defs_new, where_old, where_new = {}, {}, {}, {}, {}, {}
for m in CHANGED:
    step = f'Becoming{m}Signatures.log'
    o, n = s3b.parse(s3b.log_of(old_r, step)), s3b.parse(s3b.log_of(new_r, step))
    old.update(o)
    new.update(n)
    where_old.update({k: m for k in o})
    where_new.update({k: m for k in n})
    defs_old.update(s3b.definitions(s3b.source_at_head(m)))
    defs_new.update(s3b.definitions((ROOT / PKG / f'Becoming/{m}.lean').read_text(encoding='utf-8')))
# The sources: the tree's are the run's, and no Lean file of the package changed but these and the root module.
src_files = {m: PKG + f'/Becoming/{m}.lean' for m in CHANGED}
for m, path in list(src_files.items()) + [('', PKG + '/Becoming.lean')]:
    key = 'Becoming' + ('.' + m if m else '')
    assert new_r['source_sha256'][key] == hashlib.sha256((ROOT / path).read_bytes()).hexdigest(), \
        ('the tree is not the run\'s source', key)
diff = subprocess.run(['git', 'diff', '--name-only', 'HEAD', '--', PKG], cwd=ROOT, capture_output=True, text=True).stdout.split()
lean_changed = sorted(p for p in diff if p.endswith('.lean'))
other_lean = sorted(set(lean_changed) - set(src_files.values()) - {PKG + '/Becoming.lean'})
root_old = s3b.blank_comments(subprocess.run(['git', 'show', f'HEAD:{PKG}/Becoming.lean'], cwd=ROOT, capture_output=True,
                                            text=True).stdout, 'Becoming.lean at HEAD')
root_new = s3b.blank_comments((ROOT / PKG / 'Becoming.lean').read_text(encoding='utf-8'), 'Becoming.lean')
root_code_same = ' '.join(renamed(root_old).split()) == ' '.join(root_new.split())
# Source-level comparison, beside the printed one: printing drops binder types, universes and implicit arguments,
# so a statement is also compared as written, and every other command in full.
src_old, src_new, oth_old, oth_new, mod_old, mod_new = {}, {}, {}, {}, {}, {}
for m in CHANGED:
    so, oo = commands(s3b.source_at_head(m), f'{m} at HEAD')
    sn, on = commands((ROOT / src_files[m]).read_text(encoding='utf-8'), m)
    src_old.update(so)
    src_new.update(sn)
    mod_old.update({k: m for k in so})
    mod_new.update({k: m for k in sn})
    oth_old[m] = Counter({(ns, renamed(c)): v for (ns, c), v in oo.items()})
    oth_new[m] = on
src_gone = sorted(k for k in src_old if k not in src_new and not k.startswith(('example@', 'instance@')))
src_added = sorted(k for k in src_new if k not in src_old and not k.startswith(('example@', 'instance@')))
src_changed = sorted(k for k in src_old if k in src_new and renamed(src_old[k][1]) != src_new[k][1])
# Item 1's one changed statement: the old and new heads as its kit gives them, the conclusion unchanged.
I1 = next(iter(ITEM1_CHANGED))
i1_old, i1_new = (' '.join(b[b.index('theorem '):].split()) for b in (k1.GRAMMAR_OLD, k1.GRAMMAR_NEW))
i1_ok = (I1 in src_old and I1 in src_new and src_old[I1][1].startswith(i1_old) and src_new[I1][1].startswith(i1_new)
         and src_old[I1][1][len(i1_old):] == src_new[I1][1][len(i1_new):])
unnamed_old = Counter(renamed(v[1]) for k, v in src_old.items() if k.startswith(('example@', 'instance@')))
unnamed_new = Counter(v[1] for k, v in src_new.items() if k.startswith(('example@', 'instance@')))
# Other commands: items 2-4 open sections with their variables in GrammarLaws; nothing else is added or removed.
others_removed = {m: [c for c in oth_old[m] if oth_old[m][c] > oth_new[m][c]] for m in CHANGED}
others_added = {m: [c for c in oth_new[m] if oth_new[m][c] > oth_old[m][c]] for m in CHANGED}
others_changed = {m: v for m, v in others_removed.items() if v}
others_changed.update({m: v for m, v in others_added.items() if v and m != 'GrammarLaws'})
src_moved = {k: (mod_old[k], mod_new[k]) for k in src_old if k in src_new and mod_old[k] != mod_new[k]}
gone = sorted(n for n in old if n not in new)
added = sorted(n for n in new if n not in old)
moved = {n: (where_old[n], where_new[n]) for n in old if n in new and where_old[n] != where_new[n]}
changed = sorted(n for n in old if n in new and old[n] != new[n])
by_rename = [n for n in changed if renamed(old[n]) == new[n]]
changed_real = sorted(set(changed) - set(by_rename))
rename_ok = {o: renamed(old[o]) == new.get(k67.full(k67.RENAMES[o[len('Becoming.«'):-1]])) for o in GONE if o in old}
rewritten = sorted(n for n in defs_old if n in defs_new and defs_old[n] != defs_new[n])
# Definitions print no statement in the signature logs, which list theorems: their names are read from the sources.
gone_defs = sorted(n for n in defs_old if n not in defs_new)
added_defs = sorted(n for n in defs_new if n not in defs_old)
rename_ok.update({o: renamed(defs_old[o]) == defs_new.get(k67.full(k67.RENAMES[o[len('Becoming.«'):-1]]))
                  for o in GONE if o in defs_old})
rewritten_real = sorted(n for n in rewritten if renamed(defs_old[n]) != defs_new[n])
report = {'old_receipt': old_r['utc'], 'new_receipt': new_r['utc'], 'declarations_old': len(old),
          'declarations_new': len(new), 'gone': gone, 'added': added, 'definitions_gone': gone_defs,
          'definitions_added': added_defs,
          'moved': {n: list(v) for n, v in sorted(moved.items())}, 'changed': changed_real,
          'changed_by_the_renames_only': sorted(by_rename), 'renamed_statements_equal': rename_ok,
          'definitions_rewritten': rewritten_real,
          'definitions_rewritten_by_the_renames_only': sorted(set(rewritten) - set(rewritten_real))}
report.update({'other_lean_files_changed': other_lean, 'root_module_code_unchanged_but_renames': root_code_same,
               'source_statements_changed': src_changed, 'item1_statement_as_its_kit_gives': i1_ok, 'source_gone': src_gone, 'source_added': src_added,
               'source_moved': {k: list(v) for k, v in sorted(src_moved.items())},
               'unnamed_commands_changed': sorted(set(unnamed_old) ^ set(unnamed_new)),
               'other_commands_changed': {m: [' '.join(map(str, c))[:160] for c in v] for m, v in others_changed.items()},
               'other_commands_added_in_grammarlaws': [' '.join(map(str, c))[:160] for c in others_added['GrammarLaws']],
               'added_outside_grammarlaws': sorted(n for n in added if where_new[n] != 'GrammarLaws'
                                                   and n not in {k67.full(x) for x in k67.RENAMES.values()})})
print(json.dumps(report, indent=1, ensure_ascii=False))
problems = []
if set(gone) | set(gone_defs) != GONE:
    problems.append(('gone', sorted((set(gone) | set(gone_defs)) ^ GONE)))
if set(added) | set(added_defs) != ADDED:
    problems.append(('added', sorted((set(added) | set(added_defs)) ^ ADDED)))
if moved != ITEM5_MOVED:
    problems.append(('moved', moved))
if set(changed_real) != ITEM1_CHANGED:
    problems.append(('changed', sorted(set(changed_real) ^ ITEM1_CHANGED)))
if set(rename_ok) != GONE or not all(rename_ok.values()):
    problems.append(('renamed statements', [o for o, ok in rename_ok.items() if not ok]))
if rewritten_real:
    problems.append(('definitions rewritten', rewritten_real))
for m in new_r['modules']:
    if m['module'] in {'Becoming.' + c for c in CHANGED} and any(m['axiom_dependencies'].values()):
        problems.append(('axioms', m['module']))
if other_lean:
    problems.append(('other Lean files changed', other_lean))
if not root_code_same:
    problems.append(('root module code changed beyond the renames', True))
if set(src_gone) != GONE or set(src_added) != ADDED:
    problems.append(('source names', sorted(set(src_gone) ^ GONE), sorted(set(src_added) ^ ADDED)))
if set(src_changed) != ITEM1_CHANGED:
    problems.append(('source statements changed', sorted(set(src_changed) ^ ITEM1_CHANGED)))
if not i1_ok:
    problems.append(('item 1 statement not as its kit gives it', I1))
if src_moved != ITEM5_MOVED:
    problems.append(('source moved', src_moved))
if report['unnamed_commands_changed'] or others_changed:
    problems.append(('other commands changed', report['unnamed_commands_changed'], list(others_changed)))
if report['added_outside_grammarlaws']:
    problems.append(('added outside GrammarLaws', report['added_outside_grammarlaws']))
print(f'OK: every statement and definition of the {len(CHANGED)} changed modules as the items say' if not problems
      else f'UNEXPECTED: {problems}')
sys.exit(1 if problems else 0)
