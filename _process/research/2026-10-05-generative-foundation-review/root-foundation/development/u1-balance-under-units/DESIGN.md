# U1: balance read under the continuation of units (design, reviewed)

Design, 29 October 2026, on main at `c7b66f19d`. No Lean in the package.

**Where it sits.** U1 is an item of full unification (OU plan §十三 item 13, decision D25; [WHAT-REMAINS](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md), "From no gap to the root"; the [FU proposal](../fu-full-unification/PROPOSAL.md)). It was given to this session by OU's owner: a design, scratch checks and review, with no Lean claimed.

**How it was made.**
- It was drafted on WRT's pattern, with WRT's designer's constraints. WRT's designer read it twice.
- OU's owner raised three points: open Worlds, the row table and placement.
- The independent review ([REVIEW-U1.md](REVIEW-U1.md), GPT astra, high effort) said to revise before any Lean, and every finding was taken.
- After a second scratch round, the same reviewer's second read ([REVIEW-U1-2.md](REVIEW-U1-2.md)) took the rewritten design as a whole. It found the round-2 proofs sound, five scope mismatches and a stale ledger line. It offered a narrower reviewed outcome, which this design adopts as U1's verdict (§0).

The design edits no module and redefines nothing the occurrence model defines.

**Scratch.** [scratch/Becoming/UnitScratch.lean](scratch/Becoming/UnitScratch.lean): 48 theorems in 70 declarations, every axiom report empty, every proof constructive, built with `scratch_build.py` against main. What each declaration establishes is in the ledger (§1). Nothing below is called checked beyond it.

## 0. The verdict (reviewed)

> **Balance is represented by selected finite frame bijections at every condition; the conditional crossing laws and the normalized residual-count law hold at the specified list selections. This does not derive balance from the unfolding. The attempted identification of residual endpoints with a faithful open exchange model fails when actual boundary traffic is retained; projection does not recover WRT's conservation; correspondence orbits do not exhaust the matching fibre. Global exchange attachment and line laws remain outside the established interface. No numerical consumer is rerouted, and F13's reason remains.**

The wording is the second read's (its finding 7), adapted only by naming the declarations in §1. In the plan's terms:
- **Amounts are the root's second sort.** The interface established as laws is the **limited** one of §2. The rest of what this design proposes is marked proposed and is not counted.
- **No row changes category.** The 32 balance rows keep "balance, represented" with this verdict as their reason, the 9 premise rows keep theirs, and the 3 counting rows theirs.
- **The atomism of amounts rests on natural-number amounts,** named on the premise card. These make a positive loss at least one unit. They do not force a loss to occur.

## 1. The evidence ledger (what the scratch establishes, exactly)

