#!/usr/bin/env python3
"""UE25: join Becoming.CountedCodes to the core as a leaf importing Becoming.SharedCodes and
Becoming.FreeEnergyCounting. Copies the new module (no landed module changes); adds it to the checker's core list
after Becoming.SharedCodes, with its scope sentence after SharedCodes'; imports it in the root module after SharedCodes,
with an L1 bullet after SharedCodes'; adds the package README rows (EN after SharedCodes', ZH after
FreeEnergyCounting's, the ZH table having no SharedCodes row); adds the record and the module to regions.json;
copies UE25's study folder (the design, the note, the review and its probes, the recheck
and this kit, without the scratch build) into the landing worktree. Every backticked CountedCodes name the texts cite
is checked against the kit's scratch-build axiom audit. Mirrors UE21's integrate_ue21.py; each edit is asserted to
apply exactly once.
usage (from the checkout root of the landing worktree, clean): python3 -B <kit>/integrate_ue25.py"""
import json
import os
import re
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
AUDIT = HERE / 'tree/.build/BecomingCountedCodesAxiomAudit.lean'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
WORK = ROOT / ('_process/research/2026-10-05-generative-foundation-review/root-foundation/development/'
               'ue25-communicating-agents')
RID = 'a-code-held-as-counts'
NAMES = set(re.findall(r'^#print axioms Becoming\.(\S+)$', AUDIT.read_text(encoding='utf-8'), re.M))
assert len(NAMES) == 47, len(NAMES)


def cited(text):
    """Every backticked CountedCodes name in text is a declaration of the module."""
    names = set(re.findall(r'`(CountedCodes\.[A-Za-z_.]+)`', text))
    missing = sorted(n for n in names if n not in NAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


# UE25's study folder, as it stands beside this kit (the landing commits it)
if WORK.resolve() != HERE.parent.resolve():
    WORK.mkdir(parents=True, exist_ok=True)
    for name in ('DESIGN.md', 'NOTE.md', 'REVIEW-UE25.md', 'RECHECK-UE25.md'):
        if name == 'RECHECK-UE25.md' and not (HERE.parent / name).exists() and os.environ.get('UE25_REHEARSAL'):
            (WORK / name).write_text('Rehearsal placeholder: the recheck is not yet written.\n', encoding='utf-8')
            continue
        shutil.copyfile(HERE.parent / name, WORK / name)
    shutil.copytree(HERE.parent / 'review-probes', WORK / 'review-probes', dirs_exist_ok=True)
    shutil.copytree(HERE, WORK / 'kit', dirs_exist_ok=True,
                    ignore=shutil.ignore_patterns('.build', '__pycache__', '*.log'))

# the module
target = PKG / 'Becoming/CountedCodes.lean'
assert not target.exists(), target
shutil.copyfile(HERE / 'tree/Becoming/CountedCodes.lean', target)

# the checker: core list and scope
checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.SharedCodes", "Becoming.Likeness", ',
     '"Becoming.SharedCodes", "Becoming.CountedCodes", "Becoming.Likeness", ')
edit(checker, '''imposing a code keeps the exchange of formations and privileges forms. "
    "Through a code the course of forms of every course of senses is one state at exactly the moments the course of senses is, exactly where the code tells the senses apart; where resolution reads every encoded sequence, it reads the course of forms of every course of words as its course of meanings, step by step. "
''', '''imposing a code keeps the exchange of formations and privileges forms. "
    "Through a code the course of forms of every course of senses is one state at exactly the moments the course of senses is, exactly where the code tells the senses apart; where resolution reads every encoded sequence, it reads the course of forms of every course of words as its course of meanings, step by step. "
    "CountedCodes: the code law for beliefs held as counts of each word for each meaning, in any strict order; two "
    "words are never both uniquely greatest, and counts a renaming moving every word fixes have none; under a law "
    "keeping the exchange of agents together with a renaming of the words, from a start related to itself, where the "
    "renaming at a meaning is onto an agent's uniquely greatest word, renamed, is that of the agent the exchange gives "
    "it at every step, so where the renaming moves every word and is onto, or the exchange is an involution, two "
    "exchanged agents never hold one word as each one's uniquely greatest; learning from what is heard keeps the "
    "relation where the speaker map commutes with the exchange and the rule reads count by count and commutes with "
    "renaming, adding what is heard among such rules, and so does a weight on what is heard read off the whole model "
    "where the renaming leaves it unchanged; in natural counts, over a listing a renaming permutes, a count belief "
    "reaches the free-energy bound exactly where its renaming does for the renamed weights, and under weights a "
    "renaming moving every word fixes, with a positive total, a belief at the bound over a listing of every word has "
    "no uniquely greatest word. "
''')

