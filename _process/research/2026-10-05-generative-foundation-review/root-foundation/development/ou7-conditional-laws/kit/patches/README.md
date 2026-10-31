# The kit's patches

OU7's leaf (`Becoming.GrammarConditionals`, [in the kit](../Becoming/GrammarConditionals.lean)) uses two laws that generalize laws already in the core. A generalizing law goes below, in the module that holds the law it generalizes, and the old law becomes its case. Two patches do that, Grammar's and GrammarReadings'. The leaf imports both laws and does not restate them.

Two more patches go with them:
- [PLAN.patch](PLAN.patch) edits the OU plan's line that the Grammar patch makes inexact ([below](#texts-that-name-the-two-laws)).
- [MapRegions.patch](MapRegions.patch) changes MapRegions' module doc, comments only, once part B's RoomNet imports it ([below](#mapregionspatch)).

The grammar's owner's patches are in [owner/](owner/), applied after these in name order ([below](#the-grammars-owners-patches)).

**Base.** The patches are unified diffs. Grammar's and GrammarReadings' were made against main at 248122055, where `Becoming/Grammar.lean` is blob `cd2010958b77c371f7cff7e7f9ab02e04be233ed` and `Becoming/GrammarReadings.lean` is blob `0db54ab469b3e952e62c609b4213af7d5a808aae`. MapRegions' was made against blob `1980d3903`, the file as HE2 left it (467f075ec). None of the files the patches change has changed since HE2, and all of them are the same on main at b6c8bedd8. From the repository root, `git apply --check` passes for the series.

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

`01-GrammarLaws-header.patch` holds the header items held from HE2, comments only (the kit's [README](../README.md#what-the-kit-holds)). The other three are the items held until BD2 landed. They were made in series against main once BD2 had landed (f1ea9546d), where GrammarLaws is blob `0482974`, GrammarCrossing `53933e9`, Standpoints `cb7e18e` and ConveyanceBoundaries `3858e34`. Main at b6c8bedd8 has the same four. What was held is kept in [history/HELD.md](history/HELD.md).

- **02-GrammarLaws-not-going-out.patch.** `«不出»` (nothing in a region goes out of it along a relation) and `«所闭不出»` (an occurrence's closure is not gone out of) move from GrammarCrossing into GrammarLaws, beside `«闭»` and the closure law. Their statements do not change. `«所闭之界»` keeps its statement and is proved as `«所闭不出»` at two occurrences, so the closure law is stated once.
  - GrammarLaws' table and its bullet on closure name `«不出»`.
  - GrammarCrossing's table goes, and its module doc says the module adds no definition. GrammarCrossing already imports GrammarLaws, so every use of the two names still resolves.
- **03-Standpoints-cut.patch.** `Flow.Cut V region` becomes `«不出» V.related region`. The old body is `«不出»`'s, unfolded at `V.related`, so the two are equal by `Iff.rfl`. `Flow.cut_iff_notGoingOut` is kept, with its proof. ConveyanceBoundaries' module doc says where the cut is now defined, comments only.
- **04-GrammarLaws-uncrossed.patch.** BD2's two equivalences, as BD2 sent them on 1 November, go after `GrammarLaws.uncrossed_of_closed`:
  - `GrammarLaws.uncrossed_iff_notGoingOut`: a region, read as a test, that the relation does not cross is exactly one not gone out of either way;
  - `GrammarLaws.uncrossed_iff_closed`: it is exactly one closed under the relation and under its converse. This is the converse of `uncrossed_of_closed`.

  `«对则不越域守数»` and `«对则双闭域守数»` keep their names and statements. Their docstrings and the module doc's bullet on balance say that the two read as one law on regions not gone out of either way.

  BD2 checked the two theorems on `bd2-crossing` at 7647ea36e, in a scratch module importing GrammarCrossing: 2 theorems in 2 declarations, every axiom report empty, no warning, 5 steps reused. The proofs use only case analysis on `Bool`.

The kit carries each change to what it touches:
- **The audit** holds the code. GrammarLaws gains exactly `«不出»`, `«所闭不出»` and the two equivalences, and `«所闭之界»` changes only its proof. GrammarCrossing loses exactly the two moved, which arrive unchanged. Standpoints changes only `Cut`'s body, which must unfold to the old one. No other definition changes.
- **The joins** change the root module's notes on GrammarLaws, GrammarCrossing and ConveyanceBoundaries, the README rows of GrammarLaws and GrammarCrossing, EN and ZH, and those two modules' scope sentences in the checker.
- **The record stage** changes two records, each with a history note:
  - master-laws-on-the-grammar: law 4 reads the two count laws as one, and so does its home section, 01 §7. Laws 1 and 4 and the GrammarLaws reference gain the declarations.
  - not-going-out-of-a-region: its references move the two to a GrammarLaws reference, with a proof binding.

  Both validation scopes take the receipt's counts.
- **The register** takes the two equivalences as roots of general structure and drops `«所闭不出»`, which `«所闭之界»` now uses.

## Checked

**The rehearsal** ran on 1 November ([REHEARSAL.json](../REHEARSAL.json)). The nine patches were applied in series to a copy of the package outside the repository, and the three leaves were added.
- The copy was made at 3d1528b36, and main's package is the same at b6c8bedd8. On b6c8bedd8 the dry run's apply stage makes each of the eleven changed or new files, byte for byte.
- `scratch_build.py` built fifteen modules and their import closure, 145 of the package's 365 modules. Nothing was unclean, and every axiom report was empty.

| module | rehearsal: theorems in declarations | main, receipt 20261031T202201.956842Z |
|---|---|---|
| Grammar | 72 in 120 | 70 in 118 |
| GrammarReadings | 13 in 18 | 12 in 17 |
| GrammarLaws | 178 in 207 | 175 in 203 |
| GrammarCrossing | 10 in 10 | 11 in 12 |
| Standpoints, ConveyanceBoundaries, GrammarTesting, MapRegions | 21 in 34, 8 in 8, 6 in 13, 36 in 42 | the same |
| GrammarConditionals, RoomNet, RoomRuns | 40 in 41, 94 in 120, 24 in 27 | new |

The other four modules built each import one of the changed modules: Frame, GrammarPath, GrammarCases and ListingRefutations. Each kept its counts.

A scratch module built from the same copy checks that the new `Flow.Cut` is the old definition. It has 1 theorem, and its axiom report is empty:

```lean
theorem cut_as_before {Pos Q : Type} (V : Valuation Pos Q) (region : Q → Prop) :
    Cut V region ↔ ∀ e e', region e → ¬ region e' → ¬ V.related e e' :=
  Iff.rfl
```

The other 220 modules meet the patches in the rebuild slot. Every old statement is kept, so a module could break only through a clash with one of the new names, or with the two moved into GrammarLaws. On main at b6c8bedd8, `git grep` finds the names of the three new laws and of the two equivalences nowhere in the package. It finds `«不出»` and `«所闭不出»` defined only in GrammarCrossing, which imports GrammarLaws.

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

  The plan's next line, `«位同则生亡同»`, stays. From the repository root, `git apply --check` passes for PLAN.patch on main at b6c8bedd8, in the series.
- **The connectivity maps** (`THEOREM-CONNECTIVITY.json` and `THEOREM-CONNECTIVITY-APART.json`, in root-foundation) list both old laws. They are tool output and change only when their tool runs.
