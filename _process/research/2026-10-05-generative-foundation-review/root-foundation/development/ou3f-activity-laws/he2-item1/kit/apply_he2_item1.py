#!/usr/bin/env python3
"""HE2's item 1, applied to a checkout of the Becoming package: «两端分则中有标» (Grammar) asks only that `K`
compose, its hypotheses now `split` then `trans` (so that `split`'s type fixes `K` for a caller passing a
projection such as a class's `trans`); PatternPassing's two uses pass their class's `trans`, and its module
docstring glosses the law with a transitive relation; and Sampling's `arises_within` and `ceases_within` are read
from the law, their statements unchanged. With --texts, the prose that states the law is brought to it: 01 §3, the
home section of the record continuation-relative-to-a-class, and, with --logic, the review packet's L-04.

Each edit names the text it replaces, which must occur exactly as often as stated (once, or twice for
PatternPassing's two uses), and nothing is written unless every edit applies. An edit already applied (its new
text present, its old text absent) is reported and left. Sampling's edit reads the successor's reach laws that
HE2's item 5 moves whole from MapRegions into GrammarMap (`Map.step_reaches_of_le`, `Map.step_reached_le`), so
it is refused while GrammarMap lacks them: apply item 5 first, or apply the weakening alone (Grammar and
PatternPassing), which reads true without Sampling's part.
usage: python3 -B apply_he2_item1.py PACKAGE [--check] [--weakening-only]
       python3 -B apply_he2_item1.py --texts REPOSITORY [--check] [--logic]
  PACKAGE           the folder holding Becoming/ (the package, or a scratch tree holding the three modules)
  --check           say what would change; write nothing
  --weakening-only  leave Sampling as it is
  --texts           edit the repository's prose instead (HE2's texts step, before the re-point): 01 §3
  --logic           with --texts, also LOGIC.md's L-04, its block re-copied from the law's new statement (the
                    same text the Grammar edit writes) and its Meaning; the review packet's page, so only on its
                    owner's word"""
from pathlib import Path
import re
import sys

GRAMMAR_OLD = '''\
/-- **A line whose ends a class tells apart has a marked step.** Where every step of continuation
under `E` either keeps the class `K` or carries the mark `P`, a line (相续) under `E` from `x` to
`y` with `K` telling `x` and `y` apart has a step carrying the mark, given with its place on the
line: reached from `x`, and reaching `y`. Stated for every carrier and every relation; only
transitivity of `K` is used. -/
theorem «两端分则中有标» {R E K P : «际» α} (hK : «类» K)
    (split : ∀ x y, «续» R E x y → K x y ∨ P x y) {x y : α} (line : «相续» R E x y) :
'''
GRAMMAR_NEW = '''\
/-- **A line whose ends a transitive relation tells apart has a marked step.** Where every step of
continuation under `E` either keeps `K` or carries the mark `P`, a line (相续) under `E` from `x` to
`y` with `K` failing from `x` to `y` has a step carrying the mark, given with its place on the line:
reached from `x`, and reaching `y`. Stated for every carrier and every relation; `K` need only
compose, as a class does (by its `trans`) and as a property's not arising from one end to the other
does. -/
theorem «两端分则中有标» {R E K P : «际» α} (split : ∀ x y, «续» R E x y → K x y ∨ P x y)
    (trans : ∀ {a b c}, K a b → K b c → K a c) {x y : α} (line : «相续» R E x y) :
'''
GRAMMAR_STEP_OLD = "      match ih (fun k' => apart (hK.trans k k')) with\n"
GRAMMAR_STEP_NEW = "      match ih (fun k' => apart (trans k k')) with\n"

PASSING_OLD = '«两端分则中有标» (carrierClass_class V) split line apart with'
PASSING_NEW = '«两端分则中有标» split (carrierClass_class V).trans line apart with'
# The module docstring's gloss of the law, which stated it for a class.
GLOSS_OLD = '''\
  line whose ends a class tells apart, every step of which keeps the class or carries a mark, has
  a marked step on it), applied to the carrier class along the pattern's line, with activity alike
  along it (`«线内同类»`). `Web.ByPassing.begins_passed` is proved from `«生于细而续于粗则异»` (a
'''
GLOSS_NEW = '''\
  line whose ends a transitive relation `K` tells apart, every step of which keeps `K` or carries a
  mark, has a marked step on it), applied to the carrier class along the pattern's line, with
  activity alike along it (`«线内同类»`). `Web.ByPassing.begins_passed` is proved from `«生于细而续于粗则异»` (a
'''

