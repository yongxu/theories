# GW1, GW2 and GW6 Lean: independent review

AI review, 30 October 2026, Claude Opus 5.5 (`claude-opus-5-5`), read-only except this file.

Reviewed: the two untracked modules on branch `gw-lean` at `6376f0da3`, `Becoming/MapRegions.lean` (MR, md5 `c0014700…`) and `Becoming/WideningOnTheMap.lean` (WM, md5 `01ddecb8…`), against [NOTE.md](NOTE.md) §3.1, §9 and §10 and AGENTS.md ("Proof and naming"). I also read the notions they use, in Grammar, GrammarMap, Arising, Change, HeldPossible, ReachableRanges, ContinuedClasses, EventualWidening, KeepingWidening and Settling. The build and the empty axiom reports were taken as given. Lean paths are relative to `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/`, and line numbers are those of the reviewed bytes.

Three scratch modules were built with `scratch_build.py` from `/private/tmp/claude-501/gwreview/tree`, against the two modules as reviewed. Nothing was written in the repository. Every theorem cited below with an `rv_` name compiled. Their axiom reports are empty, except three that use `omega` and report `propext` and `Quot.sound`, never `Classical.choice`. The Lean is in the appendix, since `/private/tmp` does not last.

## Findings

There is no high finding. Every theorem proves what its own statement says, and no hypothesis is hidden. The medium findings fall into three groups:
- two premises or hypotheses stronger than needed (1, 2);
- a headline that its premises do not carry (4, 5);
- two naming or twin problems, settled best before landing (6, 7).

