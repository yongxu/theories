Kept as written; local paths in it point to the session's scratch folder. Copied at 00:52 WIB on 13 November 2026, before the landing runs; later log entries are not in this copy.

*AI-written, 12 November 2026, 22:30 WIB. The working plan for board item TT. Read this first if the context is lost. Append to the log at the end; do not rewrite earlier entries.*

# TT: the centre, built from the root, joined and landed

## Ren's words that govern this run

12 November 2026, typed, in order:

- 20:33: "read what's sending from the fork, and work with it, to over time correct the direction"
- 22:19: "you know what needs to be done and where the completion is at?"
- 22:23: "alright - keep moving, spawn opus 5.5 for implementation and verification, fable will hold direction, design, and handle very complex tasks. no need to stop before fully done. if we need new lean proofs, add them, if we need to reorganize, reorganize. make sure your moves are elegant and "pareto frontier" with respect to our direction" and "i think over time you will forget - so first generate a plan, then start execution"

Earlier the same evening: his eight doubts (20:15, in a fork; answers in `EIGHT-DOUBTS.md`), and "Yes, build on it" (20:09). All of his words not yet in sources are in `ren-words-fork.json` and in the session transcript; file them at the landing.

## What "fully done" is

- **D1. One proof.** Every link of the centre is a theorem or a named premise. It is stated with the root's own predicates wherever the root can say it, and on one model only where amounts are needed. Nothing restates a law the root already has.
- **D2. Joined, not tabled.** The lock's definitions and the stock's threshold are proved to be cases of it, in Lean, or are named as exceptions with the reason.
- **D3. Below, not beside.** A law that generalizes an existing one lands under it and the old one becomes its case (board rule 9).
- **D4. Read.** Second readers find no high or medium point left open on statement against docstring. Two rounds at most; what is still open then is reported, not hidden.
- **D5. Said once.** One statement of the centre in one place, English and Chinese written apart. The fronts' first lines point to it and do not say it another way.
- **D6. A live set.** About ten pages named in one index as the way in. Everything else stays where it is and is marked archive at its entrance. No deletion, no mass rewrite.
- **D7. Near work read and placed.** The three papers found on 12 November, read whole, with what is theirs and what is ours.
- **D8. Landed once.** One train through the queue: core run, render, full gate once, board row, his words filed. Not pushed.
- **D9. One page for Ren**, ten minutes: what stands, what was wrong, what stays open.

## The test for every move

A move is taken only if it does not trade one of these away for another:

1. It joins what stood beside (fewer independent statements, not more).
2. It lowers what a reader must read.
3. It says the thing as a condition between occurrences in a respect, not as a doer acting on a thing, and not as a tuple of parts with new labels.
4. Its claim is exactly what is proved, premises said.
5. It adds no vocabulary the root does not have, unless the root truly lacks it.

If a move helps one and hurts another, look for a different move. Prefer deleting a duplicate to adding a bridge, and a bridge to a table.

## What stays Ren's

Pushing; the licence; who is sent what; money or machine time for runs; paid runs and new test designs (held since 6 November); any change to AGENTS.md's direction (prepare the wording, do not apply). A map redraw is not part of this run.

## State when this plan was written

- main `372705add`: TT claimed on the board; his four evening messages in `sources/15-codex-theory-conversations/2026-11-12-where-we-are-and-the-loop.md`. Four commits ahead of origin, not pushed.
- Worktree `/Users/ren/tmp/tt/wt`, branch `tt-turning-in-time`, clean at `372705add`.
- Scratch: `tmp/r7/the-loop/lean/Becoming/TurningInTime.lean` (46 theorems, no axioms; held, with a second reader's report in `tmp/r7/the-loop/readers/lean-reader-1.md`). Build: from the package folder, `python3 -B scratch_build.py <tree> <Module>`, about 7 s when the closure is cached.
- Drafts: `THE-LOOP.md`, `THE-LOOP.zh.md` (statement v2), `THE-LOOP-v1*` (kept), `WHY-THE-LANGUAGE-DRIFTS.md`, `EIGHT-DOUBTS.md`, `LEAN-TO-ROOT.md` (a working note, not to land as a tie), `FOR-RENS-READ.md` (AGENTS.md and glossary wording).
- Earlier: four readers' reports in `tmp/r7/where-we-are/`.

## What is already known and must be honoured

- The root already holds the centre's first half: `«至终有常»` (GrammarPath: alike leads to alike unless there is no next), `«因于核»`, `«足以定核»`, `«相须核»` (a class's regularity lies in another; the flame and its fuel), `«异»`, `«同行之迭»`, `«有常则可续»`, `«亡于核下不变»`, `«局定后则有常当且仅当同行可续»`. Build from these.
- The second reader's findings on the scratch module: its grammar section restates the root (H1); docstrings omit premises (H2); "the last level from which it can turn" is one direction only (H3); in the exact condition the marks carry nothing (H4); `left_lt` is an instance of `Adjusted.step_below`; a changing draw may already be in `Becoming.DrawHistory`; `Course.Lasts` rebuilds `Lasting.Lasts`; terms collide ("renew" is 复生's gloss; "carrier"; "condition" used two ways); the witness is thin.
- The package forbids axioms: no `omega`, no `simp`; use `sub_eq_zero_of_le`, `add_sub_of_le`, `le_of_add_le_add_right` (namespace `Becoming`) and `Naturals.sub_add_cancel`.
- The statement still has one thing at the centre with "its conditions". The candidate without it is in the session's message of 20:40. Ren has not given his own wording; go on with the best one and mark it AI-written.
- Rate: one landing train at the end, not many commits. What Ren is given is one page.