SAMPLING_OLD = '''\
/-- What fails at one step and holds at a later one arose across some step between them,
where the property is decided. -/
theorem arises_within {p : Nat → Prop} [∀ n, Decidable (p n)] {T : Nat} :
    ∀ {t : Nat}, T ≤ t → ¬ p T → p t → ∃ u, T ≤ u ∧ u < t ∧ ¬ p u ∧ p (u + 1)
  | _, .refl, absent, held => absurd held absent
  | m + 1, .step le, absent, held => match (inferInstance : Decidable (p m)) with
    | .isTrue pm => match arises_within le absent pm with
      | ⟨u, from_, below, no, yes⟩ => ⟨u, from_, Nat.lt_succ_of_lt below, no, yes⟩
    | .isFalse npm => ⟨m, le, Nat.lt_succ_self m, npm, held⟩

/-- What holds at one step and fails at a later one ceased across some step between them,
where the property is decided. -/
theorem ceases_within {p : Nat → Prop} [∀ n, Decidable (p n)] {T : Nat} :
    ∀ {t : Nat}, T ≤ t → p T → ¬ p t → ∃ u, T ≤ u ∧ u < t ∧ p u ∧ ¬ p (u + 1)
  | _, .refl, held, gone => absurd held gone
  | m + 1, .step le, held, gone => match (inferInstance : Decidable (p m)) with
    | .isTrue pm => ⟨m, le, Nat.lt_succ_self m, pm, gone⟩
    | .isFalse npm => match ceases_within le held npm with
      | ⟨u, from_, below, yes, no⟩ => ⟨u, from_, Nat.lt_succ_of_lt below, yes, no⟩
'''
SAMPLING_NEW = '''\
/-- What fails at one step and holds at a later one arose across some step between them,
where the property is decided. Along the successor from `T` to `t`, the property's not arising
composes, and it does arise from `T` to `t`, so a step where it arises lies on the line
(`«两端分则中有标»`), its place read back as order (`Map.step_reached_le`). -/
theorem arises_within {p : Nat → Prop} [∀ n, Decidable (p n)] {T : Nat} :
    ∀ {t : Nat}, T ≤ t → ¬ p T → p t → ∃ u, T ≤ u ∧ u < t ∧ ¬ p u ∧ p (u + 1) :=
  fun le absent held => match Map.step_reaches_of_le le with
  | .inl same => absurd held (same ▸ absent)
  | .inr line =>
    match «两端分则中有标» (K := fun x y => ¬ (¬ p x ∧ p y)) (fun _ _ _ => (Decidable.em _).symm)
      (fun k₁ k₂ ⟨no, yes⟩ => k₂ ⟨fun m => k₁ ⟨no, m⟩, yes⟩) line (fun k => k ⟨absent, held⟩) with
    | ⟨u, _, ⟨next, _⟩, ⟨no, yes⟩, from_, to⟩ => ⟨u, Map.step_reached_le from_,
      show u + 1 ≤ _ from next ▸ Map.step_reached_le to, no, next ▸ yes⟩

/-- What holds at one step and fails at a later one ceased across some step between them,
where the property is decided: its failing arose there (`arises_within`). -/
theorem ceases_within {p : Nat → Prop} [∀ n, Decidable (p n)] {T : Nat} :
    ∀ {t : Nat}, T ≤ t → p T → ¬ p t → ∃ u, T ≤ u ∧ u < t ∧ p u ∧ ¬ p (u + 1) :=
  fun le held gone => match arises_within (p := fun n => ¬ p n) le (fun no => no held) gone with
  | ⟨u, from_, below, no, yes⟩ => ⟨u, from_, below, Decidable.of_not_not no, yes⟩
'''

# (module, old, new, how often old occurs before the edit)
EDITS = [
    ('Grammar', GRAMMAR_OLD, GRAMMAR_NEW, 1),
    ('Grammar', GRAMMAR_STEP_OLD, GRAMMAR_STEP_NEW, 1),
    ('PatternPassing', PASSING_OLD, PASSING_NEW, 2),
    ('PatternPassing', GLOSS_OLD, GLOSS_NEW, 1),
    ('Sampling', SAMPLING_OLD, SAMPLING_NEW, 1),
]
# Item 5's laws that Sampling's edit reads, as GrammarMap states them once item 5 has moved them from MapRegions.
ITEM5 = (r'^theorem step_reached_le \{L : «际» Nat\} : ∀ \{x y : Nat\}, «所及» step L x y → x ≤ y',
         r'^theorem step_reaches_of_le : ∀ \{z n : Nat\}, z ≤ n → «所及» step «一» z n')

# The texts. 01 §3 states the law in prose: the home section of continuation-relative-to-a-class, whose law 10
# HE2's records step widens to the same hypothesis.
ROOT_OLD = (
    '**Theorem** (root). *A change between the ends has a place.* For a class `K`, where every step of continuation '
    'either keeps `K` or carries a mark `P`, a line whose ends `K` tells apart has a step carrying the mark, placed '
    'on the line between them (`«两端分则中有标»`); the proof uses only the transitivity of `K`.\n')
