# Re-check of UE18 after the fix round

29 October 2026. Read-only re-check, AI-written, by the agent that wrote [REVIEW-UE18](REVIEW-UE18.md), of the revised `Becoming.Blanket` ([module](tree/Becoming/Blanket.lean), sha256 `8939f538…6d04e281`, [build](scratch-4.log)) and [NOTE](NOTE.md) (sha256 `d67c45be…74b1`), and of the kit as it stood at 22:21 (`integrate_ue18.py`, `texts_ue18.py`, `make_records_ue18.py`, `study_ue18.txt`, `board_ue18.py`; the kit was still being written). Line numbers refer to the module's bytes above.

## Verdict

The Lean is sound, with one gap. Rebuilt with a two-theorem probe, the module has 31 theorems in 47 declarations, every axiom report empty and no warnings; the probe's two theorems also have empty axiom reports. The module adopts the review's probe faithfully for F1 (the witness's join), F3, F4, F5 and F8. F6 and F7 are folded into the text. One error survives in four places:
- the module header (l. 35–37);
- the `any_model` docstring (l. 361–363);
- NOTE §1;
- the kit's 03 §1 theorem.

A reading that the review's probe refuted, but no finding named, survives in NOTE §4 and the kit (R2). Three claims of the fix round are not so (R3, R5, R6). UE18 can land after R1–R4. These are text edits, except that R1 also changes the module's doc comments, so the module is rebuilt. R5–R8 are style. Nothing new is forbidden; the standing "near-definitional, a composition or a witness" is right.

## Findings

**R1 (E). A free energy at step four is still among the readings.** Four texts call "a free energy of any belief the model holds" a reading of the internal course up to step four:
- the module header (l. 35–37);
- `any_model`'s docstring (l. 361–363);
- NOTE §1;
- the 03 §1 theorem in `texts_ue18.py`.

A free energy reads the belief and the record at its step. Whatever the model and the policy, the sensory parts differ at step four (probe `sensory_apart_at_four`), so a free energy of the model's belief at step four can separate the two courses. *Fix:* "a free energy of the model's belief at any step before four among them, the sensory parts being alike there (`blanket_alike`)", or drop the apposition.

**R2 (O). "A selection through its couplings separates exactly what they tell apart"** (NOTE §4; the 03 §1 reading in `texts_ue18.py`). This misstates 03 §1. There, *the selections* through a formation's couplings *together* separate exactly what the couplings tell apart (03's thesis); any one selection separates at most that. The internal course is one such selection, and `Deaf.lumps` shows it can separate less. The review's probe had this witness, but no finding named the sentence. *Fix:* "the selections through its couplings together separate exactly what they tell apart (03 §1); any one of them, the internal course among them, at most (`Deaf.lumps`)".

**R3 (O). The sufficiency reading still blames the uncoupled distance** (NOTE §4, second reading). It says the sufficiency direction "fails where the supply's distance to the break does not couple in". But in the witness no action changes the supply, so the system ends whatever couples in, and a supply coupled in by level would end it too. That the failure comes from the distance's not coupling in needs actions that can renew the supply: the foraging law, which the NOTE names as not stated. *Fix:* "fails in the witness, where no action changes the supply; that it fails because the distance does not couple in is the foraging law, not stated".

**R4 (O). The 03 §1 theorem generalizes `any_model`** (`texts_ue18.py`). The kit says "from a supply that ends it and from every larger one". The Lean has a supply of three against every supply of four or more. *Fix:* use the Lean's numbers. Alternatively, prove the general form, supplies `e` and `e + d` alike before step `e + 1`, for `modelLaw`.

**R5 (S). The `Runaway` import is still unused.** The revised module builds without it with the same counts (31 in 47; 58 modules in its closure, against 59). `Web.Admits` is in `Becoming.Admission` and `Web.AlikeThroughUpTo` in `Becoming.Testing`, and both are already in `ConditionalWeights`' closure. So three texts say what is not so:
- NOTE §6, "for the World's `Web.Admits` and `Web.AlikeThroughUpTo`";
- NOTE §7, "the `Runaway` import now used";
- the study's "its `Runaway` import supplies the World's admission and coupling".

