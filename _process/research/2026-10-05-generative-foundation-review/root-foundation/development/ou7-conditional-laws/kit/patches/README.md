# The kit's patches

OU7's leaf (`Becoming.GrammarConditionals`, [in the kit](../Becoming/GrammarConditionals.lean)) uses two laws that generalize laws already in the core. A generalizing law goes below, in the module that holds the law it generalizes, and the old law becomes its case. Two patches do that, Grammar's and GrammarReadings'. The leaf imports both laws and does not restate them.

Two more patches go with them:
- [PLAN.patch](PLAN.patch) edits the OU plan's line that the Grammar patch makes inexact ([below](#texts-that-name-the-two-laws)).
- [MapRegions.patch](MapRegions.patch) changes MapRegions' module doc, comments only, once part B's RoomNet imports it ([below](#mapregionspatch)).

The grammar's owner's patches are in [owner/](owner/), and the items held until BD2 lands are in [HELD.md](HELD.md).

**Base.** The patches are unified diffs. Grammar's and GrammarReadings' were made against main at 248122055, where `Becoming/Grammar.lean` is blob `cd2010958b77c371f7cff7e7f9ab02e04be233ed` and `Becoming/GrammarReadings.lean` is blob `0db54ab469b3e952e62c609b4213af7d5a808aae`. MapRegions' was made against blob `1980d3903`, the file as HE2 left it (467f075ec). None of the files the patches change has changed since HE2, and all of them are the same on main at 815c6425f. From the repository root, `git apply --check` passes for the series.

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

## Checked

Each patch was applied with `patch -p7` to a fresh copy of main's file, in a scratch tree, beside the leaf and the checks module. The tree was built from the package folder with the commands below. Nothing was unclean, and every axiom report was empty ([BUILD.json](../../tree/BUILD.json)):

| module | declarations |
|---|---|
| Grammar | 120, two more than main |
| GrammarReadings | 18, one more |
| GrammarConditionals | 41 |
| GrammarConditionalsChecks | 17 |

The build compiles only the closure of the leaf and the checks: Grammar, GrammarReadings, GrammarCandidates, GrammarMap, GrammarLaws, GrammarTesting and Prelude. The rest of the package meets the patches in the rebuild slot.

Both old laws keep their statements, so a downstream module could break only through a clash with one of the three new names. On main at 248122055, `git grep` finds `«位核含于逆核»`, `«生于逆核下不变»` and `«两向有常有前则通»` nowhere in the package.

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

  The plan's next line, `«位同则生亡同»`, stays. From the repository root, `git apply --check` passes for PLAN.patch on main at 815c6425f, in the series.
- **The connectivity maps** (`THEOREM-CONNECTIVITY.json` and `THEOREM-CONNECTIVITY-APART.json`, in root-foundation) list both old laws. They are tool output and change only when their tool runs.
