#!/usr/bin/env python3
"""HE2's item 1: make the scratch tree. Copies Grammar, GrammarMap, PatternPassing and Sampling from the package
(refused unless they match tree/BASE.sha256, the base the kit was written on), puts item 5's three laws into
GrammarMap as item 5's kit states them (a stand-in, for this check only: item 5's lander writes GrammarMap, and
moves `Map.step_reached_le` out of MapRegions, which no module built here imports), then applies item 1 with the
kit's own script, so the tree is what the kit writes.
usage (from the worktree root): python3 -B <he2-item1>/checks/make_tree.py"""
import hashlib
from pathlib import Path
import shutil
import subprocess
import sys

HERE = Path(__file__).resolve().parent.parent
PKG = Path('experiments/integrated-correction/general-framework/generative-basis/lean/becoming')
TREE = HERE / 'tree'
MODULES = ('Grammar', 'GrammarMap', 'PatternPassing', 'Sampling')

AFTER = '''\
theorem step_irrefl : ∀ n, ¬ step n n
  | 0, h => Nat.noConfusion h
  | n + 1, h => step_irrefl n (Nat.succ.inj h)
'''
# Item 5's laws: `step_reached_le` as MapRegions states it (moved with its name, statement and proof), and
# `step_reach_succ`, `step_reach_of_le` as item 5's check file proves them (there `reach_succ`, `reach_of_le`).
ITEM5 = '''
/-- What a line along the steps reaches is later. -/
theorem step_reached_le {L : «际» Nat} : ∀ {x y : Nat}, «所及» step L x y → x ≤ y := by
  intro x y h
  match h with
  | .inl e => exact Nat.le_of_eq e
  | .inr l =>
    have later : ∀ {a b : Nat}, «相续» step L a b → a + 1 ≤ b := by
      intro a b l
      induction l with
      | one c => exact Nat.le_of_eq c.1.symm
      | more c _ ih => exact c.1 ▸ Nat.le_of_succ_le ih
    exact Nat.le_of_succ_le (later l)

/-- Under the one, the line along the successor reaches each later number. -/
theorem step_reach_succ : ∀ (k x : Nat), «相续» step «一» x (x + k + 1)
  | 0, _ => .one ⟨rfl, trivial⟩
  | k + 1, x => .more ⟨rfl, trivial⟩
      (Eq.subst (motive := fun z => «相续» step «一» (x + 1) z)
        (congrArg (· + 1) (Nat.succ_add x k)) (step_reach_succ k (x + 1)))

/-- Under the one, the line along the successor reaches every later number. -/
theorem step_reach_of_le {x y : Nat} (le : x ≤ y) : «所及» step «一» x y :=
  match Nat.eq_or_lt_of_le le with
  | .inl same => .inl same
  | .inr lt =>
    have lt_dest : ∀ {a b : Nat}, a < b → ∃ k, b = a + k + 1 := by
      intro a b lt
      induction lt with
      | refl => exact ⟨0, rfl⟩
      | step _ ih => match ih with
        | ⟨k, at_⟩ => exact ⟨k + 1, congrArg (· + 1) at_⟩
    match lt_dest lt with
    | ⟨k, at_⟩ => .inr (Eq.subst (motive := fun z => «相续» step «一» x z) at_.symm (step_reach_succ k x))
'''


def main():
    base = dict(reversed(line.split('  ', 1)) for line in (TREE / 'BASE.sha256').read_text().split('\n') if line)
    (TREE / 'Becoming').mkdir(parents=True, exist_ok=True)
    for m in MODULES:
        source = PKG / 'Becoming' / f'{m}.lean'
        digest = hashlib.sha256(source.read_bytes()).hexdigest()
        assert base[f'Becoming/{m}.lean'] == digest, f'{m}.lean is not the base the kit was written on'
        shutil.copyfile(source, TREE / 'Becoming' / f'{m}.lean')
    gm = TREE / 'Becoming' / 'GrammarMap.lean'
    text = gm.read_text(encoding='utf-8')
    assert text.count(AFTER) == 1 and 'step_reach_of_le' not in text
    gm.write_text(text.replace(AFTER, AFTER + ITEM5), encoding='utf-8')
    subprocess.run([sys.executable, '-B', str(HERE / 'kit' / 'apply_he2_item1.py'), str(TREE)], check=True)


if __name__ == '__main__':
    main()
