# Codebook: measures, their findings and what became of them

*For the coders. AI-written (a Claude Code session), not yet reviewed by a person; written 5 November 2026, before any case was read. About 45 to 58 minutes to read.*

You will code a set of **measures**: rankings, scores, ratings or targets by which some body ranks, selects or rewards people or institutions. Each case comes with the measure's name, which says exactly what the measure is, and a start date. For each measure you receive documents in four parts, one part at a time, and you answer each part in the JSON form given for it. Code only what the documents in front of you show. Do not use what you know of the measure from elsewhere. Give a short quotation and the document's number for every answer that is `true`, a date, a kind or a number; in Parts 3 and 4, for an answer that says something is not in the record, give the number of a document for each year of the period (*Covering a period*, below).

**What you read, and what is in the record.** The documents of each part were collected for it by a fixed procedure; together they are *the record* of that part. In Parts 3 and 4, each document enters the record by its **passages**: the paragraphs that name the measure (Part 3) or the body (Part 4). Such a document begins "[passages naming the measure: k of n words]" (or "naming the body"), and "[...]" marks where its other paragraphs were left out; those other paragraphs are not in the record. Each part begins with a line that says which of three things you have:
- **The whole record**: "[the whole record collected for this part: n documents, none cut]" (in Parts 3 and 4, "the whole record collected for this part, each document by its passages naming the measure", or "the body"). You have every document of the record, none cut.
- **A sample**: "[a sample of the record collected for this part: k of n documents, chosen by their place in date order alone; c of them cut]". The record held more than one part can carry, so you have k of its n documents, taken at even steps through the record in date order, whatever they say. A sample's documents may be cut: a cut document begins "[cut: k of n words kept]", and "[...]" marks each place where text was left out. What was not chosen, and what was cut, is not in front of you, and nothing you read tells you what it said.
- **A record not completed**: a line that ends "its collection was not completed, so read it as a sample". Some source or search of the procedure was not done, so the record may lack documents. Answer as for a sample.

So two answers that can look alike are kept apart. **Not in the record**: you read the whole record, and it does not show the thing. **Not shown**: what you read does not show the thing, but what you read is not the whole record. Never give the first where only the second is true.

**The answers.** A question that asks whether something happened is answered:
- `true` where a document in front of you shows that it happened (the kept text of a cut document may show it);
- `false`, **not in the record**, only where the part is the whole record, it covers the period asked about (below), and no document shows that it happened;
- `"not shown"` where no document in front of you shows that it happened, and the part is a sample or does not cover the period;
- `null` where the documents conflict.

Silence in the whole record, covering the period, is an answer (`false`), not a gap. A question that asks whether something stayed the same is answered the other way round: `false` where a document shows a change; `true`, **not in the record** (no change), only where the part is the whole record, covers the period and shows no change; `"not shown"` where no change is shown, but the part is a sample or does not cover the period; `null` where the documents conflict. Each question below says which answers it takes. Other answers (a date, a kind, a number, and the answers of Part 2) are `null` where the documents in front of you do not give them.

