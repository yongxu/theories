AI-written reading of the landing kit, 13 November 2026

# TT landing kit: a cold read before the heavy checks

Read only (Claude Opus 5.5). I wrote no git command, ran no `check_becoming.py`, render, gate, test or scratch build, and
edited nothing but this file. Two read-only Python passes ran: `json.load` on the changed JSON files, and the
repository's own link parser (`tools/research/moves.check_links`, imported with `-B`, nothing written) over the changed
Markdown. Paths below are relative to the worktree `/Users/ren/tmp/tt/wt` unless they start with `/`. `LEAN` stands for
`experiments/integrated-correction/general-framework/generative-basis/lean/becoming`.

What I read: all three Lean files in full (`LEAN/Becoming/GuardedStep.lean`, `TurningInTime.lean`, and the
`GrammarPath.lean` diff against HEAD), the diffs of `Becoming.lean`, `check_becoming.py`, both READMEs, `02-MAP.md`,
`regions.json` and `dynamics.json`, both new records in full, `NOTE.md`, `READER.md`, the kit (`kit/README.md` and
`fill_records.py`), the parts of `NEAR-WORK.md` that say how each paper was read, the TT board row, and the checklist.
I compared the declaration names cited in prose against the package source, and the layer tags against each import's tag.

**Verdict.** The kit is close to landable. No sentence I checked names a declaration that does not exist. Every cited
name resolves, including `Map.StepWhere.relation`, `ClosedCapture.lockedAlike`, `orbit_paced` and `lock_line`, which
live in `GrammarRegularity`'s `ClosedCapture` namespace. The registration, records, regions, links and JSON are all
sound. Nothing I found would turn the gate red once the kit has bound the records. What is left is one atlas gap that
the gate will not catch, and a handful of sentences that drop a premise that carries weight or add one the Lean does
not have.

## High

1. **The atlas entry is not read for its premises.** `theories/becoming/results/atlas/entries/dynamics.json:1846`
   (`turning-in-time`) is the only one of 184 dynamics with no `premises` field. `tools/research/atlas.py:1414-1415`
   counts a family as read only where every member of it has `premises`. This entry is in family A, so the render
   would quietly move family A ("Absorption and ending", 30 entries, all read today) to unread on the generated atlas
   page. No check fails on this, so the gate will not stop it. It needs a `premises` list (`{law, takes}` for each
   law), with ids for the premises this entry takes (`AloneOutside`, the marks, `kept`/`turns`/`uses`, the regime's
   `Short`/`Meets`/`Keeps`/`FromNothing`, `asItWasEnds`, decided marks) added to `entries/premises.json`. It also wants
   `drops` on the exits. A `compose` to `margin-of-a-regime` and `the-lock-draws-its-readers-out` would join it to the
   map, which is TT's purpose. Neither preparer did any of this; the registration preparer named it as unsettled.
   Also, `hypotheses: []` (line 1926) can now be filled: both records are in the worktree with 4 and 8 hypotheses.
   Ten other entries carry an empty list, so it does not fail as it stands.

## Medium

2. **"the point of no return of the lesser use"**: `theories/becoming/chapters/02-MAP.md:508`, in the Theorem
   paragraph, not the Reading. `turns_in_time_iff` has no premise `H₂ < H₁`. `H₂ + y₂` is the point of no return of
   the kept kind's use `H₂`, whatever its size. Only the witness has `3 < 5`. The record's correspondence
   (`turning-in-time.json:221`, "under the lesser use") is a marked reading, so it may stand, but the Theorem
   sentence says more than the Lean. Suggested wording: "the kept kind's point of no return".
3. **The record's statement drops the premise of its second clause.** `turning-in-time.json:12`: "with no marked
   level it ends where the net ends". `ends_with_net` also needs a positive need, `AloneOutside` and, above all, the
   course as it was in `Optimum`'s form, with at most `r` given and more than `r` taken at every step. Without the
   draw the clause is false (`Three` with a giving above the use would never end). It fits in the 300-character
   cap if the first clause is shortened, or as "with no marked level and a level drawn down, …".
4. **The composed law, as written in three places, drops premises that carry weight.**
   - `LEAN/README.md:396` (and `README.zh.md:245`): "the course as it was starting below `H₁ + y₁` with uses of at
     least `H₁` along its orbit" leaves out giving short of `H₁` below `y₁` (`short₁`). Without it, the course as it
     was need not come below the need, and the exactness at the first marked step fails. The row also leaves out
     the start at most `hi`, the positive need at most `H₂ + y₂`, `FromNothing` and `AloneOutside`.
   - `dynamics.json:1949`, the edge of the exit for `turns_in_time_iff`: it leaves out `Short giving H₂ y₂`,
     `Short giving H₁ y₁` and `FromNothing`. Without the first, `RegimeMargin.ends_iff_below` does not apply. It also
     leaves out `kept` (the kind is kept at every step), and says "uses H2" where the Lean has "every way of the
     kind uses exactly `H₂`".
   - `check_becoming.py:429` onward (SCOPE, TurningInTime) states the composed law with "giving short of H1 below
     y1". It is right but leaves out `FromNothing` and `AloneOutside`; this one is low.

   The record's law (`turning-in-time.json:83`), the 02 text (line 508) and the Becoming.lean bullet (line 5003 on)
   state these premises in full.