## Who does what

- **Fable (this session):** direction, design, the hard proofs, the final read of every statement, every text that states the centre, the landing.
- **Opus 5.5 agents:** mapping what exists, implementing Lean from a written design, adversarial verification, drafting records and registration text from a checklist.
- Each implementer works in its own scratch tree under `tmp/r7/tt/` and runs only scratch builds of its own module. Reviewers read and do not build. Heavy runs (core run, render, gate) are run once, by this session, one at a time, with `uptime` checked first and a log outside the repository.

## Phases

| | Phase | Output | Done when |
|---|---|---|---|
| P0 | Map what exists (Opus readers, one workflow) | `tmp/r7/tt/map/*.md` | every root law near the centre, every lock and stock definition, every existing tie and the landing checklist are listed with exact statements and line numbers |
| P1 | Design (Fable) | `tmp/r7/tt/DESIGN.md` | each theorem is written as a Lean statement with where it lands and what it replaces; each join is named; the moves pass the test above |
| P2 | Lean in scratch (Opus implementers; Fable on the hard ones) | scratch trees under `tmp/r7/tt/` | every statement in the design compiles with an empty axiom report, or the design is changed and says why |
| P3 | Verify (Opus adversarial readers, then Fable) | `tmp/r7/tt/readers/` | D4 |
| P4 | Texts | statement (en, zh), home section, records, study note, registration text | each sentence that states a law names its declaration and its premises; a cold reader finds no claim beyond the Lean |
| P5 | Near work | `tmp/r7/tt/NEAR-WORK.md` | D7 |
| P6 | The way in | the live-set index; archive marks; AGENTS.md wording for his read | D6 |
| P7 | Land (one train) | commits on `tt-turning-in-time`, merged to main | D8 |
| P8 | Report | one page for Ren; memory updated | D9 |

P5 can run beside P1 to P3. P4 waits for P3. P7 is serial.

## Log

