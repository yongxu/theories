# K2: the readers' rounds (AI-written record, 10 November 2026)

Cold readers of another model, as round K's rules ask (Ren, 10 November 2026: complex decisions and the verdict a landing rests on read by Fable; one model per agent; stop at the first round with no high or medium finding). Each reader read only, with no build or test run. Findings are summarized here; their full texts are in the session that ran them.

## Round 1: the design (Claude Fable 5.1, before the Lean)

Read [DESIGN.md](DESIGN.md) as first written against the brief, 02 §9, 07 §4.12, AJ's plan §1 and the Lean of Pace, RuleCapture, ClosedCapture, RuleShaping, PoolCourse and ReadingsPersist. Eleven findings: 2 high, 6 medium, 3 low. Verdict: the laws sound as compositions, the design answering a smaller question than it claimed.

| # | Severity | Finding | Taken |
|---|---|---|---|
| 1 | high | The readers were removed by a loss growing one a step whatever the selection did: removal by the clock, so the loop the brief asks for (removal read off the selection's own course) is not shown; AJ's gap moved to `K`, not filled. | Yes: the loss is drawn off the course (`fB (x, b) g`); the loop law `window_order_kept`; the witness `Drained` contrasts the clock with a drain read off the share. The clock design is kept as a failure in DESIGN.md. |
| 2 | high | A2's "the exits, exactly" overclaims: the contrapositive gives necessity somewhere in a stretch, not the step of leaving; `Borne` shows the fall and the leaving apart. | Yes: "left only along a stretch containing …", "the fall and the leaving can be steps apart"; a counterexample entry in the record. |
| 3 | medium | `K = 3` is locked the other way from step 3, not 4. | Moot (the clock family is not built); every step number now comes from a Lean theorem. |
| 4 | medium | `Alternating` cannot be reused for a start at (⟨8,4⟩, lo); generalize it in RuleCapture (rule 9). | Moot: the clock family is not built. |
| 5 | medium | The A2 proof route through a two-point order cannot restrict `turn_locked`'s ∀s; put a pointwise lemma in RuleCapture below `turn_locked`. | Not taken, with the reason (DESIGN.md, revision): with `S := Bool` and the order pulled back along `false ↦ x`, `true ↦ y`, `Raises` quantifies over the two points and holds by the step's `P.le x y`, and `ReadsShare` is the share-readers' reading's, monotone everywhere by hypothesis; the actual reading enters only by agreement at the step. It compiled (`turn_locked_at`). RuleCapture is not edited. |
| 6 | medium | The window used a single reader's rule, not MA2's pool; Thinned's laws do not apply inside it. | In part: `windowRead` is generic, and `window_standing_thinned` proves that with MA2's pools it is `Thinned.lossPool` while the readers stand; the witness uses the threshold reading for computability, as RuleCapture's witnesses do; "weight read off the loss" became "presence read off the loss". |
| 7 | medium | "The loop closed" (A3) is "stays closed"; its premises unlisted. | Yes: `closed_stays_closed`, premises in the record and 02 §10. |
| 8 | medium | The selection is not shown to prefer the removal; suggested a comparison across `K`, the share not lower where the readers are removed sooner. | Yes: `window_order_kept` (share, loss and rule ordered with the bound reversed); "not shown: a preference beyond this order, an optimizer" in the record. |
| 9 | low | `bear`'s convention to be said; `Borne`'s steps stated. | Yes. |
| 10 | low | `NotReadmitted` is not `RecruitsThrough` read on presence; "K unbounded" is not a value; "refines T7" reworded; no trichotomy. | Yes: "an analogue … supplied"; Thinned tied by a lemma; T7's way out "does not leave" on the disfavoured side; three computed outcomes not claimed as a law (and not built). |
| 11 | low | Presence drops how many and which lines; K1's interface unused. | Said in the records and the note; K1's lines are the next delta. |

## Round 2: the statements (Claude Fable 5.1, after the Lean)

(below)
