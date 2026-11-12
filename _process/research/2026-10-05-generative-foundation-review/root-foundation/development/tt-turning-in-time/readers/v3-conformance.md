Kept as written; local paths in it point to the session's scratch folder.

AI-written reading, 12 November 2026. A reader of conformance to the design and the direction. I did not build, run Lean, or run any checker. Line numbers are in `tmp/r7/tt/lean/Becoming/`.

# TT, third reading: conformance

## Verdict

Every statement the design names is there, and each one is proved in the form the design gave or in a form that is no weaker. Two places claim more than the Lean proves. The first is `regularity_in_level`, together with the header bullet that introduces it: the `«足以定核»` half is empty, and the docstring does not say so. The second is the section title "the lock as the case that needs nothing": the lock's own content is never shown as a case of the pair or the net. Both should be fixed before landing. Below them are a handful of medium wording and test-of-the-plan findings, and some low ones.

## High

**H1. `regularity_in_level` uses `«因于核»` emptily, and the text does not say so.** (TurningInTime.lean 230-242; header 52-55.)
- The `«足以定核»` conjunct holds because the meet of "same way" and "same level" is identity, and the core of a class is reflexive (`pair_eq` plus `«核为类»…refl`).
- So the same proof gives `«足以定核»` for any second class that, met with the way's class, identifies the configuration. It holds for every `renew`, including one that ignores the level altogether.
- The only content is the second conjunct: the way's class is not constant, which comes from `0 < need` through `constant_iff_needs_nothing`. In other words, the level matters only through the cut (whether there is a next). It plays no part in which way follows.
- The root already says this about its own witness: `«火之见证不择类»` (Grammar.lean 845-853), "every class that, with flame or not, tells the four moments apart suffices … it does not show which description that is". The docstring's "As with the flame and its fuel, the joint class here is the identity" invites the comparison but leaves out the caveat the root itself attaches.
- The header puts the theorem under "Which differences of level make a difference" and says "the way's regularity lies in the level". A reader will take that to mean which levels make a difference to the way, and the theorem does not show that.
- Fix: say in the docstring and in the header that the sufficiency half picks no class (cite `«火之见证不择类»`), and that what is proved is that a positive need makes the way's class not constant, whatever `renew` is.

**H2. "The lock as the case that needs nothing" is not what §6 proves.** (Header 79-88; section docstring 583-593; title of §6.) What is proved is two identifications, and they are not joined to each other or to any law of §§2-5:
- `locked_closed` and `locked_at_class` are on `Law.step (Pace.step (join fA fB) (joinRead hA) reads)`. That is a total step with no pair, no net and no need. They give the root's P2/P4 at a locked member through `«类闭则本类常闭»`, which is a real join of the lock to the root, but not to the pair.
- `window_is_pair` and `window_alone_outside` are on the window course (`windowRead`), which is a different step from the one `locked_closed` is on. `Locked` and `lockedAlike` never appear there, and nothing shows `lockedAlike` as a `Kept` kind or a `κ` class of the pair.
- `window_unending` is `Nat.zero_le` through `Law.stepWhile_unending_iff`. It holds for every pair at need 0 and says nothing that belongs to the window.
- So no theorem shows the lock to be a case of `turns_in_time_iff`, `toEnd_iff`, `kind_toEnd_of_unmarked` or any other law of the module. "Needs nothing" is a choice (`need := 0`), not something derived. At need 0 the net is total, so `«至终有常»` there is `«有常»`.
- The section on what is not shown (103-106) says the honest part plainly. The design's table row "the lock's kept class, the level's laws and the root's two endings, on one relation" is still not met for the lock, and the section title still claims it.
- Fix: retitle §6 and its header bullet as what they are, for example "The lock's region closed at its class; the window course regrouped as a pair". Alternatively, prove the missing tie: `lockedAlike`, or its image under `windowRegroup`, as a class of the pair's way that the window course's step keeps.

## Medium

**M1. The second ending is named in the title and never shown as a line.** (Title, line 8; header 14-22.) Every line-ending theorem in C is under `«一»`, where `«亡»` is the same as "conditions nothing". So every ending proved is an ending where the net ends, and those are kept apart from `«亡»` under a class correctly throughout.
- The other ending, a line under the kind's class that ends while the net goes on (`«亡»` under `sameValue κ` with a next), is never stated. It appears only as the failure of `«本类至终有常»` in `kind_not_toEnd_of_turn`, proved through `«出类不随则本类不至终有常»` rather than `«亡而网续…»`.
- `Three.turned_and_ends` has exactly such a line: under the kind, from `(true, 9)` it ends at `(true, 6)` while the net goes on to `(false, 2)`. It is not stated.
- The title's "or while the net goes on" is therefore not instanced as a line. One more conjunct in `Three.turned_and_ends` would show it, using `«亡而网续则本类不至终有常»` as the root's own law.

