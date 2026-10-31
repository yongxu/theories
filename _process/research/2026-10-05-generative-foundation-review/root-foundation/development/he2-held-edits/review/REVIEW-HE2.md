# HE2: the independent review and what was done

*AI-written, 31 October 2026, by HE2's lander. The review itself was AI-run and read-only; no person reviewed. The raw result, every finding with its evidence and the skeptic's reasons, is [kept beside this page](REVIEW-HE2-result.json).*

## How it ran

Four read-only reviewers each read one part: the Lean diff and the signature audit; the records; the re-point and the texts; the lander's kit and [design](../DESIGN.md). They read the gathered tree of the dry run (main `c05f4eab8`, every part applied, receipt `20261030T234558.400678Z`) and the kit as it stood on `he2-land` (`2a085bcbf`). They returned 49 findings. A fifth reader, a skeptic, merged duplicates into 36 and tried to refute each one against the files: 19 confirmed, 16 confirmed in part, 1 refuted.

The reviewers also checked, and found sound, among other things: every Lean hunk traced to an item; the moved laws byte for byte; every axiom report empty; the 13 changed modules compared at the source with renames applied, with nothing changed but «两端分则中有标»; no old 理 name left in live text; the re-pointed records other than HE2's changing only hashes and bindings.

## Findings

Severity is the skeptic's. Pending items are with their owners, who keep their own wording; the landing waits for them.

