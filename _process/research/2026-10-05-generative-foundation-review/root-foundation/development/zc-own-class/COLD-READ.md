# ZC: the cold read before landing

The reader was Claude Fable, run through the Agent tool on 9 November 2026 with read-only access and no build. It read `Becoming.OwnClass`, 07 §4.8, the note and the two record drafts, checking them against the Lean for overclaim. Its report follows as written; the report is AI-written. What was changed for each finding is listed after it.

---

**Cold read of ZC (`Becoming.OwnClass`, 07 §4.8, NOTE, two records)**

Checked every statement in the module against `GrammarPath` (P2 `«本类至终有常»`, P4 `«所缘同于»`), `GrammarLaws` (`«闭»`, `«所闭»`, `«所闭之逆»`), `GrammarScope` (`«续无外»`, `«续无外则同一中心»`), `Centers`/`Testing`/`Feedback` (`ReachReturns`, `InOneLoop`, `WithinCoupling`, `WithinReach`, `Affects`, `thresholdOnly`), and the three witnesses by hand. The theorem bullets of §4.8 and the records' `laws` match the Lean closely; the problems are in the Readings.

### Findings

1. **High** — 07 §4.8 line 571: "on this path, a self drawn narrower than being related at all, read forward, is a self whose class does not hold its effects."
   Lean: `«本类常则闭当且仅当所及即一之所及»` says, *given P2*, P4 ⟺ the line reaches what the one's does. Classes strictly narrower than the one meet P4 (`«后类»`, `JoinBreaks.E`, `JoinBreaks.F`); and without P2, P4 holds with a narrower reach (`Inconstant.not_all_follow`, cited in §4.6). As written the sentence is false on its natural reading (class narrower than `«一»`) and lacks P2 on the intended one (forward reach narrower). The step's study §7 item 1 also asks about a privileged *relation* for `ownClosure`, not a class on the root; carrying it over is a reading.
   Reword: "on this path, granted P2, a self whose line reaches forward less than the one's from oneself is a self whose class does not hold its effects (`«本类常则闭当且仅当所及即一之所及»`); a class narrower than the one can still hold them (`«后类»`). Whether this is the study's 'privileged relation' is a reading."

2. **Medium** — 07:571 "Where one's own class meets P2 and P4, the net fixes it" and "The net settles which class is one's own as far as P4 is granted"; record 1 `correspondence` "the net fixes it as oneself with everything one's acts condition".
   Lean fixes the *least* class (`«后类最细»`) and the *reach* of every such class (`«本类常闭则所及即一之所及»`); it does not fix the class: `JoinBreaks.E` and `F`, and the one itself where decided, all meet P2 and P4 at `m`. The docstring (lines 63–65) says it correctly ("fixes the least such class and fixes the reach of every such class").
   Reword 07 and the record's correspondence to the docstring's form: "the net fixes the least such class and what every such class reaches; which of them is one's own it does not fix, and nothing one's line reaches turns on it."

