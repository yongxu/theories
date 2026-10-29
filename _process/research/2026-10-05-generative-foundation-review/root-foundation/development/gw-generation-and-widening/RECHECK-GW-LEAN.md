# GW3–GW5 Lean: re-check of the review's findings

AI re-check, 29 October 2026, Claude Opus 5.5 (`claude-opus-5-5`). Read-only, except for this file. It re-checks [REVIEW-GW-LEAN.md](REVIEW-GW-LEAN.md) against the fixes in `git diff 2baa5ef61 2ce13d0d1`, which changes KeepingWidening, HeldPossible, MapInstances, PatternPassing and [NOTE.md](NOTE.md); NOTE §§15–16 were read in full. The worktree's KeepingWidening matches `2ce13d0d1`. The clean build of 341 modules, the empty axiom reports and the unchanged earlier statements were taken as given.

One scratch theorem, built against `2ce13d0d1` with `scratch_build.py` in the session scratchpad (nothing in the repository), has an empty axiom report:

```lean
theorem KindRelay.Fed.requirements_not_dissipated :
    ¬ ∃ (all : List (Form ⊕ Nat)) (T₀ : Nat), (∀ t f c, web.requires t f c → c ∈ all) ∧
      ∀ t, T₀ ≤ t → flow.DissipatesOn all t :=
  fun ⟨_, T₀, required, dissipates⟩ =>
    Flow.not_keepsWidening_of_dissipated_requirements balances acting dependent unloosened
      required dissipates (R := web.withinKind sameKind (flow.PassesSupport web))
      (fun _ _ s => .inl ⟨rfl, s⟩) T₀ (Web.KeepsWidening.later (Nat.zero_le T₀) keeps_widening)
```

Lean paths are relative to `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`; KW is `KeepingWidening.lean`. Line numbers are at `2ce13d0d1`.

## Findings

No high finding. Every one of the 20 review findings was taken as asked. One medium finding is new, in the corrected note text.

