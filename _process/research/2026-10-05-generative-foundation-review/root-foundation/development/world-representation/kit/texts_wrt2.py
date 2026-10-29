#!/usr/bin/env python3
"""WRT2 texts. The home of the new record, the-world-represented-both-ways, is 01 §8.6: a theorem block after the
section's reading, whose sentence on what is not an instance is corrected (the grammar counts by pairing and maps by
«像»; what it lacks is amounts). Also edited: 01's thesis, its paragraph on what is claimed, the clause of its
not-shown line on the representation theorem, and its Open entry on faithful representation; 08's Open entry and its
receipt counts, read from the receipt; the overview's two sentences on faithful representation; L-21's weakness line
in the logic dossier; the glossary line for the occurrence model; the study section; the record's and the two
modules' regions. Every name the texts cite from the two modules is checked against the scratch build's axiom
audits. Mirrors UE15's texts_ue15.py; every edit is asserted to apply exactly once.
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/texts_wrt2.py RECEIPT N"""
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
RID = 'the-world-represented-both-ways'
AUDITS = [HERE.parent / 'tree/.build/BecomingGrammarTransportAxiomAudit.lean',
          HERE.parent / 'tree/.build/BecomingWorldRepresentationAxiomAudit.lean']
NAMES = set()
for audit in AUDITS:
    NAMES |= set(re.findall(r'^#print axioms Becoming\.(\S+)$', audit.read_text(encoding='utf-8'), re.M))
OURS = ('World.reidentify_carries', 'World.arisingRecurs_iff', 'World.ceasingRecurs_iff', 'World.ofModel_model',
        'World.ofConservationForm_conserves', 'World.conserves_form', 'World.decides_activity_iff_em',
        'World.standingAt_alike', 'World.balance_needs_conservation', 'World.not_conserves_identity',
        'World.falls_exhaust', 'World.not_falls_everywhere', 'World.sheng_conservation_reidentify',
        'World.conserves_iff_same_level', 'Steps.along_endless', 'Web.sameStep', 'Web.partialIdentity',
        'World.withinStep', 'World.conservationStep', 'Reidentify.onOccurrences', '«尽之拉回»')