ROOT_NEW = (
    '**Theorem** (root). *A change between the ends has a place.* For a relation `K` that composes (a class is '
    'one), where every step of continuation either keeps `K` or carries a mark `P`, a line whose ends `K` tells apart '
    '(`K` fails from its start to its end) has a step carrying the mark, placed on the line between them '
    '(`«两端分则中有标»`).\n')
# LOGIC.md's L-04 copies the law's statement up to the proof: its first two lines are the Grammar edit's.
L04_OLD = GRAMMAR_OLD.split('-/\n', 1)[1]
L04_NEW = GRAMMAR_NEW.split('-/\n', 1)[1]
MEANING_OLD = '; if every step either keeps `K` or carries `P`, a line whose ends `K` separates has a step carrying `P`.'
MEANING_NEW = ('; for a transitive relation `K` (a class is one), if every step either keeps `K` or carries `P`, a line '
               'whose ends `K` separates (`¬ K x y`) has a step carrying `P`.')
CHAPTER, LOGIC = 'theories/becoming/chapters/01-ROOT.md', 'theories/becoming/review/LOGIC.md'
TEXTS = [(CHAPTER, ROOT_OLD, ROOT_NEW, 1)]
LOGIC_TEXTS = [(LOGIC, L04_OLD, L04_NEW, 1), (LOGIC, MEANING_OLD, MEANING_NEW, 1)]


def texts_main(args, check):
    """--texts: the prose edits, all or nothing, in the repository at args[0]."""
    root = Path(args[0])
    edits = TEXTS + (LOGIC_TEXTS if '--logic' in sys.argv[1:] else [])
    texts = {path: (root / path).read_text(encoding='utf-8') for path, _, _, _ in edits}
    failed, changed = [], set()
    for path, old, new, times in edits:
        text, first = texts[path], old.splitlines()[0][:70]
        if text.count(old) == times:
            texts[path] = text.replace(old, new)
            changed.add(path)
            print(f'{path}: {"would replace" if check else "replaced"} ({times}x) {first!r}')
        elif text.count(old) == 0 and text.count(new) == times:
            print(f'{path}: already applied, left: {first!r}')
        else:
            failed.append(f'{path}: {text.count(old)} copies of {first!r} (want {times}), '
                          f'{text.count(new)} of its replacement')
    if '--logic' not in sys.argv[1:]:
        print(f'{LOGIC}: left as it is (no --logic)')
    if failed:
        raise SystemExit('nothing written:\n  ' + '\n  '.join(failed))
    if not check:
        for path in sorted(changed):
            (root / path).write_text(texts[path], encoding='utf-8')
    print('item 1, texts:', 'checked, nothing written' if check else f'wrote {", ".join(sorted(changed)) or "nothing"}')


def main():
    flags = {'--check', '--weakening-only', '--texts', '--logic'}
    args = [a for a in sys.argv[1:] if a not in flags]
    if len(args) != 1 or any(a.startswith('-') for a in args):
        raise SystemExit(__doc__)
    check, weakening_only = '--check' in sys.argv[1:], '--weakening-only' in sys.argv[1:]
    if '--texts' in sys.argv[1:]:
        if weakening_only:
            raise SystemExit('--weakening-only concerns the Lean edits, not --texts')
        return texts_main(args, check)
    if '--logic' in sys.argv[1:]:
        raise SystemExit('--logic goes with --texts')
    becoming = Path(args[0]) / 'Becoming'
    texts = {m: (becoming / f'{m}.lean').read_text(encoding='utf-8') for m in ('Grammar', 'PatternPassing', 'Sampling')}
    grammar_map = (becoming / 'GrammarMap.lean').read_text(encoding='utf-8')
    failed, changed = [], set()
    for module, old, new, times in EDITS:
        if weakening_only and module == 'Sampling':
            print('Sampling: left as it is (--weakening-only)')
            continue
        text = texts[module]
        first = old.splitlines()[0][:70]
        if text.count(old) == times:
            if module == 'Sampling' and not all(re.search(p, grammar_map, re.M) for p in ITEM5):
                failed.append(f'{module}: GrammarMap lacks item 5\'s Map.step_reaches_of_le or Map.step_reached_le; '
                              'apply item 5 first')
                continue
            texts[module] = text.replace(old, new)
            changed.add(module)
            print(f'{module}: {"would replace" if check else "replaced"} ({times}x) {first!r}')
        elif text.count(old) == 0 and text.count(new) == times:
            print(f'{module}: already applied, left: {first!r}')
        else:
            failed.append(f'{module}: {text.count(old)} copies of {first!r} (want {times}), '
                          f'{text.count(new)} of its replacement')
    if failed:
        raise SystemExit('nothing written:\n  ' + '\n  '.join(failed))
    if not check:
        for module in sorted(changed):
            (becoming / f'{module}.lean').write_text(texts[module], encoding='utf-8')
    print('item 1:', 'checked, nothing written' if check else f'wrote {", ".join(sorted(changed)) or "nothing"}')


if __name__ == '__main__':
    main()
