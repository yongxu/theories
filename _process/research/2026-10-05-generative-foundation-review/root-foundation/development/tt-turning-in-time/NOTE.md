# TT: turning in time (AI-written, Claude Opus 5.5 from Fable's plan, design and log, 13 November 2026)

Board item TT, claimed on main `372705add` and widened on `3582ee38c`. Ren's words of 12 November 2026, kept in [sources](../../../../../../sources/15-codex-theory-conversations/2026-11-12-where-we-are-and-the-loop.md): "Yes, go on", "Yes, build on it", and at 22:23 "alright - keep moving … no need to stop before fully done. if we need new lean proofs, add them, if we need to reorganize, reorganize". Lean: seven laws added to `Becoming.GrammarPath`, the new modules `Becoming.GuardedStep` and `Becoming.TurningInTime`. Home: [02 §11](../../../../../../theories/becoming/chapters/02-MAP.md#turning-in-time), anchors [`r-going-alike-up-to-the-nets-end`](../../../../../../theories/becoming/chapters/02-MAP.md#r-going-alike-up-to-the-nets-end) and [`r-turning-in-time`](../../../../../../theories/becoming/chapters/02-MAP.md#r-turning-in-time). Records `going-alike-up-to-the-nets-end` and `turning-in-time`.

```text
Result(s): what-a-line-holds-and-a-regularity-takes-in, constancy-read-at-a-members-class (GrammarPath:
  «至终有常», «本类至终有常», «亡而网续则不至终有常», «出类不随则本类不至终有常»); shared-laws-on-the-grammar
  («同行», «同行之逐点», «同行之迭», «局定后则有常当且仅当同行可续»); what-the-net-fixes-of-ones-own-class
  («类闭则本类常闭»); re-optimizing-above-a-renewal-ends-it (Optimum's level laws); margin-of-a-regime and
  regime-point-under-adjusting-giving (RegimeMargin); rules-that-change-themselves-in-the-grammar, closed-capture,
  capture-through-the-rule, the-lock-draws-its-readers-out (ClosedCapture's joined two-level step, RuleCapture's
  Locked, PoolFromCourse's windowRead);
  when-a-selection-read-off-continuation-reads (first_of_decided).
Delta: the root's two names for one gap tied (with the successor fixed, constancy up to the net's end is going
  alike with it decided whether the next conditions anything; constancy is constancy up to the net's end with a
  next; a witness that the fixed successor cannot be dropped); a law's step cut where it cannot go on
  (Law.stepWhile), on which a line can end where the net ends, tied to the whole step and to the package's guarded
  history; a pair of a way and a level cut by a need (TurningInTime): which differences of level make a difference,
  ending where the net ends, the split at the first marked level of the course as it was, the fate after it by
  RegimeMargin's point of no return, the kind's line ending while the net goes on, ClosedCapture's joined two-level
  step and PoolFromCourse's course through windowRead read as courses of the pair at a need of nothing; a witness
  of three courses.
Supplied premises / correspondence: the marked levels and alone (AloneOutside); the kept kind kept at every step,
  a way after a marked step of it, one standing use; the level's step RegimeMargin.step giving (use w) with one
  giving; Meets, Keeps, within, high; the course as it was coming below the need; decided marks; a given way for
  constant_iff_needs_nothing. The reading of the centre and the near work are AI readings (02 §11, NEAR-WORK.md).
Evidence: scratch builds of 12 and 13 November 2026, every axiom report empty and no warning: GrammarPath 108
  theorems (seven added, nothing else changed but header sentences), its six dependents rebuilt clean;
  GuardedStep one definition and 13 theorems; TurningInTime 32 theorems and 12 definitions (44 public
  declarations). The core run's receipt at landing.
Boundary: nothing derives how what brings a level's difference to a way comes to stand, or that it stands on that
  level; RuleCapture's and ClosedCapture's models have a total step, so in them no line ends where the net ends;
  ReadOffInTime's laws are not joined; ClosedCapture's and PoolFromCourse's own-loop laws keep their own proofs;
  TurningInTime lies in the second layer only through OwnClass and ReadOffInTime; nothing about a trained system.
Integration: 02 §11 after §10; the three GrammarPath records re-pointed to the core run; regions, the Lean README
  rows, the checker's CORE entry and SCOPE paragraphs, the root's imports and bullets (the registration, written
  apart from this note).
```

## What is proved

The laws are listed with their declarations in the two records; this is the shape, marked substantive or near-definitional.