5. **The two records carry no Chinese.** In both new records, `title`, `statement`, `laws`, `hypotheses`,
   `does_not_show`, `validation_scope`, `next_delta` and `correspondence` are English only. The validator does not
   require Chinese, but every neighbour does carry it (`a-pool-read-off-the-course`, `the-lock-draws-its-readers-out`,
   `a-loss-read-before-its-point-of-no-return`, `what-a-line-holds-and-a-regularity-takes-in`,
   `constancy-read-at-a-members-class`, `margin-of-a-regime`), and AGENTS.md asks for both languages. The Lean README
   rows do have Chinese.
6. **The counts of the near work disagree.**
   - 02 line 516 names Pezzey and Anderies, Turchin, and Saravanan and Salla, then says "Three were not read whole".
     Only two of the three named were not read whole.
   - `turning-in-time.json` `does_not_show[7]` (line 186) says "three papers were read only in part or from an
     abstract". The same record's correspondence lists four: Turchin and Muneepeerakul and Anderies in part; Self-Sealing and Dalton
     and Coats from an abstract. It lists HANDY under "Read whole", though `NEAR-WORK.md:160` says "search-result
     summaries only" (line 366 has the dissertation chapter read whole in the second pass).
   - `NEAR-WORK.md` disagrees with itself on Turchin: line 294 says "Read whole", line 367 says "partly".

   The count should be settled once from `NEAR-WORK.md`'s source lists, and the same number used in 02, the record's
   correspondence and its `does_not_show`.

## Low