def cited(text):
    """Every backticked name of the two modules the text cites is one of their declarations."""
    found = set(re.findall(r'`([A-Za-z]+\.[A-Za-z_.]+|«[^»]+»)`', text))
    missing = sorted(n for n in found if n.startswith(OURS) and n not in NAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


REC = f'../results/records/{RID}.md'

# 01 §8.6: the corrected sentence, and the theorem block after the section's reading
edit(CH / '01-ROOT.md',
     "Not instances: the World model's counting, amounts, recurrence and renaming laws, since the grammar states no "
     "counting and no map of carriers; only their premises are connected.",
     "Of the laws the table does not hold, recurrence and re-identification are connected by the representation below, "
     "and counting by the grammar's pairings (`«对»`); amounts are no instances, since the grammar has none, and the "
     "representation writes that failure down.")
edit(CH / '01-ROOT.md', """

<a id="test-systems"></a>
### 8.7 Test systems of the source texts""", f"""

<a id="r-{RID}"></a>
**Theorem** (World; the grammar for its lemmas). *The World represented both ways, its amounts not.*

A World determines an occurrence model: its occurrences, a relatum at a step, with
- the class of being at the same step;
- the step conservation induces;
- activity, standing and presence, held as partial identities;
- five relations within a step: requiring, drawing, a need met, giving and taking.

These read no name at two steps. The names' step, and whatever reads one name at two steps, lie beside them.

**Forward.** The World's notions are grammar terms at that model notion by notion, through the instance theorems above. Recurrence is one through the names' step and the same-step class (`World.arisingRecurs_iff`, `World.ceasingRecurs_iff`). Every re-identification is a one-to-one correspondence of the name-free part (`World.reidentify_carries`), and the grammar's listed terms are kept by correspondence (`«尽之拉回»` and the transport laws of `Becoming.GrammarTransport`). So each term read there is fixed under re-identification.

**Converse.**
- Any activity, requiring, drawing and presence is some world's, at the model too (`World.ofModel_model`).
- Conservation is exactly a relation "the standing after the step with `b` is `a`", half of it by definition (`World.conserves_form`, `World.ofConservationForm_conserves`), and it is labelled by standings.
- What amounts induce is decided, while that every world decides its activity is exactly excluded middle (`World.decides_activity_iff_em`).

**Where it fails.**
- *Standings are not determined.* Two worlds standing at different positive amounts agree on everything the model reads (`World.standingAt_alike`).
- *Balance is carried only by conservation's step read along the names,* which is defined from the balance equation. The idle world and its double share the web and the signs of exchange, and only the first balances (`World.balance_needs_conservation`).
- *Conservation is never identity on the predicates of `Nat`* (`World.not_conserves_identity`).
- *A line of falls ends* (`World.falls_exhaust`, from `Amounts.falls_end`). That is a condition of the World's image and no law of the grammar (`Steps.along_endless`, `World.not_falls_everywhere`).

([record]({REC}))

**What is not shown:**
- that amounts are represented, or balance derived;
- the amount part's image beyond conservation alone;
- a forward theorem, since the forward direction is a schema;
- a representation of processes, or one through the order of joined exchanges rather than the shared index.

<a id="test-systems"></a>
### 8.7 Test systems of the source texts""")

# 01's thesis and its paragraph on what is claimed
edit(CH / '01-ROOT.md', "Open: that every becoming has a faithful representation in the grammar.",
     "Open: that every becoming has a faithful representation in the grammar; the World's is shown both ways for its "
     "relations and fails on its amounts (§8.6).")
edit(CH / '01-ROOT.md', "the World model's continuation family read in the grammar, which instance theorems connect (§8.6);",
     "the World model read in the grammar, which instance theorems connect and a representation theorem gives both ways "
     "for its relations, not for its amounts (§8.6);")
# 01's not-shown line: only the clause on the representation theorem changes
edit(CH / '01-ROOT.md', "need no independent entity, and no representation theorem for the World is claimed;",
     f"need no independent entity, and the World's representation in the grammar ([§8.6](#r-{RID})) concerns its relations, "
     "not entities;")
# 01's Open entry
edit(CH / '01-ROOT.md',
     "- **Faithful representation.** That every becoming, and the whole theory, has a faithful representation in the "
     "grammar; a representation theorem for each model, with the liftings, would show it.",
     "- **Faithful representation.** That every becoming, and the whole theory, has a faithful representation in the "
     f"grammar. The World's is shown both ways for its relations and not faithful on its amounts ([§8.6](#r-{RID})); "
     "a representation theorem for processes and the other models, with the liftings, would show the rest.")

# 08's Open entry
edit(CH / '08-METHOD.md', "- The lifting, and representation theorems for the World both ways.",
     "- The lifting; representation theorems for processes and the other models (the World's is shown both ways for "
     f"its relations, with its failure on amounts written down: [01 §8.6](01-ROOT.md#r-{RID})).")

# 08: receipt and counts, every count read from the receipt (as texts_ue15.py)
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
edit(OV, "that every becoming has a faithful representation in the grammar is open, and a law",
     "that every becoming has a faithful representation in the grammar is open (the World's is shown both ways for its "
     f"relations and fails on its amounts, [01](chapters/01-ROOT.md#r-{RID})), and a law")
edit(OV, "has a faithful representation in it is open ([01](chapters/01-ROOT.md#open)).",
     "has a faithful representation in it is open ([01](chapters/01-ROOT.md#open)); the World's is shown both ways for "
     f"its relations and not faithful on its amounts ([01](chapters/01-ROOT.md#r-{RID})).")

# L-21's weakness line in the logic dossier
edit(ROOT / 'theories/becoming/review/LOGIC.md',
     "- No representation theorem exists for the World or for processes, and most modules do not yet state their laws "
     "on the grammar ([01, Open](../chapters/01-ROOT.md#open)):",
     "- No representation theorem exists for processes; the World's is shown both ways for its relations and fails on "
     f"its amounts ([01 §8.6](../chapters/01-ROOT.md#r-{RID})); and most modules do not yet state their laws on the "
     "grammar ([01, Open](../chapters/01-ROOT.md#open)):")

# the glossary: the occurrence model, after the model row
GL = ROOT / 'GLOSSARY.md'
lines = GL.read_text(encoding='utf-8').split('\n')
at = [i for i, line in enumerate(lines) if line.startswith('| model; the World model |')]
assert len(at) == 1, at
assert not any(line.startswith('| occurrence model |') for line in lines)
lines[at[0] + 1:at[0] + 1] = [
    '| occurrence model | the grammar model a World determines: its occurrences, a relatum at a step, with the class '
    'of being at the same step, conservation\'s step, activity, standing and presence as partial identities, and five '
    'relations within a step, beside the names\' step | '
    f'[01 §8.6](theories/becoming/chapters/01-ROOT.md#r-{RID}) |']
GL.write_text('\n'.join(lines), encoding='utf-8')

# the study section
mods = {m['module']: m for m in R['modules']}
gt, wr = mods['Becoming.GrammarTransport'], mods['Becoming.WorldRepresentation']
section = (HERE / 'study_wrt2.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
section = section.replace('(GT)', f"({gt['theorems']} theorems in {len(gt['declarations'])} declarations)")
section = section.replace('(COUNTS)', f"({wr['theorems']} theorems in {len(wr['declarations'])} declarations)")
assert '{' not in section and 'TODO' not in section, 'a placeholder left'
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, N
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# regions
reg = json.loads(REGIONS.read_text(encoding='utf-8'))
assert RID not in reg['records']
assert 'Becoming.GrammarTransport' not in reg['modules'] and 'Becoming.WorldRepresentation' not in reg['modules']
reg['records'][RID] = {'region': 'root', 'base': 'grammar',
                       'note': 'WorldRepresentation WRT2: the World represented both ways, its amounts not; the occurrence '
                               'model and its name-free part, carried by every re-identification; the converse; the '
                               'failure on amounts with witnesses; GrammarTransport its lemmas'}
reg['records'] = dict(sorted(reg['records'].items()))
reg['modules']['Becoming.GrammarTransport'] = {'region': 'root', 'base': 'grammar',
                                               'note': 'WRT2 the grammar kept by one-to-one correspondence (lemmas)'}
reg['modules']['Becoming.WorldRepresentation'] = {'region': 'root', 'base': 'grammar',
                                                  'note': 'WRT2 the World as a model of the grammar, both ways (01 §8.6)'}
reg['modules'] = dict(sorted(reg['modules'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 01 §8.6 theorem and corrected sentence, thesis, claims, not-shown clause, Open; 08 Open and counts:',
      counts[:90], '...; overview; L-21; glossary; study section', N, '; regions')
