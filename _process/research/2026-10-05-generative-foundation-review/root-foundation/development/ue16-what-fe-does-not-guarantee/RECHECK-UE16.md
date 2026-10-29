# Re-check of UE16's fold

29 October 2026. Read-only re-check, AI-written, of how [REVIEW-UE16](REVIEW-UE16.md)'s twelve findings were folded. It covers the revised module (sha256 `28ac657e…686543`), [NOTE](NOTE.md), the head of the drafting record and the kit's scripts (`make_records_ue16.py`, `texts_ue16.py`, `study_ue16.txt`, `integrate_ue16.py`, `board_ue16.py`). The module was rebuilt in a separate scratch tree, reusing the cached steps of these bytes: 67 theorems in 98 declarations, every axiom report empty, no warnings. A probe of 2 theorems (below) also has empty reports. Nothing else was changed.

## Verdict

Every finding is folded into the Lean soundly, and the new declarations say what their docstrings say, with one exception that the review itself introduced. Its probe P4 stated the holders' takes at every step, but `HeldPair`'s holders take part only at steps 0 and 1. That is the flaw F4 named in `store_kept` (R3). The texts mostly follow the Lean. What remains is mainly in the record texts and the paraphrases:

- a stale history entry (R1) and a declaration cited under the wrong law (R2), both errors in record text;
- the need-one pinning claimed at every outrun step, where the Lean proves it at one step (R4);
- pivotality glossed wrongly (R5);
- never parting still credited to the commuting law in three places (R6);
- a paraphrase missing its window (R7);
- an unproved correspondence inside a theorem paragraph, and a stale clause (R8);
- names and small slips (R9).

It can land after R1–R6; R7–R9 are small.

## The twelve findings

- **F1, F3, F5, F7, F9, F10, F12:** taken as proposed; the statements and docstrings are exact.
- **F2:** taken. `TwoCells.minima` and its docstring are now true, but `other_sizes` mislabels `[0, 4]` (R9).
- **F4:** taken, but the holders' takes are stated at every step (R3).
- **F6:** taken in the Lean (`outside_takes_nothing`, one step from a level of at most one); the texts claim more (R4).
- **F8:** taken. `Outrun.ends_either_way` derives both endings at need three by `need_ends`, with the forager's choice two at no risk.
- **F11:** taken, but pivotality is misglossed in two texts (R5).

## Findings

**R1 (E). Stale history entry in the identical-cells record** (`make_records_ue16.py`, `history_new[RIDA]`, en and zh). It says "the descent commutes … so by the commuting law alike cells stay alike" and "the witness Parting"; F3 and F12 undid both. *Fix:* "under any descent reading no cell's number alike cells stay alike; with an exchangeable field the descent commutes with exchanging neighbouring cells, and among configurations of one size a symmetric free energy has its minima in exchanged pairs; the witness TwoCells", and the same in zh.

**R2 (E). `outside_takes_nothing` is cited under the wrong law** (`groups_b`). It is listed among the forager law's declarations ("forager and six more"), whose text does not state it. Meanwhile the restraint law says "the outrun leaves such a member nothing to take" but cites only `restraint_unread`, which does not prove that. *Fix:* move it to the restraint law ("forager and five more") and state it as R4 says.

**R3 (O). The holders take part only at steps 0 and 1** (module l. 73–76 and 785–805; NOTE §1 and §2 Law 3; 05 §1 "each taking at every step"). Since `Optimum.HeldPair.flow.present (t + 2) = []` (probe `holders_absent`), `heldPair_choices` and `held_not_one` state, for `t ≥ 2`, takes that are never taken. This is the flaw F4 named, brought back in by the review's own P4. *Fix:* restrict the take and prediction conjuncts to `t < 2`, and state that the stores are at the set point at every step by `Optimum.HeldPair.held` (probe `held_not_one_fixed`). In the texts, say "at the two steps they take part …, each store at its set point at every step".

**R4 (O). The pinning is proved at one step but claimed at every step** (`restraint_unread` docstring, l. 600–602; header l. 63–64; NOTE §1 and §2; the record law "the outrun leaves such a member nothing to take" and `hypotheses_b`; study Delta (3)). `outside_takes_nothing` holds at an outrun step from a level of at most one, which is the last outrun step. Saying "so the two courses differ only before T" needs every outrun step. *Fix:* either prove the n-step form (at step `T + j`, `Flow.excess_bounded_at` from `T` and from `T + j + 1` bound the level on both sides, and the same count gives a take of nothing), or say "at the last outrun step, from a level of one, a member outside the rest that takes part takes nothing (`outside_takes_nothing`); the earlier steps follow by the same count, not stated" and drop "only before T".