| Declaration | What it establishes | Not established |
|---|---|---|
| `Tokens.counts`, `Tokens.came` | for an equality-based token account at one condition that abides: the count law, and membership provenance (a token standing at `t + n` stood at `t` or was given between) | unique origin; repeated token values are allowed |
| `mem_of_pair`, list membership lemmas | every member of a pairing's second list is related to some member of the first | — |
| `Units`, `Units.balances`, `Units.canonical`, `units_iff_balances` | both directions for the **flat** structure (positions per frame, one relation per step and condition, existence of a matching) | — (superseded for the selection by `KUnits`) |
| `repairing_moves_lines` | the identity and the swap both pair `[1, 0]` with itself | no World, kinded model or residence in its statement |
| `stretch_of_units`, `stretch_count_of_units` | for a fixed condition and a supplied relation on kinded occurrences pairing every step, `«对之程»` pairs the stretch's ends under the closure, and the count over the stretch follows | that the relation is a selected matching |
| `one_paired_iff` | under `«一»`, a step's kinded lists pair exactly where the flow balances there | — |
| `ExchangeMatched`, `give_le_take_of_matched`, `one_matched_iff`, `dissipates_of_ending`, `no_matching_of_giving_without_taking` | source-free matchings on lists: they force `given ≤ taken`; under `«一»` on `List Unit` they exist exactly then; with endings positive when taking they give `given + sign taken ≤ taken`; none pairs `[]` with `[u]` | no labelled exchange structure, no World |
| `crossing_edge`, `crossing_line` | in a concatenated matching with more in `toDs` than in `fromDs`, some member of `fromElse` is related to some member of `toDs`; constructive | — |
| `Ex`, `takeL`, `giveL` and their lengths | exchange occurrences at one formation and step, labelled by condition and position, with lengths equal to the flow's totals over the list of conditions | step and formation are parameters, not fields; a condition repeated in the list repeats its labels, so a globally unique carrier needs distinct lists or more indices |
| `rise_crossing_weak` | from `Balances.rise_draws_beyond_inflow`'s hypotheses: **one** present formation such that **every** relation pairing what it takes from `ds` ++ any other inputs with what it gives `ds` ++ any outputs relates some other input to some unit given `ds` | that the other inputs are the formation's actual inputs (the representation's contract) |
| `rise_crossing_strong` | with the containing family written `ds ++ rest` (`Distinct ds` only): one present formation such that every relation pairing (what it takes from `ds` ++ beyond's units, numbering the source-minimal count over `ds ++ rest`) ++ what it takes from `rest`, with what it gives `ds` ++ any outputs, relates some unit taken from `rest` to some unit given `ds`; it uses the core theorem's excess inequality | "from outside `ds`" needs `Distinct (ds ++ rest)` (or disjointness); the theorem says "from `rest`" |
| `endings_count` | at a formation, every relation pairing its takes from a list ++ beyond's units (source-minimal) with its gives ++ endings has exactly `excess taken given` endings (the residual model, no separate leaving outputs) | — |
| `leaving_and_endings_count`, `endings_count_closed` | for a supplied pairing whose beyond's units number the source-minimal count (`beyondL.length = excess given taken`): with leaving outputs kept as well, leaving and endings **together** number `excess taken given`; with the leaving list empty, the endings alone do | which residual unit leaves and which ends; no closure is assumed and no correspondence with actual traffic is proved |
| `source_free_of_dissipates`, `ends_of_dissipates` | for a present formation dissipating on the list: the source-minimal count `excess given taken` is zero, and `excess taken given` is positive where it takes | the construction of a source-free selected exchange matching |
| `FrameMatch` and `.le`, `.symm`, `.eq`, `.id`, `.predecessor_unique` | a selected matching of a frame as data, a bijection of positions with its inverse. It forces equal counts (pigeonhole with no decidability). The identity is one. An in-range output's predecessor exists by the structure's `bwd_lt` and `fwd_bwd`, and is unique by `predecessor_unique`. | a global continuation graph |
| `KUnits`, `KUnits.balances`, `KUnits.canonical`, `kunits_iff_balances`, `KUnits.next` | selected frame data at **every** step and condition, equivalent to the flow balancing everywhere; the converse is pairing by position, no choice. A standing position goes, by the function `fwd`, into one of the current frame's output blocks: standing at `t + 1` or taken at `t`. | the kinded decoding as a defined graph (it is the intended reading of the index convention); attachment to formation exchange |
| `lossless_not_dissipative` | a present formation taking from a list exactly what it gives it, and something, does not dissipate on it | — |
| `KUnits.projects_along` | the coordinate fact `Steps.along (t, c) (t + 1, c)`; its proof does not use the unit hypotheses | a defined projection preserving a defined unit relation |

## 2. The established interface (the limited second sort)

These are the laws U1 establishes, at the scopes the ledger gives:

1. **The unit selection at condition frames, both ways** (`kunits_iff_balances`). Balance holds everywhere exactly where every condition's frame at every step has a selected bijection of in-positions with out-positions. The converse needs no choice, and a selected matching forces equal counts by pigeonhole with no decidability (`FrameMatch.eq`). This is global in the conditions. Finite enumeration enters only where a formation's exchange is listed (§3.2).
2. **A fixed predecessor at a frame** (`FrameMatch` fields with `predecessor_unique`). Each out-position has exactly one in-position sent to it.
3. **The crossing laws.** The weak one (`rise_crossing_weak`) holds with no closure, dissipation or normalization. The strong one (`rise_crossing_strong`) holds with beyond's count normalized and no closure or dissipation. Both are quantified as one formation, then every matching.
4. **The residual-count laws.** For a supplied pairing whose beyond's units number the source-minimal count: in the residual model, endings number `excess taken given` (`endings_count`). With leaving outputs kept, leaving and endings together do (`leaving_and_endings_count`). With the leaving list empty, the endings alone do (`endings_count_closed`).
5. **The dissipation specialization.** Where a present formation dissipates on the list, the source-minimal count is zero and the residual is positive where it takes (`source_free_of_dissipates`, `ends_of_dissipates`). Closure of a **distinct** family with `Flow.Dissipative` is one way `DissipatesOn` is guaranteed, but it can also be supplied on a family that is not closed.
6. **Storage.** Lossless transfer through a dissipating formation is excluded (`lossless_not_dissipative`).
7. **The stretch law under a supplied pairing relation** (`stretch_count_of_units`), as `«对之程»`'s instance.

## 3. What was attempted and what it showed

### 3.1 Condition frames

The finite family is not needed here. The second read is right: infinite condition support does not prevent a family of finite frame bijections indexed by every condition, which is what `KUnits.canonical` builds. A restricted unit model on one family would give balance on that family only, and is not claimed.

### 3.2 Formation exchange: residual against faithful

There are two models, and the second read tells them apart.
- **The residual model.** A formation's takes from a list plus beyond's residual units are paired with its gives plus endings, beyond's count source-minimal. `endings_count` holds here: residual endpoints are accounting, not actual boundary traffic.
- **The faithful port model.** A formation's actual exchange outside the list is kept as ports. Actual outside inputs need not number the source-minimal count: a formation may exchange both inside and outside while its inside totals are equal. Leaving outputs also enter the count (`leaving_and_endings_count`).

**The identification fails.** Residual endpoints are not actual losses once actual boundary traffic is retained. At a family closed for the formation, actual ports are zero. Closure alone still permits `given > taken`, which needs residual sources with no actual outside input. Where also `given ≤ taken`, for instance from dissipation on the family, the residual sources are none. The count of endings is then `excess taken given` for every source-minimal pairing with nothing leaving (`endings_count_closed`, `source_free_of_dissipates`). That this count is the formation's actual loss stays conditional on the proposed faithful representation below.

Proposed, not established:
- the existence of a labelled selected exchange matching for a World's formations;
- its attachment to the condition frames' given and taken positions. Multiplicities are needed here: `Flow.given` sums over list positions in `present`, so repeated formations count again.
- the non-emptiness of the enriched fibre containing both frame and exchange data;
- a bridge from a `FrameMatch`'s graph to `«对»` on labelled lists, which would make the selected model the input to the grammar's pairing laws.

### 3.3 Storage

Storage through a dissipating formation loses. Lossless retention means units staying as standing units, with no exchange. A formation giving at `t + 1` more than it took at `t` violates `DissipatesOn` at `t + 1` only when its giving exceeds what its taking at `t + 1` permits.

### 3.4 Projection

Unit continuation's image is not WRT's conservation, which relates different conditions and holds at zero levels. `KUnits.projects_along` is a coordinate fact, not a structure map. A defined projection preserving a defined unit relation would use WRP2's `preserves_iff_image` (cited by statement until it lands).

### 3.5 Correspondences

Renaming within fixed fibres, changing the matching and forgetting the matching are three operations. Their orbits do not exhaust the fibre: in the one-standing, one-given witness, no kind- and presence-preserving correspondence relates the two matchings. The equivalence on unit models is therefore "over the same World".

### 3.6 Lifting

The lifting principle splits three ways:
- validity over a fibre, a definition made non-vacuous only for the demonstrated fibre, the frame data;
- constancy across a fibre, proved per predicate;
- representation of a specified predicate, proved per predicate. Checked instances: the residual counts (§2.4) and the strong crossing (§2.3).

"The World's amount laws are exactly the re-pairing invariants of unit lines" remains a proposal.

### 3.7 Line laws and positions (proposed)

All of these lie outside the established interface:
- multi-step unique origin from the fixed predecessor;
- the stretch law restated for selected matchings;
- the finite Little's law, with residence on a half-open interval;
- arrivals against departures as the natural-number stretch equation;
- the grammar's 生/亡/住 on units under a named continuation class, with boundary conventions.

## 4. The rows "premise of the account"

EC6's audit lists one dissipation row and eight support-category rows, the latter including the two `Flow.Acting` rows.

| Row | Premise and exact scope | U1's bearing | Category |
|---|---|---|---|
| `Reproduction.Flow.number_within_take` | `DissipatesOn ds t` directly; distinct offspring, descent, offspring in `ds`; no `ClosedAt`, no `Distinct ds` | a line reading needs an injection from births to distinct given units: a separate obligation, not done | unchanged |
| `Flow.selection_within`, `Flow.transmitted_supported`, `Flow.selected_le`, `SelectionTerm.Flow.support_not_lower`, `SelectionTerm.Flow.support_moved_rises`, `carried_iff_rising` | the gate (some with Price) | the comparison need ≤ level could read as units paired into the standing units: representation, not done | unchanged |
| `GroupEnding.Flow.rises_iff_inactive`, `GroupEnding.Flow.all_end` | `Flow.Acting` | sign only | unchanged |

Balance and dissipation are **two compatible constraints**, at condition frames and at formation exchanges. They are not one law.

## 5. Where it fails, written down

- **Balance is not derived** from the unfolding: every number-stated consumer would be a round trip (WRT's designer's test), and F13's reason stands.
- **Residual endpoints are not actual losses** once actual boundary traffic is retained (§3.2).
- **The projection does not recover WRT's conservation** (§3.4).
- **Correspondence orbits do not exhaust the matching fibre** (§3.5).
- **Lines are not World data.** Which unit goes where is the selected matching's choice; counts are what the World fixes.

## 6. Placement, and what a later item could take (nothing claimed)

U1 is complete as a reviewed design with its verdict. No Lean is claimed, and none is proposed for the package yet.

If OU's owner later wants the limited interface (§2) in the package, the natural items are:
- the selected frame data and its both-ways theorem;
- the crossing joins;
- the residual-count laws.

They would sit in a leaf above `Becoming.Flow`, so that no definition is added beside `Flow.Balances` without rule 3's fallback, since Flow has no active owner. Any such claim goes to OU's owner for its place, behind WRP's first item and OU3f's twins on shared files.

§3.2's proposals and §3.7's laws could be a later item of their own (U1c), if a purpose needs them.

## 7. What would change this verdict

- **If a labelled exchange matching attached to the frames is constructed** for every balanced World, with the enriched fibre non-empty, the interface widens by §3.2's first three proposals.
- **If a line law over every selected matching** (unique origin, Little's law) reads something the counts do not, the second sort's interface gains a law of lines.
- **If either fails,** that is written down here.

## 8. The reviews' findings and where each is taken

**First review** ([REVIEW-U1.md](REVIEW-U1.md)): eleven findings.

| Finding | Status after the second read | Taken in |
|---|---|---|
| 1. Matching existence against selected matching | partly resolved; frame level done | §1 `FrameMatch`, §3.2 (attachment proposed) |
| 2. Open existence, finite support | partly; finiteness moved to the exchange layer | §2.1, §3.1, §3.2 |
| 3. Closure, sources, normalization | partly; leaving outputs now in the count | §2.4–§2.5, §3.2 |
| 4. Storage | resolved | §2.6, §3.3 |
| 5. The crossing join | partly; the partition condition is stated | §1, §2.3 |
| 6. Projection | resolved at the revised scope | §3.4 |
| 7. Correspondences | resolved as a design correction | §3.5 |
| 8. Lifting | resolved conceptually; non-vacuity restricted | §3.6 |
| 9. Checked scope | partly; ledger now exact | §1 |
| 10. Rows, two constraints | resolved | §4 |
| 11. Completed interface | partly; now the limited interface and the verdict | §0, §2 |

**Second read** ([REVIEW-U1-2.md](REVIEW-U1-2.md)): seven findings.

| Finding | Taken in |
|---|---|
| 1. Endings omit leaving outputs; residual against faithful | `leaving_and_endings_count`, `endings_count_closed`; §3.2 |
| 2. The finite family on the wrong layer | §2.1, §3.1 |
| 3. Existence and attachment presented as checked | §3.2, marked proposed; §2 lists only the established laws |
| 4. "From `rest`" against "from outside `ds`"; label uniqueness | §1 rows for `Ex`, `rise_crossing_strong` |
| 5. Stale ledger; predecessor and projection attributions | §1 |
| 6. §5 confined content to closed dissipative families | §2.3–§2.5, §5 |
| 7. Completion by failure, the narrower outcome | §0 (adopted), §5 |
