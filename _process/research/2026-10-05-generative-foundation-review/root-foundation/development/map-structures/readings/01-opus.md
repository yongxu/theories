*Claude Opus 5.5's own reading, 9 November 2026, written before Fable's or astra's was seen (AI-authored). Every figure is measured on main at `008c950e5` by the scripts in `/Users/ren/tmp/map-study/work-opus/`; other claims are marked as read in a text, argued, or a guess. One count was corrected after astra's reading was seen: 285 exits, not 284; the first count ran on the live tree before ZB's render added one exact exit.*

# The map: its structures, and what they are for

## 1. What the map is now, as a structure

Six layers, measured:

| Layer | What it holds | Typed or prose | Joined to |
|---|---|---|---|
| Lean | 391 source files under `Becoming/`; the shared-laws measure binds 4,204 record laws to declarations: 941 reach the grammar, 2,099 rest on none of the five shared laws (closure, balance, finite runs, lumping, widening) | fully typed | records, through proof bindings |
| Records | 543 (536 live): statement, laws with declarations, hypotheses, `does_not_show`, counterexamples, 1,298 dependencies (each with a relation such as formal-reuse), 1,438 "related" | ids and laws typed; hypotheses, limits and correspondence prose | Lean; chapters at `#r-<id>`; the graph |
| Chapters | eight homes, each result stated once | prose | records |
| Theory graph | 3,237 nodes (543 results, 536 sections, 390 modules, 1,724 classical text units, 41 grammar concepts, 3 dossiers), 6,962 edges, mostly proved-in, imports and states, then the records' own "related" and formal-reuse | typed | nothing in the atlas: no dynamic, correspondence, test, premise or open item is a node |
| Atlas | 177 dynamics in eight families; 285 exits, 101 transitions, 39 test links, 11 `forbids`, 39 `beyond`, 728 quoted open lines | ids, strengths and kinds typed; mechanism, condition and beyond prose | 224 of the 536 live records; Lean names |
| Crosswalk | 1,183 correspondences: 838 from Ren's sixteen folders, 345 from twelve domains | relation typed (agreement, scope, divergence, contrary reading); readings prose; every one labelled AI reading | 351 records; through them 681 entries reach 151 dynamics |

What the measurements show:

- **The atlas is a catalogue of regions with ways out, not yet a map of where courses go.** Of 285 exits, 22 name the dynamic they lead to; 151 are witnesses (a constructed example, no condition); 57 dynamics have no exit. No transition names what it goes between, and 116 dynamics have none. The plan's first view (PLAN §8.1, "exits as arrows, transitions as ridges") cannot be drawn from this data: it would be 22 arrows among 177 points.
- **Premises are not objects.** The records hold 1,248 hypotheses as 1,218 distinct strings; one premise, discrete steps with natural-number levels, appears in at least four spellings (9, 5, 3 and 3 records). The premise card in 08 §4 lists the premises in tables with their Lean names, but nothing joins a law to a row of it. The shared-laws measure does join laws to five premises by Lean dependency, and it is the best structure the map has.
- **Of the eight kinds of entry the plan designed** (dynamics, transitions, exits, premises, theses and tests, correspondences, open items, events; PLAN §3.2), two exist as files. Exits and transitions sit inside dynamics; premises, tests, open items and events are not entries.
- **Wisdom lives in two structures that do not meet.** 1,724 classical Chinese units are graph nodes, each with a formal reading (`form`) and a role (definition, conditional law), joined to 278 results by `read-as`. The crosswalk, a separate file, has 10 entries for Chinese classical thought and 10 for Buddhist thought. Of the 345 domain correspondences, 328 rest on the AI's knowledge with no text read. No person's reading of any entry is recorded.
- **The atlas is in English.** 6 of 177 dynamics have a Chinese name; none has a Chinese mechanism.
- **The pictures draw the repository, not the dynamics.** `spine.svg` draws chapters and their formal-reuse counts; `connections.svg` and `map.html` draw folders and domains against chapters. The atlas has no picture. Nothing draws a dynamic, a course or an exit.

