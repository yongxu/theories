#!/usr/bin/env python3
"""DF2: the package's layer labels say what the import graph gives (UE10's second re-check, note 7, passed on by
the coordinator, and DF's recount of every module the core checker lists). Run once from the checkout root, after
UE10's landing (which relabels EventualWideningInstances and ComparingCourses): python3 -B <kit>/df2_layers.py.

L0 is defined as what it was computed to be before the grammar joined the base, extended by the same rule: the World
with every module it imports (Frame, Prelude, and the grammar's Grammar, GrammarMap and GrammarLaws, on which the frame
rests). GrammarReadings, GrammarTesting and GrammarCandidates, labelled L0 at their landings though the frame does not
import them, are L1, as GrammarPath, which imports only grammar modules too, already is.

Doc-only: the root module's notes (Becoming.lean, so the core checker reruns its step), the package README and its
Chinese edition, 08's layer list and the R31 kit's layers.py, which computes the base. Appends the DEFECTS-FOUND
section; its marks carry DF_N, set at landing. Then recomputes every label and asserts each agrees."""
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
LEAN, EN, ZH = PKG / 'Becoming.lean', PKG / 'README.md', PKG / 'README.zh.md'
R31 = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/r31-support'
METHOD = ROOT / 'theories/becoming/chapters/08-METHOD.md'
DEFECTS = ROOT / '_process/research/2026-10-05-repository-reconciliation/architecture/DEFECTS-FOUND.md'
DEMOTED = ('GrammarReadings', 'GrammarTesting', 'GrammarCandidates')


def sub(path, old, new):
    t = path.read_text(encoding='utf-8')
    assert t.count(old) == 1, (path.name, old[:90], t.count(old))
    path.write_text(t.replace(old, new), encoding='utf-8')


def row(path, module, old_layer, new_layer, old=None, new=None):
    """Relabel a README row (and optionally change text within it)."""
    t = path.read_text(encoding='utf-8')
    head = f'| L{old_layer} | [`{module}`]'
    lines = [l for l in t.split('\n') if l.startswith(head)]
    assert len(lines) == 1, (path.name, module, len(lines))
    l2 = lines[0].replace(head, f'| L{new_layer} | [`{module}`]', 1)
    if old is not None:
        assert l2.count(old) == 1, (path.name, module, old)
        l2 = l2.replace(old, new)
    path.write_text(t.replace(lines[0], l2), encoding='utf-8')


# Root notes.
sub(LEAN, '* `Becoming.OverExchange` (L1):', '* `Becoming.OverExchange` (L2, through `Becoming.Direction`):')
sub(LEAN, '* `Becoming.GrammarScope` (L1):', '* `Becoming.GrammarScope` (L2):')
sub(LEAN, '* `Becoming.GrammarCases` (L1):', '* `Becoming.GrammarCases` (L2, through `Becoming.GrammarScope`):')
sub(LEAN, '* `Becoming.MapInstances` (L2):', '* `Becoming.MapInstances` (L1):')
sub(LEAN, '* `Becoming.KeepingWidening` (L2, through `Becoming.MapInstances`):',
    '* `Becoming.KeepingWidening` (L2, through `Becoming.EventualWideningInstances`):')
for m in DEMOTED:
    sub(LEAN, f'* `Becoming.{m}` (L0):', f'* `Becoming.{m}` (L1):')
sub(LEAN,
    "L0 is the base, `Becoming.World`, `Becoming.Frame` and `Becoming.Prelude`; L2 holds the modules\n",
    "L0 is the base, `Becoming.World` with every module it imports: `Becoming.Frame`, `Becoming.Prelude`\n"
    "and the grammar's `Becoming.Grammar`, `Becoming.GrammarMap` and `Becoming.GrammarLaws`, on which the\n"
    "frame rests; L2 holds the modules\n")

# The English README.
row(EN, 'Becoming.OverExchange', 1, 2)
row(EN, 'Becoming.GrammarScope', 1, 2)
row(EN, 'Becoming.GrammarCases', 1, 2)
row(EN, 'Becoming.MapInstances', 2, 1)
row(EN, 'Becoming.KeepingWidening', 2, 2, '(L2 through `Becoming.MapInstances`;',
    '(L2 through `Becoming.EventualWideningInstances`;')
for m in DEMOTED:
    row(EN, f'Becoming.{m}', 0, 1)