| # | Sev. | Location | Finding | Suggested fix |
|---|---|---|---|---|
| 1 | medium | WM:154–170 (`located`, `generation_of_keepsWidening`); WM:196, 244, 302, 311 (the theorems built on them); WM:50–54 (Standing) | **`dec : ∀ n x, Q n x ∨ ¬ Q n x` is stronger than needed.** Deciding each holding only up to double negation is enough: induct on `¬¬ Q (S + d) x` in place of `Q (S + d) x` (`rv_located_weak`, `rv_generation_of_keepsWidening_weak`). That weak premise is exactly what the direction needs in general. **Lean:** `(∀ X Q, KeepsWideningFrom Q 0 → «全生成» next (kept Q) (same Q) 0) ↔ ∀ P : Prop, ¬ P ∨ ¬ ¬ P` (`rv_wlem_of_locating`, `rv_locating_of_wlem`). **The coding:** point `k` arrives at `2k + 1` where `P` holds, and at `2k + 2` otherwise. The step that changes what is held lies at an even place exactly where `¬¬P`, and at an odd place exactly where `¬P`. **Effect on the Standing:** "locating the step needs what is held decided" is false as a claim of need. | Take `wdec : ∀ n x, ¬ Q n x ∨ ¬ ¬ Q n x` in these theorems (from `N` on is enough); `dec` gives it at once. Add the weak-excluded-middle calibration as a lemma of GW6. AGENTS.md makes a calibration of the logic alone a lemma, and its record can say what the need means: to locate where something new arrives, each moment's holding must be not held or not refuted. Revise the Standing to match. A hand-arithmetic version of `rv_wlem_of_locating` would have an empty report. |
| 2 | medium | MR:30–34, MR:340–373 (`«生成后守之定则LPO»`) | **The LPO calibration is not in its strongest natural form.** (a) **A weaker premise is enough.** Deciding 后守 alone, for the one sequence `settling p`, decides `p`: `(«后守» … (settling p) 0 ∨ ¬ «后守» … (settling p) 0) → (∃ n, p n = true) ∨ ∀ n, p n = false` (`rv_lpo_of_keepsAfter_decided`). The stated theorem follows from it through `«单行则生成后守不并»` (`rv_lpo_stated_from_weaker`). Deciding 生成 alone gives only the weak form, WLPO (`rv_wlpo_of_generates_decided`). (b) **The stated hypothesis is more than LPO.** By the characterizations of finding 3, it says exactly that every Boolean sequence changes at arbitrarily late steps or is constant from some step on. That is the positive Σ⁰₂ decision. LPO gives it back with countable choice: decide each tail, choose, then decide the chosen sequence. It does not evidently give it back without choice, and the core has none. So LPO is the lower bound shown, not the exact strength. "To decide whether it renews again" describes the coding; the hypothesis decides whether the line renews without end. | State the pointwise law on 后守 as the calibration. Its need statement: to tell whether a line keeps from some point on is to decide whether it stops renewing. Keep the present theorem as its corollary and add the WLPO half for 生成. In the docstring, say that placing a point in 生成 or 后守 is the Σ⁰₂ decision, which the two characterizations make exact, and that LPO is the part derived. |
| 3 | low | MR:30–32; NOTE §9 ("生成 at 0 is …, 后守 at 0 is …") | **The note's two single-line readings are not theorems.** The LPO proof inlines one direction of each. Both equivalences hold: `«生成» step «一» (b-class) 0 ↔ ∀ y, ∃ n, y ≤ n ∧ b n ≠ b (n + 1)` and `«后守» step «一» (b-class) 0 ↔ ∃ z, ∀ n, z ≤ n → b n = b (n + 1)` (`rv_generates_iff`, `rv_keepsAfter_iff`, with the helpers `rv_reach_to` and `rv_holds`). | Add both. They are GW1's reading on a single line, and they make finding 2's exact strength a theorem. |
| 4 | medium | WM:33–39 (the bullet "What parts generation from widening is exactly loss"), WM:137–150 (`generation_iff`) | **"Exactly loss" holds only under both premises, and no theorem states it.** `generation_iff` is unconditional and exact, but it relates two map notions: 全生成 at (nothing lost, the same possible) and 全生成 at (the one, the same possible). The claim of the bullet, the board's GW6 line and the record is about keeping widening: what parts keeping widening from generation under the one is exactly loss. That holds only where `dec` (or `wdec`) and `found` both hold. Without them each direction amounts to a logical principle in general: weak excluded middle (finding 1), and excluded middle (finding 12). | Add `keepsWidening_iff_kept_and_generation (wdec) (found) : KeepsWideningFrom Q N ↔ (∀ n, N ≤ n → kept Q n (n + 1)) ∧ «全生成» next «一» (same Q) N`. Word the bullet, the board and the record with the premises: "where what is held is decided and what is new is found, what parts keeping widening from generation under the one is exactly loss". |
| 5 | medium | WM:320–334 (`Web.keeps_each_generates_whole`), WM:40–48 | **"Keeps each, generates the whole" says more than the Lean.** (a) **"The whole".** The second conjunct is about the admitted range of one course, read on its moments. It is not the World, the whole possible or a whole made of the formations, and no theorem relates the two conjuncts beyond their shared hypothesis. (b) **"Grain".** In the map, two grains are two classes on one carrier. The two conjuncts here sit on two carriers: occurrences `Nat × F` along `continuationStep itself`, and moments `Nat` along `Steps.next`. So `«全生成全守不并»` is not in play, and the contrast is not the map's two grains. (c) **What each half uses.** The first conjunct uses only `keeps.1`, that nothing is lost. Its "none is 全生成" holds of every occurrence with no hypothesis (`itself_not_generation`). (d) **A wrapper.** The theorem is the conjunction of `kept_of_includes_by_name` and `generation_of_keepsWidening_byName`, so by AGENTS.md it is not another result. | Rename it to what it states, for example `kept_by_name_and_generation_on_moments`. Docstring: "on the occurrences, by name, each formation admitted from `T` on is 全守, from nothing lost alone, and no occurrence is 全生成; on the course's moments, where admission is decided, the admitted range is 全生成 at (nothing lost, the same possible)." Record it as a corollary, and drop "generates the whole" from the board's GW6 line and the module summaries. |
| 6 | medium | WM:72 (`Steps.kept`) and every use | **"Kept" means two things in the package.** It already means 全守 (`Web.kept_of_includes_by_name`), and keeping is the map's 守, the region that 全生成 excludes. Here `kept Q` is "nothing lost", the coarse relation of 全生成. The two senses meet in `keeps_each_generates_whole`, where «全守» comes from `kept_of_includes_by_name` beside `«全生成» … (Steps.kept …)`. A reader takes `«全生成» next (kept Q)` as "generation at keeping". | Name it by inclusion, the package's word for nothing lost (`Web.IncludesAcross`, `IncludesAcrossFrom`): `Steps.includes`, with `buqiong_includes_iff`, `includesFrom_iff`, `same_includes` and `includes_refl`/`includes_trans`. The name is chosen at claim time, before landing (AGENTS.md). |
| 7 | medium | WM:287–298 (`Web.keepsWidening_itself_iff`); WM:228–239 (`keepsWidening_iff_from_zero`) | **A twin of a landed law, not cited.** The landed `Web.keepsWidening_iff_chain` (ReachableRanges.lean:747) already says that keeping widening by name from `T` is `Reaching.KeepsWidening` of the chain shifted by `T`. `keepsWidening_itself_iff` proves that law again by its own unfolding. **A shift lemma removes the twin.** `KeepsWideningFrom Q T ↔ Reaching.KeepsWidening (fun n => Q (T + n))` (`rv_keepsWideningFrom_iff_shift`) generalizes `keepsWidening_iff_from_zero`. With it, `keepsWidening_itself_iff` takes one line: `Web.keepsWidening_iff_chain.trans (rv_keepsWideningFrom_iff_shift (Q := …)).symm` (`rv_keepsWidening_itself_iff`). | Add the shift lemma and derive both theorems from it; the zero case needs `Nat.zero_add`. Cite `Web.keepsWidening_iff_chain` in the module docstring and in the record. |
| 8 | low | MR:18 | **Garbled wording.** "a pattern that renews and then stays is in quiet of 生成, 守 and 退化". The module's description in `check_becoming.py` has it right: "in none of". | Write "in none of". |
| 9 | low | MR:6 | **Unclear phrase.** "Laws of the map … that nothing below it uses". The intended reason seems to be that these laws sit in a leaf, since GrammarMap has many dependents. | Say that. |
| 10 | low | WM:152–159 (`located`); WM:22–24 | **`located` drops what its proof has.** Its docstring says the point "arrives at a step from `S`". The statement gives only some `n ≥ S` with `¬ same Q n (n + 1)`, with no upper bound and no tie to `x`. The proof has both: `n < S + d`, and `¬ Q n x ∧ Q (n + 1) x`. | Return both. `rv_located_weak` is the form with weak deciding, ending in `¬ Q n x ∧ ¬ ¬ Q (n + 1) x`; with `dec` the last conjunct is `Q (n + 1) x`. Then the module docstring's "the step at which something new arrives is located" holds of the new point itself. |
| 11 | low | WM:172–181 (`opens_unrefuted_of_generation`) | **The name says more than the statement.** In the package, "unrefuted" means "under double negation" (`rests_unrefuted`). The conclusion `¬ kept Q (n + 1) n` is weaker than an unrefuted opening, `¬ ¬ ∃ x, Q (n + 1) x ∧ ¬ Q n x`, unless `Q n` is stable. The docstring is exact. | Rename it, for example `not_includes_back_of_generation` (with finding 6's vocabulary). |
| 12 | low | WM:183–186, 196–197, 309–314 (`found`); WM:25–27 | **The wording of `found` reads as a weaker premise.** "found wherever it is not refuted" reads as `¬¬∃ → ∃`. The premise is `¬ kept Q (n + 1) n → ∃ …`, which asks more where `Q` is undecided; the two agree under `dec`. The clause "as a listing of what each moment holds gives" leaves out that `found_of_listed` also takes `dec`. `found` is genuinely needed: for every type, the converse over every decided chain gives double-negation elimination (`rv_dne_of_converse`); over `Nat × Nat` it gives Markov's principle (`rv_markov_of_converse`). It is needed only from `N` on. | Word it "wherever not everything held after a step was held before, something new there is found". Add "with what is held decided" to the listing clause. Restrict `found` and `dec` to `N ≤ n`. |
| 13 | low | WM:12–18 | **The coarse place holds a preorder, not a class.** The docstring says "the coarse class is nothing lost … It is a preorder, not a class", and "Read at two grains, as the map reads". The map's `L` is a class (GrammarMap's docstring). The join depends on putting a relation that is not symmetric in its place, since a symmetric coarse relation cannot tell loss from gain. | Say "a preorder in the place of the coarse class" and give that reason, here and in the record. |
| 14 | low | WM:54–56 (Standing, last sentence) | **Loss alone does not explain the held-possible case.** "On the held possible under the one … the join is one way, and the classes here say why: the one does not count loss." The fine class of `Run.generation_of_heldKeepsWidening` is the part held (`Same` on configurations), not the same possible. Its converse fails on `Oscillating`, where the part changes at every step whatever the held possible does. Loss explains the one-way join at (the one, the same possible) (`Moving`), not by itself the held-class case. | "At (the one, the same possible) the join is one way because the one does not count loss (`Moving`); the held class of `Run.generation_of_heldKeepsWidening` is a further fine class." |
| 15 | low | WM:241–246, WM:30–32 | **An instance claim with no instance theorem.** "for the possible with a part held, and for the whole possible". No theorem states either instance. There, `dec` means deciding possibility, which is reach, at every moment. That premise is stronger than, and different from, `Run.generation_of_heldKeepsWidening`'s premise, which decides whether each step holds the part. Along a course of `P`, the whole possible under `P` never keeps widening (`Run.not_keepsWidening_of_within`, every step being a move of `P`), so that instance is empty for the course's own process. | Drop the clause, or write "for any chain, such as …", with the premise each instance takes. |
| 16 | low | WM:270–279 | **Stated at 0 only.** `Growing.keepsWidening` and `Growing.generation` are stated at 0, and the same proofs give every `N`. The `Moving` theorems are stated at every `N`. | Take `(N : Nat)`. |
| 17 | low | MR:319–338; WM:103–116; HeldPossible.lean:406, 412 | **The same lemmas several times.** `Map.step` and `Steps.next` are the same relation. "What a line along the steps reaches is later" now appears three times: `Map.step_reached_le`, `Steps.reached_le`, and HeldPossible's local `reached_le`. "It reaches every later step" appears twice more: `Steps.reaches`, and HeldPossible's local `reach_to`. The imports force this for now. `Map.seen` and `Map.seen_witness` repeat Settling.lean:337 and :349. The nearest landed calibration is `Settling.OneWay.lpo_of_settles` (Settling.lean:377). The conclusion of `«生成后守之定则LPO»` is `Becoming.LPO` (Change.lean:381) written out. | In the docstrings, cite the Settling calibration and `LPO`. Note the twins for the next rebuild of GrammarMap or Arising. |
| 18 | low | WM:111, 139, 154, 203; MR:274–284 | **Generic names in shared namespaces.** `Steps.reaches`, `Steps.generation_iff`, `Steps.located`, `Steps.search`, `Map.seen`, `Map.turning`, `Map.settling`. Arising, Change, HeldPossible and WorldRepresentation share `Steps`. A theorem called `search` names a procedure, not a statement. | For example: `Steps.reaches_of_buqiong`, `Steps.generation_includes_iff`, `Steps.change_located` (as `Run.held_change_located`), `Steps.new_in_list_or_none`. Put the LPO coding in its own namespace. |
| 19 | low | GrammarMap.lean:203–204 | **A stale sentence upstream.** GrammarMap's docstring still says that how the strong forms stand to 生成, 守 and 退化 "is not stated". MapRegions now states `«全守则后守»` and `Map.Once`. | Record the change for GrammarMap's next rebuild. GrammarMap cannot change now without rebuilding its dependents. |
| 20 | low | MR:68–70 (`«后守»`) | **The docstring's path is looser than the Lean.** "from a point it reaches on that branch". The Lean asks that `z` be reached from `x` on the coarse line and lie on the branch (`S z`); the path to `z` need not lie in `S`. This is harmless, since a reached point with quiet ahead gives a genuine branch. | "from a point of that branch reached from `x`". |

