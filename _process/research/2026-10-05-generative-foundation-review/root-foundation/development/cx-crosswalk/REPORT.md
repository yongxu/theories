<!-- AI-written, 7 November 2026, the report of board item CX. It adds no result: no law, premise or proof of the account changed. -->

# The crosswalk and the connection map: what was done, and how far to trust it

Ren asked whether the theory is whole and unified, and whether all the theories and wisdoms are connected in a way that can be seen ([his words](../../../../../../sources/15-codex-theory-conversations/2026-11-06-crosswalk-and-map.md)). The answer had three parts. The account is whole by its own checklist and partly unified. It is connected to other traditions only as far as the Chinese texts. No person has read it. CX built what that answer found missing:

- **(a)** a checked crosswalk from the sixteen earlier theory folders and twelve domains of thought to the live account;
- **(b)** the theory graph's missing edges;
- **(c)** a page on which the connections can be seen;
- **(d)** corrections to front pages that misreported the folders.

Every entry is an AI reading. No person has read any of it.

## What was built

- **The crosswalk** ([page](../../../../../../theories/becoming/results/atlas/CROSSWALK.md), [entries](../../../../../../theories/becoming/results/atlas/entries/correspondences.json)) has 1,183 entries in 28 groups: 16 earlier folders and 12 domains. Each entry gives:
  - one claim in its source's own sense, with a quotation where the source is stored here;
  - what became of it in the live account;
  - its relation to the account: agreement 相合, scope 定域, divergence 相分 or contrary reading 反读;
  - for an agreement, what it is agreement with: a checked law, a thesis or method, or a reading;
  - its targets, each with the role it plays (carries, neighbour or limit) and what the target says, as its home words it.
- **The theory graph** (commit `68868bb97`): each grammar concept is joined to its module, and each corpus sentence read as a candidate or conditional law is joined to the record that registers it, with its outcome and family. Citations are by unit id. The page says how many units are read against nothing yet: 1,330 of the 1,724 that state something.
- **The connection map** ([page](../../../../../../theories/becoming/results/atlas/map.html), `tools/research/connection_map.py`) is one page with six views:
  - the loom: folders and domains joined to the records and sections they meet;
  - where they meet;
  - the root's reach;
  - how far the corpus has been read;
  - loose ends;
  - how it was read.
  Every count on it is read from the generated data, and none is typed.
- **MAP.md** counts sixteen folders, not fifteen. It no longer calls the earlier folders a stratum of the live account, and it points to the crosswalk and the map.

## How it was read

Each folder and domain was read in five steps, each by a different AI reader:

1. A mapper read the item and the account.
2. A reviser read the mapper's entries against both sides.
3. A checker was told to refute them.
4. A critic read the whole and found the labels overstating the readings: "carried" where the account states part of a claim, and agreement where the join was the reader's own. Each item then had a repair by a new reader, under the amended [brief](BRIEF.md) ([REPAIR.md](REPAIR.md)).
5. Like claims were compared across items by the targets they share, and each conflict was settled at the home ([COMPARE.md](COMPARE.md), `reads/compare-*.json`, three conflicts in `reads/compare-resolved.json`).

A second critic then read a random sample ([CRITIC2.md](CRITIC2.md)). Its fixes, and the entries brought up to date with the live text, are the late layer, `reads/<item>.6-final.json` (`apply_late.py`).

About 150 agent reads made this, plus 36 that the account's usage limit stopped and that were run again. No one ran any tests while reading. The checks below are AI critics, not people.

## What it found

Of the 1,183 claims, the live account states 3 in whole and 488 in part, and takes up 189 to say otherwise. 376 it does not state, and a reader proposes the connection here. 105 it does not take up, and 22 stand only in its history.

By relation, over every entry that has one:

- 338 agree;
- 371 are scoped: the source states it universally and the account under conditions;
- 325 diverge;
- 25 read the other way.

Agreement is with a checked law in 130 cases, a thesis or method in 67 and a reader's join in 141. The map counts 337 agreements: one more stands in an entry the account keeps only in its history, and the map leaves such entries out of its relation counts.

328 entries rest on the AI's knowledge of a text not stored here. They are unchecked against that text, and a critic's check of them was memory against memory.

## How far to trust it

The first critic read 59 entries aimed at suspects:

- 32 held;
- 12 held in part;
- 15 failed.

An aimed sample gives no error rate. Its findings led to the repair and the comparison.

The second critic read 100 entries drawn at random, stratified by verdict (seed 20261107, up to six per stratum, twenty strata):

- 83 held;
- 15 had a label or a target's role wrong;
- 2 had a wrong reading.

Weighted by stratum size, that estimates 82.6% of all entries holding, 14.2% with a label or role wrong and 3.2% with a wrong reading. Its fixes are applied. The other entries were not read again, so the estimate stands for them. The sample was drawn before the late layer. Beyond the second critic's own fixes, the late layer did two things, and changed no label:

- it brought wording into line with what the homes say now;
- in nine entries, it corrected wording that gave ranking to C alone or dropped 02's premises on giving.

## What it corrected in the live account

Readers whose job was the crosswalk flagged places where the live account seemed false or wider than its home. Each flag was checked at its home ([VERIFY.md](VERIFY.md), `reads/verify-*.json`):

- 26 held;
- 3 were mistaken;
- 3 were true and would change no belief;
- 1 turns on a source no one here can check.

The 26 were corrected in commit `95a7008a9` (`apply_corrections.py`), with a history note in each record whose wording changed:

- **COLLECTIVE-DIRECTION §5** said no institution is modelled. It now names the one minimal model of an institution on the root and says no actual institution is shown to meet its hypotheses.
- **02:** D26's power account, the working definition, which is another sense and not a wider one, and the refutation, read as a loss the loop does not read.
- **03:** the proxy problem's kinds, the revision theorem's base (a named model, not any type) and 无明's formal reading.
- **05 §7:** MQ1's failed half (80 of 151). The same failure is stated in **08** too.
- **06:** 未决.
- **07 §6:** the imperial examination as read.
- **08:** the double-negation gloss, two credits and Sen's title.
- **The glossary.**
- **Four review dossiers:** Buddhist thought, philosophy, alignment and logic.
- **Twelve records' correspondences.**

Since then:

- OPENING's note on the meta-attractor reads the refutation as 02 does. Its header says its notes are AI-written and follow the current account.
- Round two of keeping in step (below) found two more wordings that give ranking to C alone, at their homes. LM1 had corrected thirteen records' "ranking needs C", searching by those words, and these two wordings stood:
  - 05's D65 label, "any ranking is C's";
  - eight records' line "ranking goes through the comparison C" (排序经由比较 C).

  Each now adds what 07 §4 adds, "or a premise in its place", in LM1's words, with a history note in each record (`apply_ranking.py`). A reader other than their author then checked these corrections and asked for three more. They were made by hand and are recorded in the script:
  - 05's label names both premises: "scope by the continuation condition, and a ranking needs C or a premise in its place (07 §4)";
  - selection-within-and-among-groups says "not through the division", where "it" had come to read as C;
  - 06's 易传 line (616) says 对进程的排序须它或代替它的前提.

  Eleven entries quoting these homes follow the corrected text.

  The same reader found the error elsewhere, and each correction uses the reader's words:
  - six entry fields and one group summary that gave ranking to C alone in their own words;
  - four lines in AA's atlas (`entries/dynamics.json`) that copied the eight records' old line. AA's session was told.
- The edition to send, `review-packet-4`, carries most of the corrected sentences in their old wording. Whether it goes out as it is is Ren's decision.

**Not changed, and listed.** A-10 and the record `shaping-the-rule-selected-by-what-comes-back` list the persistence of elites (Acemoglu and Robinson 2008) as a known form of shaping selected by what comes back. Whether their mechanism is that form turns on a reading of their paper that no source here can check.

## Kept in step with what the homes say

A crosswalk entry quotes its homes, so it goes stale when a home changes, and nothing in the render or the gate catches that. Three passes found such entries by searching every entry for the words each change removed:

- **This crosswalk's own corrections:** five entries quoting COLLECTIVE-DIRECTION §5, and 30 more quoting the other corrections.
- **AA's errata on main:** six entries named COLLECTIVE-DIRECTION's exit "Give first, with a reserve", now "Spare all one waits on", since the law has no reserve in it.
- **LM2 on main:** one entry said that the title of the record `generation-is-replenishment` keeps the older sense of "generation". 04 now says that its id keeps the older word.
- **Everything else main changed since this branch began,** LM1 and AA's errata and restatements among it, in two rounds ([MAIN-DRIFT.md](MAIN-DRIFT.md)). In each, one AI author per group read the fields against their homes as they are now, and another AI checked every verdict.
  - **Round one, by words** (`main_drift.py`, `reads/main-drift-*.json`): every entry field quoting words that main removed.
  - **Round two, by claim** (`reads/claims-*.json`): its checkers found that a word search misses an ending changed at a sentence's close ("needs C." became "needs C or a premise in its place.") and misses paraphrases. Round two read every field stating one of the changed claims, whatever its words: C's order, waiting and sparing, promises and ignition, CD's edges, joint ending, optima, and AA's eleven restated lines.

  Together, 382 fields in 209 entries were read:
  - 213 changed;
  - 169 left, because they already said what the home says, the match was a coincidence, or they are a source's own words;
  - 41 amended by their checker;
  - 0 label changes.

Three entries that round two's checker named and no group listed kept 02's label "any giving law" and dropped its premises on giving, so the margin's exactness read as holding for every giving law. They now state the premises. The first version still fell short of them, and the ranking corrections' reader gave the words that are now used: meeting the draw at every z from y with z + H at most the top, and 0 < H + y.

The late pass stops if any removed wording it names survives. Round two's patterns were chosen from the changed claims, so a restatement in words none of them matches can still be stale.

## What is not verified

- No person has read the crosswalk, the map or the corrections.
- Entries whose source is not stored here (328) are the AI's knowledge of the source. Several folders' own primary sources were read only in part: each group's `read`, `skimmed` and `searched` lists say how far.
- The estimate rests on one random sample of 100 read by AI critics.
- The theory graph has 1,330 classified units read against nothing yet.
- Checks run: the focused tests (`test_atlas`, `test_connection_map`, `test_theory_graph`), the render's strict freshness check, the links, and the map in a browser at desktop and phone width, light and dark. The full suite was deliberately not run here; the landing gate runs what the change reaches.

## Not done

- **A third full pass.** It would mean another repair read of all 28 items against the late layer: about 28 agents, then a second random sample of about 100 entries, about 8 agents. It is not run: the second critic's estimate is the measure, and AGENTS.md asks for a fan-out to be proposed first.
- **People's reads.** The map is ready for the first people who read the account. What they report is the measure the work's order puts third, after errors and refuters.