sub(EN, "L0 is the base, `Becoming.World`, `Becoming.Frame` and `Becoming.Prelude`, on the foundation;",
    "L0 is the base, `Becoming.World` with every module it imports (`Becoming.Frame`, `Becoming.Prelude` and the "
    "grammar's `Becoming.Grammar`, `Becoming.GrammarMap` and `Becoming.GrammarLaws`, on which the frame rests), on "
    "the foundation;")
NEW_ROWS = {
    'Becoming.ComparingCourses': (
        '| L1 | [`Becoming.Growth`](Becoming/Growth.lean) | widening along a reading of one web\'s formations in '
        'another\'s (`Web.WidensAlong`), which along the identity is widening (`Web.widensAlong_id_iff`), and over a '
        'grown world: a growth adds formations and conditions without changing the old requirements (`Web.grow`); '
        'the grown web widens the old along the inclusion exactly where the old levels include and either exceed or '
        'admit a new formation (`Web.grow_widensAlong_iff`), while on the old formations nothing widens '
        '(`Web.grow_widens_unregistered`); an attachment widens exactly where its new condition meets the new '
        'formation\'s need (`Web.attach_widensAlong_iff`) |'),
    'Becoming.DrawnBeyond': (
        '| L1 | [`Becoming.JointDraw`](Becoming/JointDraw.lean) | which dependence breaks when several formations take '
        'at once, and restraint over any number of drawers: in a balanced flow a dependence breaks exactly where its '
        'need with all that is taken exceeds the level with all that is given (`Flow.Balances.broken_iff`); the '
        'highest needs break first, every break lies where an active formation draws, a break within each drawer\'s '
        'slack is shared by every drawer, and restraint by the excess keeps it (`Flow.Balances.kept_of_restrained`); '
        'under the whole-run reading restraint extends overdraw for any number of drawers exactly when it includes '
        'an event the other withholds (`Ranking.restraint_extends_iff`), and under the stepwise reading too where the '
        'restrained flow takes from no condition more than it gives (`Ranking.restraint_extends_iff_stepwise`); '
        '`TwoDrawers` is the instance |'),
    'Becoming.Identity': (
        '| L1 | [`Becoming.ContinuedClasses`](Becoming/ContinuedClasses.lean) | formation classes read along a '
        'continuation rather than a name (`Web.Continuing`, `Web.RenewingAlong`, `Web.ConsumingAlong`): renewing '
        'passes into every branch of a split and consuming back into every formation merged '
        '(`Web.renewingAlong_iff`, `Web.consumingAlong_iff`); both are unchanged by every re-identification carrying '
        'the continuation and are the name classes where each formation continues itself '
        '(`Web.renewingAlong_reidentify`, `Web.renewingAlong_itself_iff`), and a merge can make a formation that '
        'renews as named consume along it (`MergeClass.readings`); tenure and undermining read along a continuation '
        'likewise (`Web.underminingAlong_itself_iff`), and widening across a stretch is read along it, so that a bud '
        'adds nothing (`Web.WidensAcross`, `Bud.readings`) |'),
}
# Each new row goes after the row its note follows, or lower, below the rows of all its imports (an import order).
IMPORTS = {m: re.findall(r'^import (\S+)', (PKG / (m.replace('.', '/') + '.lean')).read_text(), re.M)
           for m in ('Becoming.Growth', 'Becoming.JointDraw', 'Becoming.ContinuedClasses')}
t = EN.read_text(encoding='utf-8')
for after, new in NEW_ROWS.items():
    module = re.match(r'\| L1 \| \[`([^`]+)`\]', new).group(1)
    lines = t.split('\n')
    def at(m):
        k = [i for i, l in enumerate(lines) if re.match(rf'\| L\d \| \[`{re.escape(m)}`\]', l)]
        assert len(k) <= 1, m
        return k[0] if k else -1
    k = max([at(after)] + [at(i) for i in IMPORTS[module]])
    assert at(after) >= 0, after
    lines.insert(k + 1, new)
    t = '\n'.join(lines)
EN.write_text(t, encoding='utf-8')

# The Chinese README (it keeps the modules it had, so it gains no rows).
row(ZH, 'Becoming.OverExchange', 1, 2)
row(ZH, 'Becoming.GrammarScope', 1, 2)
row(ZH, 'Becoming.GrammarCases', 1, 2)
row(ZH, 'Becoming.MapInstances', 2, 1)
row(ZH, 'Becoming.KeepingWidening', 2, 2, '（经 `Becoming.MapInstances` 而属 L2；',
    '（经 `Becoming.EventualWideningInstances` 而属 L2；')
for m in DEMOTED:
    row(ZH, f'Becoming.{m}', 0, 1)