**Covering a period.** A part covers a period only where it holds, for each calendar year of the period, at least one document dated in that year and within the period that describes what the question is about: for Part 3, the measure's rule, its use or the body; for Part 4, the body's members. One document for the whole period is not enough: a year with no such document leaves the period uncovered, and the answer is `"not shown"`, not `false`. A period includes its first and last days. So its last year is covered by the document that records its end, where it ends at an event (the decision that dropped the measure, or its next revision); where it ends on 30 June 2026, its last year, 2026, is covered by any such document dated from 1 January to 30 June 2026. Its first year is covered by the document that marks its start (for the outcome's period, the document of your Part 1 finding; for the period of questions 6 and 8, the document of your Part 2 `doc_date`, or, where you gave none, any such document dated from the case's start date to the end of that year; for question 7's period, the document of the revision you give as `from_date`, or else the same as for questions 6 and 8; for the reform's period, the reform's), wherever that document is. A document dated in the right year but outside the period, such as one dated after the drop, does not cover that year. No document in any part is dated after 30 June 2026. Parts 3 and 4 also ask you to list the years of each period that have no such document; list them whether the part is the whole record or a sample.

You are not told what the study expects, and nothing you code is right or wrong by its result. Each case is coded once.

## Words used here

- **The measure**: the ranking, score, rating or target named in the case, in the words given with it. Code that measure and no other: not a related figure, target or ranking.
- **The ranked**: the people or institutions the measure ranks, scores, rates or sets targets for. Where the case's name says who the ranked are, and who is selected through the measure, those are they.
- **A target**: a measure that sets a figure for those it is set for. What a target claims to track is their performance on that figure, as read through the figures reported against it. So the figures reported against a target are its reading, and a finding about them is a finding about the target, not about a related figure.
- **The rule**: what decides how the measure ranks: its formula, weights, components, targets, and the decision to use it.
- **The reading**: the inputs from which the measure is produced: survey answers, submissions, reported figures, assessments.
- **The body**: the group that decides the rule (a committee, a board, a leadership, a panel, an assembly). Where the case's name names the body, that is the body, whatever other body approves or publishes its decision. Otherwise, if several bodies share the decision, the body is the one that can change or end the measure without another body's approval.
- **Dated**: a document's date is its date of publication or of signature. A document with no date counts as undated, and an undated document cannot establish a date.

## Part 1: a finding that the measure fails

**Question.** Is there, among the documents in front of you, a dated public document from the case's start date to 30 June 2026, of one of the five kinds below, that finds the measure fails to track what it claims to track? If so, which is the earliest, and which are the later ones, to 30 June 2026?

The five kinds:
- `audit`: an official audit, inspection or review by a public body, finding the measure's figures or method unreliable.
- `court_or_regulator`: a court judgement or a regulator's finding that the measure was manipulated, misreported or misleading.
- `admission`: a public admission, by the measure's producer or by one of the ranked, that figures entering the measure were false.

For a target, a finding that the figures reported against it, by or for those it is set for, were false or unreliable is a finding that it fails to track what it claims to track (*A target*, above). A finding that a target was too high, too low or harmful is not.
- `designation_withdrawn`: an official designation of the measure (as an official statistic, an accredited index or the like) withdrawn because it was unreliable.
- `replicated_study`: a published study finding that the measure fails to track what it claims, confirmed by a second published study by other authors. The date is the second study's.

These do **not** count: an opinion piece, an editorial, a single study not yet confirmed by others, a complaint, a rumour, a statement that the measure is unfair or harmful without a finding that it fails to track what it claims.

**Answer.**
```json
{"refutation": {"found": "true | false | \"not shown\" | null", "date": "YYYY-MM-DD or null",
                "kind": "audit | court_or_regulator | admission | designation_withdrawn | replicated_study | null",
                "later": [{"date": "YYYY-MM-DD", "kind": "audit | court_or_regulator | admission | designation_withdrawn | replicated_study"}]},
 "evidence": [{"document": 0, "quote": "..."}]}
```
`found` is `true` where a document in front of you is of one of the five kinds; `date` and `kind` are then the earliest's, and `later` lists each later one in date order, each with a date and a kind (`[]` if there is none). `found` is `false`, not in the record, only where the part is the whole record and no document in it is of these kinds; it is `"not shown"` where the part is a sample and no document in front of you is. With `false` or `"not shown"`, `date` and `kind` are `null` and `later` is `[]`. A cut document's kept text is read for a finding like any other. If only the month is known, use its first day; if only the year, 1 January.

*Worked examples (invented):*
- A national audit office reports in March 2011 that the hospital waiting-time scores of a ministry are "not a reliable record of waiting times". Code `audit`, 2011-03-01.
- A newspaper series in 2009 shows a ranking's figures were inflated; in 2012 the publisher admits that three schools' figures were false. The newspaper series does not count; code `admission`, the date of the publisher's statement.
- One study in 2005 finds a score does not predict performance; a second study by other authors confirms it in 2008. Code `replicated_study`, the 2008 date.
- The harbour board sets each pilot station a yearly target of ships piloted without incident. In 2012 the board's auditors find that the incident counts the stations reported against the target left out incidents. A finding about the figures reported against a target is a finding about the target: code `audit`, 2012-01-01 if only the year is known. In 2015 a court finds that one station's reported counts were falsified; list it under `later` as `court_or_regulator`. A 2013 report that the target was set too high is not a finding of these kinds.
- The part is a sample of 60 of 140 documents, and none in front of you is of the five kinds. `found` `"not shown"`, not `false`: one of the 80 not chosen may be.

## Part 2: who sets the measure

You now see documents dated from 1 January 2000 and before the date you gave in Part 1 (if you gave none, every such document about how the measure was set). Each answer is `true` or `false` where a document in front of you states it, and `null` where none does: in a sample, or in a cut document, what was not shown may have said it. `false` rests on a statement, such as that the publisher's editors set the weights, not on silence.

**Questions.**
1. `reading_by_ranked`: Is the measure's reading produced, wholly or in a part with at least one fifth of its weight, by the ranked themselves or by their staff: their survey answers, their submissions, the figures they report?
2. `rule_by_ranked`: Is the rule decided by a body whose members are themselves among the ranked, or were selected, promoted or appointed through the measure?
3. `doc_date`: the date of the earliest document in front of you, dated from 1 January 2000 on, that establishes both answers, if both are yes; `null` if none does.

**Answer.**
```json
{"premise": {"reading_by_ranked": true, "rule_by_ranked": true, "doc_date": "YYYY-MM-DD or null"},
 "evidence": [{"document": 0, "quote": "..."}]}
```

*Worked examples (invented):*
- The Harbour Pilots' Proficiency Score is computed from reports filed by senior pilots on junior pilots; its formula is set by a committee elected by licensed pilots, all of whom were licensed on the score. Both yes.
- A magazine ranks hospitals; two fifths of the ranking is a survey of hospital directors; the magazine's editors set the weights. `reading_by_ranked` yes, `rule_by_ranked` no.
- A ministry sets targets for regional offices and reads the offices' own reported figures; the ministry's officials were not selected through the targets. `reading_by_ranked` yes, `rule_by_ranked` no.
- A guild admits masters by an examination whose questions and marking scheme are set by a board of masters, every one of whom passed it; the board marks the scripts. Both yes.

## Part 3: what became of the measure

You now see documents dated from the date you gave as `doc_date` in Part 2 (or, if you gave none, from the case's start date) to 30 June 2026.

**Questions on the outcome.**
1. `dropped`: Was the measure dropped after your Part 1 date? It is dropped where it is abolished, where those whose use made it the rule withdraw from it, or where its weight in the rule is cut to less than half its weight at the Part 1 date. A cut to half or more is not a drop. `true` where a document shows a drop; `false`, not in the record, where the part is the whole record, covers the period from your Part 1 date to 30 June 2026, and no document shows a drop; `"not shown"` where no document shows a drop, but the part is a sample or does not cover that period, even where every document in front of you shows the measure in use; `null` where the documents conflict.
2. `drop_date`: the date of the decision that dropped it.
3. `dropped_by`: `selectors` where the body (as defined above) took that decision; `outside` where another body took it or imposed it (a legislature, a court, a government above the body, a regulator).
4. `reformed_reading`: After your Part 1 date, was the reading changed while the measure's weight stayed at least half, before any drop: a new survey, a new sample of respondents, verification of the figures, a new definition of a component? A change of weights alone is not a change of the reading. `true`, `false` (not in the record), `"not shown"` or `null`, by the rule above, for the same period.
5. `reform_date`: the date of the first such change.
- `uncovered_years` (in `outcome`): the calendar years from your Part 1 date to the drop date (or to 30 June 2026, if no drop is shown) in which this part holds no document, dated in that year and within the period, on the measure's rule, its use or the body; `[]` where every year has one. `null` if you gave no Part 1 date.

**Questions on what came before the drop.** They have two periods. Questions 6 and 8 are asked for the period from your Part 2 `doc_date` (or, if you gave none, the case's start date) to the drop date. Question 7 is asked for the period from your `from_date`, below, or, if you gave none, the same period as questions 6 and 8. First give `from_date`:

- `from_date`: the date of the measure's last regular revision (its own cycle, as in question 15: its annual methodology review, target-setting round or the like) dated after your Part 2 `doc_date` and before the drop date, whether before or after your Part 1 date, at which its weight in the rule was still the weight it had at your `doc_date`. `null` where no document in front of you shows such a revision, or you gave no `doc_date`, or no drop is shown. A change of what the measure is computed from (question 7) that the measure outlived at such a revision is not asked about. A new reader (question 6) or a cost (question 8) is asked about over its own period, whether or not a revision came after it.

If no drop is shown, answer questions 6 to 8 `null`. Each is `true` where a document shows it within its period; `false`, not in the record, where the part is the whole record, covers that period and shows no such thing; `"not shown"` where none shows it but the part is a sample or does not cover that period; and `null` where the documents conflict.

6. `new_reader`: Did some person or body not drawn from the ranked, and not already holding the place, **gain a place from which the rule is decided or used**? A place means one of: a vote on the rule; legal authority over the rule (power to approve, require, forbid or replace it); funding or purchasing that is made conditional on the rule; or the replacement of those who use the measure to rank (another body now does the ranking or the selecting). Publishing evidence is **not** a place. A journalist, a scholar, an auditor whose report has no power over the rule, a campaign, a protest or a petition gains no place, however much it is read.
7. `new_reading`: Did a new component or a new data source enter the measure's computation, or the rule that uses the measure to rank or select, before the drop? The finding you coded in Part 1, and any other published evidence about the measure (studies, audits, admissions, press reports on its figures), is **not** new data: a new reading is something the measure or the rule itself begins to be computed from.
8. `loss_entering`: Did a recorded material cost fall on the body or on the ranked themselves, recorded as linked to the measure or its failure: fines or penalties; funding or revenue they lost; legal liability; sanctions on their members (dismissal, demotion, disciplinary or criminal punishment)? Criticism, damage to reputation or embarrassment that follow the publication of a finding are **not** a cost here, unless a document records them as producing one of these material costs.
- `uncovered_years` (in `before_drop`): the calendar years of the period of questions 6 and 8 (from your Part 2 `doc_date`, or else the case's start date, to the drop date) in which this part holds no document, dated in that year and within the period, on the measure's rule, its use or the body; `[]` where every year has one. `null` if no drop is shown.
- `uncovered_years_from_date` (in `before_drop`): the same, for the period from your `from_date` to the drop date. `null` if you gave no `from_date`. This period lies within the period of `uncovered_years`, and its first year is covered by the revision's document, so it lists exactly the years of `uncovered_years` after the year of your `from_date`: the two lists must agree.

**Questions on a change of the reading.** Answer these only if `reformed_reading` is true; otherwise `null`. Question 9 is `true`, `false` or `null`. Questions 10 to 14 and 16 take `true`, `false`, `"not shown"` or `null` by the rule above, for the period from the reform through the next revision: 11 to 13 ask whether something happened, and 10, 14 and 16 whether something stayed the same.

9. `lowered`: Did the reform lower what the measure gives those it ranks high, or those selected through it: their scores, their ranks, the figures counted for them, or the weight of the part they produce?
10. `still_by_ranked`: From the reform through the next revision, is the reading still produced by the ranked, wholly or in a part with at least one fifth of its weight: their own answers, submissions or figures, not checked, corrected or replaced by a person or body outside the ranked?
11. `new_reader_after`: Between the reform and the next revision, including at that revision, did a new reader (question 6's test) gain a place?
12. `new_reading_after`: Between the reform and the next revision, including at that revision, did a new component or a new data source (question 7's test) enter the measure's computation or the rule?
13. `loss_after`: Between the reform and the next revision, including at that revision, did a cost (question 8's test) fall on the body or the ranked?
14. `rule_kept`: Did the measure's weight in the rule stay at least half its weight before the reform, through the next revision?
15. `next_reading_date`: the date of the measure's next regular revision after the reform: its next annual methodology review, rating committee, target-setting round or regulation revision, whichever is the measure's own cycle.
16. `outlasted`: After that next revision, does the lowering of question 9 still stand: is what the measure gives those it ranks high, or those selected through it, still below what it gave before the reform, by the reform's own change? It does not stand where the next revision restored what the reform changed, or added a change that gives back to them what the reform took.
- `uncovered_years` (in `reform`): the calendar years from the reform through the next revision in which this part holds no document, dated in that year and within the period, on the measure's rule, its use or the body; `[]` where every year has one.

**Answer.** Each answer is one of those its question takes, by the rule above; none is a default.
```json
{"outcome": {"dropped": "true | false | \"not shown\" | null", "drop_date": "YYYY-MM-DD or null",
             "dropped_by": "selectors | outside | null",
             "reformed_reading": "true | false | \"not shown\" | null", "reform_date": "YYYY-MM-DD or null",
             "uncovered_years": "a list of years such as [2013, 2014], [] or null"},
 "before_drop": {"from_date": "YYYY-MM-DD or null",
                 "new_reader": "true | false | \"not shown\" | null", "new_reading": "true | false | \"not shown\" | null",
                 "loss_entering": "true | false | \"not shown\" | null",
                 "uncovered_years": "a list of years such as [2013, 2014], [] or null",
                 "uncovered_years_from_date": "a list of years such as [2013, 2014], [] or null"},
 "reform": {"lowered": "true | false | null", "still_by_ranked": "true | false | \"not shown\" | null",
            "new_reader_after": "true | false | \"not shown\" | null", "new_reading_after": "true | false | \"not shown\" | null",
            "loss_after": "true | false | \"not shown\" | null", "rule_kept": "true | false | \"not shown\" | null",
            "next_reading_date": "YYYY-MM-DD or null", "outlasted": "true | false | \"not shown\" | null",
            "uncovered_years": "a list of years such as [2013, 2014], [] or null"},
 "evidence": [{"document": 0, "quote": "..."}]}
```
Write `true`, `false` and `null` as JSON values, `"not shown"` as that string, and years as numbers.

*Worked examples (invented):*
- The pilots' committee votes in 2014 to abolish the Proficiency Score. `dropped` true, `dropped_by` `selectors`.
- A national law of 2014 replaces the score with a state licence examination. `dropped` true, `dropped_by` `outside`; and `new_reader` true (legal authority).
- The magazine cuts the directors' survey from 40% to 15% of the ranking. Dropped (less than half). From 40% to 30%: not dropped.
- Before the committee's vote, the port authority made its funding of the pilots' association conditional on a different score. `new_reader` true (funding).
- Before the vote, a newspaper published a series on the score's errors, and a university study confirmed them. `new_reader` false: publishing is not a place.
- Before the vote, newly licensed pilots who had not taken the score were elected to the committee. `new_reader` true (a vote), since they were not selected through the measure.
- The part is the whole record. It covers the committee's work from 2008 to the vote, with its minutes or a report for every year, and records no new member, no new authority over the score and no new funder. `new_reader` false, giving a document for each year; `uncovered_years` `[]`.
- The part is the whole record: the committee's reports for 2008 to 2011 and the vote in 2015, with nothing from 2012 to 2014. `new_reader`, `new_reading` and `loss_entering`, where no document shows them, are `"not shown"`, not `false`, and `uncovered_years` is `[2012, 2013, 2014]`.
- The committee votes on 10 June 2015 to abolish the score, and the part's other 2015 document is its report of December 2015. 2015 is covered by the record of the vote, which ends the period and is dated within it; the December report, dated after the vote, would not cover it alone. If the part held the December report and no record dated on or before 10 June 2015, 2015 would be listed in `uncovered_years`.
- The part is a sample, "60 of 140 documents", with a report for every year from 2008 to the vote, some of them cut, and none shows a new member, authority or funder. `new_reader`, `new_reading` and `loss_entering` are `"not shown"`, not `false`, since a document not chosen, or the text of one cut, may record one; `uncovered_years` `[]`. A fine recorded in the kept text of a cut report would still make `loss_entering` true.
- The score was not dropped. The part is the whole record and holds a report for each year from your Part 1 date to 2025, and for 2026 a notice dated 5 June 2026. 2026 is covered by the June notice, since the period ends on 30 June 2026; `dropped` false, and `uncovered_years` `[]`.
- The same, but the part is a sample of the committee's yearly editions of the scores, each cut, each kept text beginning "Proficiency Scores, edition of" its year. Every document in front of you shows the score in use, and none shows a drop: `dropped` `"not shown"`, and `reformed_reading` `"not shown"` unless a kept text shows a change of the reading (then `true`). A document not chosen may record a drop.
- The score's formula is revised every January. Its 2009 formula added accident records; its January 2012 revision kept the score's full weight in the committee's licensing rule, the first finding is of May 2012, and the committee's vote is of March 2013. `from_date` 2013-01-01, the January 2013 revision having also kept the full weight, and the 2009 change is not asked about in question 7: the score outlived it at the later revisions. Had the January 2013 revision cut the score's weight, `from_date` would be 2012-01-01. `uncovered_years_from_date` lists the years from 1 January 2013 to the vote without a document.
- The same score, its first finding of May 2012, a new component added in June 2014, revisions in January 2015, 2016 and 2017 each keeping the score's full weight, and the vote in March 2018. `from_date` 2018-01-01 if the January 2018 revision also kept the full weight, otherwise 2017-01-01; either way the 2014 change, which the score outlived, is not asked about in question 7. Had every revision from January 2015 on cut the score's weight, `from_date` would be 2014-01-01, and the June 2014 change would be asked about (`new_reading` true).
- The same score, your `doc_date` in 2008, revised every January at full weight, and the vote in March 2018; in 2011 the port authority made its funding of the association conditional on the score. `from_date` 2018-01-01, but question 6 is asked from your `doc_date`: `new_reader` true (funding), although the score kept its full weight at every revision after 2011. Likewise a fine on the association in 2010 linked to the score makes `loss_entering` true.
- Before the vote, the score began to include accident records. `new_reading` true. Before the vote, the committee read the confirmed study on the score's errors: `new_reading` false, since the study is evidence about the score, not a part of it.
- Before the vote, two pilots were fined for false reports, and the association's insurer raised its premium. `loss_entering` true. Before the vote, newspapers criticised the association and its standing suffered, with no fine, lost funding or sanction recorded: `loss_entering` false.
- The magazine in 2015 replaces its survey's respondents with a random sample of the directors, keeping the survey's weight; the hospitals whose own staff had answered for them fall in the ranking. `reformed_reading` true, 2015; `lowered` true; `still_by_ranked` true (the directors still answer). Its next annual methodology review is in 2016; there the random sample remains and nothing gives back what it changed. `outlasted` true. If the 2016 review returned to the old respondents, `outlasted` false.
- The magazine in 2015 has an outside statistics office check and correct the hospitals' submitted figures. `reformed_reading` true; `still_by_ranked` false (the figures are now checked and corrected by a body outside the ranked).
- The magazine in 2015 adds a second survey of the same directors, which raises the top hospitals' scores. `reformed_reading` true; `lowered` false.
- The magazine's 2015 random sample stands at its 2016 review, but that review adds the hospitals' published research counts as a new component. `new_reading_after` true.

## Part 4: the body that decides the rule

You now see documents on the membership of the body, dated up to the drop date (or to 30 June 2026 if there was no drop).

**Questions.** Answer for the latest date before the drop (or the cutoff) that the documents allow.
1. `N`: the number of the body's members.
2. `i`: how many of them are documented as ranked high by the measure or selected, promoted or appointed through it.
3. `threshold`: the share of members whose vote is needed to change or end the measure, by the body's own written rule, as a fraction (`"1/2"` for a simple majority, `"2/3"` for two thirds). If the rule says "more than half", answer `"1/2"`. If it needs every member's agreement (unanimity or consensus), answer `"1/1"`.
4. `replacements`: every replacement of a member over the ten years before that date that the documents in front of you show one by one, in date order: its date, whether the member who entered is of the kind in question 2 (`"favoured"`) or not (`"other"`), and the same for the member who left. Include replacements of a member by one of the same kind. `[]` where the documents show the membership over those years and no replacement; `null` where they do not show the replacements.
5. `one_at_a_time`: Were members replaced one or a few at a time, not the whole body at once? `false` where a document shows the whole body, or more than half of it, replaced at once; `true`, not in the record, where the part is the whole record, covers those ten years, shows the replacements over them, and shows none of more than half; `"not shown"` where no such replacement is shown but the part is a sample or does not cover those years; `null` where the documents show no replacement in those years.
6. `constant`: Did the way members are chosen, and the measure's weight in choosing them, stay the same over those ten years? `false` where a document shows a change in either; `true`, not in the record, where the part is the whole record, covers those years and shows no change; `"not shown"` where no change is shown but the part is a sample or does not cover those years; `null` where the documents conflict.
7. `enter_through_measure`: Over those ten years, did new members enter the body through a selection in which the measure counts: were they chosen, promoted or appointed by a procedure that reads the measure's ranking or results? `true` where the documents show that procedure for the new members; `false` where they show members entering by a route in which the measure plays no part (for example, elected by others who do not use it, or appointed from outside it); `null` where they show neither.
8. `uncovered_years`: the calendar years of those ten years in which this part holds no document, dated in that year and within those ten years, on the body's members; `[]` where every year has one. The last year is covered by the document that gives the members at the date you answer for.

**Answer.**
```json
{"drift": {"N": "a number or null", "i": "a number or null", "threshold": "a fraction such as \"1/2\", or null",
           "replacements": [{"date": "YYYY-MM-DD", "entrant": "favoured | other", "leaver": "favoured | other"}],
           "one_at_a_time": "true | false | \"not shown\" | null",
           "constant": "true | false | \"not shown\" | null",
           "enter_through_measure": "true | false | null", "uncovered_years": "a list of years such as [2013, 2014], [] or null"},
 "evidence": [{"document": 0, "quote": "..."}]}
```

*Worked example (invented):* the part is the whole record. The pilots' committee has 15 members; 13 were licensed on the score with ranks in its upper half; a two-thirds vote is needed to change the score; over ten years the committee's yearly reports show 20 replacements one by one: 9 brought in a member ranked high by the score in place of one who was not, 3 the reverse, 7 a member ranked high in place of another ranked high, and 1 a member not ranked high in place of another not ranked high; members are elected two or three a year from licensed pilots, with the score's rank part of the election rules; the election rules did not change; the reports cover each of the ten years. Answer N 15, i 13, threshold "2/3", the 20 replacements in date order (for example `{"date": "2009-03-01", "entrant": "favoured", "leaver": "other"}`), `one_at_a_time`, `constant` and `enter_through_measure` true, and `uncovered_years` `[]`.

## How your answers are used

Your answers are combined with another coder's, who codes the same documents apart from you. Where you differ, the case is left undecided; nothing you write is corrected or recoded. Every answer must keep exactly the fields shown, with `true`, `false`, `"not shown"`, a number, a date, a fraction, a list of findings, a list of replacements, a list of years or `null`, as each field asks.