| # | Sev. | Location | Finding | Suggested fix |
|---|---|---|---|---|
| 1 | medium | NOTE:157 (§3.4, last paragraph), NOTE:275 (§7, the bullet for AJ5's page), NOTE:29 (§1 item 3, last sentence) | The corrected need is not exact. The Lean premise is *a list* holding every condition any formation requires, dissipated on from some step. Its failure has three forms, and the text names two: "supplied from beyond the family of requirements, or exchanging beyond it without loss to it". It omits the case where **no finite family holds what the formations require**, so that requirements spread to ever-new conditions. That is the route of novelty (`Flow.new_beyond_every`), which matters most on AJ5's page. NOTE:29 also says "Where what is required is dissipated on, both need what lies beyond it". Where it is dissipated on, the law says neither holds, whatever lies beyond, so the sentence inverts the conditional. | §3.4 and §7: "both need that no finite family holding what the formations require is dissipated on from some step: what is required lies in no finite family, is supplied from beyond such a family, or is exchanged beyond it without loss to it." §1 item 3: "Where a finite family holding what is required is dissipated on, neither holds; both need what lies beyond such a family." |
| 2 | low | KW:178–180; NOTE §16 row 12 ("escapes them because its requirements conserve, which `Fed.conserving_on_part` states") | "The laws for dissipated requirements do not apply to it" is asserted but not proved. `conserving_on_part` covers only the six-condition list. A list that adds some fuel conditions dissipates at the steps whose fuel it holds, and fails only beyond them. So conservation is half the reason, and the finiteness of lists is the other half. The scratch `Fed.requirements_not_dissipated` above proves the whole claim in one line from the law and `Fed.keeps_widening`. | Add that theorem, cite it in KW:178–180, and in §16 row 12 say "because its requirements conserve and a list holds the fuel of only finitely many steps (`Fed.requirements_not_dissipated`)". |
| 3 | low | KW:171–172 | `KindRelay.Runs.not_keepsWidening_supportedItself, .not_keepsWidening_supportedPassing, .not_keepsWidening_dormant` reads as `Runs.*`. No `Runs.not_keepsWidening_supportedPassing` or `Runs.not_keepsWidening_dormant` exists. The declarations are `KindRelay.*` and `KindRelay.Fed.*`, and `Runs` has `not_keepsOpening_dormant`. | Write the full names (`KindRelay.not_keepsWidening_supportedPassing`, `KindRelay.not_keepsWidening_dormant`), or cite `Runs.not_keepsOpening_dormant`. |
| 4 | low | KW:2494–2497 | "It also meets the premises of the finite-whole law …, which `Flow.whole_not_keepsWidening` turns into the same exclusion." That application was the checked proof at `71a83ec27`. It is now an unchecked claim in prose, though each premise is a theorem. | Keep it checked in a three-line `not_keepsWidening_byName_of_whole` (the old proof), or write "would turn". |
| 5 | low | KW:1112; NOTE:259; NOTE:30 | Stale labels. KW:1112's section header still reads "Under dissipation a finite world has neither", but the laws under it now take dissipated requirements. NOTE §7's bullet ends "(§3.4, argued)", which is now Lean. §1 item 4 keeps "[hand check; planned Lean]" while item 3 beside it was relabelled "[Lean, §15]". The header (NOTE:3) does explain the planned marks. | Retitle KW:1112 "Where what is required is dissipated on, neither". Change "(§3.4, argued)" to "(§3.4; Lean, §15)". Relabel item 4 as item 3 was. |
| 6 | low | NOTE:29 | §1 item 3 states the opening half ("along any reading containing carrying on of the supported, nothing keeps opening") without the four premises of the descent law, which `not_keepsOpening_of_dissipated_requirements` takes. The 全生成 half needs only balance on the list. | Add "under the four premises of the descent law" to the opening half. |
| 7 | low | NOTE:136–139 (§3.3) | That 全生成 along `withinKind Q` at (activity, one formation) "is" `«阶全生成» P Es 0` remains argued in general. The Lean proves both forms on the relay (`Runs.generation`, `Runs.generation_order_zero`), not their equivalence. The equivalence holds, for reflexive `Q` from supported occurrences, by lifting `withinKind_cont_iff` and `withinKind_begins_iff` along lines. | Mark it "[argued]", or add `Web.withinKind_generation_iff`. |
| 8 | low | KW:1976–1977 (`total_eq_of_supports`) | The choice is sound (see below). The pending move, though, is recorded only as process text in a Lean docstring ("to move there at the next full rebuild"), which will go stale. `KindRelay.inside`, which review finding 13 also named, is not mentioned in §16. It is acceptable where it is, since it fixes `F = Form`. | Record the move on GW's board row or in the next-full-rebuild list, and keep the docstring to what the lemma states. Mention `inside` in §16 row 13. |

## Checked and found sound

- **1.** `Web.kindGrains` gives carrier, kind and activity at 0, 1 and 2+. `Runs.generation_order_zero` is `«全生成» P K C`, and `Runs.generation_two_orders` is `«阶全生成» P (kindGrains …) 0 ∧ … 1` by definition. The two orders are now on one relation. `Web.generation_of_one_step_supports` (any class `L` finer than activity) is correct: `supported_along` carries support along `L`-lines, and the step's end arises.
- **2.** The two general lemmas are in MapInstances (section variables `W`, `R`). `itself_carries_nothing` and `itself_not_generation` are derived, with statements unchanged, and `supportedItself_not_generation` is an instance at `W.admitting W.level`. The revised NOTE §4 sentence is exact.
- **3.** `Runs.begins_dormant` reduces freshness along the dormant reading to `not_into`. This is valid because a dormant step into `c` counts only from a supported giver, which is a `withinKind` step. `beginnings_without_opening` gives the beginnings outright, not up to double negation, and the dormant reading contains carrying on of the supported, so it is a genuine converse failure of `begins_late_of_keepsOpening`.
- **4.**
  - Fed's `draws` is `x = .inl f ∨ x = .inr s`, which leaves `Supported` and `Unloosened` untouched. `Fed.taking` is correct, and so is `Fed.conserving_on_part` (`total_map` with `part_conserves`).
  - The fed relay's reading in NOTE §1 item 4, §6 ("What the part does") and KW:173–180 and KW:2525 is exact: the fuel is drawn on and required by none, the part's required conditions conserve, deleting the fuel gives back the closed relay, and `Dissipative` as stated does not by itself exclude the two holding together. It is not a part sustained by supply from beyond.
- **5, 8, 9, 10.** The headline and bullets, the Standing paragraph, the citation of `gain_carried` and "On names and on passing of support" are fixed as asked. The Readings paragraph now confines "one grain up" to the kind relay.
- **6.** `begun_of_exceedsAcross` carries the apartness conjunct. The statement was new on the branch, so no landed statement changed.
- **7.** `BeginsAlong.iff_begins` is correct in both directions and matches its docstring.
- **11, 12.**
  - The renames are made. The `…_of_dissipated_requirements` laws take `required : ∀ t f c, requires t f c → c ∈ all`, which is strictly weaker than the old `every`, and `PassesSupport.takes` now needs only the gainer's requirements.
  - A finite closed world under `Dissipative` (with the list without repetition, so closed at every step) meets the premise, so the new laws cover the old ones.
- **13.** `Bool.not_not`, `ListTests.false_of_not` and `distinct_map_on` are used. `odd_of_next_even` is a parity-specific helper with no twin in scope.
  - **The `total_eq_of_supports` choice is sound.** It sits at `Becoming.total_eq_of_supports` in a leaf module, and only KeepingWidening uses it. Moving it into Dissipation later keeps its name and statement, and so changes nothing for its user, while moving it now would recompile 264 modules (counted from the import graph, 265 with `Becoming.lean`).
  - No twin exists: `Listing.total_eq_of_same` needs equal membership, and `SelectionLevels.total_eq_of_mem` needs pointwise equality. A later collision with a same-named upstream lemma would fail the build, not pass silently.
- **14.** `Web.begins_of_arises` in PatternPassing is general in `V` and `R`, and the forward half of `arises_iff_sheng_carrier` is derived. `begins_of_gains` is gone; it was new on the branch.
- **15, 16.** `Run.generation_of_held_changes` needs no decidedness, and `RaisedRule.generation` and `Oscillating.generation` are its cases. The wrapper `generation_with_both` was removed; it was new on the branch, so no landed statement was removed. The HeldPossible docstrings cite what exists.
- **17.** `Runs.not_includes_within_itself` is correct: some formation is supported at every step, and a one-step link along a continuation within `itself` keeps the formation, which brevity refutes. It gives the by-name and carrying-on-while-supported exclusions for both relays. `Fed.not_keepsWidening_byName` now exists.
- **18.** KW:160–162 and NOTE §15 say that `Q` is chosen with the witness and that the openings are the passings across kinds.
- **19, 20.** `KindRelay.taking` (with `takes_own`), `Runs.not_keepsWidening_supportedItself`, NOTE §6's "Not met" line, and `local instance` are fixed as asked.
- NOTE §15's figures that I could check hold: MapInstances has 2 modules downstream and PatternPassing 3, counting `Becoming.lean` (so "one or two" excludes it), and Dissipation has 264 without it. I did not recount the declaration totals.

## High and medium findings

There is no high finding. The one medium finding (1) is in the corrected note, not the Lean. NOTE §3.4 and §7 (the bullet meant for AJ5's page) give only two ways out of the dissipation law: supply from beyond, or loss-free exchange beyond the family of requirements. They omit the third, that no finite family holds what the formations require, which is the route of novelty. §1 item 3's last sentence inverts the law's conditional. The fed relay's own reading is exact. Making its "the laws do not apply" a theorem takes one line (finding 2).