**Where the structure carries the content, and where it lists it.** It carries provenance and proof well: what proves, states and cites what, which laws reach the grammar, standings derived from records and never typed. That is real and rare. It lists the dynamics. Forming, persisting, changing and ending are family letters (A, G, H). Selection, drain and lock are families (B, C, D) whose defining terms, who selects, reading what, through which couplings, what lies beyond, from whom the rule's readers are drawn, live in prose. The meta-attractor shows the gap most clearly. `closed-capture` is a theorem entry with two exits, both to nowhere. The corpus's wide sense is `open`, with no base and no exit. The second and third orders, capture reaching the routes of correction and selection for narrowing what couples in, are readings with no exit. ZB's 07 §3.5 names the limit: "a selection that removes its own readers … is not stated here". The map is densest where the dynamics are simplest (29 absorption and 34 renewal entries, mostly on World or any type) and thinnest where alignment needs it most: 5 of the 16 capture entries have no base.

## 2. Better structures for the four uses

The account's object is a net of relata related by condition, with classes (sameness in some respect), continuation (linked and alike), reach (closure), two grains (parts and pattern, the coarse net between classes), and flows with couplings, takers and readers. My argument: the map's data should be that object, so that the account's own operators run on the map itself. Three structures follow, then the views.

### 2.1 Understanding: the landscape, as a transition system

Make every exit and transition an edge between regimes:

```json
{"edge": "exit",
 "from": "closed-capture",
 "to": "<a dynamic id> | outside:unrepresented | unknown",
 "via": "Becoming.ClosedCapture.turned_by_loss",
 "condition": {"en": "a rule read favouring at no loss of at least N, each step adding at least one: after every reading step past N the course is not locked"},
 "control": {"en": "a level reading beyond the share"},
 "strength": "sufficient", "base": "any type", "records": ["closed-capture"]}
```

`closed-capture` today has two exits, `turned_by_loss` and `loss_ends_line`, both sufficient and both `to: null`, one transition (a pace bound, `readers_uniform_locks`), one run test (T7, `experiments/self-rewarding-lock`) and a `forbids` in prose. Its likely destinations are already entries: `readers-drawn-from-the-selected` (the turn holds exactly where the others' reading is not above the carriers') and `loss-read-in-time-by-the-others` (when it holds in time). Only the edges are missing. Which target is right is a curator's reading of the records, not mine to settle here.

With edges, the grammar's own reach (及) runs on the map. "From closed capture, which regimes can a course reach, by which laws, at what strength?" becomes a query. A route's strength is its weakest edge (witness, then sufficient, then necessary or exact). Regimes with no way out show as sinks, `attraction-is-not-returning` applied to the map itself. The picture is a state diagram on two axes the account supplies: what a selection reads (only its share, through to beyond it), and what a course does at the grain of its parts (degenerate, keep, generate). Closed capture sits at "reads only the share, keeps", and its arrows point toward "reads beyond". That is the account's picture of the alignment problem: the regime and its ways out, each arrow a law.

*Cost:* a curator pass over 285 exits and 101 transitions (an extractor and a checker per family, about 16 agents, or one session per family); a validator rule that every exit names a target or says `outside` or `unknown`; about 300 lines in `atlas.py`. *Hides:* an arrow says a course can leave, not that it does. A witness arrow is an example and must be drawn apart (dashed). A drawn route invites being read as a forecast.

### 2.2 Storing and indexing: premises as the coupling surface

Make the premise card's rows entries, and point every hypothesis at one:

```json
{"id": "balance", "name": {"en": "Balance", "zh": "守数"},
 "lean": ["Becoming.World.Balanced", "Becoming.Flow.Balances"],
 "kind": "world premise | representation commitment | local hypothesis | application obligation | ethics, not asserted",
 "holds_in": ["<model ids>"], "fails_in": ["<witnesses, as World.independent gives them>"],
 "world_side": {"en": "every change of a level is what is taken from it and given to it: measured how, in which systems"},
 "used_by": "generated from records and the Lean dependency measure",
 "tested_by": ["<tests that measured whether a system met it>"]}
```

Each record's hypotheses become `{"premise": "balance", "text": {...}}`, the text kept as written. `shared_laws.py` already measures balance's reach by Lean dependency (853 laws); generalizing it from five shared laws to the card's rows by declaration, and to the rest by a curated pass, gives the coupling surface. Someone could then ask: if balance fails in this system, which laws stop applying and which dynamics lose their footing? Which premises has no test ever touched? What must a builder measure before applying T3? The same premise ids index the map, alongside grammar concept → dynamics (today "is a case of" exists for the 11 derived central declarations only), reader → claims, and tradition → dynamics.