- 12 Nov 22:30: plan written. P0 starting.
- 12 Nov 22:35: P0 launched as workflow `tt-map-what-exists` (run `wf_8f3d7a2d-f3e`; ten Opus readers, one on the near work, a critic, follow-ups). Maps go to `tmp/r7/tt/map/`, the near work to `tmp/r7/tt/NEAR-WORK.md`.
- 12 Nov 22:38, design seed (Fable, from reading `GrammarPath.lean`'s header and declaration list; to be checked against the maps). The root already states both ways a line under a class can end. Where the class is constant up to the net's end (`«至终有常»`, or at the member's own class `«本类至终有常»`), a line under it ends only at an occurrence that conditions nothing. A line that ends while its last stage still conditions something fails that condition at its own class (`«亡而网续则本类不至终有常»`, `«亡而网续则不至终有常»`); the root's example is the organism's line ending at old age. So in the root's terms: **used up unturned** is a line under the class "as it was" ending where the net ends, and **turning in time** is that line ending while the net goes on (亡而网续), with the line under the coarser class going on. Nothing new is needed in the root for this. What the root cannot say is which of the two happens, because that takes amounts: a level, what is used, and the points of no return. So the design is: (1) no restated root law; (2) one model that supplies a relation with a guard (a next only where the level meets the need) and a class "as it was"; (3) its laws stated with the root's predicates on that relation: the class is constant up to the net's end exactly where no level at which it goes on turns it; with the level falling, the line ends where the net ends; the exact condition on the marks and the level left for the line to end while the net goes on and the coarser line never to end; (4) the marks must carry weight in the exact condition (the reader's H4): state it on the as-it-was run of the level, so that it is a condition on marks, start and uses, not an event on the same line; (5) joins: the lock's `Locked` region as the class "as it was", `PoolFromCourse.windowRead` as the marks with loss counted up where the level counts down, the stock's laws used as they stand, a changing draw placed below `RegimeMargin.ends_below` if `DrawHistory` does not already have it.
- 12 Nov 22:58: P0 done (18 Opus agents; maps in `tmp/r7/tt/map/`, result in `_workflow-result.json`, near work in `tmp/r7/tt/NEAR-WORK.md`). What it showed: the lock is already read on the grammar (`GrammarRegularity`: `lockedAlike`, `lock_line`, `loss_ends_line`, `adaptive_constant_iff`); every lock course is endless (total step, `Accrues`); the level's laws with a changing draw and a run split at a step `T` are in `Optimum` 2228-2410 (`ends_within`, `kept_at_need`, `reread_kept_iff`, `reread_deadline_iff`) on `Amounts.falls_by_stretch`; `OwnClass` ties a closed block to `«本类至终有常»`; no theorem relates `«同行»` and `«至终有常»`; no law has a next only where a condition holds. Near work: none of the four papers has what could turn the process running down with it in formal form, and none is machine-checked; "Self-Sealing Reward Models" was read from its abstract only and must still be read whole; HANDY (2014) and Brander and Taylor (1998) are unread.
- 12 Nov 23:00: P1 done: `tmp/r7/tt/DESIGN.md`. Three things are missing and only three: (A) the tie `«同行»` to `«至终有常»`, six theorems added to `GrammarPath.lean` (six dependents); (B) `Law.stepWhile`, a law's step while it can go on, new small module `Becoming.GuardedStep`; (C) `Becoming.TurningInTime` rewritten as `Mechanism.adaptive` with a level cut by a need: which differences of level make a difference, ending where the net ends through `Optimum.ends_within`, the split at the first marked level of the course as it was, `RegimeMargin.ends_iff_below` for the fate after it, the root reading with a kind, the lock as the case that needs nothing (PoolFromCourse's window course identified with the pair by regrouping; the `Locked` region closed under the net). No structure, two definitions, nothing renamed, `RegimeMargin`, `Optimum`, `ClosedCapture`, `GrammarLaws` untouched. Named and not done: re-deriving `join_course`, `course_past`, `window_past_course` from `agrees_until_marked` (23 modules to rebuild).
- 12 Nov 23:02: P2 and P3 launched as workflow `tt-implement-and-verify` (run `wf_d1cfee06-df3`): Opus implementers A+B, then C1 to C5 and C7, then C6, all in the one tree `tmp/r7/tt/lean/`; then three Opus readers (statements, duplicates, conformance) writing to `tmp/r7/tt/readers/v1..v3`. After it: Fable's own read of every statement, fixes, a second round only if a high or medium point remains.
- 12 Nov 23:06: the times of the five entries above were first written from memory and ran up to forty minutes ahead of the clock; corrected here against `uptime` and the workflow's duration (P0 took about 23 minutes). Board row widened and Ren's five later messages filed on the branch (`eccf14c7b`), gate running; a second near-work reading (population and resource models with an institutional response) started as a background agent. OpenReview shows a browser check for the Self-Sealing paper, which I may not pass: it stays unread until Ren opens it or another copy appears.
- 12 Nov 23:14: the widened board row and Ren's five later messages landed on main as `3582ee38c` (gate passed: secrets, strict, links, board, seven focused tests; the entry's time corrected before the merge; not pushed, five commits ahead of origin).
- 12 Nov 23:17: P5 second pass done (appended to `tmp/r7/tt/NEAR-WORK.md`). Brander and Taylor 1998 (whole): a level with regrowth, no response. Pezzey and Anderies 2001 and 2002 (whole): the only response triggered at a threshold of the stock (a tax falling with stock per head), the trigger's place chosen and not derived, the need to come in time said in words only; and one exact sense of the corrective failing with the stock: the tax has no effect once the stock is at or below subsistence, and a quota is disobeyed below it. HANDY 2014 (whole): no response; in words, the part that could change course feels the decline last. Turchin's demographic-fiscal model (partly): the state that holds conflict down is funded by a surplus that growth erodes; no condition for turning. Muneepeerakul and Anderies 2020 (main text): effort rebuilt from payoffs, governance funded from the resource but enabling harvest. Found nowhere: a comparison of the level at which the response comes, the level it needs to stand, and the level from which the resource recovers; a machine-checked proof. Still unread whole: Self-Sealing Reward Models (browser check), Dalton and Coats 2000 (abstract only), Pezzey and Anderies 2003 as published. D7 is met for what could be fetched and not for those three; the texts must say so.
- 12 Nov 23:35: P2 round 1 done (workflow `wf_d1cfee06-df3`, 6 agents). A and B exactly as designed (GrammarPath: additions only, its six dependents rebuild clean; GuardedStep: 11 theorems). C: 28 theorems, 39 declarations, every designed statement proved, no axioms, no warnings; `window_is_pair` holds in the designed form. Three readers (`tmp/r7/tt/readers/v1..v3`): no false statement, the witness right by hand, the marks carry weight in `turns_in_time_iff`. Found: `regularity_in_level` is empty in its first half (the joint class is the identity; the root's own caveat) so it goes; section 6's title claimed a join no theorem made (the locked laws were on one step, the window identification on another, `window_unending` vacuous); GuardedStep re-proved `Law.unending_iff_steps` by its own induction; the header left out premises; the written-out step as it was cost reading. Round 2 written in `tmp/r7/tt/DESIGN-R2.md`: `asItWas` as a definition; `net_zero`; the kind over any type and `kind_ends_while_net_goes`; section 6 restated with `join_is_asItWas` and `window_agrees_until_marked` (only if the lock modules do not already have it); GuardedStep derived through one tie from the whole step's laws. Then two readers, and Fable's own read. D4 allows no third round: what is open after it is reported.
- 13 Nov 00:03: P2 round 2 and P3 done (workflow `wf_94c4ef8a-765`, 4 agents; reports `tmp/r7/tt/readers/v4-statements.md`, `v5-duplicates-conformance.md`). No false statement, nothing high; five medium, all wording, plus one real find: the package already has a guarded law (`Viability.guardedStep`, `Lasting.guarded_upto_iff`), which the design had said did not exist. Fable's own read of all three files done, and the last fixes made by hand and built: GrammarPath gains a seventh law, the witness `«后不定则至终有常可不同行»` (now 108 theorems, additions only); GuardedStep gains `stepWhile_guarded_iff` (the tie to Viability's guarded law) and `stepWhile_toEnd_decides` (that `can` be decided cannot be dropped), 13 theorems; TurningInTime 32 theorems, 44 declarations: `windowRegroup` now through `ClosedCapture.loopPart` and `loss`, `Three.line_ends_while_net_goes` applies the root's `«亡而网续则不至终有常»`, the header's false sentence about sections 4 and 5 corrected. All three: empty axiom reports, no warnings. Round-2 copies kept in `tmp/r7/tt/readers/_*.r2.lean`. Per D4 there is no third reading round. Open and to be said in the texts: TurningInTime is in the second layer only through what it imports (`OwnClass` for `«类闭则本类常闭»`, `ReadOffInTime` for `first_of_decided`); moving those two pure laws down would put it in the first; `kept` and the marks are premises; `ClosedCapture`'s own-loop laws are not re-derived.
- 13 Nov 00:06: the home section written by Fable (`tmp/r7/tt/landing/02-section-11.md`: two theorems, what is given, a reading with the near work); the landing kit launched as workflow `tt-landing-kit` (run `wf_18b2b390-7fa`): one Opus agent on registration, chapter, regions and atlas, one on the two records, the study folder and the fill kit, both in the worktree with no heavy runs and no commits; a third reads the result. The module's header now says it lies in the second layer only through two imports.
- 13 Nov 00:46: the kit is prepared in the worktree, uncommitted (workflow `wf_18b2b390-7fa`; its reader's report `tmp/r7/tt/readers/v6-landing-kit.md`: registration correct, every public declaration named in exactly one law, links and JSON sound; one high, the atlas entry had no premises, which would quietly mark family A unread; five medium). Fable's fixes made: the section's wording (no "carrier", the kept kind's point of no return, the coinciding laws named, the near work's counts), the README rows' premises, the root bullet, the record's statement under its cap, and the Chinese of both records' titles, statements and laws written directly (records lint clean). An Opus agent is adding the atlas entry's premises, drops and hypotheses. Landing order settled: commit content on the branch; head clause on main from a detached switch; merge main; core run; fill, repoint, shared laws; render; focused checks and gate; landed clause; fast-forward. Decided: the one page is not edited in this landing (the row and pointer go to Ren with the AGENTS.md wording); the live set is a proposal for him.
