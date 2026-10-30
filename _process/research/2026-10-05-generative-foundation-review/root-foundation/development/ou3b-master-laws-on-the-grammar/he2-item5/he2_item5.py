#!/usr/bin/env python3
"""HE2 item 5, GrammarMap's two edits from GW (its history row, study §467), by GrammarMap's owner (OU's):
  1. the reach laws of the successor stated once, in GrammarMap: `Map.step_reached_le`, `Map.step_reaches` and
     `Map.step_reaches_of_le` move from MapRegions, names, statements and proofs unchanged, and the two other copies
     become one application each (`Steps.reached_le` in WideningOnTheMap, HeldPossible's local `reached_le` and
     `reach_to`), statements unchanged;
  2. GrammarMap's sentence that how the strong forms stand to the regions below "is not stated" re-pointed to the
     leaves that state it.
No name changes, so no record is rebound and no register changes; `Map.step_*` change module, and the indexes and the
theorem graph regenerate at render and at THEOREM-CONNECTIVITY.py.

From the checkout root:
  python3 -B he2_item5.py --check                 every edit's text is found once (or the edit is applied); writes nothing
  python3 -B he2_item5.py --list                  every edit, file, old and new
  python3 -B he2_item5.py --apply lean            the four Lean files in the package
  python3 -B he2_item5.py --apply lean --to DIR   the same files written under DIR/Becoming/, for a scratch build
The part checks all of its edits before it writes any file, and an applied edit checks as applied. Every edit works by
text, not by line, and none touches Grammar.lean (items 1 and 7), GrammarLaws (items 2, 3, 4 and 6), Response or
SelectionPool (items 3 and 4), so it applies before or after HE2's other items in one pass."""
import sys
from pathlib import Path

ROOT = Path.cwd()
B = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/'

# The block that moves: MapRegions' three reach laws of `step`, cut whole, so what lands is what was built.
MOVE_START = '/-- What a line along the steps reaches is later. -/\n'
MOVE_END = '  | step _ ih => exact «所及之传递» ih (.inr (.one ⟨rfl, trivial⟩))\n'
MOVED_INTRO = ('/-! The reach laws of the successor, stated once here, below every module that reads a line along it\n'
               '(`MapRegions`, `WideningOnTheMap`'"'"'s `Steps.reached_le`, `HeldPossible`). -/\n\n')

GM_ANCHOR = '  | n + 1, h => step_irrefl n (Nat.succ.inj h)\n\n'

GM_OLD_SENTENCE = ("reached, where `«尽»` asks one on every branch. How they stand to the regions below (`«生成»`, `«守»`,\n"
                   "`«退化»`) is not stated: `«全守»` allows a carrying renewal before its point, which `«守»` forbids. -/")
GM_NEW_SENTENCE = ("reached, where `«尽»` asks one on every branch. How they stand to the regions below (`«生成»`, `«守»`,\n"
                   "`«退化»`) is stated in leaves that import this module: strong generation gives generation\n"
                   "(`«全生成则生成»`, `Becoming.KeepingWidening`), and strong keeping gives keeping from some point on\n"
                   "(`«全守则后守»`, `Becoming.MapRegions`) but not strict keeping, since `«全守»` allows a carrying renewal\n"
                   "before its point, which `«守»` forbids (`Map.Once.keeping`, `Map.Once.not_keeps`). -/")

WOM_OLD = ("theorem reached_le {L : «际» Nat} {x y : Nat} (reached : «所及» next L x y) : x ≤ y :=\n"
           "  match reached with\n"
           "  | .inl at_ => Nat.le_of_eq at_\n"
           "  | .inr line => match reach_later line with\n"
           "    | ⟨n, at_⟩ => Eq.subst (motive := fun z => x ≤ z) at_.symm\n"
           "        (Nat.le_succ_of_le (Nat.le_add_right x n))\n")
WOM_NEW = ("theorem reached_le {L : «际» Nat} {x y : Nat} (reached : «所及» next L x y) : x ≤ y :=\n"
           "  Map.step_reached_le reached\n")
WOM_DOC_OLD = "/-- What a line along the moments reaches is later. -/\ntheorem reached_le"
WOM_DOC_NEW = ("/-- What a line along the moments reaches is later: GrammarMap's law of the successor\n"
               "(`Map.step_reached_le`), read at `next`, which is the same relation. -/\ntheorem reached_le")

HP_OLD = ("  have reach_to : ∀ {x y : Nat}, x ≤ y → «所及» Steps.next «一» x y := fun {x _} le =>\n"
          "    match Nat.eq_or_lt_of_le le with\n"
          "    | .inl same => .inl same\n"
          "    | .inr lt => match le_dest lt with\n"
          "      | ⟨m, at_⟩ => .inr (Eq.subst (motive := fun z => «相续» Steps.next «一» x z)\n"
          "          ((Nat.add_right_comm x 1 m).symm.trans at_.symm) (Steps.reached_of_buqiong (endless x) m))\n"
          "  have reached_le : ∀ {x y : Nat}, «所及» Steps.next «一» x y → x ≤ y := fun {x _} reached =>\n"
          "    match reached with\n"
          "    | .inl same => Nat.le_of_eq same\n"
          "    | .inr line => match Steps.reach_later line with\n"
          "      | ⟨n, at_⟩ => Eq.subst (motive := fun z => x ≤ z) at_.symm\n"
          "          (Nat.le_succ_of_le (Nat.le_add_right x n))\n")