**M2. GrammarPath header: "is the composite of these two, by its own proof there".** (GrammarPath.lean header, the added lines after 42.)
- No Lean statement composes `«局定后则至终有常当且仅当同行可决»` with `«有常当且仅当至终有常可续»` into `«局定后则有常当且仅当同行可续»`. The latter keeps its direct proof in GrammarLaws.
- "Composite" is an argued reading. It is true, since `可续` gives `可决`, but nothing checks it. "By its own proof there" can be read as saying that its proof is the composite, which is false.
- Say instead: "follows from these two, since a next where `E` leads decides it; that is not stated in Lean, and the GrammarLaws law keeps its own proof".
- The witness sentence (`0` conditions `1` and `2`, `«静»`) is also unchecked in Lean, and the text does not mark it as unchecked.

**M3. GuardedStep header claims more than its laws state.** (GuardedStep.lean 36-38.) "Where `can` always holds, each law reads as the total step's (… `Law.unending_iff`)": no theorem derives any total-step law from its guarded form at `can := fun _ => True`. `stepWhile_always` is the only tie that is proved. Either prove one instance or say "each law specializes, by `stepWhile_always`, to a statement of the total step; that is not stated here".

**M4. The design's `asItWas` abbreviation was not made, and no report says so.** (Throughout C. `pair (fun w _ => alone w) left` is written out about forty times; lines 509-546 repeat it fourteen times in one statement.) The design asked for a local notation or an `abbrev`. Its absence is not in any implementer's list of deviations, and it is the largest single cost to the plan's point 2 (what a reader must read).

**M5. Vocabulary the root lacks.**
- `可决`, in four new GrammarPath names, appears nowhere else in the package. It is defensible, because the root truly lacks a word for "decided whether it conditions anything", but it is new and no report marks it as new.
- C's labels on parts are all new: way, level, need, marked, alone, as it was, kept kind, giving, use, turns. The design permits "the level". The others are model words and stay outside the root's terms. The header does not say they are model labels and not the root's.

## Low

