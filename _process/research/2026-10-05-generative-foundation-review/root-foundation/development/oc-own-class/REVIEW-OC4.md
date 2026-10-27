# OC4: second check of the crux's texts after OC2 and OC3

> Saved by the lander, 27 October 2026. One reviewer, a separate AI agent working read-only, returned this report as text, since its harness kept it from writing a file; it is kept here as returned, with only this note added and the lander's verification appended as section 6. Its scratch Lean is [review-oc4/OC4Doubts.lean](review-oc4/OC4Doubts.lean), copied byte for byte (sha256 `b504a21b…`). Line numbers refer to main at `cba4a923e`.

**Method**
- Main is at `cba4a923e`. `GrammarPath.lean` has not changed since `ff8e83159`.
- Its sha (`471420ce…`) matches receipt `20261025T160649.851818Z` (86 theorems in 132 declarations) and the record.
- All 95 names cited in 07 §4.6 exist, and all 21 quotes of 07 in P-15 and P-20 are verbatim.
- `OC4Doubts.lean` holds 14 checks (Lean 4.29.1, Init only), every axiom report empty.
- I recompiled a copy of REVIEW-OC1's `Doubts.lean`; it gives the same axiom reports.
- The repository was not touched.

No proof is wrong. Part A finds 2 errors, 8 imprecise claims and 2 clarity points. Part B finds 6.

## 1. Findings (Part A)

### Errors

**A1. The what-leaves record's third law states a witness as a law.**
- **Where:** `what-leaves-a-class-follows-its-line.json`, `laws[2]`, en and zh: "In a finite net without cycles, a class holding a member and part of what follows it **is** constant up to the net's end though not constant, … follows every **step** of its line that conditions anything."
- **Lean:** `FiniteWake.constant_to_end`, `.not_constant`, `.not_held` and `.wake_follows` describe one net. Against them stands `CleanStep.not_constant_to_end`.
- **Why it differs:** read as a law, the sentence is false in the same module.
  - `CleanStep` is finite and has no cycles (scratch `CleanStepCopy.acyclic`).
  - Its class holds m together with i and j.
  - It is not constant up to the net's end.
  - REVIEW-PF2 item 1 made 07 say "can be"; the record still says "is". "Step" also stands for an occurrence here.
- **Replace with:** "…**can be** constant up to the net's end though not constant, not holding the member's effects, while something outside it follows every **occurrence** on its line that conditions anything (a witness)." In zh: "可至网之终有常…其线上每一有所缘者…（见证）".

**A2. P-18 still glosses P2 by its consequence.** This is outside the assigned list, but it is in the dossier.
- **Where:** PHILOSOPHY.md:352: "constancy up to the net's end, a class under which a line ends only where the net itself ends (its P2, an AI reading)".
- **Lean:** `«本类至终有常»`, `CleanStep.ends_where_net_ends`, `CleanStep.not_constant_to_end`.
- **Why it differs:**
  - In `CleanStep`, every line under the class ends only where the net does, yet the condition fails. So the gloss is strictly weaker than the condition it is used to define.
  - The gloss is stated for the whole class, while P2 now reads one's own class.
  - REVIEW-OC1 #8 fixed this in 07 and P-20, but not here.
- **Replace with:** "…as constancy up to the net's end at one's own class (its P2, an AI reading): whatever an occurrence alike to oneself conditions, every alike occurrence that conditions anything conditions something alike to it; this asks more than that one's line end only where the net does."

### Imprecise

**A3. P2's consequence holds only for a line that takes a step.**
- **Where:** 07:362, "It is a regularity of its own, and one's line ends only where the net itself ends (`«亡而网续则本类不至终有常»`)". The same wording is in P-20's P2 and its third question.
- **Lean:** the cited theorem needs `hxy : «续» R E x y`, a step into the end.
- **Why it differs:**
  - The theory says a line "ends at" any occurrence where it is `«亡»` (the `ends` hypothesis of `«过亡而续»`). "On one's line" includes oneself (`«所及»`).
  - Read with the split, `FinerOutside` meets P2 at m (`split_constant_at`). Yet m ends at once while it still conditions b (scratch `ZeroStep.ends_while_net_goes`).
  - The class of a single moment meets P2 at every member of every net (scratch `moment_at`).
  - So, unless "a line" in P2 must take a step (the text does not say so), P2 alone admits the momentary self while it excludes the organism.
  - P4 together with acting removes this case (scratch `acting_held_continues`), so the path itself is unaffected.