## Checked and found sound

- **Statements against proofs.** Every declaration of both modules was read against its proof. Each proves what its statement says, and every hypothesis is in the statement.
- **GW1 and GW2 against NOTE §10.** Every item planned is present:
  - `«后守»`, `«守则后守»`, `«全守则后守»`, `«后守则延»`, `«后守退化不并»`, `«单行则生成后守不并»` and `«三域之周»`;
  - `Map.Once` with `.not_generates`, `.not_keeps`, `.not_degenerates`, `.keepsAfter` and `.keeping`;
  - the Unit-model lemma `«三域之定当且仅当排中»`, and `«生成后守之定则LPO»`;
  - `«传则粗不生»` and `«生则或粗生或传»`, which assumes no order between the classes, with `«粗有前则生为传»` added.

  Together with `«传则粗不生»`, the split of a beginning is exclusive. The module is a core leaf importing only GrammarMap, as OU's decision put it.
- **`«后守»`.** It is §9's definition verbatim, and the point must be reached from `x`, for the note's reason. Take `Map.fork` at `.chain 0`. Without reach, keeping from some point on holds there, through the still occurrence that the chain never reaches (`rv_anywhere`). With reach it fails, since every point the chain reaches renews at once (`rv_not_keepsAfter`).
- **`«三域之周»`.** The family of reached points that do not end on every branch is closed, by excluded middle, and excluded middle on the 后守 condition then places the point. The calibration's Unit model has the relation `P`. `Map.Once` is §9's `{p, q, r}`: only `first → second` renews under (the one, identity), and the other four theorems hold.
- **The LPO coding.** `settling p` turns until `p` first holds and stays after. Both cases of the proof are right: 生成 refutes `p n = true` through the renewal ahead of `n`, and 后守's point `z` either has `p` already seen by `z + 1` or would carry a renewal at `z`.
- **The definitions on the moments.** `Steps.kept`, `Steps.same` and `Steps.KeepsWideningFrom` are faithful. `KeepsWideningFrom Q 0` is `Reaching.KeepsWidening Q` (`keepsWidening_iff_from_zero`). Its two clauses are `IncludesAcrossFrom` and `KeepsOpening` read by name (`keepsWidening_itself_iff`, through `includesAcross_itself_iff` and `exceedsAcross_itself_iff`). The shift lemma of finding 7 covers every `T`.
- **The unconditional laws.** `generation_iff` is exact with no premise. `begins_iff`, `buqiong_kept_iff`, `includes_iff`, `reached_le` and `reaches` are right. `opens_unrefuted_of_generation` takes no premise. `keepsWidening_of_generation` is right. `search` is exhaustive, and `found_of_listed` is right.
- **The witnesses.** `Moving` is 全生成 under the one at every `N`, is not 全生成 at (nothing lost, the same possible) and does not keep widening: loss parts the two. `Growing` has both.
- **The World corollaries.** They use `kept_of_includes_by_name` and the two `itself` lemmas as stated.
- **Names.** A scan of the qualified declaration names in `Becoming/*.lean` finds no clash with an existing declaration. Clashes of meaning are findings 6 and 18.
- **Registration.** Both modules are in `CORE` (check_becoming.py:72) and imported by `Becoming.lean` in the working tree. The descriptions there repeat the module docstrings, so fixes to findings 2, 4, 5 and 8 should be carried there too.
- **Style.** Definitions use exhaustive patterns (`Map.once`, `seen`, `turning`). Terms are used where the surrounding modules use terms, and `by` blocks where GrammarMap's analogues use them (`«单行则生守不并»`, `«全三域之周»`). Comments are about as dense as in GrammarMap; the small helpers carry no docstrings, as GrammarMap's do not.