- L1. TurningInTime.lean 126: `pair_adaptive`'s docstring says "in the place of its rule". "Rule" is a borrowed word outside §6. It is the design's own text (c1 flagged it). Write "in the second place", as line 41 does.
- L2. Header 79-88 uses share, rule, loss, window, lock and favouring outside §6. These are cited names and describe §6, so this is defensible, but strictly it is outside the section the design allows them in.
- L3. TurningInTime.lean 567-571: `kind_not_toEnd_of_turn`'s docstring says "at a marked level `x`". Markedness is not a premise; the theorem holds for any `x` meeting the need with `turns`. The docstring adds a premise the Lean does not have. The claim is weaker than the proof, but it is still not what the Lean says.
- L4. TurningInTime.lean 215 and header 52: "the core … tells a level … from one below it" reads as a doer. The statement is that `«核»` does not relate `(w, x)` to `(w, x')`. Say that.
- L5. TurningInTime.lean 72-74: the header's summary of `turns_in_time_iff` names only one premise ("below `H₁ + y₁`"). The theorem docstring (488-496) names them all.
- L6. GuardedStep.lean 9: `«同行当且仅当有常»` is cited without its two premises (`«定后»`, every occurrence has a next). `Law.step` meets both, but the text does not say so.
- L7. TurningInTime.lean 689-690 and 591: "the way after a step is the share's own". `windowAlone` also carries the schedule and the step count (c6's doubt). Say "read off the share by `hA`, on the same schedule".
- L8. `locked_closed` (608-619) recomposes `turn_locked` with `turn_join` in one step. It does not re-prove `locked_stays` or `lock_outlives_loss`, but it is the one-step core of the locked part of `lock_outlives_loss`, without `Accrues`. Identification only: it passes.
- L9. TurningInTime.lean 775: "marks from ten to nothing" is an odd way to say an empty interval. Write "marks between ten and nothing, an empty interval".
- L10. The text added to GrammarPath does not say that it is AI-written, and AGENTS.md asks for that. GuardedStep and TurningInTime do say so.

## 1. Statement by statement against the design

**A.** All six theorems are proved as designed and placed after `«有常则至终有常»`. The diff against the package copy shows additions only: the one replaced header line keeps its old text. The header sentences are present, with M2.

**B.** All eleven statements are proved as designed. There are two private helpers, `stepWhile_line_on_orbit` and `stepWhile_unending_rel_iff`, and both are sound. `stepWhile_toEnd_iff` is from A's iff, as designed. The design asked that laws which are instances of `«不穷则迭»`, `trace_on` or `«亡者不在长迭»` be proved from those laws. `stepWhile_unending_rel_iff` is proved by its own induction instead, and no report says those laws were checked and found not to fit. Not checked by me.

**C2.**
- `toEnd_iff`, `constant_iff`, `constant_iff_needs_nothing`, `toEnd_of_unmarked`, `unmarked_interval_iff`, `core_tells` and `regularity_in_level` are as designed (H1 is about the text, not the statement).
- `constant_adaptive` is added. It quantifies `∀ u : Unit`, which is harmless.

**C3.** As designed.

**C4.** As designed. `regime_levels` is the joint induction the design asked for, through `Optimum.never_rises`, and does not re-prove a fall. `regime_step_eq` is public but used only by `regime_levels`, so it could be private.

**C5.**
- `unending_iff_first_marked`, `unending_iff_above` and `turns_in_time_iff` match the design's premises exactly, with no extra premise.
- The `T + 1` level is the level after the turning step by definition, and the proof uses this through `above`.
- `kind_toEnd_of_unmarked` is as designed.
- `kind_not_toEnd_of_turn` has the same statement as designed. It reaches it by `«出类不随…»`, not `«亡而网续…»`. The reason is sound: `«亡而网续…»` needs a `«续»` step from `x` to `y` before the ending, and the turn here happens on the first step. This is not a weakening. The renamed variables are fine.
- The closed form is omitted, as the design allows, and the omission is said in the header (101).

**C6.**
- `locked_closed` and `locked_at_class` are as designed.
- `window_is_pair` holds in the designed form, for every start.
- `window_alone_outside` is as designed.
- `window_unending` is added, true but vacuous (H2).

**C7.** The three theorems are present. I checked the as-it-was orbit by hand: 9, 8, 6, 2, 0 under use 5. With the mark at 9, eight is left, which is at least 6. With the mark at 8, six is left, at least 6, and 6 is a fixed point under use 3. With the mark at 6, the course gives `(false, 2)` and then `(false, 0)`. All agree with the statements.

**Header of C.** The order is as designed and the first line is as designed.

## 2. Wording rules

Breaches are L1, L2, L4 and L7.
- No "carrier", no "stock", no "reader", no "oversight".
- "renew" appears only as the function, plus the hypothesis name `renews` cited at 282, which is `Optimum`'s argument name.
- "condition" is used only for the relation (GuardedStep 51-52; all "conditions nothing/something").
- I found nothing that fits only a person. "Need", "use" and "giving" fit any going-on.

## 3. The root's terms

- `同行`, `有常`, `至终有常`, `本类至终有常`, `核`, `所缘同于`, `闭`, `迭` and `不穷` are used in the senses of Grammar.lean, GrammarLaws.lean and GrammarPath.lean.
- `«核»` in `core_tells` is the greatest symmetric constant relation, used through `«根»`.2.1 and `«有常则可续»`. That use is correct.
- `因于核` is H1: real in form, empty in its sufficiency half, and not said to be.
- `亡` against "the net ends": kept apart everywhere I read. Under `«一»` they coincide, and the module states only `«一»` lines. The cost is M1.

## 4. The plan's test ("The test for every move", PLAN.md)

| Move | 1 joins | 2 lowers reading | 3 relation, not doer or labelled tuple | 4 claim = proof | 5 no new vocabulary |
|---|---|---|---|---|---|
| A | Partly. It ties `同行` to `至终有常`, but adds six statements and removes none, and the GrammarLaws iff is not re-derived from them. | No. Six more to read. | Yes. | No, because of M2. | No: `可决` is new (M5). |
| B | Partly. It enables, rather than joins. Only `stepWhile_always` ties it to the existing step. | No. | Yes. | No, because of M3. | Yes. |
| C | Yes. It joins the level laws, `至终有常`, `adaptive` and `«出类不随…»` on one relation, `net`. | No (M4). | Partly. `net` is one relation, but the module speaks through a tuple of labelled parts. | No, because of H1, and L3 and L5 at low. | No (M5). |
| C6 | Partly. It joins the lock to the root's P2/P4, but not to the pair. | No. | Yes. | No, because of H2. | Yes (cited names). |

Statements that could be removed without loss to anything else in the three files:
- `alike_along`. Nothing uses it. It is `«同行之迭»` applied once.
- `ends_with_net_regime`. Nothing uses it. `turns_in_time_iff` goes through `regime_levels`.
- `window_unending`. It is vacuous: the statement holds for any pair at need 0.
- `stepWhile_unending_value_iff`. C does not use it. It is kept only as the guarded `unending_iff`, and that tie is unproved (M3).
- `stepWhile_always`. Nothing uses it.
- `«至终有常则可决»` and `«至终有常可续则有常»`. Each is used only inside its own iff.
- `constant_iff_needs_nothing` could be folded into `regularity_in_level`, its only user besides the header.
- `regime_step_eq` could be private.
- `unmarked_interval_iff` serves only `Three.ends_as_it_was`.

## 5. The lock section

Each theorem states an identification. None re-proves `locked_stays`, `lock_line`, `window_never_read`, `window_past_course` or `course_past` (on `locked_closed`, see L8). "The lock is the case that needs nothing" is not what is proved (H2).

## Not checked

- Compilation, the axiom reports and warnings: taken from the implementers.
- The exact forms of `adaptive_constant_iff`, `Optimum.ends_within`, `level_le_start`, `never_rises`, `RegimeMargin.step`, `Short`, `Meets`, `Keeps` and the `*_of_below` lemmas, beyond how they are called.
- That `rfl` and `decide` close the Three facts. I checked the numbers by hand only.
- The maps in `tmp/r7/tt/map/`, which I did not read. So I did not check whether a stated law duplicates one listed there, beyond what I grepped.
- Whether `«不穷则迭»`, `trace_on` or `«亡者不在长迭»` could have given B's laws.
- Name collisions in the package.
- The Chinese texts.