- **Replace with:** "It is a regularity of its own: wherever one's line takes a step, it ends only where the net itself ends (…). A self that ends at once, a single moment, meets it trivially; P4, with acting, excludes that."

**A4. "An effect one leaves out" says more than the cited law.**
- **Where:**
  - 07:362 (P2): "enters through what is alike to an effect one leaves out".
  - 07:386: "Where one does not hold them, the division enters P2 only through what is alike to an effect one leaves out (`«外分唯系出类之同»`)".
- **Lean:** the law's hypothesis `outside` ranges over the effects of every `u` with `E m u`, not only the member's own.
- **Why it differs:**
  - The claim about one's own effects alone is true where one conditions something (scratch `ownOutside`, empty axiom report).
  - It is false where one conditions nothing (REVIEW-OC1's `T1.goes_needed`).
  - At 07:386 one acts, so that sentence is true, but no Lean states it. P2 does not say that one acts.
- **Replace with:** either land `ownOutside` and cite it (P2 then says "where one acts, …"), or write "an effect that an occurrence alike to oneself leaves out" in both places.

**A5. Witnesses are read as universal claims, and the premises are ranked wrongly.**
- **Where:**
  - 07:377: "where it fails at one's own class, holding one's effects gives nothing beyond the first step …, and without P4 the regularity gives nothing beyond the class (`Unclosed`)".
  - P-20:391: "If either fails, that scope rests on the step."
- **Lean:** `Inconstant.not_all_follow` and `Unclosed.not_taken_in` are witnesses; also `«线内同类»`.
- **Why it differs:**
  1. The witnesses show "need give nothing", not "gives nothing".
  2. No line ever leaves its class (`«线内同类»`), so "nothing beyond the class" is true with P4 too.
  3. The reach is exactly "everything downstream of one's acts is alike to oneself" (scratch `reach_iff_downstream_alike`). So P4 is necessary (scratch `p4_of_reach`), but P2 is not: in scratch `NoP2.reach_without_P2`, P2 fails at one's class, P4 holds, and everything downstream still lies on one's line.
- **Replace in 07 with:** "…holding one's effects need give nothing beyond the first step (…). P4 cannot be dropped at all: an effect not alike to oneself lies on no line under one's class (`«线内同类»`); `Unclosed` shows it for a line that runs through a condition."
- **Replace in P-20 with:** "If P4 fails, that scope is not reached along one's line; if P2 fails, it is reached only where everything downstream of one's acts happens to be alike to oneself, and otherwise rests on the step."

**A6. P3 follows from P4.**
- **Where:**
  - 07:363, "(P3) One's line runs through the conditions one affects."
  - 07:390, "it is not shown for actual selves".
  - P-20, "P3 is a correspondence".
- **Lean:** scratch `p3_of_p4`. From `«所缘同于» R E m` and `R m c` it follows that `«所及» R E m c`. Affecting a condition is conditioning it (`SharedCondition.affecting`). For a condition reached through a chain, `«本类常闭则后皆续»` gives the same.
- **Why it differs:**
  - P3 does no work in steps 3–4 or in the conclusion, and it holds wherever P4 does.
  - What stays open as a correspondence is that the conditions one affects feed other lines, which is the conclusion's "where" clause.
- **Replace with:** "(P3) The conditions one affects feed other lines", followed by "P3 is a correspondence: …". Or keep P3 as it is and add "(it follows from P4)".

**A7. The what-leaves record's other fields.**
- **The statement.** `statement.en` says "a step with nothing outside breaks constancy".
  - `«出类不随则不至终有常»` concludes ¬`«至终有常»`. "Constancy" (有常) is the stronger notion, so the clause is true but names the wrong one.
  - "Step" stands for an alike occurrence. The same use survives in the zh "…之步", in the root bullet, and in the README rows ("every alike step", "每一同类之步").
- **What it does not show.** `does_not_show[2]` says "for a class with more than two blocks it does not", which implies that two blocks suffice. They do not.
  - Scratch `TwoBlocks` is a counterexample: m→i, m→y, c→x, with the split {m,c,i} against {x,y}.
  - Every leaving effect is followed at every alike occurrence that conditions anything (`leaving_follows`).
  - Yet the class fails even at m (`not_at`), because what stays does not follow.
  - REVIEW-PF2's two-block claim needed "with its counterpart for what the class holds".
- **The correspondence.** "Never clean" is not defined in the record.
- **Replace with:**
  - Statement: "…an alike occurrence that conditions something but nothing alike to that effect breaks constancy up to the net's end…".
  - What it does not show: "…not even with two blocks unless what stays follows too, and with more than two not even then (the three-block net…)".
  - Correspondence: "…every alike occurrence that conditions anything leaves something outside".

**A8. P-15 quotes a D64 sentence that asserts reach.**
- **Where:** P-15, quoting 07:258: "What comes after every present center is reached by a line under a class that continues past one's end", followed by "or by the step".
- **Checked against:** §4.6 reaches only what is downstream of one's acts, and only under P1–P4 (`«本类常闭则所及皆及»`). It leaves the rest to the step (07:379).
- **Why it differs:**
  - "Is reached" asserts what §4.6 makes conditional and partial.
  - "A class that continues": classes don't continue; lines do (`«过亡而续»`).
  - "The step" stands among time steps in the same paragraph.
- **Replace (in 07 and P-15) with:** "What comes after every present center can be reached only along a line, under a class coarser than one's organism, that continues past one's end, or by the step of invariance."

**A9. Wording in step 1 and in the module doc.**
- 07:368 says "needed only where nothing lets that continuation go on". `Flow.needs_iff_none_of_inactive` is about drawing past the stock over a finite stretch, and the glossary reserves "go on" for 延. Replace with "only where no such flow lets that continuation draw past the stock, that is, only vacuously".
- `GrammarPath.lean:32` names `FiniteDescent`, which does not exist; it should be `FiniteFamilies.one_not_constant`. Line 7's "goes on past" is the deferral §413 records.

**A10. Small points in the study.**
- §411's Delta says "even where every alike occurrence both stays and leaves (FinerWake)". In FinerWake, i and j are alike and condition nothing. Add "that conditions anything".
- §411's "What it says" gives "since nothing leaves" as the reason. That holds only where P2 holds; where it fails, every division gives the same failure.
- §411, the record's history (en, zh) and REVIEW-OC1's own summary all say "9 imprecisions". REVIEW-OC1 numbers 10 of them (findings 5–14), 18 findings in all.
- §413 says "in a finite net it still ends, later". It needs "without cycles": a finite two-element cycle goes on (延) (scratch `FiniteCycle.goes_on`).

### Clarity

**A11. The constancy-read record's `laws[2]` is circular.** It says "the class that holds a member's effects without the regularity fails it at the member", where "it" is the regularity itself. Replace with: "in `Inconstant`, where the class holds the member's effects but what follows them is not alike to it, the class fails it at the member".

**A12. The denial of P4 cites the global law, and one witness lacks a lemma.**
- 07:387 says "such a class, constant up to the net's end, has something outside it follow …". P2 asks only the condition at one's own class, and `«本类出类随行»` gives this from it. Say "meeting P2" and cite that law.
- `FinerWake` has no `finer_class` lemma, though `FinerOutside` has one. It is trivial, but "dividing … apart" assumes it.

## 2. A philosopher's reading (Part B)

**B1. The first closing question is not well posed.**
- **Where:** the first question (07:389, P-20), "a line that ends, or … the regularity one's acts keep going", and 07:385, "one can presuppose the significance of a line that ends".
- **Why it is not well posed:**
  - Without cycles, every line in a finite world ends, P2's lines included (P-20's own weakness says so). A single moment passes P2 (A3).
  - What P2 excludes is a line that ends while its last stage still conditions something.
  - "Keep going" suggests going on without end.
  - "One's acts keep [it] going" already builds in P4.