1. **The tie in the root** (`Becoming.GrammarPath`, after `«有常则至终有常»`; near-definitional, short). `«至终有常局定后则同行»`, `«同行可决则至终有常»`, `«至终有常则可决»`, `«局定后则至终有常当且仅当同行可决»`: with the successor fixed where the class leads, constancy up to the net's end is going alike with it decided, of whatever the class leads to from an occurrence that conditions something, whether that one conditions anything. `«至终有常可续则有常»`, `«有常当且仅当至终有常可续»`: with no premise, constancy is constancy up to the net's end with a next where the class leads. `«后不定则至终有常可不同行»`: the fixed successor cannot be dropped. That GrammarLaws' `«局定后则有常当且仅当同行可续»` follows from the fourth and sixth is said in the header and not checked in Lean; its proof there is its own.
2. **The cut step** (`Becoming.GuardedStep`; near-definitional). `Law.stepWhile can next` relates `s` to `next s` where `can s`, and `s` to nothing elsewhere. Tied to the whole step (`stepWhile_step`, `stepWhile_always`, `stepWhile_fixed`, `stepWhile_continues_iff`); from the whole step's laws through the tie (`stepWhile_hasSucc_iff`, `stepWhile_unending_iff` with one private transfer); on the orbit by its own induction (`stepWhile_steps_iff`); pointwise (`stepWhile_none_iff`, `stepWhile_goesAlike_iff`, `stepWhile_constant_iff`); `stepWhile_toEnd_iff` from the tie, where `can` is decided, and `stepWhile_toEnd_decides`, the witness that the decision cannot be dropped; `stepWhile_guarded_iff`, the tie to `Viability.guardedHistory` by `Lasting.guarded_upto_iff`.
3. **Which differences of level make a difference** (`Becoming.TurningInTime`, section 2; short, substantive in what it names). `toEnd_iff`, `constant_iff`, `constant_iff_needs_nothing`, `constant_adaptive`, `kind_toEnd_of_unmarked`, `toEnd_of_unmarked`, `unmarked_interval_iff`, `core_apart_below_need`.
4. **The course as it was** (section 3; short inductions). `agrees_until_marked`, `asItWas_way`, `alike_along`.
5. **Ending where the net ends** (section 4; compositions). `ends_with_net` by `Optimum.ends_within` and `first_of_decided`; `regime_step_eq`; `ends_with_net_regime` through a private `regime_levels` (a joint induction with `Optimum.never_rises`).
6. **Turning in time** (section 5; the substantive part). `unending_iff_first_marked` (the split at the first marked level), `unending_iff_above` (by `RegimeMargin.ends_iff_below` and `RegimeMargin.holds`), `turns_in_time_iff` (the two composed: the marks carry weight in it), `kind_ends_while_net_goes`, `kind_not_toEnd_of_turn` (by `«出类不随则本类不至终有常»`).
7. **ClosedCapture's joined two-level step and PoolFromCourse's course through `windowRead` as courses of the pair** (section 6; identifications). `locked_closed`, `locked_at_class` (by `«类闭则本类常闭»`), `windowRegroup`, `windowAfter`, `windowLeft`, `windowAlone`, `window_is_pair`, `join_is_asItWas`, `window_alone_outside`, `window_agrees_until_marked` (from `agrees_until_marked`, not a new induction), `window_paced`.
8. **Three courses from one start** (`Three`; computed). `Three.goes_on`, `Three.turned_and_ends`, `Three.line_ends_while_net_goes`, `Three.ends_as_it_was`, on `Three.giving`, `Three.use`, `Three.left`, `Three.after`.

## How the item went

From the plan's log (`drafts/PLAN.md`), times WIB, 12 and 13 November 2026.

