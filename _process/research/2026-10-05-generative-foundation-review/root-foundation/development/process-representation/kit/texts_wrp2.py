#!/usr/bin/env python3
"""WRP2 texts. The home of the new record, processes-represented-both-ways, is 01 §8.1: a theorem block after the
section's paragraph on frames and the World, and the table's process row naming the moves' relations and the model
with the move inside. Also edited: 01's bases line (any process split from any type), its thesis, its paragraph on
what is claimed, its Open entry on faithful representation and §8.6's not-shown line on processes; 01 §7's finite
runs, for «历» (the home of master-laws-on-the-grammar, whose new law it is); 08's Open entry and its receipt counts,
read from the receipt; the overview's two sentences on faithful representation; L-21's weakness line in the logic
dossier; the one page's sentence on representation, in both editions; the glossary line for the moves' relations; the
study section; the record's and the module's regions. Every name the texts cite from the three modules is checked
against the scratch build's axiom audits. Mirrors WRT2's texts_wrt2.py; every edit is asserted to apply exactly once.
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/texts_wrp2.py RECEIPT N"""
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
RECEIPT, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
CH = ROOT / 'theories/becoming/chapters'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
STUDY = ROOT / RF / 'BECOMING-RENEWAL-READING.md'
REGIONS = ROOT / 'theories/becoming/results/data/regions.json'
RID, RIDW = 'processes-represented-both-ways', 'the-world-represented-both-ways'
NAMES = set()
for m in ('GrammarLaws', 'GrammarTransport', 'ProcessRepresentation'):
    audit = HERE.parent / f'tree/.build/Becoming{m}AxiomAudit.lean'
    NAMES |= set(re.findall(r'^#print axioms Becoming\.(\S+)$', audit.read_text(encoding='utf-8'), re.M))
OURS = ('moveRel_mk', 'mk_moveRel', 'steps_iff_moveRel', 'steps_one_move', 'steps_edgeProcess', 'enabled_iff_neng',
        'forall_steps_iff', 'forall_moveRel_iff', 'class_is_claims', 'step_iff_withMove', 'withMove_image_iff',
        'withMove_of_renaming', 'renaming_', 'reading_next_move_not_withMove', 'trace_iff_li',
        'factorsThrough_iff_image', 'run_iff_image', 'yan_iff_keepsMoving', 'yan_line_iff_dependentChoice',
        'yan_line_of_list', 'Twist.', 'Flip.', 'NoMoves.', 'NoConfigurations.', 'Forgotten.', '«历', '«迭即历»',
        '«同行之历»')


