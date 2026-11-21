# ContextArrivalTraces

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ContextArrivalTraces.lean`
- *result records that name this place's file as a source* (computed; not a link): `becoming-context-coherence`, `claims-shown-in-context`, `fixed-places-and-sole-lines`, `place-relations-in-context`, `unity-of-readings`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-02, as "ContextArrivalTraces.lean: pooledLaw_exact_iff_joinClosed, erasedLaw_exact_iff_lifts, arrives_snoc" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-02.md.txt)); pass b: reader whole-b-07, as "ContextArrivalTraces.lean: Contextual.fitsFree_iff, Contextual.no_free_frame, pooledLaw_exact_iff_joinClosed, retainedLaw_trace_iff, retainedLaw_realizes_inOne, erasedLaw_exact_iff_lifts, arrives_append, arrives_snoc, step_arrives, CrossingContexts.pooled_crosses, ChangingContext.joins, ChangingContext.erased_not_lifted" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-07.md.txt)); the third pass, where the two differed: reader whole-c-settle-03, as "ContextArrivalTraces.lean: settled fields no_return, both_outcomes, closed_region" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-03.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `pooledLaw_exact_iff_joinClosed` (l. 116) characterizes exact pooling for an inhabited family by closure of single-context courses under joining. `arrives_snoc` (l. 207) computes the possible final contexts from the possible contexts after the same trace’s prefix and the last action.
  - *pass b:* The module states, in general for families of processes indexed by contexts: the pooled law runs exactly the courses that one context runs exactly where such courses compose; retaining the context runs exactly the courses of that context; forgetting the context of an evolving law is exact from every context exactly where every context can follow each forgotten step; and the contexts a course arrives in are those its last step advances to from where its earlier part arrives. It also states that a frame of context-free claims fits exactly where what the contexts show glues at every configuration. Built cases show a pooled crossing no context runs, a context changing within a course, and a forgotten step a context cannot follow.
- **moves**
  - *pass a:* S: `retainedLaw_trace_iff` (l. 139) characterizes every action-word trace by unchanged context and a trace in that context’s process.
  - *pass b:* S: `pooledLaw_exact_iff_joinClosed` (l. 116): for an inhabited family of processes, every trace of the pooled law (a step some context's law takes) is a trace of one context's law exactly where courses of single contexts are closed under joining (JoinClosed l. 97). `erasedLaw_exact_iff_lifts` (l. 163): every context can follow every step of the erased law exactly where, for every context i, the erased law's traces from s are exactly the evolving law's traces from (i, s).
- **a reading**
  - *pass a:* S: `Contextual.fitsFree_iff` (l. 58) characterizes fitting context-free claims on a fixed process by gluing at every configuration given a covering home assignment.
  - *pass b:* S: `erasedLaw` (l. 158) forgets the context, and `erasedLaw_exact_iff_lifts` (l. 163) says when what is kept after forgetting decides the courses exactly. `Contextual.fitsFree_iff` (l. 58): given a home context for each claim, a frame of context-free claims over P fits exactly where the shows glue at every configuration. `no_free_frame` (l. 74): where the possibilities are Local and NoGlobal and some configuration respects them, no such frame fits. `indexed_fits` (l. 47): the frame indexed by context fits everything shown.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a point of no return**
  - *settled by the third pass:* N: `empty_support_no_arrival` (l. 283, variables `{I} {S} {A}`) states `¬ Arrives R (fun _ => False) s [a] t j`: with no initial context there is no one-step arrival. The emptiness is the premise, the statement is of one step, and nothing is lost along a course. `ChangingContext.erased_not_lifted` (l. 253) states a step of the erased law that context true at 0 cannot follow, not an irreversibility. Opened also: `arrives_snoc` (l. 207), `retained_excludes` (l. 238). [which pass was right: b; opened: empty_support_no_arrival l. 283; erased_not_lifted l. 253; arrives_snoc l. 207; arrives_append l. 192; retained_excludes l. 238]
  - *pass a:* S: `empty_support_no_arrival` (l. 283) excludes every one-step arrival from empty context support. This is emptiness of compatible histories.
  - *pass b:* N: no irreversibility. B: `ChangingContext.erased_not_lifted` (l. 253): the erased law steps 0 to 1, but no evolving trace from context true at 0 reaches 1.
- **both outcomes**
  - *settled by the third pass:* N for going on and ending or keeping and losing. S of other things: `arrives_snoc` (l. 207) states `Arrives R initial s (word ++ [a]) t j ↔ ∃ m, Advance R (Arrives R initial s word m) m a t j`, a decomposition of arrival along a course; `pooledLaw_exact_iff_joinClosed` (l. 116, with a `seed : I`) and `erasedLaw_exact_iff_lifts` (l. 163) are exactly-whens of a law running exactly the courses of another; `retainedLaw_trace_iff` (l. 139) likewise. Opened those four and `empty_support_no_arrival` (l. 283). [which pass was right: b; opened: arrives_snoc l. 207; pooledLaw_exact_iff_joinClosed l. 116; erasedLaw_exact_iff_lifts l. 163; retainedLaw_trace_iff l. 139; empty_support_no_arrival l. 283]
  - *pass a:* S: `arrives_snoc` (l. 207) characterizes continued feasibility of a history with one more action exactly by an advance from a prefix-supported context at an intermediate state.
  - *pass b:* N: no exactly-when of going on and ending. S, one-sided: `empty_support_no_arrival` (l. 283): from an empty support no one-step trace arrives.
- **a comparison between two**
  - *pass a:* S: `erasedLaw_exact_iff_lifts` (l. 163) equates trace exactness from every initial context with the ability to lift every projected one-step move from each context.
  - *pass b:* S: `InOne.pooled` (l. 101): a course of one context's law is a course of the pooled law (by trace_map). `retainedLaw_trace_iff` (l. 139): a trace of the retained law from (i, s) to (j, t) exactly when i = j and a trace of family i runs from s to t. `retainedLaw_realizes_inOne` (l. 147). `erasedLaw_exact_iff_lifts` (l. 163): the evolving law's traces carry onto the erased law along Prod.snd, and back exactly where steps lift (from projection_exact_iff).
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a closed region**
  - *settled by the third pass:* S: `retainedLaw_trace` (l. 128, section Laws, variables `{I} {S} {A}`, for every `family : I → Process S A`) states `Trace (retainedLaw family) p word q → p.1 = q.1 ∧ Trace (family p.1) p.2 word q.2`: along every course of the retained law the context coordinate is unchanged, an invariant of the step. It is near-definitional, since `retainedLaw` (l. 125) puts `p.1 = q.1` in its step. `JoinClosed` (l. 97) is closure of courses under joining, as pass b says, and is a different thing. [which pass was right: a; opened: retainedLaw l. 125; retainedLaw_trace l. 128; retainedLaw_trace_iff l. 139; JoinClosed l. 97]
  - *pass a:* S: `retainedLaw_trace` (l. 128) keeps the context coordinate constant along every retained-law trace.
  - *pass b:* N: JoinClosed (l. 97) is closure of courses under joining, not a region closed under steps.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* B: `changed_context_arrives` (l. 289) reaches the other context at step one; `ChangingContext.joins` (l. 245) continues the same course to step two.
  - *pass b:* S: `arrives_snoc` (l. 207) and `arrives_append` (l. 192): the contexts a course arrives in are those its last step advances to from the contexts its earlier part arrives in, so the context may change along one course. B: `ChangingContext.joins` (l. 245): a trace from (false, 0) to (true, 2). `changed_context_arrives` (l. 289): from context false at 0, the one step arrives at 1 in context true. `CrossingContexts.pooled_crosses` (l. 222) with `not_inOne` (l. 226): pooling gives a course from 0 to 2 that no single context runs, so more is run after pooling.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statement answers cover states, moves, reading, no_return, both_outcomes, comparison, closed_region. Built-case answers cover forms_change. I reached all fourteen questions.
  - *pass b:* All statements, docstrings and the opening read (296 lines). Answers are from statements and built cases.
