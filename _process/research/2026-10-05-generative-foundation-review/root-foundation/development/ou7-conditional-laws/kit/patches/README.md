# The kit's patches

OU7's leaf (`Becoming.GrammarConditionals`, [in the kit](../Becoming/GrammarConditionals.lean)) uses two laws that generalize laws already in the core. A generalizing law goes below, in the module that holds the law it generalizes, and the old law becomes its case. Two patches do that, Grammar's and GrammarReadings'. The leaf imports both laws and does not restate them.

Two more patches go with them:
- [PLAN.patch](PLAN.patch) edits the OU plan's line that the Grammar patch makes inexact ([below](#texts-that-name-the-two-laws)).
- [MapRegions.patch](MapRegions.patch) changes MapRegions' module doc, comments only, once part B's RoomNet imports it ([below](#mapregionspatch)).

The grammar's owner's patches are in [owner/](owner/), applied after these in name order ([below](#the-grammars-owners-patches)). Stages ride after them ([../stages/](../stages/README.md)).

**Base.** The patches are unified diffs. Grammar's and GrammarReadings' were made against main at 248122055, where `Becoming/Grammar.lean` is blob `cd2010958b77c371f7cff7e7f9ab02e04be233ed` and `Becoming/GrammarReadings.lean` is blob `0db54ab469b3e952e62c609b4213af7d5a808aae`. MapRegions' was made against blob `1980d3903`, the file as HE2 left it (467f075ec). None of the files the patches change has changed since HE2, and all of them are the same on main at a91c84d35. From the repository root, `git apply --check` passes for the series.

## Grammar.patch

Two declarations are new:

- `«位核含于逆核» (R E : «际» α) : «则» («位核» R E) («核» («逆» R) E)`. It sits beside `«位核含于核»`. Read both ways, the core lies within the core of the converse net: sharing a position implies sharing a past. The proof drops the forward constancy from the witness relation.
- `«生于逆核下不变» {R E} (hE : «类» E) (hk : «核» («逆» R) E y y') (hy : «生» R E y) : «生» R E y'`. Beginning is kept along the core of the converse net. It mirrors `«亡于核下不变»`, which keeps ending along the forward core, and needs no constancy under 缘 itself.
  - **Proof.** Take a predecessor `w'` of `y'` under `E`. The witness relation `S` is constant under `«逆» R` (`«有常之逐点»`), so `w'` is matched by a predecessor `w` of `y` with `S w' w`. `S` lies within the class `E`, so `w` and `y` fall in one class (`hE.trans` and `hE.symm`). That contradicts `hy`.

One law becomes a case:

- `«生于位核下不变»` keeps its statement. Its proof is now `«生于逆核下不变» hE («位核含于逆核» R E y y' hk) hy`.

Nothing else changes. `«位同则生亡同»` and every other use of `«生于位核下不变»` see the same statement.

## GrammarReadings.patch

One declaration is new:

- `«两向有常有前则通» {R E} (hE : «类» E) (hc : «有常» R E) (hc' : «有常» («逆» R) E) (hx : «有前» R E x) : «通» R E x`. Where a class is constant under 缘 and under its converse, an occurrence with a predecessor passes through.
  - **Proof.** Going never ends by `«有常则往不穷» hc hx`. For coming, `«有常则续不尽» hc hx` gives a successor `y` with `R x y` and `E x y`. That successor is a predecessor under `«逆» R`, with the class turned by `hE.symm`, and `«有常则往不穷» hc'` gives the rest.

One law becomes a case:

- `«两向有常则通»` keeps its statement. Its proof is now `«两向有常有前则通» hE hc hc' hx.1`. What abides has a predecessor.

The module doc's sentence on 通 names the general law and its case. `«有常而不通»` and `«昼夜往来不穷»` are unchanged.

## MapRegions.patch

MapRegions' module doc says its laws are "kept in a leaf that imports" GrammarMap, and once that "this leaf does not import" Settling. Once RoomNet imports MapRegions, both are false. The patch makes them "kept in a module of their own that imports it" and "this module does not import", rewrapping the paragraph. The code is unchanged, and the audit checks that.

The same change reaches every other place that calls MapRegions a leaf:
- its note in the root module, by the joins;
- its README rows, EN and ZH, by the joins;
- the validation scope of `generation-and-degeneration-at-two-grains`, with a history note, by the record stage.

GW's history note keeps "a core leaf", which was true when it was written.

## The grammar's owner's patches

`01-GrammarLaws-header.patch` holds the header items held from HE2, comments only (the kit's [README](../README.md#what-the-kit-holds)). The other three carry the items held until BD2 landed, as OU's owner specified them on 1 November. Each was made against the tree the ones before it leave, on main at 8f11b43bd. There GrammarLaws is blob `0482974`, GrammarCrossing `53933e9`, Standpoints `cb7e18e`, ConveyanceBoundaries `3858e34` and BalanceRegions `7f90db3`, and main at a91c84d35 has the same five. What was held is kept in [history/HELD.md](history/HELD.md).

- **02-not-going-out.patch.** `«不出»` (nothing in a region goes out of it along a relation), `«闭则不出»` (a closed region is not gone out of) and `«所闭不出»` (an occurrence's closure is not gone out of) move from GrammarCrossing into GrammarLaws. They go in its Closure section, right after the closure law `«所闭之界»`. Their names, statements, proofs and namespace (`Becoming`) do not change. `«所闭之界»` keeps its statement and proof, and its docstring says that `«所闭不出»` is it read through `«不出»`.
  - GrammarLaws' table gains `«不出»`, and its bullet on closure names the three.
  - GrammarCrossing keeps everything else, and its imports. Its table goes, and its module doc says where the three now are and that the module adds no definition.
  - ConveyanceBoundaries' and BalanceRegions' module docs say which module states `«闭则不出»` and `«不出»`, comments only.
  - GrammarCrossing, ConveyanceBoundaries, GrammarPath and BalanceRegions reach GrammarLaws through GrammarCrossing's import, so every use of the three resolves as before, to the same statement ([checked](#checked)).
- **03-flow-cut.patch.** `Flow.Cut V region` is defined as `«不出» V.related region`, with the docstring "No formed relation leaves the region: nothing in it goes out of it along the valuation's relation (`«不出»`)." The old body is `«不出»`'s, unfolded at `V.related`. `Flow.cut_iff_notGoingOut` stays `Iff.rfl`, and its docstring says that it holds by definition. Standpoints reaches GrammarLaws through Descent, Correspondence, Labelled and Frame, so no import is added. ConveyanceBoundaries' module doc says where the cut is now defined, comments only.
- **04-uncrossed.patch.** BD2's two equivalences, as BD2 sent them on 1 November, go after `GrammarLaws.uncrossed_of_closed`:
  - `GrammarLaws.uncrossed_iff_notGoingOut`: a region, read as a test, that the relation does not cross is exactly one not gone out of either way;
  - `GrammarLaws.uncrossed_iff_closed`: it is exactly one closed under the relation and under its converse. This is the converse of `uncrossed_of_closed`.

  `«对则不越域守数»` and `«对则双闭域守数»` keep their names and statements. Their docstrings and the module doc's bullet on balance read the two as one law on regions not gone out of either way.

  BD2 checked the two theorems on `bd2-crossing` at 7647ea36e, in a scratch module importing GrammarCrossing: 2 theorems in 2 declarations, every axiom report empty, no warning, 5 steps reused. The proofs use only case analysis on `Bool`.
- **05-scope-wording.patch.** A text review found that `«续无外»`'s docstring, "nothing lies outside every center's continuing", can be read as weaker than its definition, `∀ p x, «所及» R E (center p) x`: as no occurrence lying outside all the centers' lines together. The docstring now reads "everything lies on every center's continuing", and the module's title "everything on every center's continuing". `«族无外»`'s docstring already says that every occurrence lies in every center's family. Comments only, as the owner specified it on 1 November, made against main's GrammarScope, which no other patch or stage changes.
  - The same reading elsewhere goes with it: the record stage restates the-continuation-condition-on-the-root's correspondence in English, and the joins SignificanceStatements' scope sentence in the checker and PHILOSOPHY.md's gloss. The text review's merge words the front pages so.
  - GrammarScope has five modules downstream, the root among them. The rehearsal builds them with the patch in place, reusing the full rehearsal's steps.

The kit carries each change to what it touches:
- **The audit** holds the code:
  - GrammarLaws gains exactly the two equivalences and the three moved;
  - GrammarCrossing loses exactly the three, which arrive with their statements unchanged, and `«不出»` with its whole text;
  - Standpoints changes only `Cut`'s body, which must unfold to the old one;
  - no other definition changes. `«所闭之界»` changes only in its docstring, which the audit blanks.
- **The joins** change the root module's notes on GrammarLaws, GrammarCrossing and ConveyanceBoundaries, the README rows of GrammarLaws and GrammarCrossing, EN and ZH, and those two modules' scope sentences in the checker.
- **The record stage** changes three records, each with a history note:
  - master-laws-on-the-grammar: law 4 reads the two count laws as one law on regions not gone out of either way, and so does its home section, 01 §7. Law 4 and the GrammarLaws reference gain the two equivalences.
  - not-going-out-of-a-region: its GrammarCrossing reference gives the three to a GrammarLaws reference, with a proof binding. Its laws still state them.
  - balance-from-conservation-along-a-relation: its dependency on not-going-out-of-a-region says that `«不出»` is GrammarLaws'.

  The first two validation scopes take the receipt's counts.
- **The register** takes the two equivalences as roots of general structure. `«所闭不出»` stays an apart root, and its entry now names GrammarLaws.

## Checked

**The owner's rehearsal** ran on 1 November ([history/REHEARSAL-owner-patches.json](../history/REHEARSAL-owner-patches.json)). It started at 23:37 UTC on 31 October, inside the coordinator's gate: the 5-minute load was 5.5, 66% of memory was free, and no other Lean was running.
- Main's five files, with the four patches applied in series, went to a tree outside the repository, beside four scratch modules that check the names. Applied to main's files at a91c84d35, the patches make the tree's five files byte for byte.
- `scratch_build.py` built ten modules and their import closure, 53 modules: 57 steps ran and 6 were reused. Nothing was unclean, and every axiom report was empty.

| module | rehearsal: theorems in declarations | main, receipt 20261101T000137.132110Z |
|---|---|---|
| GrammarLaws | 179 in 208 | 175 in 203 |
| GrammarCrossing | 9 in 9 | 11 in 12 |
| Standpoints, ConveyanceBoundaries, GrammarPath, BalanceRegions | 21 in 34, 8 in 8, 102 in 152, 6 in 7 | the same |

GrammarLaws gains two theorems and a definition by the move and two theorems by BD2's equivalences, and GrammarCrossing loses the moved three.

The name checks import GrammarCrossing, ConveyanceBoundaries, GrammarPath and BalanceRegions, one each. Each states `«不出»` as its old definition by `Iff.rfl`, and `«闭则不出»` and `«所闭不出»` at their old statements, as GrammarCrossing writes them on main. The one importing ConveyanceBoundaries adds the cut, so it has 4 theorems and the others 3. Every axiom report is empty. Their text is in REHEARSAL.json, for example:

```lean
theorem moved_closed_notGoingOut :
    ∀ {α : Type u} {R : Becoming.«际» α} {P : α → Prop}, Becoming.«闭» R P → Becoming.«不出» R P :=
  @Becoming.«闭则不出»

theorem cut_as_before {Pos Q : Type} (V : Becoming.Valuation Pos Q) (region : Q → Prop) :
    Becoming.Flow.Cut V region ↔ ∀ e e', region e → ¬ region e' → ¬ V.related e e' :=
  Iff.rfl
```

**The first rehearsal** ([history/REHEARSAL.json](../history/REHEARSAL.json)) built the kit's own patches and the three leaves with the earlier owner patches. Neither the kit's patches nor the leaves have changed since. It built fifteen modules and their closure, 145 of the package's modules then. Nothing was unclean, and every axiom report was empty:

| module | theorems in declarations | main |
|---|---|---|
| Grammar | 72 in 120 | 70 in 118 |
| GrammarReadings | 13 in 18 | 12 in 17 |
| GrammarTesting, MapRegions | 6 in 13, 36 in 42 | the same |
| GrammarConditionals, RoomNet, RoomRuns | 40 in 41, 94 in 120, 24 in 27 | new |

**The full rehearsal** ([REHEARSAL.json](../REHEARSAL.json); the kit's [README](../README.md#checked)) built the nine patches, the three leaves and both stages on main at 9a01af14e: every module downstream of them, 376 of the package's modules, nothing unclean, every axiom report empty in the core and the ring. GrammarLaws came to 192 theorems in 221 declarations, with the stages' laws. No module broke on a clash with a new name or on an old one a stage renames.

**Part A's earlier build**, build 3, applied Grammar's and GrammarReadings' patches to fresh copies of main's files at 8a1b06a3a, the blobs named under **Base**, beside the leaf and its checks module, which stays in scratch. Nothing was unclean, and every axiom report was empty ([BUILD.json](../../tree/BUILD.json)): Grammar 120 declarations, GrammarReadings 18, GrammarConditionals 41 and the checks 17. These commands reproduce it:

```bash
W=/Users/ren/theories        # a checkout at the base
S=$W/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou7-conditional-laws
PKG=$W/experiments/integrated-correction/general-framework/generative-basis/lean/becoming
T=$(mktemp -d)/tree && mkdir -p $T/Becoming
cp $PKG/Becoming/Grammar.lean $PKG/Becoming/GrammarReadings.lean $T/Becoming/
patch -p7 -d $T < $S/kit/patches/Grammar.patch
patch -p7 -d $T < $S/kit/patches/GrammarReadings.patch
cp $S/kit/Becoming/GrammarConditionals.lean $S/tree/Becoming/GrammarConditionalsChecks.lean $T/Becoming/
cd $PKG && python3 -B scratch_build.py $T Becoming.Grammar Becoming.GrammarReadings Becoming.GrammarConditionals Becoming.GrammarConditionalsChecks
```

## Texts that name the two laws

The kit changes each text that states one of the old laws, so that it states the general law, with the old one as its case:

- **The two records and their home sections.** The record stage handles both laws:
  - `«生于逆核下不变»` goes into law 5 of `continuation-relative-to-a-class` and 01 §4's paragraph on the two-way core;
  - `«两向有常有前则通»` goes into law 4 of `classical-definitions-in-the-grammar` and 06 §三's two lines on 通.

  In each record it updates the law's text and declarations and the validation scope's counts, and adds a history note.
- **The root module's note and the checker's scope sentence for GrammarReadings.** Both said "what abides passes through where a class is constant both ways". The joins make each say that what has a predecessor passes through, with what abides as its case.
- **The OU plan** ([one-unfolding-root/PLAN.md](../../../one-unfolding-root/PLAN.md), under 双向之核) says 「生只在双向之核下不变（`«生于位核下不变»`）。」 Once the Grammar patch lands, that is no longer exact. 生 is kept along the core of the converse net. That core holds the two-way core, and it also joins pairs the forward core does not (`«逆核不含于核之例»`). OU's owner accepted this replacement on 31 October. It goes into the same landing as the Grammar patch, as [PLAN.patch](PLAN.patch):
  > 生在逆缘之核下不变（`«生于逆核下不变»`）；双向之核在其中（`«位核含于逆核»`），故生亦在双向之核下不变（`«生于位核下不变»`）；前向之核下生可变（`«生于核下可变之例»`）。

  The plan's next line, `«位同则生亡同»`, stays. From the repository root, `git apply --check` passes for PLAN.patch on main at a91c84d35, in the series.
- **The connectivity maps** (`THEOREM-CONNECTIVITY.json` and `THEOREM-CONNECTIVITY-APART.json`, in root-foundation) list both old laws. They are tool output and change only when their tool runs.
