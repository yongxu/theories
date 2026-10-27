#!/usr/bin/env python3
"""For the next landing that rebuilds `Becoming.GrammarPath`: the Lean comment fixes OC3 and OC4 left for it (study
sections 413 and 423), and one class lemma OC4's review found missing. Run it in that landing's tree before its checker
run; each edit is asserted to apply once, so a part already applied or reworded stops the script and is read by hand.

- OC3 (g): the module doc's first sentence, "a line goes on past a member's end" → "continues past" (the glossary's
  "goes on" is 延, going on without end; `«过亡而续»` shows less).
- OC4 A9: the module doc names `FiniteDescent`, which is no declaration; `FiniteFamilies.one_not_constant` is meant.
- OC4 A12: `FinerWake.finer_class`, that its finer division is a class, as `FinerOutside.finer_class` is (the chapter's
  "dividing the two outside things apart" assumes it); a new declaration, so its record law cites it.
- `--root`, only on the PF line owner's yes (OC4's letter (e) covers the README rows, not this bullet): the root
  module's bullet, "a step with nothing outside the class breaks it" → "an alike occurrence that conditions something
  but nothing alike to that effect breaks it" (the law concerns constancy up to the net's end and an alike occurrence).
usage (from the checkout root): python3 -B <kit>/deferred_grammarpath.py [--root]"""
import sys
from pathlib import Path

PKG = Path.cwd() / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
GP = PKG / 'Becoming/GrammarPath.lean'
ROOT_DOC = PKG / 'Becoming.lean'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, text.count(old), old[:80])
    path.write_text(text.replace(old, new), encoding='utf-8')


edit(GP, "Chapter 7 §4.6 joins two routes into one path to the future: a line goes on past a member's end",
     "Chapter 7 §4.6 joins two routes into one path to the future: a line continues past a member's end")
edit(GP, "continues is constant; `FiniteDescent` is a witness, where not even the one is.",
     "continues is constant; `FiniteFamilies.one_not_constant` is a witness, where not even the one is.")
edit(GP, "def finer : «际» Occ := fun x y => kind x = kind y\n\n/-- Both divisions give `m` the same class. -/\n"
         "theorem same_class : ∀ y, finer .m y ↔ «二分» inClass .m y\n  | .m => ⟨fun _ => rfl, fun _ => rfl⟩\n  | .c =>",
     "def finer : «际» Occ := fun x y => kind x = kind y\n\n"
     "/-- The finer division is a class. -/\n"
     "theorem finer_class : «类» finer := ⟨fun _ => rfl, Eq.symm, Eq.trans⟩\n\n"
     "/-- Both divisions give `m` the same class. -/\n"
     "theorem same_class : ∀ y, finer .m y ↔ «二分» inClass .m y\n  | .m => ⟨fun _ => rfl, fun _ => rfl⟩\n  | .c =>")
if '--root' in sys.argv[1:]:
    edit(ROOT_DOC, "and a step with\n  nothing outside the class breaks it (`«出类不随则不至终有常»`, `CleanStep`)",
         "and an alike\n  occurrence that conditions something but nothing alike to that effect breaks it "
         "(`«出类不随则不至终有常»`, `CleanStep`)")
print('deferred GrammarPath edits applied' + (' with the root bullet' if '--root' in sys.argv[1:] else ''))