- **Plainer:**
  - The question: "in acting, does one presuppose the significance of a line that ends while its last stage still conditions something, or of a class whose line, once it takes a step, ends only where the net does?"
  - The denial: "…of a line that ends while what it conditions continues."

**B2. "Past one's own end" (Conclusion; P-20).** Under P2, one's own line ends only where the net does, so the end being passed is the organism's. A reader takes it as the self's end and sees a contradiction. Plainer: "…and past the end of one's organism's line."

**B3. The second closing question.** P4 asks this of all of one's effects. Holding only some of them is the coherent denial the text itself offers, and "one's effects are one's own" fits that denial too. Plainer: "Are **all** of one's effects one's own, in the sense of whose losses count, not of what one answers for?"

**B4. 07:386 cannot be followed:** "what it asks is that one's effects recur by kinds drawn in what lies outside oneself, a regularity read off the rest's division, not off oneself. The split … draws no kinds there". Plainer: "What a finer division adds is a demand on what one's acts leave outside: every occurrence alike to oneself that conditions anything must leave something of each kind that any of them leaves, the kinds being fixed by how the world outside oneself is divided, not by oneself. The split of oneself from the rest puts everything outside in one kind, so it adds no such demand."

**B5. 07:387:** "so such a partial holding draws its line by the identity in question". Plainer: "One's later stages are effects too, conditioned through what one takes in; so a holding of only some effects must decide which effects are one's own by the very identity in question [AI reading]."