- **Before the plan.** On 12 November four AI agents (an alignment researcher, a systems thinker, a philosopher, a reader of the formal structure) read the whole core from one side each (`where-we-are/`). The statement of the centre was redrafted twice (`drafts/THE-LOOP-v1.md`, `drafts/THE-LOOP.md`, each written apart in Chinese), with a count of why the language drifts (`drafts/WHY-THE-LANGUAGE-DRIFTS.md`), Ren's eight doubts answered (`drafts/EIGHT-DOUBTS.md`), a table from the centre's statements to the root's terms (`drafts/LEAN-TO-ROOT.md`) and wording prepared for his read (`drafts/FOR-RENS-READ.md`).
- **A first attempt, held.** A scratch `TurningInTime` (46 theorems, no axioms) was read cold by another AI agent (`readers/lean-reader-1.md`): no false statement, but its grammar section restated root laws, docstrings left out premises, a heading named a threshold the theorem does not give, and the marks carried nothing in the exact condition. It was held, and is kept as `held/TurningInTime-first-attempt.lean.txt`.
- **Planned** at 22:30 (`drafts/PLAN.md`): what "fully done" is, a test for every move, who does what.
- **Mapped** from 22:35 to 22:58 by eighteen AI agents (`map/`): the root already has both ways a line ends; `ClosedCapture.lockedAlike` and `lock_line` already read the capture modules on the grammar; every course of those modules is endless; the level's laws exist with a changing draw; no law had a next only where a condition holds; the landing checklist (`map/landing.md`).
- **Designed** at 23:00 (`DESIGN.md`): three things missing and only three, the tie, the cut step, the pair cut by a need; nothing renamed; RegimeMargin, Optimum, ClosedCapture and GrammarLaws untouched.
- **Implemented, round 1** (23:02 to 23:35): three AI implementers (the tie and the cut step; the pair's laws; the section on the joined step), then three AI agents read the result cold, for statements, duplicates and conformance (`readers/v1-statements.md`, `v2-duplicates.md`, `v3-conformance.md`).
- **Round 2** (`DESIGN-R2.md`, 23:35 to 00:03): two AI implementers made the changes; two AI agents read it cold (`readers/v4-statements.md`, `v5-duplicates-conformance.md`); the coordinating session (Fable) read all three files and made the last fixes by hand and built them. The plan allows no third round; what was left open is in `READER.md`.
- **Near work** (`NEAR-WORK.md`), in two passes beside the design.
- **Texts** (13 November): the home section by Fable; the records, this folder and the fill kit by an AI agent from the landing checklist.

## The follow-up, in the same landing

After the first gate run was started, one law was added and one name changed, by one AI implementer and one AI reader (`readers/v9-follow-up-lean.md`), with the reader's three wording points fixed by the coordinating session. `TurningInTime.locked_alone` and `TurningInTime.locked_ends_with_net`: where the way's step as it was is the lock's and the going on needs a positive level, a `Locked` start ends `Locked` where the net ends, under `RuleCapture.turn_locked`'s premises and `ends_with_net`'s. So the lock is a case of the pair beyond a need of nothing: its first ending. `core_tells` was renamed `core_apart_below_need`, since the old name read as a doer. The module then has 34 theorems and 12 definitions. After the landing, the function giving the way after a step, first named `renew`, was renamed `after` (and `windowRenew` `windowAfter`): "renews" is the root's gloss of 复生, another thing, so the name was a two-sense word at the centre's module. The statements are unchanged.

## Failed candidates and corrections kept

- **The held first attempt**, the cold reading of it and why it was held: above, and `READER.md`.
- **Round 1's over-claims**, taken out in round 2: `regularity_in_level`, whose first half holds of every relation because the joint class is the identity (the root's own caveat, `«火之见证不择类»`); section 6's title, which claimed a join of the capture modules' `Locked` region to the pair that no theorem made, and `window_unending`, true of every pair at a need of nothing; GuardedStep's own induction repeating `Law.unending_iff_steps`; a header that left out premises.
- **Round 2's prose findings**, fixed by the coordinating session: "sections 4 and 5 say nothing of" the capture modules' models, false for the two kind laws; `window_through` misdescribed; a reason for the `decided` premise that the cited law does not give, replaced by the witness `stepWhile_toEnd_decides`; the package's guarded law (`Viability.guardedStep`), which the design had said did not exist, named and tied (`stepWhile_guarded_iff`).
- **The design's** "no law has a next only where a condition holds" was wrong: `Viability.guardedStep` is such a law, of another shape.

## Readings, not proved

- In the root's words the centre is one sentence with two endings: a line that stays alike in a respect ends where the net ends, or ends while the net goes on (02 §11, Reading).
- Moving `«类闭则本类常闭»` and `first_of_decided` down would put `TurningInTime` in the first layer; it uses no continuation condition and no valuation.
- `ClosedCapture`'s and `PoolFromCourse`'s own-loop laws could be derived below from `agrees_until_marked` once their courses are stated as instances of the pair; the design left this for the next time `ClosedCapture` is opened (it would rebuild 23 modules).
- The step `T` could be given in closed form by `Optimum.reread_deadline_iff`; not stated.

