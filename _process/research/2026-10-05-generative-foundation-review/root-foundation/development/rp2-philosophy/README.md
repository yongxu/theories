# RP2: the philosophy dossier, kit

Board item RP2, 24 October 2026 ([Ren's choice](../../../../../../sources/15-codex-theory-conversations/2026-10-24-philosophy-dossier.md)). The dossier is [`theories/becoming/review/PHILOSOPHY.md`](../../../../../../theories/becoming/review/PHILOSOPHY.md), the packet's fourth, in the format of the [logic dossier](../../../../../../theories/becoming/review/LOGIC.md). AI-authored throughout.

## How it was built

- **Sources.** Chapter 7 as it stood after IV3k (`4b385daac`), GS2–GS5 and SW; the glossary; PW's note §6f as corrected on 24 October (steps 4–5 witnessed, their general form open) and PW's [item on the crux](../pw-step-forward/CRUX-ITEM-FOR-RP2.md), taken and adapted as P-20 (board rule 2); SW's note §1–§2.
- **Lean.** [`lean_statements.py`](lean_statements.py) copies statements from the core sources, theorems cut at `:=`, definitions whole. Every block in the dossier was compared with the sources after writing: no mismatch.
- **Quotations and names.** The packet's [`check_dossiers.py`](../review-packet/check_dossiers.py) checks every `Quote [path]: "…"` against its file and every backticked Lean name: 0 problems for the dossier and for the whole packet.
- **Review.** An independent reader (a separate AI agent with no part in writing it) checked faithfulness to chapter 7 and the Lean, the literature, neutrality of the questions, clarity and coverage, in two passes; what it found and what was taken is in study §398.

## References, as checked on 24 October 2026

Each against a publisher, catalogue, PhilPapers or proceedings record found by web search; page ranges only where the record gave them.

| Work | Record checked | Note |
|---|---|---|
| Gewirth 1978, *Reason and Morality* | University of Chicago Press listing; Penn and CiNii catalogues | xii+393 pp. |
| Goodpaster 1978 | PhilPapers: *Journal of Philosophy* 75(6):308–325 | |
| Jonas 1984 | NYPL, Penn and USI catalogues (University of Chicago Press, 1984; trans. with David Herr; original 1979) | |
| Johnston 2010, *Surviving Death* | Princeton University Press; De Gruyter record | Hempel Lecture Series |
| Korsgaard 1996 | Cambridge Core book page; Tanner Lectures 1992 | |
| Lewis 1979 | *Philosophical Review* 88(4):513–543 (JSTOR 2184843, PhilArchive) | |
| Næss, "Self-realization" | Keith Roby Memorial Lecture, Murdoch University, 12 March 1986 (archived copy); Shambhala 1995 catalogue record of Sessions (ed.), *Deep Ecology for the 21st Century* | A 1987 *Trumpeter* 4(3) printing, cited in AI recall, was **not** found in any record and is not cited. Pages in Sessions not confirmed. |
| Nagel 1970 | BnF and university catalogues; *Canadian Journal of Philosophy* critical notice (Clarendon Press, 148 pp.) | |
| Parfit 1984 | standard; parts cited, not chapters | |
| Parfit 1997 | PhilPapers: *Ratio* 10(3):202–221 | |
| Perry 1979 | PhilPapers: *Noûs* 13(1):3–21 | |
| Prior 1960, Schurz 1997, Sen 1970 | as checked for the logic dossier | |
| Scheffler 2013 | OUP record (ISBN 9780199982509, ed. Niko Kolodny, with Wolf, Frankfurt, Shiffrin, Kolodny) | |
| Siderits 2003 | university catalogues (Ashgate World Philosophies Series) | |
| Taylor 1986 | Princeton University Press; catalogues | |
| Turner, Smith, Shah, Critch, Tadepalli 2021 | NeurIPS 2021 proceedings page; arXiv 1912.01683 | |
| Williams 1976 | catalogue of Rorty (ed.), *The Identities of Persons* (University of California Press, 1976), listing the essay | Pages not confirmed. |
| Crisp 2003 | *Ethics* 113(4):745–763 (bibliographic records; Temkin's reply in the same volume) | |
| Dreier 1993 | *The Monist* 76(1):22–40 (stafforini record; OUP Monist issue) | |
| Fine 1975 | PhilPapers: *Synthese* 30(3–4):265–300 | |
| Frankfurt 1987 | *Ethics* 98(1):21–43 (JSTOR 2381290) | |
| Hare 1981 | Oxford Academic book page; CiNii (Clarendon Press, 1981) | |
| Hyde 1997 | PhilPapers: *Mind* 106(424):641–660 | |
| Kagan 2019 | *Utilitas* review record (OUP, 2019, x+309) | |
| Kamm 1993 | OUP book page; *Canadian Journal of Philosophy* notice (New York: OUP, 1993) | |
| Kiesewetter 2015 | Bielefeld and ANU repositories: *Ethics* 125(4):921–946 | |
| Krakovna and others 2018 | arXiv 1806.01186 (titles and revision history) | |
| McMahan 1981 | University of Chicago Press page, doi 10.1086/292301: *Ethics* 92(1):96–127 | |
| Moore 1903 | fair-use.org text of §§59–62 | the argument runs across §§59–62, not §59 alone |
| Narveson 1967 | stafforini record; Cambridge Core: *Mind* 76(301):62–72 | |
| Portmore 2011 | Oxford Academic book page; *NDPR* review | |
| Raz 2005 | *JESP* journal page, vol. 1 no. 1 | |
| Restall and Russell 2010 | PhilPapers RESBTI; Restall's page (Pigden (ed.), Palgrave, 243–259) | author order Restall first; also titled "Barriers to Consequence" |
| Scanlon 1998 | library catalogues; *Economics and Philosophy* review (Belknap, ix+420) | |
| Scheffler 2018 | catalogues; *Utilitas* review (OUP, viii+146) | |
| Shue 1980 | catalogues (Princeton University Press, 1980) | |
| Sidgwick 1907 | the Book IV, chapter II text (laits.utexas.edu) | edition of that text not stated; 7th edition is the standard citation |
| Taurek 1977 | stafforini record and PhilPapers: *Philosophy & Public Affairs* 6(4):293–316 | |
| Turner, Hadfield-Menell and Tadepalli 2019 | arXiv 1902.09725 | venue beyond arXiv not confirmed, so not given |
| Voorhoeve 2014 | LSE repository and PhilArchive: *Ethics* 125(1):64–87, doi 10.1086/677022 | |
| Williams 1981 | catalogue records and the reprint in *Moral Luck*, pp. 101–113 | first published in Harrison (ed.), *Rational Action*; its year is given as 1979 or 1980 |

## The front sized for a person (RP2b, 31 October 2026)

This is board item RP2b: the release gate's item 6 as amended on 31 October ([WHAT-REMAINS](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md#the-release-gates-item-6-sized-for-a-person-31-october-2026)). The coordinator routed it to RP2's owner together with the reader edition. The worked examples were AJ4's alignment dossier (branch `aj4-human`) and FM's map (branch `fm-readers`).

- **Why.** The old front was 1,067 words, within ten minutes by count. It gave the question, the times, how the dossier was made and the conventions. It did not give the two premises' roles, what is proved, what failed or what is asked, so a person had to read the items to learn them.
- **What changed.** The dossier now opens with `## The dossier in ten minutes`. It gives:
  - the question;
  - the two premises with their roles, and what the warrant does not reach;
  - what is proved, each result with its base and deciding premises;
  - the open question, with §4.6's P1 to P4 and the standing of each;
  - T8, and T5 with its two tests as they fell;
  - what is not claimed, and what is asked;
  - the times.

  Then come:
  - `## The items`: the parts with item links, and how to read each item's fields;
  - `## Terms`: the old conventions, whole;
  - the items, the references, and the response form, now anchored;
  - `## How this dossier was made`: the old paragraph, whole, in bullets, with this change recorded.

  The 27 items are unchanged, except that P-26 now carries the AI label on the gloss of 生生 (D1). 07 omitted that label then; HE2 (landed 31 October 2026) has since added it in §2 and in §8's T8. After RV21b scoped 07's D65 reading (it locates the boundary that power-seeking results leave open and does not answer that question in its own terms), P-25 gives the reading as locating that boundary and quotes the chapter's scope.
- **Measures.** These use the counting in AJ4's `kit/measure_layers.py`, ending the part at the alignment dossier's pattern `^(## The items|###? P-01)`.
  - The part: 1,114 words, 8.6 to 11.2 minutes, and it states its time. That is 15 words over the budget of 1,100. The excess is items that may not be cut, restored by the review (amendment 1).
  - The one-hour path (the part with P-04, P-05, P-07, P-10, P-11 and P-20): 4,386 words and 177 characters, 34.4 to 44.7 minutes.
  - The whole dossier: 13,190 words and 263 characters, 102 to 133 minutes, "about two hours" as the cover says (13,141 words before P-25 quoted the chapter's scope of D65).
  - With the kit's old pattern for philosophy (`^###? P-01`), the front would also count the item list and the terms: 1,843 words. AJ4's owner was told on 31 October, and the measure (on `aj4-human` at `9e128d30e`) now reads every dossier's front as alignment's, with a row for this hour; its readings at `3ae441d97` agree with these, and its version at `33f5c4ebd` gives the same part and hour on this branch after main's RV21b was merged.
- **Checks.** `check_dossiers.py` reports 0 problems. All seven parts of the reader edition build (`tools/publishing/build_review_packet.py`). In PHILOSOPHY's edition every in-document link resolves (95) and no checker markup is left. In the LOGIC and CLASSICAL-TEXTS editions, the markup itself is converted, but the sentences explaining it (Source [ID], 原文〔ID〕, 引〔路径〕) remain, a small mismatch, noted in the board's RP row on 31 October for the next touch of those fronts.
- **Review.** One independent AI reader, read-only and with no part in the writing, checked the part against the items, chapter 7 and AGENTS.md. It found 2 errors:
  - the free-parameter hypothesis was dropped from P-01's sentence, which then contradicted the de se reading before it;
  - an AI label was cut.

  It also found 11 imprecisions or clarity problems:
  - P2 lacked "at oneself", and its gloss was weaker than the condition;
  - the path's support was overstated;
  - P1 was said to be shown by a witness;
  - the closing's "nothing dropped" was false, and neither the packet nor P-11's form of the question was named;
  - the step of invariance was undefined;
  - T8 was truncated, and the gloss of 生生 was unlabelled;
  - the standing of P2 and P4 was merged with P3's;
  - the path's conclusion was not said to be a law;
  - three hypotheses were missing from the results on self-concern;
  - several terms were undefined;
  - the provenance named the release gate.

  Every finding was taken. Cuts elsewhere kept the part near its budget: a repetition, and the population-ethics clause of question 2, which P-07 keeps in full.

## The re-sync of 2 November 2026

The dossier was read against what had moved around its citations since `33d06e9b7` (31 October), the first dossier re-synced by the freeze's rehearsal ([the steps](../review-packet/FREEZE-STEPS.md)), at `2cab11114`. [`resync_report.py`](../review-packet/resync_report.py) flagged 11 of 27 items, 15 of 135 quotations and 9 of 29 linked sections, and every check had passed through all of it.

- **What changed.**
  - P-16 gained the result on self-concern and C (`increasingInOwn_iff_increasing_iff_unrestricted`, `Web.extension_ranked_of_increasingInOwn`), with its limits as known weaknesses and a second question, and the front a line on it, since item 3 would otherwise understate what self-concern reaches.
  - P-02 gained what a standpoint is on the theory's reading (`forced_iff_center`).
  - P-08 and Terms follow chapter 7's wording of *sub-true* and *super-true*, and the scope bullet states the condition as chapter 7 does.
- **Left out, on reading.** `r-when-holding-for-a-reading-stands-above-a-route`: the alignment dossier carries it, and it adds nothing to what this dossier asks.
- **Measures.** The kit's counting, on this text:
  - The part: 1,156 words and 2 characters, 8.9 to 11.6 minutes, 57 over the budget of 1,100 with a character counted as half a word. The excess is the earlier 16 and the new line. Amendment 1 protects the line's hypotheses, not the line: keeping it is a judgement, which the measure warns of and does not block (amendment 2).
  - The hour: 4,428 words and 177 characters, 34.7 to 45.2 minutes.
  - The whole: 13,721 words and 261 characters, 106.5 to 138.5 minutes, stated as 105 to 140.
  - After PF3 landed the same day, on the merge: the part 1,173 words and 2 characters, 9.0 to 11.7 minutes, 74 over; the whole 13,981 words and 261 characters, 108.5 to 141.1 minutes, stated as 105 to 145; the hour 4,603 words and 177 characters, 36.1 to 46.9 minutes.
- **Review.** One independent AI reader, read-only and with no part in the writing, read the changes against chapter 7, the Lean and AGENTS.md. It confirmed that `Extension` there is exactly the page's widening (`Web.paths_extension_iff_widens`), so that "the wider of two courses as C asks" says what the theorem says. It found:
  - in P-16, two hypotheses dropped (every claim counted as living; each item marked by its formation), and chapter 7's third not-shown left out;
  - P-16's second question saying "courses whose admissions end" where listing implies ending and not conversely, with admission decided dropped too;
  - in the front, "such an order" with no antecedent, and "listed courses", which can read as courses on a list;
  - the standing lacking its base and "conditional", a result assuming the condition sitting unmarked in a part called "without the step", and *drawn* left without a gloss.

  Every finding was taken. Its findings on the kit are taken in [the steps](../review-packet/FREEZE-STEPS.md).

## The re-check of 3 November 2026

The dossier was read against what had moved since `2cab11114`, PF3 above all. [`resync_report.py`](../review-packet/resync_report.py) flagged 11 of 27 items.

- **What changed.**
  - P-02 gained chapter 7 §1's sorting of what is shown, read and supplied, with *standard* in Terms and the one link through the relation (`Web.selfValuation_feeding_own`).
  - P-21 gained the law of a common response, stated with its exact existence condition.
  - P-04, the front and P-20 gained C's exact role: a ranking needs C or a premise in its place.
  - P-20's known weaknesses gained the crux as chapter 7 §4.7 sharpens it (the theorem moves the question into the class; P2 excludes the organism, so P4 carries the crux; `selfAscribed` takes the de re reading); P-03, P-11, P-26 and P-20's fourth question gained what §4.7 says of them.
- **Measures.** The kit's counting, on this text:
  - The part: 1,180 words and 2 characters, 9.1 to 11.8 minutes, 81 over the budget of 1,100 with a character counted as half a word. The excess is the earlier 74 and the words C's exact role takes; those hypotheses are what amendment 1 protects.
  - The whole: 14,535 words and 261 characters, 112.8 to 146.7 minutes, stated as 110 to 150, rounded out to five minutes.
- **Review.** One independent AI reader, read-only and with no part in the writing, read the change and the other flagged items against chapter 7, chapter 3 and the Lean. Every finding was checked against the source and taken:
  - errors: "Ranking still needs C" in the front and P-20, which 07 had replaced with "or a premise in its place", and which the front's own item 3 contradicted; "Chapter 7's newest section" for §4.6, since §4.7 is newer;
  - misleading: my new sentence on §1's sorting stood in P-01, when P-02 is the item carrying §1's title unqualified; P-21's new sentence never stated the law; "That is a law, not only a reading of witnesses" lacked 07's own limit; P-04's quotation stopped before "in general alone"; §4.7's sharpenings were absent;
  - minor: P-26's clause on actors of whatever substrate, P-20's fourth question, and P-03's "recorded nowhere else" where 07 now raises it.