**B6. 07:369 (quoted in P-20):** "In time, self-concern alone is kin-shaped." It rests on TwoLines, where lines share nothing. "Kin-shaped" is a metaphor, and "alone" is not explained. P-20's fifth question adds the needed "until lines share conditions". Plainer: "So, read with time and before shared conditions enter, self-concern without the step reaches only one's own line of descent."

## 3. REVIEW-OC1's findings 1–18

1. Fixed; the correspondence is exact in en and zh.
2. Fixed in the statement, laws 2 and 4, the root bullet, the README rows (en and zh) and the checker scope. §408 is corrected in §411.
3. Fixed.
4. Fixed.
5. Fixed in OC1's texts. Partly fixed nearby: "step" for an occurrence remains (A1, A7), "go on" remains in step 1 (A9), and module line 7 is deferred under §413.
6. Fixed.
7. Fixed.
8. Fixed in 07 and P-20. The consequence itself needs a step (A3), and the old gloss survives in P-18 (A2).
9. Fixed.
10. Fixed; `Inconstant.not_constant_at` has an empty axiom report and is cited.
11. Fixed in 07, P-20's step 2 and P-18's weakness bullet.
12. Fixed.
13. Fixed.
14. Fixed through §411.
15. Fixed (`«外分唯系出类之同»`), but it is now cited for more than it says (A4).
16. Fixed in 07. The same defect remains in what-leaves' third law (A1).
17. Fixed.
18. Fixed; "applied both ways" is exact (scratch `sameVerdict`, recompiled).

## 4. Claims found exact

**07 §4.6, theorem blocks**
- All of "What a line must hold", including "(needed where the start is another occurrence alike to it)" (scratch `GoesNeeded.fails`).
- All of "What leaves a class follows its line".
- The whole at-class block:
  - bullet 1;
  - the seven at-class forms, with the same hypotheses as the global ones;
  - `«亡而网续则本类不至终有常»` and both organisms;
  - CleanStep's two theorems;
  - the family and held classes;
  - `Inconstant.not_constant_at`;
  - every division citation, including "applied both ways" and "where a predicate decides";
  - every theorem and net of FinerOutside, FinerWake and UnevenOutside.