## On the high and medium findings

There is no high finding. Each theorem is correct as stated, and the "both ways" of GW6 is honest as a conditional equivalence: both premises are in the statement of `generation_iff_keepsWidening` and of its World form. The premises themselves are uneven, and the Lean can show how.

**The first premise, `dec`** (finding 1). It is more than the direction needs. Weak deciding is enough, and weak excluded middle is exactly what the direction costs in general, so the Standing's "needs what is held decided" should become that need.

**The second premise, `found`** (finding 12). It is needed: in general it amounts to double-negation elimination, and to Markov's principle on decided chains over `Nat × Nat`. A listing together with deciding meets it. With both premises the identity is constructive, as `Growing` shows.

**What follows for the headlines.**
- **Exactly loss** (finding 4). "What parts generation under the one from widening is exactly loss" holds only under these premises. It deserves its own theorem, and its wording needs the premises.
- **Keeps each, generates the whole** (finding 5). That headline needs renaming: its conjuncts sit on two carriers, its first half uses nothing lost alone, and "the whole" is one course's admitted range.

**The LPO calibration** (finding 2). It is sound but not strongest. Deciding 后守 alone, pointwise, already gives LPO. The stated hypothesis is the Σ⁰₂ decision of eventual constancy, of which LPO is only a lower bound. Finding 3's two characterizations make this exact.

**Settle before landing** (findings 6 and 7). Once records cite these names, they are costly to change.
- **`Steps.kept`** reuses "kept" in the opposite sense to 全守 and 守. `Steps.includes`, the package's word for nothing lost, fits.
- **`Web.keepsWidening_itself_iff`** is a twin of the landed `Web.keepsWidening_iff_chain`. A shift lemma makes it a one-line corollary.

## Appendix: the scratch checks

