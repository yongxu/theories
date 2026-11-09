# ZA-G1: readers' reports

AI-written. The reader is Claude Fable 5.1, an AI model other than the author's (Opus). It read cold and read-only, against the Lean, the two records, 07 §4.8 and the study note, with a brief that named what to look for (overclaim, underclaim, "read off the flow", the near-definitional label, the Chinese, the counterexamples) and gave no conclusion. No person's review is recorded.

## Round 1 (9 November 2026)

The reader's report, as returned:

> I have read everything the brief names: the module, both records (English and Chinese), 07 §4.8, the note, the definitions in Weightings, Significance, Frame, Feedback, Interdependence, Centers, MutualDependence, Boundaries, GrammarScope, Roles and the Clearing and Drawing witnesses, and the sibling G3 lemmas on branch `claude/unruffled-dirac-983955`. I checked each theorem statement against the proof terms and the definitions by hand; I did not build.
>
> Overall: the Lean statements say what the prose says, with the premises stated. Every quantifier and direction I checked (the 32 theorems; I count 32, as the note says) matches the text. The witnesses (Clearing, Drawing, Unexchanged) are described correctly against their Lean. "Near-definitional" is the right label; the one substantive step is the prior `Flow.exists_reachReturns`, and nothing is presented as new mathematics. The "read off the flow" claim is stated honestly in 07's "What is still supplied" list and the records' hypotheses. The Chinese matches the English in content throughout; I found no divergence.
>
> **High:** none.
>
> **Medium**
>
> 1. Record `standpoints-read-off-a-flow`, `statement.en`: "Held de se along affecting, the continuation condition is mutual dependence whether every formation is a standpoint or only those whose acts return". The "every formation" half is `Flow.mutuallyDependent_iff_unrestricted`, which is on the G3 branch, not in this tree, and in none of this record's laws, declarations or dependencies. The returning half's "exactly" (mutual dependence → the condition at the returning formations) is also not a named theorem here; it is one line from `ownClosure_unrestricted_atReturning_iff` and `mutuallyDependent_iff_reach`, as `Drawing.returning_feeding_apart` does inline. Fix: either add the one-line iff at the returning formations to the module and cite it in law 2, and reword the statement to "…is mutual dependence at the formations whose acts return, given one, as route (b)'s joining lemma gives it with every formation a standpoint", or add the G3 record as a dependency once it lands. The same applies to the module docstring (bullets 1 and 3), which names `Flow.mutuallyDependent_iff_unrestricted` and `Flow.unrestricted_of_mutuallyDependent` in backticks though the module cannot see them; mark them "(G3's, not imported here)" so a reader does not look for them in this build.
> 2. 07 §4.8, first theorem: "On a flow, held de se along affecting at the formations whose acts return, it holds only where the flow is mutually dependent (`Flow.mutuallyDependent_of_returning_unrestricted`…)". The Lean takes `some : ∃ c, ReachReturns c`; without it the condition holds vacuously on a flow with no returning formation (an infinite chain), which need not be mutually dependent. The sentence before has "given one" for the generic law and the sentence after has it for the iff, but this one does not. Fix: "…it holds, given one of them, only where the flow is mutually dependent".
> 3. Both records, `validation_scope` and `history`: "one AI reader of another model read the statements against this record and the home section, cold, for overclaim (READER in the study folder)". The study folder holds only NOTE.md, whose §7 reads "(Below, once read.)". The record asserts a reading that has not happened at the time it was written. Fix: put this report in the folder as READER (or under §7) and set the record's wording to what was read, before landing.
>
> **Low**
>
> 4. Record 1, `does_not_show[1]` (witness `Clearing.returning_apart`) and 07's covering theorem: "There the two readings of the standpoints part, since with every formation a standpoint the condition along being affected is mutual dependence." `returning_apart` proves the returning reading holds along being affected, the clearer-as-one-center reading fails, and the flow is not mutually dependent. That the every-formation reading fails is G3's `Clearing.not_unrestricted_ownClosure`, or one line from `ownClosure_unrestricted_iff` and `¬ MutuallyDependent`; the note §4 says exactly this, the record and 07 do not. Fix: in 07 add "(`ownClosure_unrestricted_iff` with `shares_not_mutual`)" or cite G3; in the record's witness detail say the second half is immediate from the fifth conjunct.
> 5. 07 §4.8, "What is now read off the flow": "given one formation whose acts return, which finitely many formations give". `exists_reachReturns` also needs reach decided; the record's hypothesis says so. Fix: "which finitely many formations with reach decided give".
> 6. 07 §4.8: "Moving the inputs into definitions does not discharge them (`[08 §12](08-METHOD.md#the-work-by-its-own-laws)`)". (The link is printed as code here, AI-authored note, so that it is not read as a live link of this page.) The sentence cited ("Calling an input immanent, or moving it into a definition, does not discharge it") is §12's opening paragraph under `#open-programme`; `#the-work-by-its-own-laws` is a later paragraph in that section. Fix: link `#open-programme`.
> 7. Record 1, `dependencies`: the `where-a-formations-acts-return` detail names `Flow.InOneLoop`, which FlowCenters does not use; `Clearing.centers_retain_yet_loses` (used by `returning_loses_dweller`) is not named under `what-the-step-across-standpoints-reaches`. Fix: drop InOneLoop, add centers_retain_yet_loses.
> 8. Record 1, `correspondence`: "a bottom class of the reach preorder" (zh 底类). Whether a sink component is bottom or top depends on the preorder's orientation. Fix: "a sink (terminal) component: a class with no arc leaving it".
> 9. Record 2, law 3 and `Flow.covering_of_acting`'s docstring: "every formation that takes part". Feedback.lean defines `TakesPart g c := DependsOn g c ∨ Exchanges g c`, and `Exchanges` itself uses "takes part" for `h ∈ L.present t`. The Lean subtype is `∃ c, L.Exchanges f c`. Fix: "every formation that exchanges with some condition".
> 10. NOTE.md §3, table row "returning and bearing on themselves": "as above, given one" in both condition columns. Nothing in Lean states these; the affecting column follows from `ReturnsAlong.whole` by the same argument, but the being-affected iff's backward direction needs covering by self-bearing returning formations, which fails in general (Unexchanged has none). Fix: write "forward direction only; the iff would need covering, which fails" or "not proved".
> 11. NOTE.md §4: "Covering holds along being affected (`Flow.covered_by_returning`)". Omits "on finitely many formations with reach decided". Fix: add it.
> 12. Module docstring, last bullet: "that reading has no standpoint and covers nothing". `Unexchanged.apart` proves no formation is self-bearing; "covers nothing" is immediate (two formations, no standpoints) but not stated. Fix: "and so, with two formations, covers nothing" or leave as is, labelled a consequence.
>
> **(e) Chinese:** no content error found. Renderings checked in particular: 自依 for `SelfBearing` (law 6, counterexample 3), 底类 (see 8, shared with the English), 所为回返 for `ReachReturns`, 同处一环 for the pairwise `WithinReach` iff, 强于彼此依存 (law 3), and the hypotheses' 构成有限且所及可判定时即有.
>
> **(f) Counterexamples against their Lean:** all correct. Clearing: the dweller exchanges with nothing, so it returns vacuously; the clearer reaches the dweller, which cannot reach it; the source reaches the clearer, which cannot reach it; the dweller's influence closure is the whole via the habitat and the resource; the clearer's excludes the dweller (`levels.2.1`). Drawing: `requires f c := f = c`, `take 0 true false = 1`, so "each taking from what the other depends on" is right. Unexchanged: `requires := False` gives `¬ SelfBearing`; `take = give = 0` gives no affecting.
>
> **(c) and (d):** stated honestly. The section says the relation choice, the standpoint reading, the class, the own-closure reading and finiteness are still supplied; the records' hypotheses and does_not_show say the same. "Near-definitional" fits: each law is a few lines over the closure laws plus the existing `exists_reachReturns`; `returning_influence_unrestricted_iff` is the longest and still a direct composition.