sub(ZH, "L0 是基底 `Becoming.World`、`Becoming.Frame` 与 `Becoming.Prelude`，在基础之上；",
    "L0 是基底，即 `Becoming.World` 及其导入的每个模块（`Becoming.Frame`、`Becoming.Prelude`，以及框架所依的文法模块 "
    "`Becoming.Grammar`、`Becoming.GrammarMap` 与 `Becoming.GrammarLaws`），在基础之上；")

# 08's list.
sub(METHOD, "- L0, the foundation layer: the grammar modules, `Becoming.World`, `Becoming.Frame` and `Becoming.Prelude`;",
    "- L0, the foundation layer: `Becoming.World` with every module it imports, that is `Becoming.Frame`, "
    "`Becoming.Prelude` and the grammar's `Becoming.Grammar`, `Becoming.GrammarMap` and `Becoming.GrammarLaws`, on "
    "which the frame rests;")

# layers.py computes the base: the World with every module it imports.
sub(R31 / 'layers.py', 'BASE = ["Becoming.World", "Becoming.Frame", "Becoming.Prelude"]\n',
    '# The base is computed: the World with every module it imports (board item DF2, 27 October 2026; before the\n'
    '# grammar joined it, the same rule gave World, Frame and Prelude).\n'
    'BASE = ["Becoming.World"]\n')
sub(R31 / 'layers.py', '        if m in BASE:\n', '        if m in BASE or any(m in clo[b] for b in BASE):\n')
sub(R31 / 'layers.py', "* L0: the base, `Becoming.World`, `Becoming.Frame` and `Becoming.Prelude` (the foundation\n",
    "* L0: the base, `Becoming.World` with every module it imports (Frame, Prelude, and the grammar's Grammar,\n"
    "  GrammarMap and GrammarLaws, on which the frame rests; the foundation\n")

# DEFECTS-FOUND: the section, each entry ending with what became of it.
at = subprocess.run(['git', 'rev-parse', '--short=9', 'main'], capture_output=True, text=True, check=True).stdout.strip()
SECTION = f"""## Found by UE10's second re-check (27 October 2026, UE10)

Listed by UE10's second re-check ([RECHECK2-UE10](../../2026-10-05-generative-foundation-review/root-foundation/development/ue10-what-can-be-reached/RECHECK2-UE10.md), note 7) and passed on by the coordinator. DF recomputed the layer of each of the 328 modules the core checker lists (core, instances, applications; sources and imports read by the R31 kit's `graph.py`) and compared it with the module's note in `Becoming.lean` and its rows in the package README and its Chinese edition, at main `{at}`.

- `Becoming.OverExchange` is labelled L1 but imports `Becoming.Direction` (L2). *DF: fixed in DF2 (study §DF_N): L2, through `Becoming.Direction`, in the note and both READMEs.*
- `Becoming.GrammarScope` is labelled L1 but states the continuation condition (`Unrestricted`) and imports `Becoming.Weightings` (L2). *DF: fixed in DF2 (study §DF_N): L2 in the note and both READMEs.*
- `Becoming.GrammarCases` is labelled L1 but imports `Becoming.GrammarScope`, so it is L2 through it. *DF: fixed in DF2 (study §DF_N): L2, through `Becoming.GrammarScope`.*
- `Becoming.Growth`, `Becoming.JointDraw` and `Becoming.ContinuedClasses` have notes in `Becoming.lean` but no row in the package README. *DF: fixed in DF2 (study §DF_N): a row each in the English table, after the row its note follows and below the rows of its imports, its text from the note; the Chinese table keeps the modules it had, so it gains none.*
- `Becoming.EventualWideningInstances` (through `Becoming.Weightings`) and `Becoming.ComparingCourses` (through `Becoming.EventualWideningInstances`) are labelled L1 but are L2. *DF: fixed at UE10's landing.*
- Found by DF's recount: `Becoming.MapInstances` is labelled L2 in its note and both READMEs, though neither its source nor any module it imports states the condition or a valuation; it is L1. *DF: fixed in DF2 (study §DF_N).*
- Found by DF's recount: `Becoming.KeepingWidening`'s note and rows say it is L2 through `Becoming.MapInstances`; it is L2 through `Becoming.EventualWideningInstances`. *DF: fixed in DF2 (study §DF_N).*
- Found by DF's recount: the legend in `Becoming.lean` and both READMEs says L0 is `Becoming.World`, `Becoming.Frame` and `Becoming.Prelude`, computed by the R31 kit's `layers.py`, while the notes and rows label six grammar modules L0 as well, and 08's list says "the grammar modules", which would take in `Becoming.GrammarRegularity`, `Becoming.GrammarPath` (L1), `Becoming.GrammarScope` and `Becoming.GrammarCases` (L2). No import rule gives the six: `Becoming.GrammarPath` imports only grammar modules labelled L0 and is L1, while `Becoming.GrammarReadings`, `Becoming.GrammarTesting` and `Becoming.GrammarCandidates` do the same and were labelled L0, by their landings alone. The old base, computed, is the World with every module it imports; now that the frame rests on the grammar's `Becoming.GrammarLaws`, the same rule gives `Becoming.Grammar`, `Becoming.GrammarMap` and `Becoming.GrammarLaws` beside the three. *DF: fixed in DF2 (study §DF_N): L0 is the World with every module it imports, in the legend, 08 and `layers.py`, which computes it; `Becoming.GrammarReadings`, `Becoming.GrammarTesting` and `Becoming.GrammarCandidates` are L1, as `Becoming.GrammarPath` is; every module's label agrees with the layer recomputed.*
"""
d = DEFECTS.read_text(encoding='utf-8')
assert "## Found by UE10's second re-check" not in d
DEFECTS.write_text(d.rstrip('\n') + '\n\n' + SECTION, encoding='utf-8')