7. **Borrowed field words.** These appear outside citations of the lock modules' own names:
   - 02 line 497: "carrier" in the theorem label ("root: every carrier, relation and class"). The records preparer
     also flagged it.
   - 02 line 500: "in the place of its rule", for `Mechanism.adaptive`'s slot.
   - 02 line 510 ("The lock's courses"): window, loss, losses, share and lock are used as plain words ("the loss as the
     level", "the losses in `[N, K)` marked", "course read off the share", "premises that keep a lock").
   - 02 line 514: "that a lock needs nothing of what it uses".
   - 02 line 516 (the Reading): "lock outliving its loss", and "an overseer, a stock with its balancing loop, lock-in"
     as glosses of other fields. A gloss is acceptable; the first phrase is not one.
   - `TurningInTime.lean`'s "What is given" (the same phrase, which READER.md lists as a low left open).

   The registration (SCOPE, the bullets, the README rows) and the records keep these words to the modules' names
   (`Locked`, `ClosedCapture.loss`, `lockedAlike`, `windowRead`, the "Lock-in Hypothesis" title). "renew" is used only
   as the function's name. The only name that fits a person is `core_tells` (READER.md says so).
8. **`B = Nat` drops out of `locked_at_class` downstream.** The Lean states it with the level a whole number. The
   record and the Lean header say so; SCOPE (`check_becoming.py:457`), the bullet (`Becoming.lean:5055`), the README
   row and 02 line 510 do not.
9. **Two argued sentences read as if a single Lean statement held them.**
   - 02 line 497: "A determined law's step never lets the net end, so on it the three coincide". This follows from
     `«同行当且仅当有常»` with `«有常当且仅当至终有常可续»`; no single statement says it.
   - 02 line 510 and the atlas mechanism: "in them no line ends where the net ends". This follows from a total step
     plus `net_zero` through regrouping, which READER.md lists as a low left open (v4 L5).

   Either name the pair of laws or mark the sentence as argued.
10. **A law cited under the wrong clause.** `LEAN/README.md:332`, the GuardedStep row, puts
    `Law.stepWhile_hasSucc_iff` beside "a configuration conditions nothing exactly where it cannot go on". That is
    `stepWhile_none_iff`; `hasSucc_iff` is the successor in a line under `E`. The Chinese row (line 48) has the same
    grouping.
11. **The leaf bullet does not say why it is a leaf.** `Becoming.lean:5003`, TurningInTime's bullet, ends "A leaf."
    Board rule 9 asks a leaf's row to say why (an instance, a tool, a model), and the board row says "a model".
12. **The board row's count is stale.** It says "(A) six theorems added to `Becoming/GrammarPath.lean`"; seven landed.
    It also says GuardedStep's laws are "each … derived from the total step's", but `stepWhile_steps_iff` has its
    own induction and three laws are proved pointwise. The landed clause should say seven.
13. **"Insertions only" is true of the text, not of the lines.** The GrammarPath diff rewrites one existing header
    line (`are their corollaries. In a finite descent …`), splitting it around the new sentences, and leaves two
    lines over 100 characters. This is harmless, since any byte drifts the three bound records anyway, but it
    corrects the registration report's "insertions only".
14. **Other small points.**
    - `turning-in-time.json:170`, `does_not_show[3]`, is kind `non-implication` with no witness. Its content (the
      models are total by construction) is a scope.
    - `NOTE.md:28`: "its six dependents rebuilt clean". GrammarPath has three direct importers (GrammarCases, OwnClass,
      RoutesToC) besides GuardedStep and the root; six may count transitive ones. I cannot check this without a
      build.
    - Hypothesis 8 of `turning-in-time` calls the joined step "the net at a need of nothing". That holds only through
      regrouping, which item 9 covers.

## Claims against the Lean (item 1): what holds

I checked these against the statements, premises included:

- **GrammarPath's seven laws.** The header sentences, the bullet, SCOPE and both README rows match them. The header
  says, and the records repeat, that `«局定后则有常当且仅当同行可续»` follows from them but is not checked in Lean.
- **GuardedStep.** All 14 public declarations match the header, the bullet, SCOPE, the README rows and the record's
  laws 4 to 8, apart from item 10. `stepWhile_toEnd_decides` (the Bool witness, under the one) says what its texts say.
- **TurningInTime.** The bullet, the record's laws and the 02 text match `toEnd_iff`, `constant_iff`,
  `constant_iff_needs_nothing` (a given `w₀`), `kind_toEnd_of_unmarked`, `unending_iff_first_marked` (`asItWasEnds`,
  decided marks), `unending_iff_above`, `kind_not_toEnd_of_turn` (`un₀`, `keeps`), the lock section, and the window
  laws.
- **The witness.** I recomputed it: the course as it was runs 9, 8, 6, 2, 0. Marked at 9 the way turns with 8 left;
  marked at 8, with 6 left; marked at 6, with 2 left, and the line comes to `(false, 0)` at step 4. `H₂ + y₂ = 6`. The
  records, 02 and the atlas say this.
- **The layer sentence and the counts.** "L2 only through `OwnClass` and `ReadOffInTime`" holds: GuardedStep,
  GrammarRegularity and PoolFromCourse are tagged L1, OwnClass and ReadOffInTime L2. The NOTE's counts are right:
  1 definition and 13 theorems; 32 public theorems and 12 definitions, 44 in all; GrammarPath at 108 theorems.

## Checklist, sections A, C, D, E (item 2)

**A.** The checklist's plan (one L1 leaf importing only RegimeMargin, plus section B) was written before the scope was
widened (board, `3582ee38c`). What landed follows the widened row, and that is right.

- **A.1, the module files.** Done differently: two new modules and an edit to GrammarPath. There is exactly one
  `TurningInTime.lean` and one `GuardedStep.lean` under the tree; the held attempt is `.lean.txt`.
- **A.2, CORE.** Done. `"Becoming.TurningInTime"` follows `"Becoming.ReadOffInTime"`, and `"Becoming.GuardedStep"`
  follows `"Becoming.GrammarPath"`, both in `check_becoming.py:113`. The order is harmless: `closure` is a depth-first
  search over imports (`check_becoming.py:4067`). Every import of both modules is in CORE, and none is in INSTANCES or
  APPLICATIONS.
- **A.3, SCOPE.** Done: one sentence added to GrammarPath's paragraph (line 301 on), GuardedStep's paragraph after it
  (308), TurningInTime's after ReadOffInTime's (429).
- **A.4, the imports.** Done: `import Becoming.GuardedStep` after GrammarPath (line 390), `import Becoming.TurningInTime`
  after ReadOffInTime (line 400).
- **A.5, the layer tags.** Done and correct. GuardedStep is L1: GrammarCourse, GrammarPath, GrammarRegularity and
  Lasting are all L1. TurningInTime is "L2, through `Becoming.OwnClass` and `Becoming.ReadOffInTime`": those two are L2,
  and GuardedStep, GrammarRegularity and PoolFromCourse are L1. Both tags match the parser's pattern. Only TurningInTime
  ends "A leaf", which is right, since TurningInTime imports GuardedStep.
- **A.6 and A.7, the README rows.** Done in English and Chinese, with GrammarPath's row extended in place.
- **A.8, regions.** Done: modules `map/grammar` and `map/general`, records `map/grammar` and `map/general`. A record
  homed in 02 must be `map`, and both are.

**B** does not apply, since RegimeMargin is untouched. What drifts instead is the three records that bind
`GrammarPath.lean` and the ten that cite the receipt file. The kit's single repoint covers all thirteen
(`kit/README.md`, step 7); I read `repoint.py`'s arguments and the combination works.

**C.** The records have the required fields and allowed values: kind `theorem`; status `recorded-checked`; relations
`formal-reuse`; roles from the list; `does_not_show` kinds from the list; every `standard_boundaries` entry known; each
witness among the references' declarations; every counterexample and `interface.evidence` path a hashed reference.
Every field is within its cap (statements of 298 and 276 characters, correspondence 1,199). Hypotheses number 4 and 8.

Every public declaration is named in exactly one law: GrammarPath's 7 and GuardedStep's 14 in
`going-alike-up-to-the-nets-end` (21 in all), and TurningInTime's 44 in `turning-in-time`. There are no duplicates,
none outside the references, and no alias collides across the records.

The placeholders (`FILLED-BY-KIT` ×22, `RECEIPT_TIMESTAMP`, empty `proof_bindings`) match what
`kit/fill_records.py` replaces. Its receipt reading (`modules[].module`, `declarations[].name`, `source_sha256`)
matches the live receipt's structure.

Missing: Chinese (item 5). Joining a law family is optional, and neither record joins one.

**D.** Done. §11 is inserted at 02 line 492, before `<a id="not-shown">` (line 518). `git diff --numstat` shows 27
insertions and no deletions, so no existing line was rewritten and lines 1-16 are untouched. Both anchors are of the
form `r-<id>`. Two references were corrected against the designer's text, and both corrections are right: `01 §7` (the
anchor `r-shared-laws-on-the-grammar` is in `## 7`), and `07 §4.10` for `«类闭则本类常闭»` (`07-SIGNIFICANCE.md:676`).
`07 §4.6` and `07 §3.6` also check. The atlas entry was added, but without premises (item 1).