# the root module: import and L1 bullet
root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.SharedCodes\n', 'import Becoming.SharedCodes\nimport Becoming.CountedCodes\n')
BULLET = """* `Becoming.CountedCodes` (L1): the law of a code formed between formations for beliefs held as
  counts, as the principle's agents hold a likelihood of words given meanings. A belief state gives
  each agent, for each meaning, a count of each word; `CountedCodes.UniqueGreatest c w` says `w`
  alone has the greatest count. In any strict order, two words are never both uniquely greatest
  (`CountedCodes.unique_greatest_not_two`), and counts a renaming moving every word fixes have none
  (`CountedCodes.fixed_no_unique_greatest`). Under a law keeping the exchange of agents together
  with a renaming of the words (`CountedCodes.Renamed`), from a start related to itself, where the
  renaming at a meaning is onto, an agent's uniquely greatest word, renamed, is that of the agent
  the exchange gives it at every step (`CountedCodes.unique_greatest_exchanged_run`); so where the
  renaming moves every word and is onto, or the exchange is an involution, two exchanged agents
  never hold one word as each one's uniquely greatest (`CountedCodes.never_shared`,
  `CountedCodes.never_shared_of_involution`). Learning from what is heard, the hearer given the
  meaning, keeps the relation where the speaker map commutes with the exchange and the rule reads
  count by count and commutes with renaming (`CountedCodes.hear_keeps`); adding what is heard is
  such a rule where what is heard is (`CountedCodes.addHeard_keeps`); a weight on what is heard read
  off the hearer's whole model keeps it where the renaming leaves the weight unchanged
  (`CountedCodes.gatedHear_keeps`). In natural counts, over a listing a renaming permutes, a count
  belief reaches the free-energy bound exactly where its renaming does for the renamed weights
  (`CountedCodes.bound_invariant`), and under weights a renaming moving every word fixes, with a
  positive total, a belief at the bound over a listing of every word has no uniquely greatest word
  (`CountedCodes.minimizer_no_unique_greatest`). Witnesses: a preferred word in the order of
  speaking, and an asymmetric start, each bring a shared uniquely greatest word. A leaf importing
  `Becoming.SharedCodes` and `Becoming.FreeEnergyCounting` (board item UE25).
"""
lines = root.read_text(encoding='utf-8').split('\n')
at = [i for i, line in enumerate(lines)
      if line.startswith('* `Becoming.Likeness` (L') and lines[i - 1].startswith('  meanings, step by step.')]
assert len(at) == 1, at
lines[at[0]:at[0]] = cited(BULLET).rstrip('\n').split('\n')
root.write_text('\n'.join(lines), encoding='utf-8')


def readme_row(path, after, row):
    rows = path.read_text(encoding='utf-8').split('\n')
    at = [i for i, line in enumerate(rows) if line.startswith(f'| L1 | [`{after}`]')]
    assert len(at) == 1, at
    assert not any('[`Becoming.CountedCodes`]' in line for line in rows)
    rows[at[0] + 1:at[0] + 1] = [cited(row)]
    path.write_text('\n'.join(rows), encoding='utf-8')


readme_row(PKG / 'README.md', 'Becoming.SharedCodes',
           '| L1 | [`Becoming.CountedCodes`](Becoming/CountedCodes.lean) | the code law for beliefs held as counts (no '
           'ethical predicate): under a law keeping the exchange of agents with a renaming of words, from a start '
           'related to itself, two exchanged agents never hold one word as each one\'s uniquely greatest where the '
           'renaming moves every word and is onto, or the exchange is an involution (`CountedCodes.never_shared`, '
           '`CountedCodes.never_shared_of_involution`); learning from what is heard keeps the relation where the '
           'speaker map commutes with the exchange and the rule reads count by count and commutes with renaming '
           '(`CountedCodes.hear_keeps`, `CountedCodes.addHeard_keeps`, `CountedCodes.gatedHear_keeps`); the '
           'free-energy bound in counts is unchanged by a renaming permuting the words (`CountedCodes.bound_invariant`), '
           'and under weights a renaming moving every word fixes, with a positive total, a belief at the bound over a '
           'listing of every word names no word (`CountedCodes.minimizer_no_unique_greatest`) |')
readme_row(PKG / 'README.zh.md', 'Becoming.FreeEnergyCounting',
           '| L1 | [`Becoming.CountedCodes`](Becoming/CountedCodes.lean) | 以计数持之信念之码律（无伦理谓词）：于保对换主体并改名诸词之律，'
           '始于自相关之态，凡改名移每词且为满射处，或对换为对合处，所对换之二主体永不以一词各为其唯一最大（`CountedCodes.never_shared`、'
           '`CountedCodes.never_shared_of_involution`）；说者映射与对换可交换、规则逐数而读且与改名可交换时，由所闻而学保此关系'
           '（`CountedCodes.hear_keeps`、`CountedCodes.addHeard_keeps`、`CountedCodes.gatedHear_keeps`）；计数形式之自由能界于置换诸词之'
           '改名下不变（`CountedCodes.bound_invariant`），于移每词之改名所不变、总和为正之权下，于含每词之列达界之信念不名一词'
           '（`CountedCodes.minimizer_no_unique_greatest`） |')

# regions: the record and the module
regions = ROOT / 'theories/becoming/results/data/regions.json'
data = json.loads(regions.read_text(encoding='utf-8'))
assert RID not in data['records'] and 'Becoming.CountedCodes' not in data['modules']
data['records'][RID] = {'region': 'collective', 'base': 'general', 'note': (
    'CountedCodes UE25: the code law for beliefs held as counts; under a law keeping the exchange of agents with a '
    'renaming of the words, two exchanged agents never share a uniquely greatest word where the renaming moves '
    'every word; learning from what is heard keeps the symmetry; the free-energy bound in counts is unchanged by a renaming permuting the '
    'words')}
data['modules']['Becoming.CountedCodes'] = {'region': 'collective', 'base': 'general',
                                            'note': 'UE25 the code law for beliefs held as counts (05 §9)'}
data['records'] = dict(sorted(data['records'].items()))
data['modules'] = dict(sorted(data['modules'].items()))
text = regions.read_text(encoding='utf-8')
regions.write_text(json.dumps(data, ensure_ascii=False, indent=1) + ('\n' if text.endswith('\n') else ''),
                   encoding='utf-8')
print('integrated: Becoming.CountedCodes joined (root import and L1 bullet, checker core list and scope, README rows '
      'EN and ZH), regions; UE25\'s folder copied; no landed module changed')