### What the author did with round 1

| # | Taken? | What changed |
|---|---|---|
| 1 | yes | `Flow.returning_unrestricted_iff_mutuallyDependent` added (the first law with `mutuallyDependent_iff_reach`) and cited in law 2; the statement now reads "at the formations whose acts return, given one, … exactly mutual dependence, as it is with every formation a standpoint"; G3's names in the module marked "not imported here". |
| 2 | yes | 07: "given one of them" added; the sentence now cites the iff and says which direction is new. |
| 3 | yes | This file; the records' wording says the reader read the statements and then the corrections. |
| 4 | yes | 07 adds that in `Clearing` the every-formation reading fails (`ownClosure_unrestricted_iff` with `Clearing.shares_not_mutual`); the record's does-not-show line names the parting in `Clearing`. |
| 5 | yes | "with reach decided" added. |
| 6 | yes | Linked `#open-programme`. |
| 7 | yes, changed | `Flow.InOneLoop` dropped. `Clearing.centers_retain_yet_loses` is no longer used: before the report arrived, `Clearing.returning_loses_dweller` was tightened to compare one reading (significance held de se along being affected) at the two centers, so that the verdict changes with the center alone. It now uses `Web.retains_bounded_iff` and `Clearing.loses_beyond`, and the dependencies name them. |
| 8 | yes | "a sink component: no arc leaves it" (汇点分支), in both records. |
| 9 | yes | "every formation that exchanges with some condition", in the Lean, the record and 07. |
| 10 | yes | The note's table says "not proved here" for that row. |
| 11 | yes | Added. |
| 12 | yes | "there being formations, covers none of them". |