# Recount: every module the core checker lists, against its root note and its README rows.
sys.path.insert(0, str(R31))
import graph  # noqa: E402
import layers  # noqa: E402

src = (PKG / 'check_becoming.py').read_text()
listed = []
for name in ('CORE', 'INSTANCES', 'APPLICATIONS'):
    listed += re.findall(r'"([^"]+)"', re.search(rf'^{name} = \[(.*?)\]\n', src, re.S | re.M).group(1))
listed = [m for m in listed if m != 'Becoming']
mods = graph.modules()
clo = graph.closures(mods)
base = ['Becoming.World'] + [i for i in clo['Becoming.World'] if i in listed]
assert sorted(base) == sorted(['Becoming.World', 'Becoming.Frame', 'Becoming.Prelude', 'Becoming.Grammar',
                               'Becoming.GrammarMap', 'Becoming.GrammarLaws']), base
direct = {m for m in listed if graph.CONDITIONAL.search(graph.strip_comments(mods[m]['src']))}
layer = {m: 0 if m in base else 2 if (m in direct or any(i in direct for i in clo[m])) else 1 for m in listed}
_, _, _, r31_layer, _ = layers.layers()
assert all(r31_layer[m] == layer[m] for m in r31_layer), [m for m in r31_layer if r31_layer[m] != layer[m]]
notes = {m: (int(l), rest) for m, l, rest in
         re.findall(r'^\* `(Becoming\.[A-Za-z0-9.]+)` \(L(\d)([^)]*)\)', LEAN.read_text(encoding='utf-8'), re.M)}
bad = []
for m in listed:
    if m not in notes or notes[m][0] != layer[m]:
        bad.append((m, 'note', notes.get(m), layer[m]))
    for x in re.findall(r'`(Becoming\.[A-Za-z0-9.]+)`', notes.get(m, (0, ''))[1]):
        if layer.get(x) != 2 or x not in mods[m]['imports']:
            bad.append((m, 'note through', x))
for p in (EN, ZH):
    rows = {m: (int(l), d) for l, m, d in
            re.findall(r'^\| L(\d) \| \[`(Becoming\.[A-Za-z0-9.]+)`\]\([^)]*\) \| (.*)$', p.read_text(encoding='utf-8'), re.M)}
    for m in listed:
        if m in rows and rows[m][0] != layer[m]:
            bad.append((m, p.name, rows[m][0], layer[m]))
        if p == EN and m not in rows:
            bad.append((m, 'no README row'))
        for x in re.findall(r'L2 through `(Becoming\.[A-Za-z0-9.]+)`', rows.get(m, (0, ''))[1]):
            if layer.get(x) != 2 or x not in mods[m]['imports']:
                bad.append((m, p.name, 'through', x))
    pos = {m: i for i, m in enumerate(rows)}
    for m in ('Becoming.Growth', 'Becoming.JointDraw', 'Becoming.ContinuedClasses'):
        for i in mods[m]['imports']:
            if m in pos and i in pos and pos[i] > pos[m]:
                bad.append((m, p.name, 'row above its import', i))
for m in listed:
    for i in mods[m]['imports']:
        assert layer.get(i, 0) <= layer[m], (m, i)
assert not bad, bad
print('df2_layers: applied;', len(listed), 'modules agree with their notes and rows; L0:', sorted(base))