**R5 (O). Pivotality is misglossed** (NOTE §5: "where the joint draw decides, no one member's choice is pivotal"; study, standing: "no one member being pivotal"). In joint excess each taker can be pivotal: in the held pair, one holder alone takes within what the pool is given, so the pool keeps its renewal. The gloss holds of the outrun, where the rest alone exceeds what is given. *Fix:* "where the rest alone outruns the renewal, no member outside it is pivotal (Palfrey and Rosenthal 1984, as the outrun record reads it)".

**R6 (O). Never parting is still credited to the commuting law.** Three places:
- `RELATED[RIDC]`: "the commuting law read on a free-energy descent, against guaranteed differentiation";
- the regions note for RIDA: "commutes with exchanging them, so alike cells stay alike";
- 08 §8's third parts: "joining claims … to the commuting law, …: identical cells … stay alike".

Since F3, the commuting law gives only the exchanged run and the paired minima. Likewise "what parts them is a start or a law that breaks the symmetry" (05 §9, NOTE §3) is misleading: a field that is not exchangeable does not part alike cells. *Fix:* "never parting needs only a descent reading no cell's number; the commuting law gives the exchanged run and the paired minima", and "what parts them is a start that differs, a rule reading a cell's number, or noise".

**R7 (O, small). `expectation_not_course` is paraphrased without its window** (05 §1 "the level reached is below it"; NOTE §1 and §2; study Delta (3)). The law holds under the outrun premises, from the rest's end on. *Fix:* add "from the rest's end on".

**R8 (O, small). An unproved correspondence inside a theorem paragraph, and a stale clause.**
- 05 §1 puts "for a point prediction its risk orders as active inference's does …" inside a **Theorem** paragraph, though no Lean states it. *Fix:* mark it "(a correspondence, not a Lean law: for a point prediction ô, KL[δ_ô ‖ P] is −ln P(ô))".
- `history_new[RIDB]` still says "one goal over the joint level a witness". *Fix:* "a goal over the joint level no guarantee either (two regulators continue, three end)".

**R9 (S). Names and small slips.**
- `TwoCells.other_sizes` lists `[0, 4]`, which has two cells, as another number of cells (in its docstring, header l. 48, NOTE §2 and the record law). Rename it `other_minima`: "other configurations of free energy nothing: no cells, one cell at 3, two cells at 0 and 4".
- "Two alike cells rest where they started" cites `alike_never_least` (05 §9, `counterexamples_a`, the record law, study Delta (1)). Resting is `alike_rests`, and only from `[1, 1]`; cite that.
- Header l. 79–80: `TwoStores.jointly_broken` is not "the same at an optimum by distance". It is a companion witness: a dweller's dependence broken at the takers' joint best response.
- The record id `identical-cells-under-a-symmetric-descent` names a symmetry that F3 showed the headline law does not need. Before landing, use an id matching the title, such as `identical-cells-under-a-descent-treating-them-alike`.
- The zh correspondences omit pivotality (record B) and `Relabel.EquivariantChoice.withholds_of_full_tie` (record A).
- UE1's correspondence ("A restatement; its third parts are UE16's …") and FEP-INTEGRATION ("A restatement; its third parts are UE16's (below)") contradict themselves. Phrase them as 08 §8 does: "its own laws restate; the containment's third parts are …".

## Probe

Built against the revised module's bytes with `python3 -B scratch_build.py <tree> Becoming.UE16RecheckProbe`: 2 theorems in 2 declarations, every axiom report empty, no warnings.

```lean
import Becoming.FreeEnergyGuarantees

/-! Re-check probe for UE16: not for landing. -/

namespace Becoming

namespace UE16RecheckProbe

open FreeEnergyGuarantees.SharedModels (holder)

/-- The held pair's holders take part at steps zero and one only. -/
theorem holders_absent (t : Nat) : Optimum.HeldPair.flow.present (t + 2) = [] := rfl

/-- The fix of R3: the takes at the two steps the holders take part, the stores at the set point
at every step. -/
theorem held_not_one_fixed :
    (∀ t, t < 2 → Optimum.HeldPair.flow.take t .first .pool =
        holder.chosen (Optimum.HeldPair.web.level t .firstStore) ∧
      Optimum.HeldPair.flow.take t .second .pool =
        holder.chosen (Optimum.HeldPair.web.level t .secondStore)) ∧
    ∀ t h, Optimum.AtSetPoint (Optimum.HeldPair.store h) Optimum.HeldPair.one
      (Optimum.HeldPair.web.level t) :=
  ⟨fun _ _ => ⟨rfl, rfl⟩, Optimum.HeldPair.held⟩

end UE16RecheckProbe

end Becoming
```