Built with `python3 -B scratch_build.py /private/tmp/claude-501/gwreview/tree <module>` from the package folder, against MR and WM as reviewed. All three compile. Unused-variable warnings appear in the second and third. Axiom reports are empty except `rv_late_keeps`, `rv_parity` and `rv_wlem_of_locating`, whose `omega` gives `propext` and `Quot.sound`.

### `Becoming/GWReviewWiden.lean`

```lean
import Becoming.WideningOnTheMap

namespace Becoming
namespace Steps

variable {X : Type} {Q : Nat → X → Prop}

/-- Weak deciding suffices for locating, and the point itself arrives within the stretch. -/
theorem rv_located_weak (wdec : ∀ n x, ¬ Q n x ∨ ¬ ¬ Q n x) {S : Nat} {x : X} (before : ¬ Q S x) :
    ∀ d, ¬ ¬ Q (S + d) x → ∃ n, S ≤ n ∧ n < S + d ∧ ¬ Q n x ∧ ¬ ¬ Q (n + 1) x
  | 0, held => absurd before held
  | d + 1, held => match wdec (S + d) x with
    | .inl not_yet => ⟨S + d, Nat.le_add_right S d, Nat.lt_succ_self _, not_yet, held⟩
    | .inr earlier => match rv_located_weak wdec before d earlier with
      | ⟨n, from_, lt, a, b⟩ => ⟨n, from_, Nat.lt_succ_of_lt lt, a, b⟩

theorem rv_generation_of_keepsWidening_weak (wdec : ∀ n x, ¬ Q n x ∨ ¬ ¬ Q n x) {N : Nat}
    (keeps : KeepsWideningFrom Q N) : «全生成» next (kept Q) (same Q) N :=
  generation_iff.mpr ⟨buqiong_kept_iff.mpr (includes_iff.mp keeps.1),
    generation_iff_begins.mpr fun y le => match keeps.2 y le with
      | ⟨_, later, x, held, before⟩ => match le_dest later with
        | ⟨d, at_⟩ =>
          match rv_located_weak wdec before d
              (fun no => no (Eq.subst (motive := fun m => Q m x) at_ held)) with
          | ⟨n, from_, _, not_yet, arrives⟩ =>
            ⟨n, from_, begins_iff.mpr fun s => arrives fun h => not_yet ((s x).mpr h)⟩⟩

/-- The coding for the calibration: point `k` arrives at `2k + 1` where `P`, else at `2k + 2`. -/
def rv_late (P : Prop) : Nat → Nat → Prop := fun n k => 2 * k + 2 ≤ n ∨ (2 * k + 1 ≤ n ∧ P)

theorem rv_late_keeps (P : Prop) : KeepsWideningFrom (rv_late P) 0 :=
  ⟨fun _ _ _ later k held => held.elim (fun a => .inl (Nat.le_trans a later))
      (fun ⟨a, p⟩ => .inr ⟨Nat.le_trans a later, p⟩),
   fun S _ => ⟨2 * S + 2, by omega, S, .inl (Nat.le_refl _),
     fun h => h.elim (fun a => by omega) (fun ⟨a, _⟩ => by omega)⟩⟩

theorem rv_parity : ∀ n : Nat, ∃ k, n = 2 * k ∨ n = 2 * k + 1
  | 0 => ⟨0, .inl rfl⟩
  | n + 1 => match rv_parity n with
    | ⟨k, .inl e⟩ => ⟨k, .inr (by omega)⟩
    | ⟨k, .inr e⟩ => ⟨k + 1, .inl (by omega)⟩

/-- **Calibration**: locating, for every chain, is at least weak excluded middle. -/
theorem rv_wlem_of_locating
    (h : ∀ (X : Type) (Q : Nat → X → Prop), KeepsWideningFrom Q 0 →
      «全生成» next (kept Q) (same Q) 0) (P : Prop) : ¬ P ∨ ¬ ¬ P :=
  match generation_iff_begins.mp (generation_iff.mp (h Nat (rv_late P) (rv_late_keeps P))).2 0
      (Nat.le_refl 0) with
  | ⟨n, _, begun⟩ =>
    have apart := begins_iff.mp begun
    match rv_parity n with
    | ⟨k, .inl e⟩ => .inr fun np => apart (e ▸ fun j =>
        ⟨fun held => held.elim (fun a => .inl (by omega)) (fun ⟨a, p⟩ => .inr ⟨by omega, p⟩),
         fun held => held.elim (fun a => .inl (by omega)) (fun ⟨_, p⟩ => absurd p np)⟩)
    | ⟨k, .inr e⟩ => .inl fun p => apart (e ▸ fun j =>
        ⟨fun held => held.elim (fun a => .inl (by omega)) (fun ⟨a, p⟩ => .inr ⟨by omega, p⟩),
         fun held => held.elim (fun a => .inr ⟨by omega, p⟩) (fun ⟨a, _⟩ => .inr ⟨by omega, p⟩)⟩)

/-- **Conversely**, weak excluded middle gives locating for every chain. -/
theorem rv_locating_of_wlem (wlem : ∀ P : Prop, ¬ P ∨ ¬ ¬ P) (X : Type) (Q : Nat → X → Prop)
    (keeps : KeepsWideningFrom Q 0) : «全生成» next (kept Q) (same Q) 0 :=
  rv_generation_of_keepsWidening_weak (fun n x => wlem (Q n x)) keeps

/-- A decided chain for Markov's principle: at every step, a point `(n, k)` with `p k` arrives. -/
def rv_marked (p : Nat → Bool) : Nat → Nat × Nat → Prop := fun n x => x.1 < n ∧ p x.2 = true

/-- **Calibration of `found`**: even for decided chains, the converse for every chain gives
Markov's principle. -/
theorem rv_markov_of_converse
    (h : ∀ (X : Type) (Q : Nat → X → Prop), (∀ n x, Q n x ∨ ¬ Q n x) →
      «全生成» next (kept Q) (same Q) 0 → KeepsWideningFrom Q 0)
    (p : Nat → Bool) (unrefuted : ¬ ∀ k, p k = false) : ∃ k, p k = true :=
  have dec : ∀ n x, rv_marked p n x ∨ ¬ rv_marked p n x := fun n x =>
    match Nat.decLt x.1 n, hp : p x.2 with
    | isTrue lt, true => .inl ⟨lt, hp⟩
    | isTrue _, false => .inr fun ⟨_, e⟩ => Bool.noConfusion (hp.symm.trans e)
    | isFalse ge, _ => .inr fun ⟨lt, _⟩ => ge lt
  have generation : «全生成» next (kept (rv_marked p)) (same (rv_marked p)) 0 :=
    generation_iff.mpr ⟨buqiong_kept_iff.mpr fun _ _ _ ⟨lt, e⟩ => ⟨Nat.lt_succ_of_lt lt, e⟩,
      generation_iff_begins.mpr fun y _ => ⟨y, Nat.le_refl y, begins_iff.mpr fun s =>
        unrefuted fun k => match hk : p k with
          | false => rfl
          | true => absurd ((s (y, k)).mpr ⟨Nat.lt_succ_self y, hk⟩).1 (Nat.lt_irrefl y)⟩⟩
  match (h (Nat × Nat) (rv_marked p) dec generation).2 0 (Nat.le_refl 0) with
  | ⟨_, _, x, ⟨_, e⟩, _⟩ => ⟨x.2, e⟩

end Steps
end Becoming

namespace Becoming
namespace Steps

/-- A decided chain over a type inhabited exactly where `P`. -/
def rv_inhabited (P : Prop) : Nat → Nat × PLift P → Prop := fun n x => x.1 < n

/-- **Calibration of `found`, over every type**: the converse for every decided chain over every
type gives double-negation elimination, so excluded middle. -/
theorem rv_dne_of_converse
    (h : ∀ (X : Type) (Q : Nat → X → Prop), (∀ n x, Q n x ∨ ¬ Q n x) →
      «全生成» next (kept Q) (same Q) 0 → KeepsWideningFrom Q 0)
    (P : Prop) (nn : ¬ ¬ P) : P :=
  have dec : ∀ n x, rv_inhabited P n x ∨ ¬ rv_inhabited P n x := fun n x =>
    match Nat.decLt x.1 n with
    | isTrue lt => .inl lt
    | isFalse ge => .inr ge
  have generation : «全生成» next (kept (rv_inhabited P)) (same (rv_inhabited P)) 0 :=
    generation_iff.mpr ⟨buqiong_kept_iff.mpr fun _ _ _ lt => Nat.lt_succ_of_lt lt,
      generation_iff_begins.mpr fun y _ => ⟨y, Nat.le_refl y, begins_iff.mpr fun s =>
        nn fun p => Nat.lt_irrefl y ((s (y, ⟨p⟩)).mpr (Nat.lt_succ_self y))⟩⟩
  match (h (Nat × PLift P) (rv_inhabited P) dec generation).2 0 (Nat.le_refl 0) with
  | ⟨_, _, x, _, _⟩ => x.2.down

end Steps
end Becoming
```