def cited(text):
    """Every backticked name of the three modules the text cites is one of their declarations."""
    found = set(re.findall(r'`([A-Za-z_.]*«[^»]+»|[A-Za-z_]+(?:\.[A-Za-z_]+)*)`', text))
    missing = sorted(n for n in found if n.startswith(OURS) and n not in NAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


REC = f'../results/records/{RID}.md'
ONE = CH / '01-ROOT.md'

# 01 §8.1: the table's process row, and the theorem block after the section's paragraph
edit(ONE, "| A process (`Generative.Process`) | configurations | one step | likeness; descriptions a law goes alike across |",
     "| A process (`Generative.Process`) | configurations; with the move inside (`withMove`), configurations with moves "
     "| one relation per move (`moveRel`), their union the steps | likeness; descriptions a law goes alike across; with "
     "the move inside, the same move and the same configuration |")
edit(ONE, """formations and conditions are two roles of one relatum.

<a id="r-place-transition-nets-on-the-spine"></a>""", f"""formations and conditions are two roles of one relatum.

<a id="r-{RID}"></a>
**Theorem** (any process; the grammar for its lemmas). *Processes represented both ways.*

A process is exactly its relations, one per move (`moveRel_mk`, `mk_moveRel`), and its steps are their union (`steps_iff_moveRel`).

**Forward.** A property of relations that relations alike pointwise share holds of every process's steps exactly where it holds of every relation (`forall_steps_iff`), and a property of relations indexed by moves holds of every process's exactly where it holds of all such (`forall_moveRel_iff`). So a law's truth is carried; its statement is in the grammar's terms only through a bridge for each notion it names. The bridges added here:
- enabledness is «能» at a move's relation (`enabled_iff_neng`);
- a trace is passing through the moves' relations along its word (`trace_iff_li`, on `«历»` of [§7](#r-master-laws-on-the-grammar));
- a process factors through a map exactly where the image of each move's relation lies within the other's (`factorsThrough_iff_image`, the image process of `Becoming.Mechanism` read move by move);
- with the move inside, a run is exactly a sequence along which the image of the line of steps lies within the steps (`run_iff_image`);
- going on along some branch (`«延»`) is lying in a family that keeps moving (`yan_iff_keepsMoving`).

**Converse.** Every relation is a process's steps (`steps_edgeProcess`), and every class a frame's class of claims (`class_is_claims`). The model with the move inside (`withMove`) recovers the process on its fixed carrier (`step_iff_withMove`), and its image is exactly the relations leaving the next move open (`withMove_image_iff`). A renaming relating two processes is a correspondence of these models carrying the steps, the class of the same move and that of the same configuration (`withMove_of_renaming`); from a configuration and a move, every such correspondence is a renaming relating them (`renaming_of_withMove`). A renaming keeps the bridged notions: traces, the word renamed letter by letter (`renaming_trace`); `n` steps and within `n` steps (`renaming_iterate`); reach, returning and invariants (`renaming_reach`, `renaming_returns`, `renaming_invariant`); determination and merging nothing (`renaming_determined`, `renaming_lossless`); going alike (`renaming_goAlike`); and going on along some branch (`renaming_yan`).

**Where it stops.**
- *The steps forget the moves* (`Forgotten.moves_forgotten`).
- *Neither class alone* makes the model with the move inside faithful up to correspondence: the twist keeps the class of the same move and the flip that of the same configuration, and each relates two processes that no renaming relates (`Twist.not_renamed`, `Flip.not_renamed`). With no move, or no configuration, a point is needed (`NoMoves.not_renamed`, `NoConfigurations.not_renamed`): the empty models forget the configurations, or the moves. The relation "the next move is true" is no process's model (`reading_next_move_not_withMove`).
- *A line from going on is a choice.* On relations on a type of the first universe, going on along some branch gives a line exactly under dependent choice (`yan_line_iff_dependentChoice`); within finitely many configurations it gives one with nothing chosen (`yan_line_of_list`).

([record]({REC}))

**What is not shown:**
- that a statement naming an unbridged process notion is in the grammar's terms;
- that every functional total relation is a determined law's step, which is unique choice on one carrier;
- a product and its factors as one construction, which needs a pairing the grammar does not form;
- the theorems that read no field of the old base and are about other structures;
- morphisms of models beyond correspondences.

<a id="r-place-transition-nets-on-the-spine"></a>""")

# 01's bases line: any process split from any type
edit(ONE, "(any process), (any type): every step relation or type, not yet in the grammar's vocabulary;",
     f"(any process): every process, read in the grammar by its moves' relations ([§8.1](#r-{RID})), its statement in "
     "the process's vocabulary; (any type): every type, not yet in the grammar's vocabulary;")
# 01's thesis and its paragraph on what is claimed
edit(ONE, "Open: that every becoming has a faithful representation in the grammar; the World's is shown both ways for its "
          "relations and fails on its amounts (§8.6).",
     "Open: that every becoming has a faithful representation in the grammar; processes' is shown both ways by their "
     "moves' relations (§8.1), and the World's both ways for its relations, failing on its amounts (§8.6).")
edit(ONE, "the World model read in the grammar, which instance theorems connect and a representation theorem gives both "
          "ways for its relations, not for its amounts (§8.6);",
     "processes and the World model read in the grammar, processes both ways by their moves' relations (§8.1) and the "
     "World by instance theorems and a representation theorem both ways for its relations, not for its amounts (§8.6);")
# 01's Open entry
edit(ONE, "The World's is shown both ways for its relations and not faithful on its amounts "
          f"([§8.6](#r-{RIDW})); a representation theorem for processes and the other models, with the liftings, would "
          "show the rest.",
     f"Processes' is shown both ways by their moves' relations, faithful up to correspondence carrying both classes of "
     f"the model with the move inside ([§8.1](#r-{RID})); the World's both ways for its relations and not faithful on "
     f"its amounts ([§8.6](#r-{RIDW})); a representation theorem for the other models, with the liftings, would show "
     "the rest.")
# 01 §8.6's not-shown line on processes
edit(ONE, "- a representation of processes, or one through the order of joined exchanges rather than the shared index.",
     f"- a representation through the order of joined exchanges rather than the shared index (processes' is "
     f"[§8.1](#r-{RID})'s).")
# 01 §7, finite runs: «历»
edit(ONE, "Steps split as they compose (`«迭之分»`), and steps read backward are steps of the converse (`«迭之逆»`). "
          "Where whatever is reached",
     "Steps split as they compose (`«迭之分»`), and steps read backward are steps of the converse (`«迭之逆»`). Passing "
     "through a word's relations in turn (`«历»`) has `«迭»` as its constant family (`«迭即历»`), and these two laws, "
     "with `«迭之接»`, `«迭之末步»`, `«迭之定前»` and `«同行之迭»`, are cases of its laws (`«历之接»`, `«历之逆»`, "
     "`«同行之历»` and the others). Where whatever is reached")

# 08's Open entry
edit(CH / '08-METHOD.md',
     "- The lifting; representation theorems for processes and the other models (the World's is shown both ways for "
     f"its relations, with its failure on amounts written down: [01 §8.6](01-ROOT.md#r-{RIDW})).",
     "- The lifting; representation theorems for the other models (processes' is shown both ways by their moves' "
     f"relations: [01 §8.1](01-ROOT.md#r-{RID}); the World's both ways for its relations, with its failure on amounts "
     f"written down: [01 §8.6](01-ROOT.md#r-{RIDW})).")

# 08: receipt and counts, every count read from the receipt (as texts_wrt2.py)
R = json.loads((ROOT / PKG / 'becoming-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed'
layers = {}
for module in R['modules']:
    count = layers.setdefault(module['layer'], [0, 0])
    count[0] += 1
    count[1] += module['theorems']
assert set(layers) <= {'foundation', 'core', 'instance', 'application'}, set(layers)
modules = sum(v[0] for v in layers.values())
theorems = sum(v[1] for v in layers.values())
assert modules == len(R['core_closure']), (modules, len(R['core_closure']))
ring = layers.get('instance', [0, 0])[0] + layers.get('application', [0, 0])[0]
declarations = sum(len(m['declarations']) for m in R['modules'])
injeq = sum(1 for name, axioms in R['generated_axiom_dependencies'].items()
            if name.endswith('.injEq') and axioms == ['propext'])
assert injeq == len(R['generated_axiom_dependencies']), 'a generated dependency other than injEq on propext'
superseded = len(R['superseded_modules'])
link = f'../../../{PKG}/becoming-checks/{RECEIPT}/verification.json'
counts = (f"At core receipt [`{RECEIPT}`]({link}) (Lean 4.29.1), the closure held {modules} modules "
          f"({layers['foundation'][0]} foundation, {layers['core'][0]} core, {ring} in the instance and application ring) "
          f"and {theorems:,} theorems; the {layers['core'][0]} core modules held {layers['core'][1]:,} of them; "
          f"{declarations:,} declarations were audited; {injeq} generated `injEq` lemmas depend on `propext`; "
          f"{superseded} superseded modules were kept out of the run.")
path = CH / '08-METHOD.md'
s = path.read_text(encoding='utf-8')
s, k = re.subn(r"At core receipt \[`[0-9TZ.]+`\]\([^)]*\) \(Lean 4\.29\.1\), the closure held \d+ modules \(\d+ foundation, "
               r"\d+ core, \d+ in the instance and application ring\) and [\d,]+ theorems; the \d+ core modules held [\d,]+ of "
               r"them; [\d,]+ declarations were audited; \d+ generated `injEq` lemmas depend on `propext`; \d+ superseded "
               r"modules were kept out of the run\.", lambda m: counts, s)
assert k == 1, k
path.write_text(s, encoding='utf-8')

# the overview's two sentences
OV = ROOT / 'theories/becoming/THE-THEORY-OF-BECOMING.md'
edit(OV, "that every becoming has a faithful representation in the grammar is open (the World's is shown both ways for its "
         f"relations and fails on its amounts, [01](chapters/01-ROOT.md#r-{RIDW})), and a law",
     "that every becoming has a faithful representation in the grammar is open (processes' is shown both ways by their "
     f"moves' relations, [01](chapters/01-ROOT.md#r-{RID}), and the World's both ways for its relations, failing on its "
     f"amounts, [01](chapters/01-ROOT.md#r-{RIDW})), and a law")
edit(OV, "the World's is shown both ways for its relations and not faithful on its amounts "
         f"([01](chapters/01-ROOT.md#r-{RIDW})).",
     f"processes' is shown both ways by their moves' relations ([01](chapters/01-ROOT.md#r-{RID})), and the World's both "
     f"ways for its relations and not faithful on its amounts ([01](chapters/01-ROOT.md#r-{RIDW})).")

# L-21's weakness line in the logic dossier
edit(ROOT / 'theories/becoming/review/LOGIC.md',
     "- No representation theorem exists for processes; the World's is shown both ways for its relations and fails on "
     f"its amounts ([01 §8.6](../chapters/01-ROOT.md#r-{RIDW})); and most modules do not yet state their laws on the "
     "grammar ([01, Open](../chapters/01-ROOT.md#open)):",
     "- Processes are represented both ways by their moves' relations "
     f"([01 §8.1](../chapters/01-ROOT.md#r-{RID})) and the World both ways for its relations, failing on its amounts "
     f"([01 §8.6](../chapters/01-ROOT.md#r-{RIDW})); most modules do not yet state their laws on the grammar "
     "([01, Open](../chapters/01-ROOT.md#open)):")

# the one page, both editions
edit(ROOT / 'theories/becoming/ONE-PAGE.md',
     f"The World is represented in the grammar both ways in its relations, not in its amounts ([01 §8](chapters/01-ROOT.md#r-{RIDW})).",
     f"Processes are represented in the grammar both ways by their moves' relations ([01 §8.1](chapters/01-ROOT.md#r-{RID})), "
     f"and the World both ways in its relations, not in its amounts ([01 §8](chapters/01-ROOT.md#r-{RIDW})).")
edit(ROOT / 'theories/becoming/ONE-PAGE.zh.md',
     f"世界在其关系上于文法中双向表示，在其量上则否（[01 §8](chapters/01-ROOT.md#r-{RIDW})）。",
     f"过程以其诸着之关系于文法中双向表示（[01 §8.1](chapters/01-ROOT.md#r-{RID})），世界在其关系上亦双向表示，在其量上则否"
     f"（[01 §8](chapters/01-ROOT.md#r-{RIDW})）。")

# the glossary: the moves' relations, after the occurrence model's row
GL = ROOT / 'GLOSSARY.md'
lines = GL.read_text(encoding='utf-8').split('\n')
at = [i for i, line in enumerate(lines) if line.startswith('| occurrence model |')]
assert len(at) == 1, at
assert not any(line.startswith("| the moves' relations") for line in lines)
lines[at[0] + 1:at[0] + 1] = [
    "| the moves' relations (`moveRel`) | a process read in the grammar: one relation per move, relating `s` to `t` "
    "where the move takes `s` to `t`; their union is the steps, and the model with the move inside reads them on "
    f"configurations with moves | [01 §8.1](theories/becoming/chapters/01-ROOT.md#r-{RID}) |"]
GL.write_text('\n'.join(lines), encoding='utf-8')

# the study section
mods = {m['module']: m for m in R['modules']}
gl, gt, pr = (mods[f'Becoming.{m}'] for m in ('GrammarLaws', 'GrammarTransport', 'ProcessRepresentation'))
section = (HERE / 'study_wrp2.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
section = section.replace('(GL)', f"({gl['theorems']} theorems in {len(gl['declarations'])} declarations)")
section = section.replace('(GT)', f"({gt['theorems']} theorems in {len(gt['declarations'])} declarations)")
section = section.replace('(COUNTS)', f"({pr['theorems']} theorems in {len(pr['declarations'])} declarations)")
assert '{' not in section and 'TODO' not in section, 'a placeholder left'
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, N
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# regions
reg = json.loads(REGIONS.read_text(encoding='utf-8'))
assert RID not in reg['records'] and 'Becoming.ProcessRepresentation' not in reg['modules']
reg['records'][RID] = {'region': 'root', 'base': 'grammar',
                       'note': 'ProcessRepresentation WRP2: processes represented both ways by their moves\' relations; '
                               'a law\'s truth carried to all relations indexed by moves; the model with the move inside '
                               'faithful up to correspondence with both classes, a renaming keeping the bridged notions; '
                               'the forward bridges; GrammarTransport its lemmas'}
reg['records'] = dict(sorted(reg['records'].items()))
reg['modules']['Becoming.ProcessRepresentation'] = {'region': 'root', 'base': 'grammar',
                                                    'note': 'WRP2 processes as models of the grammar, both ways (01 §8.1)'}
reg['modules'] = dict(sorted(reg['modules'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 01 §8.1 theorem and table row, bases, thesis, claims, Open, §8.6 not-shown, §7 «历»; 08 Open and counts:',
      counts[:90], '...; overview; L-21; one page (EN, ZH); glossary; study section', N, '; regions')
