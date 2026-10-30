# HE2's items 2, 3 and 4: U4's laws into GrammarLaws

*AI-written kit, 31 October 2026, by U4's taker, for whoever lands HE2's rebuild (the board's HE2 row, items 2 to 4). It is checked outside the package; none of it is package Lean yet.*

**Who decides what.** Item 2 is U4's own (lever 1, landed `c5e6b1060` as a study scratch). Items 3 and 4 came from U4's boundary review (u4-edge `2cc1bac0b`, DESIGN-BOUNDARY §3). The coordinator routed them here on 31 October 2026: neither Response nor SelectionPool has a live owner, and both edits are proof-only with every statement kept. OU's owner decides the GrammarLaws additions, since the grammar is theirs, and read every «» name below: all were taken as sent but two in the census, renamed on that reading. «前并生» and «后并亡» read before ++ arising and after ++ ceasing, with «并» the word of joined lists («对之并»), where «前生» read alone means a former life. «前者在前» and «后者在后» say what the hypotheses state, the predecessors lying in the list before and the successors in the list after, with «在» as in «缘在所闭»; «步闭» would have read as «闭», a forward closure the hypotheses are not.

## What lands

Three model lemmas are re-proved through the new laws, and 38 declarations go into `Becoming.GrammarLaws`. No name in the package changes and no statement changes, so no record is rebound.

| item | into GrammarLaws | re-proved through it |
|---|---|---|
| 3 | `«所闭之逆»`: `«所闭» («逆» R) x y ↔ «所闭» R y x`, after `«所闭之对称»` | Response's `WithinClosure.converse` (10 uses), so `Flow.mutuallyDependent_iff_reach` reaches the grammar through it |
| 4 | `«借步之所闭在二所闭»`, `«二所闭在借步之所闭»`, before `end Closure`. On the region of `o` or `a`, Frame's `WithinClosureOf` is `«所闭» R o g ∨ «所闭» R a g`, so no new form is needed | SelectionPool's `WithinClosure.of_reads` and `WithinClosureOf.to_reads` |
| 2 | counting and the class law, before `end Balance`; the census of a step, in a new section after `end Runs`; the list helpers, in the existing `namespace GrammarLaws` block | nothing: the laws are new to the grammar |

**Item 2's laws.**

| name | statement |
|---|---|
| `«计»` (definition) | How many units of a list a test holds of. A region enters as a test `α → Bool`, which is a modelling choice; a region given as a proposition enters by `decide`. It is the structural twin of `List.countP` (`GrammarLaws.count_eq_countP`, empty report), and the grammar keeps its own because Init's `countP` lemmas report `propext`. |
| `«对则不越域守数»` | A pairing keeps the count on every region the relation does not cross (`∀ x y, R x y → p x = p y`). |
| `«对则双闭域守数»` | The same for every region closed under the relation and under its converse, stated with `«闭»`. |
| `«对而单闭域不守数之例»` | Witness: closed one way is not enough. Take one step 0→1 and the region {1}: `[0]` is paired with `[1]`, and the count is 0 before and 1 after. |
| `«类之对当且仅当类类等数»` | Under a class decided by a test, `«对» E a b` holds exactly where every class counts as many units in `a` as in `b`. |
| `«一对而静不对之例»` | Witness, cited by the class law's docstring as its scope, since the class does work: `[0]` and `[1]` are paired under `«一»` and not under `«静»`. |
| `«续之对则类类等数»` | A pairing under `«续» R E`, with `E` a class decided by a test, keeps the count in every class. This is what a pairing under continuation adds to equal count. |
| `«定后定前则前并生对后并亡»` | The census of a step. Take units listed once before and after it, under `«续» R E` decided by a test, with successors and predecessors fixed. The units before, joined with those arising, are paired one to one with the units after, joined with those ceasing; each pair is a continuation or the same unit. |
| `«前者在前则所列生者生»`, `«后者在后则所列亡者亡»` | Where every predecessor of a unit after the step stands before it, the units listed as arising are exactly those after that begin (`«生»`); where every successor of a unit before stands after it, those listed as ceasing are exactly those before that end (`«亡»`). |

**Item 2's helpers.** None has a «» name.
- With `«计»`, as `total_congr` already stands in Balance: `GrammarLaws.count_append`, `count_insert`, `split_of_count_pos`, `count_go`, `count_eq_countP`, `uncrossed_of_closed`, `class_test_congr` and `pair_of_class_counts`.
- In the list block: `keep`, `keep_append`, `keep_congr`, `keep_all`, `mem_keep`, `any_false_mem`, `any_split`, `any_remove`, `any_true_of_mem`, `any_false_of`, `mem_middle`, `mem_of_removed`, `distinct_removed` and `not_eq_true_iff`.
- In the census section: the definitions `GrammarLaws.arising` and `GrammarLaws.ceasing`, and `GrammarLaws.census_pairs`.

**Changes from lever 1's scratch.**
- The law the scratch called `«对则闭域守数»` is renamed `«对则不越域守数»`. `«闭»` is closure one way, and a region closed only forward does not keep the count, as the new witness shows, so the old name stated a wrong meaning.
- The census holds for `α : Type u`; lever 1 had `Type`. The prelude's `Distinct` and `ListTests` are polymorphic over universes.
- `countIn_all` is dropped, since only a model bridge used it.

**What stays in the study as evidence.** The nine declarations of lever 1's scratch that read a model (`Flow`, `Web`, `Continuity`) stay there: `census_pairs_of_fixed`, `census_balance`, the Nat representations and the bridges. The scratch's own `total_congr` is not restated.

**GrammarLaws' module doc.** Five edits:
- a `«计»` row in the table;
- the Closure bullet names items 3 and 4, and says the three model lemmas are proved as them;
- the Balance bullet adds the count laws, the class law, the census and its two witnesses, ending "The listing and the test are supplied, as the pairing is";
- the list block's doc names the census helpers;
- "What is not shown" no longer says that what a pairing under continuation adds to equal count "is not stated". It says the count on every region the pairing does not cross is stated now (`«对则不越域守数»`), and so is the count in every class where `E` is a class decided by a test (`«续之对则类类等数»`), and that nothing beyond these is stated.

**Response and SelectionPool.** Each docstring gains a clause naming its grammar law. The proofs become:

```lean
-- WithinClosure.converse
  «所闭之逆»
-- WithinClosure.of_reads
  match «借步之所闭在二所闭» split within with
  | .inl inside => ⟨o, .inl rfl, inside⟩
  | .inr inside => ⟨a, .inr rfl, inside⟩
-- WithinClosureOf.to_reads
  «二所闭在借步之所闭» larger reaches (match within with
    | ⟨_, .inl same, inside⟩ => .inl (same ▸ inside)
    | ⟨_, .inr same, inside⟩ => .inr (same ▸ inside))
```

The lemmas the old proofs used all keep other uses. For example, `closedUnder_withinClosureOf` is still used in Selection, so no new unused root appears.

## The check

Every edit is applied by [he2_u4.py](he2_u4.py), by text and with asserts, and it reads the Lean blocks from the checked file, so what lands is what was built. `--check` finds every anchor once. `--list` prints each edit.

- [tree/Becoming/HE2U4Laws.lean](tree/Becoming/HE2U4Laws.lean) states the 38 declarations as GrammarLaws would, arranged by target section. It imports only `Becoming.GrammarLaws`.
- [tree/Becoming/HE2U4Check.lean](tree/Becoming/HE2U4Check.lean) states the three model lemmas verbatim, with the exact proofs above. Each has an `rfl` certificate against the package's lemma. Because `rfl` relates terms of one type only, the certificate shows both that the statement is the package's and that the re-proof is the lemma.
- [tree/Becoming/HE2U4Names.lean](tree/Becoming/HE2U4Names.lean) is the clash check, generated by `he2_u4.py --names`. It holds the 38 declarations under their target names, importing all 354 modules of `Becoming.lean`, so a name the package already declares would fail as already declared. None does.
- [scratch-build.log](scratch-build.log): the three modules, built by the package's `scratch_build.py`. It reused the current run's 357 modules and rebuilt nothing below. HE2U4Laws has 34 theorems and 38 declarations, HE2U4Check has 6 and 6, HE2U4Names has 34 and 38, and every axiom report is empty.
- [scratch-build-grammarlaws.log](scratch-build-grammarlaws.log): `he2_u4.py --apply lean --to DIR` wrote the three edited files outside the repository, and GrammarLaws.lean was built from there. It has 172 theorems and 200 declarations (162 before, so 38 new), and every axiom report is empty. Response and SelectionPool are not rebuilt outside the package, because everything between GrammarLaws and them would rebuild too. HE2U4Check stands for them, and HE2's rebuild builds them.

## Records and registers

- **No rebinds.** The records citing the three lemmas keep their declarations: `comparison-where-the-rest-responds`, `mutual-dependence-and-its-pace` and `reading-anothers-couplings-is-pooling`. Their proof bindings move to HE2's core receipt with every other proof the rebuild changes. No record or chapter cites lever 1's scratch names.
- **The master-laws record** (`he2_u4.py --apply records N`, after the checker run, mirroring item 6's part):
  - the closure law (laws.0) gains items 3 and 4, with a clause in en and zh;
  - the list lemmas (laws.2) gain the helpers, with a clause;
  - balance at one step (laws.3) gains `«计»`, the count laws, the class law, the census and the two witnesses, ending "The listing and the test are supplied, as the pairing is";
  - the GrammarLaws reference lists the 38 declarations;
  - one history note is added, or printed with `--no-notes` for one HE2 note per record.
  
  The record gets no new reference: this kit is evidence of the integration, and the integration note is HE2's.
- **The apart register** (`he2_u4.py --apply register LOG`): it registers, with category and reason, the kit's laws that `THEOREM-CONNECTIVITY.py --check` lists as roots without a reason. Reasons are ready for ten declarations: the seven general laws (four count laws and three census laws, as `general-structure`), the two witnesses (as `model-witness`), and `count_eq_countP` (as `support`). It prints any of these the measure does not list, and any listed root that is not this kit's.
- **MV's view.** `master_laws.py` is rerun after the core run, as after every core run. The three model lemmas now reach grammar laws, so `central_reach` may move.

## Composition with HE2's other items

Every edit is found by text, so the order among items does not matter.
- Item 1 edits Grammar.lean, PatternPassing and Sampling. `Sampling.arises_within` and `ceases_within` have no textual overlap with the census here.
- Item 5 edits GrammarMap.
- Item 6 edits GrammarLaws' lumping section and its bullet, the master-laws record's lumping law (laws.14) and the register. Its anchors are not among this kit's, and both kits append to the GrammarLaws reference's declaration list and re-sort it if it was sorted.
- Item 7 renames names in Grammar, GrammarRegularity and GrammarCandidates, and none of them appears here.

GrammarLaws lies above Grammar.lean, which items 1 and 7 edit, so HE2's rebuild recompiles it and everything above it anyway; this kit adds no rebuild of its own.

## What the landing runs, for these items

1. Re-run `he2_u4.py --names` and build it with `scratch_build.py` against the head at landing: LA4's two leaves (`Becoming.OptimumSeason`, `Becoming.WeightedCommuting`) land first and may add names.
2. `he2_u4.py --apply lean`, with HE2's other Lean parts.
3. The checker's incremental core run (HE2's one near-full rebuild). Every axiom report must be empty.
4. `he2_u4.py --apply records N` and `--apply register LOG`, from that run.
5. Render, `research-check`, links and tests, with HE2's other items.

## Not done here

- Response and SelectionPool have not been built against the edited GrammarLaws inside the package. That build is HE2's rebuild.
- No chapter text changes. Chapter 08 §7 and U4's boundary record point at GrammarLaws through the master-laws record, which this kit updates.