### `Becoming/GWReviewRegions.lean`

```lean
import Becoming.MapRegions

namespace Becoming
namespace Map

/-- The line under the one along the steps reaches every later step. -/
theorem rv_reach_to : ∀ {z n : Nat}, z ≤ n → «所及» step «一» z n := by
  intro z n le
  induction le with
  | refl => exact .inl rfl
  | step _ ih => exact «所及之传递» ih (.inr (.one ⟨rfl, trivial⟩))

theorem rv_holds {S : Nat → Prop} (s₀ : S 0) (closed : ∀ z, S z → ∃ w, S w ∧ «续» step «一» z w) :
    ∀ m, S m := fun m => match step_reaches m with
  | .inl e => e ▸ s₀
  | .inr l => «单行则族含所及» (R := step) (L := «一») step_func closed s₀ l

/-- **生成 at the first step, for the class of a sequence, is changing at arbitrarily late steps.** -/
theorem rv_generates_iff (b : Nat → Bool) :
    «生成» step «一» (fun n m => b n = b m) 0 ↔ ∀ y, ∃ n, y ≤ n ∧ b n ≠ b (n + 1) :=
  ⟨fun ⟨S, s₀, closed, ahead⟩ y => match ahead y (rv_holds s₀ closed y) with
     | ⟨u, _, _, _, hu, c⟩ => ⟨u, step_reached_le hu, fun e =>
         c.2 ⟨u, c.1.1, Eq.subst (motive := fun v => b u = b v) c.1.1.symm e⟩⟩,
   fun changes => ⟨fun _ => True, trivial, fun z _ => ⟨z + 1, trivial, rfl, trivial⟩,
     fun z _ => match changes z with
       | ⟨n, le, ne⟩ => ⟨n, n + 1, trivial, trivial, rv_reach_to le, ⟨rfl, trivial⟩,
           fun ⟨w, hw, e⟩ => ne (Eq.subst (motive := fun k => b k = b (n + 1))
             (Nat.succ.inj hw).symm e)⟩⟩⟩

/-- **后守 at the first step, for the class of a sequence, is settling from some step.** -/
theorem rv_keepsAfter_iff (b : Nat → Bool) :
    «后守» step «一» (fun n m => b n = b m) 0 ↔ ∃ z, ∀ n, z ≤ n → b n = b (n + 1) :=
  ⟨fun ⟨S, s₀, closed, z, _, _, quiet⟩ => ⟨z, fun n le =>
     match decEq (b n) (b (n + 1)) with
     | isTrue e => e
     | isFalse ne => absurd ⟨⟨rfl, trivial⟩, fun ⟨w, hw, e⟩ => ne (Eq.subst
         (motive := fun k => b k = b (n + 1)) (Nat.succ.inj hw).symm e)⟩
         (quiet n (n + 1) (rv_holds s₀ closed n) (rv_holds s₀ closed (n + 1)) (rv_reach_to le))⟩,
   fun ⟨z, settles⟩ => ⟨fun _ => True, trivial, fun z _ => ⟨z + 1, trivial, rfl, trivial⟩,
     z, step_reaches z, trivial, fun u v _ _ hu c =>
       c.2 ⟨u, c.1.1, Eq.subst (motive := fun w => b u = b w) c.1.1.symm
         (settles u (step_reached_le hu))⟩⟩⟩

end Map
end Becoming

namespace Becoming
namespace Map

/-- **Deciding keeping from some point on alone, for one settling sequence, decides `p`.** -/
theorem rv_lpo_of_keepsAfter_decided (p : Nat → Bool)
    (decided : «后守» step «一» (fun n m => settling p n = settling p m) 0 ∨
      ¬ «后守» step «一» (fun n m => settling p n = settling p m) 0) :
    (∃ n, p n = true) ∨ ∀ n, p n = false :=
  match decided with
  | .inl k => match (rv_keepsAfter_iff (settling p)).mp k with
    | ⟨z, settles⟩ => .inl (match hs : seen p (z + 1) with
      | true => seen_witness hs
      | false =>
        have unseen : seen p z = false := match hz : seen p z with
          | true => Bool.noConfusion (hs.symm.trans (seen_succ hz))
          | false => rfl
        absurd ((settling_unseen unseen).symm.trans ((settles z (Nat.le_refl z)).trans
          (settling_unseen hs))) (turning_turns z))
  | .inr nk => .inr fun n => match hp : p n with
    | false => rfl
    | true => absurd ((rv_keepsAfter_iff (settling p)).mpr ⟨n, fun m le =>
        (settling_seen (seen_of_le (seen_of hp) le)).trans
          (settling_seen (seen_of_le (seen_of hp) (Nat.le_succ_of_le le))).symm⟩) nk

/-- The stated calibration follows, through the single line. -/
theorem rv_lpo_stated_from_weaker
    (decides : ∀ b : Nat → Bool,
      «生成» step «一» (fun n m => b n = b m) 0 ∨ «后守» step «一» (fun n m => b n = b m) 0)
    (p : Nat → Bool) : (∃ n, p n = true) ∨ ∀ n, p n = false :=
  rv_lpo_of_keepsAfter_decided p (match decides (settling p) with
    | .inl g => .inr fun k => «单行则生成后守不并» (R := step) (L := «一») step_func ⟨g, k⟩
    | .inr k => .inl k)

/-- Deciding generation alone, for one settling sequence, gives the weak form (WLPO). -/
theorem rv_wlpo_of_generates_decided (p : Nat → Bool)
    (decided : «生成» step «一» (fun n m => settling p n = settling p m) 0 ∨
      ¬ «生成» step «一» (fun n m => settling p n = settling p m) 0) :
    (∀ n, p n = false) ∨ ¬ ∀ n, p n = false :=
  match decided with
  | .inl g => .inl fun n => match hp : p n with
    | false => rfl
    | true => match (rv_generates_iff (settling p)).mp g n with
      | ⟨m, le, ne⟩ => absurd ((settling_seen (seen_of_le (seen_of hp) le)).trans
          (settling_seen (seen_of_le (seen_of hp) (Nat.le_succ_of_le le))).symm) ne
  | .inr ng => .inr fun never => ng ((rv_generates_iff (settling p)).mpr fun y =>
      have unseen : ∀ m, seen p m = false := fun m => match hs : seen p m with
        | true => match seen_witness hs with
          | ⟨k, hk⟩ => Bool.noConfusion (hk.symm.trans (never k))
        | false => rfl
      ⟨y, Nat.le_refl y, fun e => turning_turns y ((settling_unseen (unseen y)).symm.trans
        (e.trans (settling_unseen (unseen (y + 1)))))⟩)

end Map
end Becoming
```