## What is in this folder

| Path | What |
|---|---|
| `NOTE.md` | this note |
| `TURNING-IN-TIME.md`, `TURNING-IN-TIME.zh.md` | the centre on one page, a candidate statement for Ren's read, English and Chinese written apart (Fable) |
| `FOR-REN.md` | what now stands and what waits for Ren, on one page (Fable) |
| `turning-in-time.svg`, `turning-in-time.zh.svg` | the one page's picture: the level step by step, with the steps at which it first makes a difference to the way |
| `READER.md` | the cold readings in short, and what was done about each finding |
| `DESIGN.md`, `DESIGN-R2.md` | the design and its second round (Fable) |
| `NEAR-WORK.md` | the near work, two passes |
| `drafts/` | the plan with its log, the statements of the centre (English and Chinese, two versions), the eight doubts, why the language drifts, the table to the root's terms, wording for Ren's read |
| `readers/` | the cold readings: `lean-reader-1.md` on the held attempt, `v1` to `v5` on the landed files |
| `where-we-are/` | the four AI agents' reports of 12 November and the full picture put together from them |
| `map/` | the maps of what exists, the critic, the follow-ups and the landing checklist |
| `held/TurningInTime-first-attempt.lean.txt` | the held first attempt, as a text file so that no second `TurningInTime.lean` lies under the repository |
| `kit/` | `fill_records.py`, which binds the two records to the core run, and the lander's commands |

Files copied from the session's scratch folder are kept as written; those that name local paths say so in their first line. Links between them were changed only where the move broke them.

## TT2: the point of no return, a level and a step (13 November 2026)

*AI-written, 13 November 2026. Appended; the sections above are as they stood at TT's landing.*

Board item TT2. The package used one name for two things: `RegimeMargin` calls the level `H + y` the point of no return under a standing use `H`, and `Becoming.ReadOffInTime` calls the first step at which a course is not recoverable its point of no return (`NoReturnAt`), with the feasible courses and what is asked of them given. One witness tied them (`FourReaders.recoverable_iff_regime`). A new last section of `TurningInTime.lean` before `Three` ties them for every level course that never rises.

- **`recoverable_iff_above`, `noReturnAt_iff_first_below`.** For a level course `X` that never rises and starts at most `hi`, with the feasible courses `X` turned to one standing use `H` at some step, the start included (`turned`, `Turned`), and the need met at every step asked (`MeetsNeed`), under nothing given from nothing, `Short`, `Meets`, `Keeps` at `H` and a positive need at most `H + y`: `X` is recoverable at `N` exactly where `H + y ≤ X N`, so its point of no return is the first step at which its level is below `H + y`.
- **`course_turned`.** On the pair, the level course is the course as it was turned at `T + 1`, for `T` its first marked step. No premise on the need.
- **`noReturn_exists`, `turns_in_time_iff_before`.** Under `turns_in_time_iff`'s premises the course as it was has a point of no return `N ≤ x`, and the line never ends exactly where the first marked step `T`, the need met there and before, has `T + 1 < N`.
- **`Three.noReturn`.** From nine as it was the point is step 3; marked at step 2, `T + 1` is that step and the line ends.

It is a composition of landed theorems (`RegimeMargin.ends_below`, `holds`, `Optimum`'s level theorems, `agrees_until_marked`), about two hundred lines, and no existing statement or name changed; one existing proof was refactored (the kept kind's run, now a private lemma). The module now has 61 declarations, 46 of them theorems. The header's sentence that `ReadOffInTime`'s theorems "are not joined" is replaced by what is joined and what is not: its selection side is not instantiated, other continuations than a turn to one use are not among the feasible courses, and `FourReaders`' witness is not derived from the join.

How it was made: a first design ([`TT2-DESIGN-attacked.md`](TT2-DESIGN-attacked.md)) claimed a tie to `ReadableInTime`; two AI readers refuted it (the pair's course and the course as it was first part at `T + 2`), found the join near-definitional, and fixed the family of feasible courses and the step `T + 1` ([`readers/tt2-n1-existing.md`](readers/tt2-n1-existing.md), [`readers/tt2-n2-logic.md`](readers/tt2-n2-logic.md)). The revised design is [`TT2-DESIGN.md`](TT2-DESIGN.md). One AI agent wrote the section in scratch; one AI reader checked each statement by simulation and each sentence against its statement ([`readers/tt2-v1-section.md`](readers/tt2-v1-section.md)); nine findings, all repaired.