## Round 2 (9 November 2026)

The same reader read the corrections (`git diff 56964d2c1 5ef2eac33`) and the Lean they compose. Its findings, in short (AI-written summary of the report; the reader's words are quoted where it matters):

- The new `Flow.returning_unrestricted_iff_mutuallyDependent` is correct, and is stated everywhere with "given one" and with its forward direction named as the new one.
- `Clearing.returning_loses_dweller` is correct. On "the verdict changes with the center alone" the reader wrote: "Yes. Both conjuncts use the same content (own closure along being affected, held de se); only the center changes". It also noted, as a nuance the prose need not add, that the two standpoint types differ (`Unit` and `Returning`), while the content function is one.
- Every round-1 finding is fixed; finding 7 is fixed differently, with the new dependencies' records checked.
- **High:** nothing. **Medium:** nothing.
- **Low**, all taken:
  - the note said 32 theorems where the module now has 33;
  - "by the joining lemma" stood for an iff whose other direction is G3's `Flow.mutuallyDependent_iff_unrestricted` (or one line from `ownClosure_unrestricted_iff`), and 07 now names both;
  - the module docstring's last bullet kept "takes part" where every other place says "takes from its resource".
- The Chinese of the changed sentences matches the English.

No round 3: round 2 had no high or medium finding.

## A later reading: astra, of route (b)'s join (9 November 2026)

After the landing, the session that joins route (b)'s pieces had astra (an AI model, through Codex) read the join, read-only. Three of its items concern G1's texts; in the author's words (AI-written):

1. That finitely many formations with reach decided give a returning formation needs a formation to start from (`Flow.exists_reachReturns` starts from a supplied one); on an empty carrier there is none. The module docstring, 07 §4.8, the first record's hypothesis, this folder's note and the hand-over said it without that. All now say "wherever there is a formation".
2. The shared notes (INTERFACES) still said 32 theorems and that G1 does not state the converse. Both were already out of date when read. They now say 33 theorems and name `Flow.returning_unrestricted_iff_mutuallyDependent`.
3. Covering from activity covers the formations that exchange with some condition (`∃ c, L.Exchanges g c`), not every formation. The docstring, 07, the second record's law and the note now say so.

Its suggestion to place the generic `ReturnsAlong` below `Becoming.Centers`, and the mutual-dependence adapters below both route (b) modules, is for the joining (board rule 9).