### `Becoming/GWReviewMore.lean`

```lean
import Becoming.WideningOnTheMap
import Becoming.MapRegions

namespace Becoming

namespace Steps

variable {X : Type} {Q : Nat → X → Prop}

/-- Keeping widening from `T` is 07's chain form of the chain shifted by `T`. -/
theorem rv_keepsWideningFrom_iff_shift {T : Nat} :
    KeepsWideningFrom Q T ↔ Reaching.KeepsWidening (fun n => Q (T + n)) :=
  ⟨fun ⟨includes, opens⟩ =>
    ⟨fun n d x held => Eq.subst (motive := fun m => Q m x) (Nat.add_assoc T n d)
       (includes (T + n) (T + n + d) (Nat.le_add_right T n) (Nat.le_add_right _ d) x held),
     fun n => match opens (T + n) (Nat.le_add_right T n) with
       | ⟨_, later, x, held, before⟩ => match le_dest later with
         | ⟨d, at_⟩ => ⟨d, x, Eq.subst (motive := fun m => Q m x)
             (at_.trans (Nat.add_assoc T n d)) held, before⟩⟩,
   fun ⟨kept_on, opens⟩ =>
    ⟨fun S U from_ later x held => match le_dest from_, le_dest later with
       | ⟨n, atS⟩, ⟨d, atU⟩ =>
         have here : Q (T + n) x := Eq.subst (motive := fun m => Q m x) atS held
         Eq.subst (motive := fun m => Q m x)
           ((Nat.add_assoc T n d).symm.trans ((congrArg (· + d) atS).symm.trans atU.symm))
           (kept_on n d x here),
     fun S from_ => match le_dest from_ with
       | ⟨n, atS⟩ => match opens n with
         | ⟨d, x, now, before⟩ => ⟨S + d, Nat.le_add_right S d, x,
             Eq.subst (motive := fun m => Q m x)
               ((Nat.add_assoc T n d).symm.trans (congrArg (· + d) atS).symm) now,
             fun earlier => before (Eq.subst (motive := fun m => Q m x) atS earlier)⟩⟩⟩

end Steps

namespace Web

variable {F C : Type} {W : Web F C} {l : Nat → C → Nat} {T : Nat}

/-- The module's `keepsWidening_itself_iff`, derived from the landed `Web.keepsWidening_iff_chain`. -/
theorem rv_keepsWidening_itself_iff :
    W.KeepsWidening itself l T ↔ Steps.KeepsWideningFrom (fun t f => W.Admits (l t) t f) T :=
  Web.keepsWidening_iff_chain.trans (Steps.rv_keepsWideningFrom_iff_shift (Q := fun t f => W.Admits (l t) t f)).symm

end Web

namespace Map

/-- 后守 without the point reached from `x`. -/
def rv_keepsAfterAnywhere {α : Type} (R L E : «际» α) (x : α) : Prop :=
  ∃ S : α → Prop, S x ∧ (∀ z, S z → ∃ w, S w ∧ «续» R L z w) ∧
    ∃ z, S z ∧ ∀ u v, S u → S v → «所及» R L z u → ¬ «传» R L E u v

theorem rv_still_next {w : Branch} (h : fork .still w) : w = .still := by
  cases w
  · exact False.elim h
  · exact False.elim h
  · rfl

theorem rv_stays_still : ∀ {x y : Branch}, «相续» fork «一» x y → x = .still → y = .still := by
  intro x y l
  induction l with
  | one c => intro e; subst e; exact rv_still_next c.1
  | more c _ ih => intro e; subst e; exact ih (rv_still_next c.1)

def rv_side : Branch → Prop
  | .root => False
  | .chain _ => True
  | .still => True

/-- Without reach, the chain's first link keeps from some point on, by the still occurrence. -/
theorem rv_anywhere : rv_keepsAfterAnywhere fork «一» «静» (.chain 0) :=
  ⟨rv_side, trivial, fun z hz => match z, hz with
     | .chain n, _ => ⟨.chain (n + 1), trivial, rfl, trivial⟩
     | .still, _ => ⟨.still, trivial, trivial, trivial⟩,
   .still, trivial, fun u v _ _ hu c =>
     have atStill : u = .still := match hu with
       | .inl e => e.symm
       | .inr l => rv_stays_still l rfl
     match u, atStill, v, c with
     | .still, _, .still, ⟨_, hb⟩ => hb ⟨.still, trivial, rfl⟩
     | .still, _, .root, ⟨⟨r, _⟩, _⟩ => r
     | .still, _, .chain _, ⟨⟨r, _⟩, _⟩ => r⟩

/-- With reach, it does not: every point the chain reaches renews at once. -/
theorem rv_not_keepsAfter : ¬ «后守» fork «一» «静» (.chain 0) := by
  intro ⟨S, _, closed, z, hz, sz, quiet⟩
  have chainOf : ∀ {a b : Branch}, «相续» fork «一» a b → (∃ n, a = .chain n) → ∃ m, b = .chain m := by
    intro a b l
    induction l with
    | one c => intro ⟨n, e⟩; subst e; rename_i b' ; cases b' with
      | root => exact False.elim c.1
      | chain m => exact ⟨m, rfl⟩
      | still => exact False.elim c.1
    | more c _ ih => intro ⟨n, e⟩; subst e; rename_i y _ _; cases y with
      | root => exact False.elim c.1
      | chain m => exact ih ⟨m, rfl⟩
      | still => exact False.elim c.1
  have : ∃ m, z = .chain m := match hz with
    | .inl e => ⟨0, e.symm⟩
    | .inr l => chainOf l ⟨0, rfl⟩
  match this with
  | ⟨m, e⟩ =>
    subst e
    match closed _ sz with
    | ⟨w, sw, c⟩ =>
      have : w = .chain (m + 1) := by
        cases w with
        | root => exact False.elim c.1
        | chain k => exact congrArg Branch.chain c.1
        | still => exact False.elim c.1
      subst this
      exact quiet _ _ sz sw (.inl rfl) ⟨c, fork_chain_begins (m + 1)⟩

end Map

end Becoming
```