| finding | verdict | severity | what | done |
|---|---|---|---|---|
| records F1 | confirmed | blocker | master-laws does_not_show[4] says a pairing under continuation adds nothing known to equal count, while law 3 now states the count on uncrossed regions and in every class | taken: narrowed to what is not stated, as GrammarLaws' module doc is (he2_records.py `ml_text`) |
| lean F1 | partly | should-fix | the reviewed tree was gathered from earlier item tips (items 2–4 with `count_append`, item 1 before its revision); DESIGN pinned them | taken: DESIGN repinned (01ca4779f; 37, 41, 784); rehearsed from the tips on he2-land (checker passed, audit OK); the full dry run is rerun after the owners' revisions |
| lean F2 | partly | should-fix | the audit compared statements as printed, and printing drops binder types, universes and implicit arguments | taken: every statement is also compared as written in the source, comments blanked and renames applied |
| lean F3 | partly | minor | the audit's gaps: the root module, instances and variables, item 1's statement checked by name only, definitions read with no hash check | taken: root module code compared after renames, every command compared, item 1's statement checked against its kit's head with the conclusion unchanged, sources checked against the receipt |
| lean F4 | confirmed | should-fix | GrammarMap's doc says how «有终» stands to «退化» is stated in leaves; it is not stated, and the modules are not leaves | taken by OU's owner (he2-item5 `d54f52264`): the sentence says how 全生成 and 全守 stand to 生成 and 守 in modules that import this one, and that how 有终 stands to 退化 is not stated |
| lean F5 | confirmed | should-fix | 01 §3 (home of continuation-relative-to-a-class) still states «两端分则中有标» for a class; item 1's KIT says no chapter states it; LOGIC.md L-04 quotes the old signature | taken by item 1's owner (`ou3f-laws` `ac9276674`): 01 §3 through the kit's texts part, before the re-point, saying "a transitive relation" as law 10 does; the KIT's sentence corrected; PatternPassing's gloss as a fifth Lean edit; L-04 run at the landing on its owner's word; Grammar's and Sampling's docstrings say transitive where they said compose |
| lean F6 | confirmed | minor | the audit's docstring says every expectation is read from the items' kits, but items 1 and 5 are fixed in it | taken: the docstring says which are fixed and why |
| lean F7 | partly | minor | HeldPossible's doc still cites a law its proof no longer uses | taken by OU's owner (`d54f52264`): it cites the two laws the proof uses |
| lean F8 | confirmed | minor | GrammarMap's list of the reach laws' readers omits Sampling | taken by OU's owner (`d54f52264`) |
| lean F9 | confirmed | minor | «续之对则类类等数»'s doc omits the test that decides the class | taken by items 2–4's owner (he2-item2 `80ccb2e7c`) |
| lean F10 | partly | minor | «对则不越域守数» binds its uncrossed hypothesis as `closed`; «二所闭在借步之所闭»'s doc and law 0 say 'reaches' where «所闭» allows the same occurrence | taken by items 2–4's owner (`80ccb2e7c`): the binder is `uncrossed`; the law's doc, GrammarLaws' closure bullet and law 0 say 'a lies within o's closure under R′'; OU's owner keeps the name (the converse of «借步之所闭在二所闭», borrowed steps being its case), and its doc says it holds for any R′ containing R. SelectionPool's own `to_reads` doc keeps 'o reaches a', in that module's prose, which reads a closure as what is reached |
| records R2 | confirmed | should-fix | master-laws' scope miscounts HE2's reviews, and its note has no clause for the lander's own changes | taken: 'two of HE2'; a 'The landing:' clause in the note |
| records R3 | partly | minor | the hypotheses do not name the Bool reading of regions, classes and continuations or the census's lists without repeats | taken: a hypothesis added as its own item (hypotheses[0] would pass its cap), named in the note |
| records R4 | confirmed | minor | continuation-relative-to-a-class gives Grammar's counts as 68 in 116, stale since OU6 | taken: 70 in 118, read from the receipt |
| records R5 | confirmed | should-fix | generation-and-degeneration's scope gives MapInstances 28 theorems; the receipt gives 27 | taken: read from the receipt |
| records R6 | confirmed | should-fix | laws-at-coarser-steps names Sampling's binding at an older receipt, which the re-point moves | taken: the scope names HE2's receipt; a clause for item 1 in its note |
| records R8 | partly | minor | law 3's census sentence names no pairing; two census lemmas are filed among law 2's list lemmas | taken by items 2–4's owner (`80ccb2e7c`): law 3 says 'each pair a continuation or the same unit', and the two lemmas are law 3's ((a) is folded into lean F10) |
| records R9 | partly | minor | items 6–7's 'no statement's content changes' reads as covering a note that also widens a law | taken: beside another item's clause it reads 'these renames and rewordings change no statement's content' |
| kit F1 | refuted | minor | DESIGN's link to the combined log breaks | refuted: the log is tracked on he2-land |
| kit F2 | partly | minor | the records kit needs files the landing tree may lack; this review was not written | taken: (c): this file, committed before the records step (DESIGN step 1); (a) and (b) refuted |
| kit F3 | confirmed | should-fix | the head was claimed only after the run and the records | taken: DESIGN step 2: the head and the row first, then main merged in |
| kit F5 | confirmed | should-fix | DESIGN gave the texts kit three arguments and never saved the audit's output | taken: DESIGN steps 5 and 10 |
| kit F6 | confirmed | should-fix | the study section N was never checked before the records were written | taken: the records kit asserts N is the study's next section |
| kit F7 | confirmed | should-fix | master-laws' old scope was checked by its first words only, the Chinese not at all | taken: both old texts asserted whole |
| kit F8 | confirmed | should-fix | the study said nothing changed in the re-pointed records, six of which HE2 changed | taken: 'these eight among them, and nothing the other N say changed', from the re-point log |
| kit F9 | partly | minor | the study omits the AI-reading labels and several sections items 6–7 change, and names no owner for items 6–7 | taken: Delta (7) and Output → input completed; the owner named; DESIGN step 8 lists 06 |
| kit F10 | confirmed | should-fix | the board kit never claims HE2's row (owner, workspace) | taken: `head` claims both cells; `land` asserts the row was claimed |
| kit F11 | confirmed | minor | a failure after the kits' parts write leaves records with no notes; check mode never built master-laws' final state | taken: every record snapshotted and restored on failure; check mode builds it |
| kit F12 | partly | minor | nothing asserts that only one record cites the moved laws, or that the study's record list is right | taken: both asserted; DESIGN step 2 scans after merging main |
| kit F13 | partly | minor | the notes, the board and the stamps each take their own UTC date | taken: one local day for the notes; the board dates the receipt by its id; refuted part: no reviewed_at_utc stamp where only a scope changes (RESULT-WORKFLOW) |
| kit F14 | partly | minor | the study states a rehearsal and a clean connectivity check it never reads | taken: both filled from their logs and asserted; 'in the thirteen changed modules' |
| kit F15 | partly | minor | the board kit rebases only some relative links | taken: every relative link rebased |
| repoint F5 | confirmed | should-fix | Becoming.lean's and the READMEs' catalogues of GrammarLaws and GrammarMap miss HE2's additions | taken; items 2–5 sent: item 6's clauses added (he2_core_li.py); item 5's in its own script (`d54f52264`), which also moves MapRegions' bullet out of GrammarMap's, where an earlier landing had put it; items 2–4's in theirs (`80ccb2e7c`): the closure and balance clauses, and Response and SelectionPool among the modules proved from GrammarLaws |
| repoint F6 | confirmed | should-fix | the checker's SCOPE strings, which every receipt carries, miss HE2's additions | taken; items 2–5 sent: as F5, each item's clause in its own kit; SCOPE edits reuse every cached step |
| repoint F10 | partly | minor | a-regularity's does_not_show[2].zh and the GrammarPath record's title.zh write 理 for a regularity | taken: both reworded to 规律, each note with its reason; refuted part: aliases keep the old titles as search keys |
| repoint F11 | partly | minor | master-laws law 18 cites no Response or SelectionPool, though they are now proved as HE2's closure laws | taken by items 2–4's owner (`80ccb2e7c`): their records part adds the three to law 18 with Response's and SelectionPool's proof references bound to the run; the master-laws scope names HE2's derivations there |

