# WX: the atlas re-read after WB

*AI-written (a Claude Code session started from WB's session), 9 November 2026. About fifteen minutes to read; the kept hits and the follow-ups are the part to check.*

WB (landed 9 November 2026, content `6cf2950b3`) revised what readers are told about evaluation. Each of its five reader rounds found more AI-read atlas entries in the old ethics frame that no one had cited, and [WB's hand-off list](../wb-within-becoming/review/FOR-OTHERS.md#for-the-crosswalks-owner) asked for a full pass by claim. This pass re-read both atlas files, `theories/becoming/results/atlas/entries/correspondences.json` (1,183 entries) and `dynamics.json` (177), against the homes WB revised:

- 07 §1, §4, §5, §7, §8 (T8) and its does-not-show list;
- 08 §2 and §12;
- 05's not-shown line and §6;
- the one page's ethics paragraph and T8 row;
- the glossary's ethics rows.

It also used three homes these entries quote: 02 §7, 06's D49 and D65 readings (in Chinese), and COLLECTIVE-DIRECTION §4 and §8. Texts only: no Lean, no record, no new result, nothing paid.

## What changed

There are 204 exact replacements, in 233 fields of 190 entries: 230 fields of 188 crosswalk entries, and 3 fields of 2 dynamics entries. Each re-says the field from its home's current words. [`kit/edits.py`](kit/edits.py) lists every replacement with the entries it may touch and the number of fields it must change. [`kit/apply.py`](kit/apply.py) stops if any count differs. [`review/fields-changed.md`](review/fields-changed.md) gives every changed field before and after, with the home it restates. These are the shapes the pass found, in WB's readers' terms:

- **A ranking given a compulsory scope** (about 80 fields). Forms: "widening is better only under C for order, with the continuation condition for scope"; "asked only under the continuation condition for scope and C for order"; "scope from the condition"; "whose losses count is the condition's"; "the condition fixes only whose losses count". Each now names its scope and order, or says only that calling the wider better is C's.
- **The ethics as two readings or two premises** (about 20). Examples: "the account rests its ethics on two unasserted premises", "in the ethics the condition fixes scope and C order", "the ethics' premises", "one chosen premise becomes two". Each now says the account asserts no should and that, where it ranks, a result names its readings, most often these two.
- **A warrant said to stay open** (about 15). Forms: "a warrant binding every possible mind stays open", "the warrant question the account leaves open", "the ethics, life's stance, does not wait on a warrant". Each now follows 07's does-not-show list and its open item. The question stays open as one the account does not pursue, and no warrant from outside is sought.
- **A loss's occurrence confused with its being counted** (about 12). Examples: "where nothing has significance it loses nothing", where 05 now says an empty predicate counts no loss though the dweller still ends; "whether a drain is a harm is asked under the condition and C"; "whether a loss counts takes the condition for scope and C for order".
- **生生 tied to widening, or to the whole** (about 8). Examples: "supports 生生" in readings, "the whole's 生生", "the 生生 of life in the whole" (two dynamics fields), and "生生 as the direction".
- **Mixed comparisons said to stay unranked** (6), where 07 says C alone leaves them undecided and a further stated order can rank them.
- **Quotations of homes that no longer say them** (about 90):
  - the one page's former "No law evaluates: none says a loss is a harm or restraint better" (8 entries) and its centre sentence;
  - the glossary's "whether meeting it has significance";
  - 07's route (b) wording ("'should' is what a center does", "gives, without warranting, a reason");
  - 07 §6's capability reading ("a reason to pool, not to govern", 11 fields), now "a reason its makers offer to pool rather than to govern";
  - 07 §7's "the direction proposed" (12 fields), now "the direction its makers offer AI, read under scope and order", and its "warranted transformation";
  - 07 §4.4's grades ("numbers count only if status is invariant and equal");
  - 02 §7's and 05's "none of this says whether a locked loop (a code) keeps or closes for 生生" (20 fields), now "none of this ranks a locked loop: what it keeps, opens or closes, and for whom, is 07's question";
  - 06's D49 and D65 readings ("支持、丰富或损害生生", 天地之大德曰生 "as a comparison commitment like C");
  - 06's 一体之仁 reading;
  - a premise list that 07's practical Conditional never states ("living significance, which the continuation condition yields, for scope; … a ranking is under C or another named order"; 5 entries).

## How the pass read

The pass read by claim, not by line. [`kit/check.py`](kit/check.py) is the closing scan. It holds narrow patterns for each shape WB's readers named, plus the removed home phrases this pass found. Three wider scans, kept in the session's scratchpad, gave the list read before it:

- **Shape patterns.** A sentence-level scan over every prose field of both files (the `says`, `part`, `reading`, `account_adds`, `source_adds`, `sense`, `quote` and `name` fields; `mechanism`, `edge`, `open`, `condition`, `beyond` and `forbids` in the dynamics atlas). It flagged 757 distinct sentences in 778 fields, and the pass read all of them. Most were right: a role stated (the condition fixes scope, C gives order), a source's own words, or a result that does use the readings it names.
- **Ethics phrasings.** A second scan looked for "ethic", "stance", "life in the whole" and similar phrasings the first missed, and the pass read its 171 hits.
- **Quotations.** Quoted spans in AI-read fields were checked against the files their targets cite. 42 of the misses touched the ethics vocabulary, and the pass read them all.
- **Removed wording.** As in WB's `wb_drift.py`, the scan took windows of wording removed from live homes between `8ee6a26c9` (main before WB's text revision) and main. It kept only windows that no live home still has. That gave 115 fields, and the pass read them.

The window and quotation scans find quotations, not every restatement. The shape scans find restatements only in the forms their patterns name. The last two sweeps of this pass still turned up paraphrases ("scope comes from the continuation condition", "one chosen premise becomes two"). So a further reader may find more.

## Hits kept, with their reasons

After the edits, `check.py` reports 36 hits. Each is kept for one of the reasons below.

- **The home still says it** (27 hits):
  - 07 §7's direction is Conditional on the continuation condition for scope, C read as widening for order, J1–J4 and correspondence E (6 hits);
  - 05's required organization is Conditional on the condition for scope through living significance, C for order with J1–J4, and correspondence (3);
  - 07's RR reading says "under C, with the continuation condition for scope, a comparison apart from the prospects' order" (3);
  - 07 §6's assessment says "With the condition for scope a loss beyond every rater's closure counts" (5);
  - 06's D49 reading says 延续之条件定范围，持以广为愈（C）者定拓宽与收窄之序 (2);
  - 05's D65 reading is bracketed "scope by the continuation condition, and a ranking only under C or another named order" (1);
  - COLLECTIVE-DIRECTION §8 says "mixed comparisons stay unranked" (1);
  - 07's D45 reading at keeping widening says "生生 read as widening is generation of the possible that loses none of it" (3);
  - 08 §2's "the continuation condition … fixes scope … C fixes order", in its own words (1);
  - 07 §3.4's frame, "Under the continuation condition for scope, which ranks nothing" (1);
  - a true conditional, "with the continuation condition for scope every narrowing loses something with significance" (1).
- **Dated history** (1): T8's former refuter, dated 9 November 2026.
- **The field quotes its record's own not-shown line** (5): "which giving supports 生生" (4) and "that returning, waxing or waning is good or supports 生生" (1). They match ten records' not-shown items. Read with 生生 as the continuation of life, they are not false.
- **Not a wrong form** (3):
  - "that this is the 生生 of the ethics is no claim of the law";
  - T5's "mixed cases stay open", the bound's own scope;
  - "C for order and the continuation condition for scope stay unasserted", a statement of roles.

## Left for others (homes, not the atlas)

These are not this pass's to change. They are homes or records, and an entry restating them follows them.

- **07 against the glossary on 生生 read as widening.** 07 §2's D45 reading at keeping widening still says "So 生生 read as widening is generation of the possible that loses none of it". The glossary (WB) now makes keeping widening the subject: "keeping widening is generation of the possible that loses none of it; widening is not 生生's measure". Three entries follow 07, and one quoting the glossary now follows the glossary.
- **COLLECTIVE-DIRECTION against 07 on mixed parts.** CD §4 says "Mixed comparisons are left unranked by both … A measure for mixed parts is open", and §8 says "mixed comparisons stay unranked". 07 §2 now says "a further judgment names its criterion and who holds it, and the criterion need not be a number". The atlas entries now say 07's words where they restate 07.
- **Dossier B's B-34.** It still reads cessation as release by no longer continuing, against the continuation condition: 方向与延续条件相反，记为相分. WB's fourth round re-said the crosswalk's entry on the same reading: "That reading alone does not conflict with the continuation condition, which counts continuations without ranking them; any conflict with C requires a comparison meeting C's widening hypotheses". The dossier and the crosswalk now disagree. Two crosswalk entries report B-34 as the dossier states it.
- **Records.**
  - `generation-and-degeneration-at-two-grains`: its not-shown line and gloss say "the 生生 of life in the whole". The dynamics atlas now says "生生, the continuation of life". The record wants the same re-saying, with a history note.
  - `whole-drawing-beyond-renewal-ends`: its not-shown line points to "chapter 6" for significance, which is chapter 7.
  - Ten records carry "supports 生生" in not-shown items (kept above). For example `giving-that-waits-on-giving`, `hexagram-world-laws` and `where-two-courses-rejoin`.
- **Stale quotations outside the ethics frame.** The quotation check found them, and this pass did not change them:
  - 05's former pool sentence, "resisting a capture hiding a loss needs a member admitted by what the pool does not yet read" (two crosswalk entries and two dynamics `open` items);
  - USES' former "trained judges; the model's law";
  - PHILOSOPHY's "and what would refute";
  - the one page's former reading time, "Eleven to fifteen minutes", in one entry;
  - five paraphrases of 07's novelty row ("so the two are mixed and C does not rank them"; the row now says "C alone gives no verdict, and T8, the makers' offer, ranks neither").
  
  About 200 more quotation misses are mostly the check's own noise from apostrophes, and the pass did not read them.

## Checks

- **Render.** `python3 -B tools/research/gate.py hold -- make research-render` (see the Queue line's landed clause for the result).
- **Strict check and links.** `make research-check-strict` and `make research-links`.
- **The reader.** One reader other than the author read [`review/fields-changed.md`](review/fields-changed.md) against the homes. The report is in `review/`.
- **The gate.** `make gate` on the merged tree.
- **Deferred.** The full suite is deferred to the phase's end.