*Fix:* drop the import and say "a leaf importing `Becoming.ConditionalWeights`" (also in the root bullet, the board line and the study's evidence). Or keep it with its true role: naming T6's module beside the witness, with no declaration of it used.

**R6 (S). `Deaf` is not the design's witness** (NOTE §6). The design asked for internal and external courses that differ together because the blanket's course differs. `Deaf`'s internal course is constant: it shows that a reading lumps, not that the two sides co-vary. `ThresholdDrain` is the design's witness: from three and from a hundred the external courses differ from the start (`external_course`), the blankets from step four, the internal parts from step five (`sensed_at_break`). Cite those instead.

**R7 (S). "When the sensory parts first differ"** (l. 38, citing `sensed_at_break`). Dropping `alike_before_break` left "first" unproved for `law`. Add `law.BlanketAlike short long 4` as a conjunct of `sensed_at_break` (probe `alike_before_four`, one match), or cite `sensed_alike`, which proves it for `modelLaw`.

**R8 (S). Wording.**
- The module's standing (l. 57) and the study say "the existence claim's emptiness … is conceded". Record B's `does_not_show` says the principle is *not* shown empty, and Ramstead and others concede unfalsifiability. Write "that the claim alone forbids nothing is conceded".
- NOTE §5 and the study say the agent form "removes UE1's caveat". Add "for a determined policy": the caveat concerns a sampled action.
- Record B's statement says forbidden "exactly where a weighting fixed apart from it weighs it nothing", but `forbids_iff` proves "exactly where its weight is nothing". The "fixed apart" belongs to the reading with `read_off_admits`.
- NOTE §1 and record B's counterexample say "so the claim's antecedent holds" of the ended system. That is a reading of `short_rests` (a fixed point read as a steady state with a trivial blanket); label it.
- The 03 §6 theorem identifies the principle's model with the point weighting inside a Theorem paragraph. Mark it "read so".
- Optionally, the principle's own name for the internal and active states together is "autonomous states", if `agent` reads as a separate actor.

## Probe

I ran `python3 -B scratch_build.py <tree> Becoming.Blanket Becoming.UE18RecheckProbe` from the package folder, with the module byte-identical to the study's. The module gave 31 theorems in 47 declarations and the probe 2 in 2, every axiom report empty and no warnings. The module's compile and audit were restored from the shared cache for these exact bytes. A copy without `import Becoming.Runaway` was compiled afresh with the same counts.

```lean
import Becoming.Blanket

/-! Re-check probe for UE18: not for landing. -/

namespace Becoming

namespace UE18RecheckProbe

open Blanket Blanket.ThresholdDrain

/-- The witness's blankets agree before step four: the "first" of `sensed_at_break`'s text. -/
theorem alike_before_four : law.BlanketAlike short long 4 :=
  fun k lt => match k, lt with
    | 0, _ => ⟨rfl, rfl⟩
    | 1, _ => ⟨rfl, rfl⟩
    | 2, _ => ⟨rfl, rfl⟩
    | 3, _ => ⟨rfl, rfl⟩
    | k + 4, lt => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 4 k))

/-- Whatever the model and the policy, the sensory parts differ at step four, from a supply of
three and from every supply of four or more: a free energy of the model's belief at step four,
reading the record there, can separate the two courses. -/
theorem sensory_apart_at_four {M A : Type} (update : M → Bool → A → M)
    (policy : Bool × M → Bool → A → A) (m : M) (a : A) (d : Nat) :
    ((modelLaw update policy).course (start m a 3) 4).sensory = false ∧
      ((modelLaw update policy).course (start m a (d + 4)) 4).sensory = true :=
  ⟨rfl, match d with
    | 0 => rfl
    | _ + 1 => rfl⟩

end UE18RecheckProbe

end Becoming
```