## Not taken

Only what the skeptic refuted: kit F1, kit F2 (a) and (b), the stamp in kit F13, and aliases in re-point F10. A refuted part needs no change.

## The owners' word

Each owner decides its own item's wording and its own records' text. The lander asked each one before writing. Their answers came as messages between the working sessions on 31 October. They are AI sessions, not persons.

- **OU's owner** decides the grammar's additions and names, and owns item 5 and continuation-relative-to-a-class.
  - It approved the master-laws-on-the-grammar edits as written: the validation scope in English (593 characters) and in Chinese with three corrections that bring it to the English sense (258 characters); does_not_show[4]; the counting hypothesis; the "The landing:" clause; and the counts (Grammar 70 in 118, MapInstances 27). No reviewed_at_utc stamp, since only a scope changes.
  - It approved the GrammarPath record's Chinese title, with the old title kept in its aliases.
  - It approved continuation-relative-to-a-class's law 10, with one word changed in the English: "a transitive relation" for "a relation that composes". The hypothesis is transitivity, and "composes" in the package means the composition of relations.
  - «二所闭在借步之所闭» keeps its name.
- **As LOGIC's owner** (the review packet's dossier), the same session asked for L-04 to be run at the landing (`--texts --logic`), its Meaning as written. In the same texts step, LOGIC's reader edition is rebuilt, the dossier check reports 0 problems, and LOGIC's front is recounted, unchanged at 1,094 words. 01 §3 says "a transitive relation `K` (a class is one)" before HE2 lands. 01 has no Chinese edition, so 「传递之关系」 is written only in the record's Chinese.
- **Item 1's owner** brought 01 §3, L-04, PatternPassing's gloss and Grammar's and Sampling's docstrings to "transitive" (`ac9276674`), so no word is held for a later rebuild. Items 2–4's owner took the review's findings and OU's wording.