3. **Medium** — 07:571, docstring 65–67, NOTE §2 line 27: "At every occurrence that conditions something other than itself, the identity … and the least class, meeting both, are both classes."
   Lean: `«后类本类常闭»` proves `«后类»` meets P2 only given *some* class meeting P2 and P4 at `m` (it borrows that class's decidedness). No declaration gives `«后类»`'s P2 from `goes` alone, and constructively it needs `decided`. P4 for `«后类»` is unconditional.
   Reword: "the least class, which holds its effects and meets P2 wherever any class does (`«后类本类常闭»`)".

4. **Medium** — 07:571 "the de se question has nothing left but P4"; docstring 67–68 "is P4 and nothing more"; record 1 `correspondence`.
   This presupposes P2. §4.6 names P2 *and* P4 as the crux and calls denying P2 coherent; without P2, classes holding one's effects differ in reach (`Inconstant` vs `OtherLeaves`). "On §4.6's path" carries P2 implicitly, but the sentence should say it.
   Reword: "granted P2, the de se question on this path has nothing left but P4."

5. **Medium** — 07:579 and record 2 law 4: "P2 and P4 together ask more than that: that the formation's coupling closure be closed under affecting (`Flow.couplingClass_closed`)."
   Lean: `couplingClass_closed` requires `goes : ∃ g, L.Affects W f g`. The docstring (line 756) states it; 07 and the record drop it.
   Reword: "at a formation that affects something, P2 and P4 together ask …".

6. **Medium** — 07:583 "§4.6's path reaches no further than route (b), the self and what it depends on" and "with a class drawn on representation, is route (b)."
   Lean: `couplingClass_line_iff_loop` puts the line in `InOneLoop`, whose second half is `WithinReach g f = WithinInfluence f g`: the *influence* closure. §3.3 (line 199) bounds route (b) by the feeding closure for dependence and the influence closure for feedback, and `withinInfluence_of_withinFeeding` nests feeding inside influence. So the loop lies within what can affect the formation, not within what it depends on. The record's correspondence says "within what can affect it", which is right; 07 should match it, and "is route (b)" should be "lies within route (b)'s outer bound".

7. **Low** — 07:563 places "at an occurrence that conditions something" over both directions; `«类闭则本类常闭»` needs only `decided`, and `«本类常闭则类闭»` only `goes`. Say "the forward direction at an occurrence that conditions something, the converse where it is decided".

8. **Low** — 07:571 "no law of the dynamics chooses between them" is an unprovable negative stated flat inside a reading (repeating §4.7). Per the repository's own lesson on negatives about the grammar, prefer "no law stated here chooses between them".

9. **Low** — Module docstring "Read together" paragraph (63–69) is a reading but is not marked as one, while 07 marks the same text "[AI reading, new]". Add "Read together [reading]".

10. **Low** — 07:566 and record 1 law 4 call the LHS of `«各本类常闭则续无外即一之续无外»` "the condition along the net"; `«续无外»` takes one class, and the LHS is its per-center-class variant. "the per-center condition along the net" is exact.

11. **Low** — §4.7's table (07:511) still says of the widest self's P2 "this application is argued, no Lean states it". `«后类本类常闭»` (given any class meets both) and `«类闭则本类常闭»` with `«所闭之闭»` now come close; either cite them with their premise or leave the cell as is deliberately. Not wrong, but a reader will see the two sections disagree.

12. **Low** — Record 2 `statement`: "where its acts return under coupling by threshold only, and its line is its loop" lets the threshold-only qualifier be read as attaching only to the return clause; `couplingClass_line_iff_loop` also needs it. Reorder: "and, with coupling by threshold only, where its acts return and its line is its loop."

13. **Low** — 07:583 "Where they do not return, some effect lies on no line from it": by `couplingClass_reach_iff_returns` the failing item is something downstream at some remove, not necessarily a direct effect. "some occurrence downstream of it".

**Witnesses:** `JoinBreaks` (blocks {m,a},{x,z},{w} and {m,a,x},{z},{w}; join block {m,a,x,z}, z→w leaves), `MeetBreaks` (crosswise pairing; meet at m fails on m′→c,d; idle n), `ReturnsNotRegular` (f↔k, g→f, g→h; reach and P4 at f, P2 fails via g→h) each show what the prose says. Cross-references: 01 §1's paragraph on dated occurrences (01:37) does support "a net of dated occurrences, having no cycle"; §3.3's route (b) is as the reading says except for finding 6; step study §7 item 1 is as finding 1 says.

### Verdict

The theorem text of §4.8, the module docstring's bullets and both records' `laws`/`hypotheses`/`does_not_show` say what the Lean proves, with premises placed correctly, and the near-definitional parts are called so. The weaknesses are concentrated in the two Readings: one sentence (finding 1) is false as written and needs P2 and the "forward reach" sense made explicit; "the net fixes it"/"settles which class" overstates a result that fixes the least class and the reach (2); `«后类»`'s P2 is stated unconditionally where the Lean has a premise (3); P2 is silently presupposed in "nothing left but P4" (4); `couplingClass_closed`'s `goes` is dropped in 07 and record 2 (5); and the flow reading equates the loop, which lies in the influence closure, with route (b)'s "what it depends on" (6). With those six edits the section states exactly what `Becoming.OwnClass` proves.

---

## What was done (AI-written, the author)

The section the reader calls §4.8 became §4.10 after the read, since G1 holds §4.8 and G3 §4.9. Nothing in it changed with the number.


Every finding was taken, in 07 §4.8, the module's docstring, the note and the records:

1. The sentence is replaced by the reader's form, granted P2, citing `«本类常则闭当且仅当所及即一之所及»` and `«后类»`. The step's study's "privileged relation" is now called a reading.
2. 07, the docstring and record 1's correspondence now say that the net fixes the least class and what every such class reaches, and not which class is one's own.
3. A lemma is added, `«判则后类本类常闭»`: `«后类»` meets P2 where it is decided, of each occurrence downstream, whether it conditions something. 07, the docstring and the note now state `«后类»`'s P2 with that premise, or wherever any class meets both (`«后类本类常闭»`).
4. "Granted P2" is added wherever the de se question is said to reduce to P4. 07 and the note add that without P2 classes holding one's effects can differ in reach (`Inconstant`, `OtherLeaves`).
5. "At a formation that affects something" is added in 07 and record 2's law.
6. 07, the note and record 2 now say "route (b)'s outer bound, the influence closure". They add that the feeding closure lies inside it and the loop is not shown to lie within the feeding closure. "Is route (b)" became "lies within route (b)'s outer bound".
7. The two directions of the closure form now carry their own premises.
8. "No law of the dynamics" became "no law stated here".
9. The docstring's paragraph is marked "[a reading, not a theorem]".
10. "The per-center condition along the net", with its sense spelled out in 07.
11. §4.8 now says that `«判则后类本类常闭»` states in Lean, with its premise, the regularity §4.7's table gives the widest self by argument. §4.7's own cell is left as it is, since that wording is AG's to revise.
12. Record 2's statement now puts "with coupling by threshold only" before both the return and the loop clauses.
13. "Some formation downstream of it lies on no line from it."