**07 §4.6, the argument**
- P1 and P4.
- Steps 2–4, every citation (`goes` from acting, `held` from P4, `atClass` from P2).
- In the conclusion: the law sentence, "Given the regularity…", and "rests on one premise" taken as a reading.
- "What the path does not reach".
- The constancy and organism sub-bullets.
- "Which class P2 reads", apart from A4 and B4.
- FiniteWake passing P2.

**The records**
- Constancy-read: statement, laws 1, 2 and 4–7, hypotheses, does_not_show 1–5, next_delta and correspondence. Its 57 cited declarations are exactly OC1's and OC2's additions (GrammarPath went from 75 to 132 declarations between the receipts).
- What-leaves: laws 1–2, does_not_show 1, 2 and 4, and next_delta.

**PHILOSOPHY.md and the study**
- P-20: every citation and steps 1–4.
- §411: findings 1–18 as summarized, the corrections to §408, the counts and the constructivity note.
- §413: the Delta. Every text it lists now says "continues past".

**The Lean module**
- The docstrings of `«本类至终有常»`, `«外分唯系出类之同»`, `«闭则外分无关»`, `«内外皆缘则二分本类常»`, `Inconstant.not_constant_at`, both CleanStep theorems and FinerWake.
- The module-doc bullets "At a member's class" and "Neither premise can be dropped".

## 5. Not checked

- I did not rerun the package build or the checker; I relied on the receipt and my scratch copies.
- In zh, I read only the two records' statements, laws and correspondence.
- I did not check the records' `.md` renders, chapter 08's counts, or README rows other than GrammarPath's.
- For GrammarCases I checked only the statements cited, not their docstrings.

## 6. The lander's verification (27 October 2026)

- **The scratch Lean.** `review-oc4/OC4Doubts.lean` was compiled again with the package's toolchain (Lean 4.29.1, `Init` only): all 14 `#print axioms` lines report no axioms. The definitions it copies are those of `Grammar.lean`, `GrammarMap.lean` and `GrammarPath.lean`, word for word. `CleanStepCopy` is `CleanStep`'s net, and `ZeroStep` is `FinerOutside`'s (m→b, c→d, the split {m, c} against {b, d}), read at a line of no step.
- **Each finding** was checked against the statement of every declaration it cites and against the cited line, and each holds. On A6: `SharedCondition.affecting` is the net's relation itself, so affecting a condition is conditioning it, and P4 puts every condition one affects on one's line in one step.
- **Two suggested wordings were narrowed.**
  - A7: the three-block net of the IV3 line's review of PF2 (`ThreeBlocks`) refutes only the weaker form, something outside following every alike occurrence that conditions anything; nothing in its class is conditioned. Asked with "alike to that effect" at every member alike to the member, together with its counterpart for what stays, the condition at the member's class is met for any number of blocks, given a decided class, since those are its two cases. So the record's text says: even with two blocks what stays must follow too (`TwoBlocks`), and with more than two what leaves must follow as something alike to it, not only as something outside.
  - A8: "can be reached only along a line … or by the step of invariance" says that no third route exists, which no Lean shows. The reading keeps its contrast with need instead: what comes after every present center "is reached, if at all, not along need but along a line under a class coarser than the organism, continuing past the organism's end, or by the step of invariance".
- **Also found.** A9's wording ("only where nothing lets the continuation go on") stood in D64 in DELEGATED-CHOICES too, beside A8's sentence; both are fixed there.
- **Ownership.** The texts of the IV3 and OC lines (P2, step 1, the conclusion's closing sentences, which class P2 reads, D64 and its reading, the records constancy-read-at-a-members-class and need-and-feeding-read-with-time) were fixed in OC4's landing, with the dossier's quotations and glosses of them. The PF line's places (PF2's record, P3, the two questions, the conclusion's end, the reply to the denial of P4, step 2's last sentence, the consequence in that denial) went to its owner as proposals (a) to (l); the study section says which were applied. Lean comments wait for the next landing that rebuilds `Becoming.GrammarPath`.
- **Not checked by the lander either.** The package build: no Lean file changed.