*Storage* stays JSON in git, which is the repository's strength (diffs, provenance, nothing deleted). Normalize to one file per kind (dynamics, edges, premises, tests, open items, readings, readers, events), with derived fields generated, and compile one `map-graph.json` that merges the theory graph and the atlas. For queries, a SQLite or DuckDB build artifact is enough: about ten thousand nodes needs no graph database. One addition from the repository's own history: every quotation of a home (a crosswalk `says`, a dossier, a front) stores the hash of the sentence it quotes, so that editing the home flags every quote of it. Restatement drift has been hit repeatedly (30 and then 64 crosswalk entries kept old wording after corrections). Hash-binding makes it computable instead of searched for.

### 2.3 For alignment: the selection net, a case in the account's own terms

The laws on selection, drain and capture are stated on `Flow` and `Web`: formations, conditions, couplings, taking and giving, readers, and a rule formed from a share. A case written in the same terms:

```json
{"case": "reward-model-pipeline", "drawn_by": "<who drew it, and when>",
 "formations": ["policy", "reward-model", "raters", "operator", "users", "others-affected"],
 "conditions": ["ratings", "deployment-share", "user-wellbeing", "information-commons"],
 "couples_into": [["ratings", "policy"], ["ratings", "reward-model"], ["deployment-share", "operator"]],
 "affects": [["policy", "user-wellbeing"], ["policy", "information-commons"]],
 "rule": {"read_from": "ratings", "readers": ["raters"], "readers_drawn_from": "operator"},
 "time": {"reading_step": "per release", "point_of_no_return": "unknown"}}
```

A checker computes what the theorems quantify over:
- each selector's coupling closure and its *beyond-set*: what its acts affect outside what couples in, which by `BeyondCoupling` no selection read off its continuations tells apart;
- whether the rule's readers are drawn from the selected;
- whether a reading of the beyond can land before the point of no return;
- whether the rule and its reading are read only from the share (closed capture);
- which formations' acts return, and whether the net is mutually dependent (07 §4.8–4.9).

It reports which dynamics' premises the case meets and the exits the atlas lists for them. Finite cases with reach decided are exactly where the core's theorems are decidable, so a small case can be checked by `decide` in a leaf, the way the plan's §8.2 meant to check phase diagrams.

This is how the map gets used inside a selection: an alignment team writes its pipeline as a case and sees where its selection is blind by theorem. *Cost:* a schema, a checker of about 500 lines, three worked cases (the one page's lake, a reward-model pipeline, an institution's rule). *Hides:* everything turns on how the case is drawn, which formations and which couplings. The classes and standpoints are supplied, not derived (07 §4.8 lists them), so a case's drawing is where a reader's bias enters, and the file must say who drew it.

### 2.4 The views that follow

- **The landscape** (2.1).
- **Exact phase diagrams** for decidable conditions (PLAN §8.2): a picture that is a theorem, checked at sample points by `decide`.
- **The coupling surface**: each premise against the laws resting on it, the tests touching it, and the systems known to meet or fail it.
- **Traditions against dynamics, not chapters**: with the dynamics no tradition names, and each tradition's points the account lacks (`source_adds`) drawn as open items.
- **Readers**: who has read each claim (Lean, a frozen test, an AI model, a person).
- **Zoom as quotient**: the grammar's coarse net, 粗. A view at a class (family, base, region, premise) is the quotient by that class, so zooming means changing the class, not hiding nodes. What persists across a zoom is what continues relative to both classes, the account's own definition. The generic toolkit (force layouts, faceted filters) stays right for search. For the pictures that carry meaning, the account's own operations are the better grammar.

## 3. The map and the world

The map touches the world in three ways, and the structure should keep them apart:

1. **Proof on a model.** A law holds of whatever meets its premises. The atlas's bases: World 60, a named model 38, any type 36, any process 15, periphery 11, the root 8, none 9.
2. **Application obligations.** The premise card has "Observables: claims realized, levels, dependence and drawing correspond to actual histories" as a premise of no theorem (read in 08 §4). Every application of a law to a system passes through such an obligation. Today it is one table row; on the coupling surface it is where evidence attaches.
3. **Tests and readings.** Theses T1–T8 are frozen and run: 25 dynamics are touched by a test, and the outcomes are mixed (read in ONE-PAGE and TESTS). Correspondences are AI readings; a sample of 100 put 14.2% of labels or roles and 3.2% of readings wrong.

**How wrongness would show.** A proved law is not wrong where its premises hold. The map is wrong where a premise is false of a system it was applied to, where a forbidden outcome occurs (only 11 dynamics say what they forbid), or where a reading misreads its source. Failures should be nodes: failed tests, premises failing in named systems, counterexamples (the records have the field), failed candidates. ZB kept one: "coupling the dweller in turns the joint selection against its loss" fails. AGENTS.md says to keep these. The atlas shows none as an entry.

**The map read by its own law** (argued). Selection through couplings reaches exactly what couples in (03). The map is a selection: what is recorded, read and drawn. What couples into it: the Lean, Ren's folders (838 of 1,183 correspondences), the AI's knowledge (328 domain entries without a text), and one class of reader, AI. Beyond its coupling closure lie the traditions in their own texts and holders, the people alignment decisions fall on, and the systems not tested. A view of the map's own beyond-set is the most direct picture of "how far it has been seen". And by `readers-drawn-from-the-selected`, a map written, read and checked by readers formed from its own outputs meets the premise of closed capture. Today the records are AI-written and AI-checked, every correspondence is AI-read, and Ren's yes shows that a wording fits what he means, not that a reading is right. The structure makes this visible only if readers are first-class.

## 4. The map and alignment, "even universal alignment"

**Trained systems.** The drain beyond a reward (05, T3; LA4's Stage A contradicted nothing and left its locus unresolved); goal misgeneralization read where an order is fixed only on the occasions met (07 §4.9's reading); selection through couplings. The case format turns these into a check by theorem, not by analogy.

**The joint selection.** GOALS asks that the rule read beyond the shapers' share, that a lock be left in time, and that courses be compared by widening. ZB's newest result sharpens the first condition (read in 07 §3.5). It is not supplied by the shapers' own selection: it holds where the loss is coupled into a reader of the selection, "a coupling to keep, not a consequence of selection read off continuation". And coupling in does not fix the direction (`where-the-blindness-lifts`, with the failed candidate kept). So an aligned joint selection is a structure to maintain, readers and couplings and timing, not a property selection produces. The map's role in it, argued: to be a reader of what lies beyond, held in common, that no party owns.