HP_NEW = ("  -- GrammarMap's reach laws of the successor, read at `Steps.next`, the same relation\n"
          "  have reach_to : ∀ {x y : Nat}, x ≤ y → «所及» Steps.next «一» x y := Map.step_reaches_of_le\n"
          "  have reached_le : ∀ {x y : Nat}, «所及» Steps.next «一» x y → x ≤ y := Map.step_reached_le\n")
HP_DOC_OLD = ("step of it is a carrying renewal exactly where its end begins under `E`. -/\n"
              "theorem Steps.generation_iff_begins")
HP_DOC_NEW = ("step of it is a carrying renewal exactly where its end begins under `E`; the line reaches a moment\n"
              "exactly when it is later (`Map.step_reaches_of_le`, `Map.step_reached_le`). -/\n"
              "theorem Steps.generation_iff_begins")


def moved_block(regions):
    i = regions.find(MOVE_START)
    if i < 0:
        return None
    j = regions.index(MOVE_END, i) + len(MOVE_END)
    return regions[i:j]


def edits(texts):
    """(file, old, new) for every edit; the moved block is read from MapRegions, or from GrammarMap once applied."""
    block = moved_block(texts[B + 'MapRegions.lean']) or moved_block(texts[B + 'GrammarMap.lean'])
    assert block is not None, 'the reach laws are in neither MapRegions nor GrammarMap'
    return [
        (B + 'MapRegions.lean', block + '\n', ''),
        (B + 'GrammarMap.lean', GM_ANCHOR, GM_ANCHOR + MOVED_INTRO + block + '\n'),
        (B + 'GrammarMap.lean', GM_OLD_SENTENCE, GM_NEW_SENTENCE),
        (B + 'WideningOnTheMap.lean', WOM_OLD, WOM_NEW),
        (B + 'WideningOnTheMap.lean', WOM_DOC_OLD, WOM_DOC_NEW),
        (B + 'HeldPossible.lean', HP_OLD, HP_NEW),
        (B + 'HeldPossible.lean', HP_DOC_OLD, HP_DOC_NEW),
    ]


FILES = [B + n for n in ('GrammarMap.lean', 'MapRegions.lean', 'WideningOnTheMap.lean', 'HeldPossible.lean')]


def state(text, old, new):
    """'todo' where the old text stands once and the new does not; 'done' where the new stands (a removal: where the
    old is gone); anything else is reported."""
    if new == '':
        return 'todo' if text.count(old) == 1 else 'done' if old not in text else f'found {text.count(old)} times'
    if new in text:
        return 'done' if text.count(new) == 1 and (new.startswith(old) or old not in text) else 'both'
    return 'todo' if text.count(old) == 1 else f'found {text.count(old)} times'


def plan():
    texts = {f: (ROOT / f).read_text() for f in FILES}
    return texts, [(f, old, new, state(texts[f], old, new)) for f, old, new in edits(texts)]


def check():
    _, rows = plan()
    bad = [r for r in rows if r[3] not in ('todo', 'done')]
    for f, old, new, s in rows:
        print(f'{s:5} {Path(f).name}: {old.splitlines()[0][:70] if old else ""}')
    assert not bad, f'{len(bad)} edits not found as expected'
    gm = (ROOT / B / 'GrammarMap.lean').read_text()
    assert 'import Becoming.Grammar\n' in gm and gm.count('\nimport ') == 0 and gm.startswith('import Becoming.Grammar\n'), \
        'GrammarMap imports more than the grammar'
    return rows


def apply(to):
    texts, rows = plan()
    assert all(r[3] in ('todo', 'done') for r in rows), 'check first: an edit is not found as expected'
    out = dict(texts)
    for f, old, new, s in rows:
        if s == 'todo':
            assert out[f].count(old) == 1, (f, old[:60])
            out[f] = out[f].replace(old, new)
    for f in FILES:
        dest = (Path(to) / 'Becoming' / Path(f).name) if to else ROOT / f
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.write_text(out[f])
        print('wrote', dest)


def main(argv):
    if argv[:1] == ['--check']:
        check()
    elif argv[:1] == ['--list']:
        for f, old, new, s in plan()[1]:
            print(f'== {f} [{s}]\n-- old:\n{old}\n-- new:\n{new}\n')
    elif argv[:2] == ['--apply', 'lean']:
        to = argv[3] if argv[2:3] == ['--to'] else None
        apply(to)
    else:
        print(__doc__)
        return 2
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