**E.** Done.
- NOTE.md opens with an AI-written line, gives the board row, Ren's words (the quote checks against the sources file,
  line 101), the modules, the anchors and the record ids, then the RESULT-WORKFLOW block, what is proved (each item
  marked substantive or near-definitional), the failed candidates kept, and the readings.
- READER.md summarises six reports instead of being one reader's report. That suits this item.
- No study note links a `.lean` file: `drafts/LEAN-TO-ROOT.md:5` links the `.lean.txt`, and `map/landing.md:94` holds
  the row inside a double-backtick span, which the parser treats as code.
- No link has the form `File.lean:NNN`.

## Links (item 3)

The repository's parser checked 46 Markdown files and 1,003 links: `02-MAP.md`, both Lean READMEs and the whole study
folder. It found 0 broken links or anchors. In the records, every reference, counterexample, evidence and canonical
path resolves except the receipt placeholder. The atlas sources `02-MAP.md#turning-in-time`,
`#r-going-alike-up-to-the-nets-end` and `#r-turning-in-time` exist. `02-MAP.md`'s other links to `.lean` files (lines
139, 307 and 470) were already there.

## JSON (item 4)

`regions.json`, `atlas/entries/dynamics.json`, `records/going-alike-up-to-the-nets-end.json` and
`records/turning-in-time.json` all parse. There is no JSON file in the study folder.

## What a landing here still needs that neither preparer did (item 6)

Compared with K2 (`7c7860eb1`, then regions in `f95fab769`) and K3 (`b110553be`, receipt `5fab3baf4`), which carried no
atlas entry in those commits:

1. **The atlas premises** (item 1): the entry's `premises`, the new ids in `entries/premises.json`, and `drops`, so
   that family A stays read. The `hypotheses` can now be filled from the records.
2. **Chinese for both records** (item 5), as K2's and K3's records had.
3. **The sentence fixes**: items 2 to 4 and 6. Make them before the kit runs, since the records hash 02, NOTE and the
   records' own text, and an edit afterwards drifts them.
4. **The landed clause**: say seven GrammarPath laws (item 12). K2's kit carried `kit/board.py` for the head and landed
   clauses; this kit leaves them to checklist steps 4 and 12.
5. **Not needed, and correctly not done**: no module counts in `Becoming.lean` or the READMEs need updating (searched);
   lines 1-16 of 02 (the "§§2–9" thesis) stay frozen, as K2's did; the board row's "feeds … the map's first path"
   (`results/map/`) is a follow-up, not part of this landing.

The full suite, gate and render were not run, by design: this was a read before the heavy steps.