**"Universal".** What it can mean in the account's terms:
- *Universal in the scope of the laws.* The selection laws hold for any type or any process, so genes, markets, institutions, minds and trained systems are cases of one law. True as far as proved, and mostly near-definitional.
- *Every standpoint counted.* This is the continuation condition. Held de se, it is exactly mutual dependence along affecting (07 §4.8–4.9, theorems). On a relation with no cycle and two distinct centers it fails (route (b)'s universal form, closed). So the universal condition forms where relations close, not along one-way relations and not in time unfolded, which has no cycle. In this sense universal alignment is a property of the net's shape: every selector's coupling closure takes in what its acts affect, or each remainder has a reader in time.
- *What it should not mean.* One rule or value for every selector: that is the meta-attractor's form, one rule read from one share, its readers drawn from it. Nor closure reached by dominance: mutual dependence includes mutual drain (05; 07 §4.8), so making everything depend on one thing closes the net and is capture. Nor an end state: under `Flow.persists_not_listsAdmitted`, no finite listing holds what a persisting line admits, and an order on listed paths never ranks the course actually taken. Universality is kept, not reached.

So, argued: universal alignment is a set of invariants over every selection in the joint net, not a value. (i) Each selector's beyond-set has a reader coupled into the selection, not drawn only from the selected. (ii) It is read before the point of no return. (iii) The routes of correction cannot themselves be captured (second- and third-order capture). (iv) Courses are compared by what they keep open, with the continuation condition and C named, not asserted. The map supports (i) and (ii) by theorem on models. It is thinnest on (iii): readings, no exits. (iv) is conditional.

**Using the map without it becoming a lock.** The map must meet the same invariants: readers from beyond its makers (people, traditions in their own words, tests that can fail); its rule of entry read by readers not drawn from the selected; its errors read in time (failures as nodes, drift flagged by hash); no guardian (Lean, public, forkable). For an AI using it: read the landscape and premises through a tool interface, write cases, get beyond-sets, add readings labelled as its own, and never edit a standing. The rule the atlas already keeps for standings (derived, never typed) generalizes to: no reader writes its own verification.

## 5. The map and wisdom; the complete system

- **Join the two wisdom structures on dynamics and premises, not chapters.** The 1,724 classical units already carry a formal reading and a role, so they can be read onto dynamics. The crosswalk's domains should be read onto dynamics too, and `source_adds` should become edges into open items: what a tradition sees that the account does not.
- **Keep each tradition's own structure.** Store a tradition's terms and their relations as its own small graph, and a correspondence as a partial mapping between two graphs, not a dot in a chapter's column. Where the mapping preserves a relation, they meet. Where a term has no image, or its image breaks a relation, they do not. 道可道，非常道 then becomes a structural fact: no mapping is total, and the remainders are drawn.
- **The complete system is a loop, not eight chapters.** Root → map → knowing → life and collectives → significance → alignment → back to the root, since the map and its readers are formations within it. Show it with one case moving through it.
- **What a reader should see first:** one case on the landscape, with its beyond-set, its exits, the traditions that saw that dynamic, and the holes.
- **The holes, as white space:**
  - gaps with no law (hysteresis, cycles with a period, noise-driven exit, higher-order capture);
  - 152 of 177 dynamics untested;
  - no person's reading recorded;
  - 328 domain entries with no text read;
  - 171 dynamics with no Chinese name.

## 6. Where the question, or the direction, may be wrong

1. **Structure is not coupling.** The largest gaps are not data-structural: runs that could fail are held, no person's reading is recorded, most of the world's wisdom is AI knowledge. A better structure shows the holes; it does not fill them. By the account's own law, refining what already couples in reaches nothing beyond it. The risk is a fine map built in place of the couplings.
2. **"Universal alignment" read as one alignment for all has the meta-attractor's shape.** The account gives universality only as invariants of a net, held where relations close and kept in time. ZB shows selection does not produce them. The work is the design and keeping of readers, which the map can inform and cannot perform.
3. **"The complete system" collides with the account's own theorems.** No finite listing ranks the course taken; no selection reads beyond its couplings; 道可道. Complete should mean: every part says how far it has been seen, and the holes are drawn as part of the map.
4. **The priorities run against the purpose.** If the map is first for alignment, its most important dynamic, a selection coming to select for control over its own selection (capture of the routes of correction, a selection removing its own readers), is its least formal: readings, no exits, no base, and named as not stated by ZB. The densest work has gone where proof is easiest.
5. **The map of wisdom is its least checkable part, and the atlas is English-only.** A reader whose first language is Chinese, as the classical corpus's is, cannot use the atlas.
6. **The question suits me too well.** "Better data structure" is the question an AI answers well and fast. The account's warning applies to me: I can make the map more legible to AI more easily than I can make it more coupled to the world.

## 7. What to build first

1. **The landscape.** Give every exit a destination and every transition its two sides; add the validator; draw the landscape; compute reach over it, with each capture-family regime's routes out and their weakest strength. Size: one extractor and one checker per family (about 16 agents) or a session per family; about 300 lines in `atlas.py`; outputs `entries/edges.json`, `landscape.svg` and a routes table.
2. **Premises as entries.** `entries/premises.json` from 08 §4's card; the 1,248 hypothesis strings assigned to it by an AI pass and a checker, with records gaining premise ids beside their text; `shared_laws.py` generalized to premise dependence; a generated coupling-surface page. Size: medium, about one session plus two readers.
3. **The case format and its checker.** `tools/research/cases.py` and `cases/{lake,reward-pipeline,institution}.json`, computing coupling closures, beyond-sets, readers drawn from the selected, returning formations and mutual dependence, each joined to dynamics and exits; later a finite version checked by `decide` in a Lean leaf. This turns the map into an instrument for alignment and gives people something to check against their own systems.

After these: formalize higher-order capture with an exit (a board item, Lean); join the classical corpus and the crosswalk on dynamics; make readers nodes; give the atlas its Chinese.
