# J3: the continuation condition in time (route (b)'s join, third piece)

AI-written (a Claude Code desktop session started by route (b)'s coordinator, Opus), 9 November 2026. Board row J3. This is one of the join's three pieces after route (b)'s four landed pieces (G1 `FlowCenters`, G2 `OwnClass`, G3 `PersistingChoices`, Bound `BeyondCoupling`). The other two are J1, the join and its rule-9 moves, and J2, readings that persist. Ren asked for route (b) to be done in parallel and with care: "ok - 这一类请平行化认真完成，非常重要" ([his words, 9 November 2026](../../../../../../sources/15-codex-theory-conversations/2026-11-09-route-b-ethics-forms.md)).

The join's AI readings and checks are local, not in the repository, in `/Users/ren/tmp/za-how-far/route-b/join/`: three join readings, eight adversarial checks and a critic. This piece answers their item on time (`NEXT.md`, "The base" and "What the critic adds" item 5; `check-base-opus.md` §1; `check-base-fable.md` §1; `critic.md` §4).

## 1. The gap

G1's landed iff, `Flow.returning_unrestricted_iff_mutuallyDependent`, says that held de se along affecting at the formations whose acts return, the condition holds exactly where the flow is mutually dependent. It reads `Flow.Affects`, which binds the step of the need and the step of the exchange separately (`Web.DependsOn`, `Flow.Exchanges`), and `ownClosure` ignores its step. So mutual dependence can be carried by an exchange after the need, or by a chain whose links run backward. No dated mutual dependence existed.

On a dated net, `«续无外则同一中心»` says the condition admits one center only. It bites because the condition asks each center to reach the other center itself, past occurrence included. The critic argued that over what comes after, two centers meet it (a₀→z, b₀→z); that was not in Lean.

Ren was told "按时间展开的事件……续无外只容一个中心" and answered "ok". The checks found that this describes what the condition counts, not time. This piece settles both.

## 2. What was done

```text
Result(s): the-condition-in-time, what-the-one-center-bound-counts, a-line-alive-after-a-window (new);
  reuses standpoints-read-off-a-flow (ReturnsAlong, Returning, ownClosure_unrestricted_atReturning_iff,
  ownClosure_unrestricted_of_none, Flow.returning_unrestricted_iff_mutuallyDependent),
  feedback-and-reach (Flow.ReachesBefore, Flow.Affects), mutual-dependence-and-its-pace
  (MutuallyDependent, mutuallyDependent_iff_reach, Drawing), the-continuation-condition-on-the-root
  («续无外», «续无外则同一中心», withinClosure_iff_reached), what-persisting-shows-of-an-order
  (the premises of Flow.persists_never_overdraws), groups-formed-by-descent (family_childless).
Delta: (1) on a relation without cycles the returning elements are the sinks; (2) the condition over what
  comes after a center's step («续无外于后»), and on a net going forward in time the root's condition split
  exactly into it and "nothing else at or before the center's step", the part the one-center bound rests on;
  two-center witnesses; (3) a relation in time on occurrences (an exchange before a need, ReachesBefore's link,
  and a formation going on), mutual dependence in time, and the two own-closure conditions it is exactly
  (from some step on: mutual dependence in time from every step; over every later step: coupling at every
  next step), with witnesses where it holds with two formations, where the two part, where it lapses and
  where the time-blind condition holds and it fails; (4) the finite, dated form of persists_never_overdraws.
Supplied premises / correspondence: the going on as a formation's identity forward (a reading); every
  occurrence a standpoint (a reading); the condition read over what comes after the standpoint's step (a
  reading; by the region law a rival of the condition over every step wherever something lies at or before).
Evidence: Becoming.ConditionInTime, 50 theorems, 72 declarations, every axiom report empty (scratch build
  9 November 2026; the core run's receipt at landing).
Boundary: TwoSources.apart, Recurring.oneCenter_counts, RingOfThree.apart, Drawing.lapses, LatePair.apart.
Integration: 07 §4.11 (new); the board row; INTERFACES for the join, J3 section.
```

## 3. Choices, and what each candidate gave

**The relation in time.** Three readings of "affects" were weighed.

- **Across all steps** (`Flow.Affects`): the landed one. It is blind to time.
- **Each link forward, chains unordered.** This is an exchange at a step before the need, on formations: `∃ t, ReachesBefore {f} t g`. It removes the exchange after the need, but not the chain whose links run backward (f affects g at steps 2→3, g affects f at 0→1). Being a fixed relation on formations, G1's generic laws apply to it as they stand. Nothing new was proved for it, so it is not stated.
- **On occurrences, links ordered** (`Flow.StepInTime`): an exchange before a need, plus a formation going on to its next step. This is the one taken. The link is `ReachesBefore`'s (`Flow.reachesBefore_iff`). It is the one through which a part's acts show on a later step: `Flow.Balances.admits_unreached_before`, with `Late.affected_without_effect` showing an exchange after the need shows nowhere. The going on keeps a formation's identity forward, as `Affects` keeps it across all steps. It does not ask the formation to take part. Requiring presence would narrow the relation and break no law here, but it would change what "the same formation" means between steps; that is left as a reading.

**The standpoints.** No occurrence returns along the relation in time (`Flow.not_returnsAlong_stepInTime`): each goes on to its next step, which cannot reach it back. So G1's returning standpoints are empty in time, and the condition there is vacuous. Along affecting before alone, without the going on, the returning occurrences are the sinks (`Flow.returnsAlong_affectsBefore_iff`). By `ownClosure_unrestricted_atReturning_acyclic_iff`, the condition there fails wherever there is a sink and two occurrences, which `Nat × F` has whenever there is a formation (Fable's check). Either way G1's second reading of the standpoints gives nothing in time. The standpoints taken are every occurrence, the dated counterpart of every formation a standpoint (G3's `Flow.mutuallyDependent_iff_unrestricted`).

**The condition.** `Unrestricted` asks significance at every step. On a dated closure nothing reaches an earlier step, so held de se at every occurrence it fails wherever there is a formation (`Flow.not_unrestricted_inTime`); nothing reaches a step beside an occurrence either (by `«及则后»`; witnessed in `Recurring.oneCenter_counts` on the root). Two restrictions to what comes after were stated:

- **Over every later step** (`UnrestrictedAfter`). This is the brief's "from each center at step t, significance of what lies after t". It holds exactly where every formation affects every other at the next step (`Flow.unrestrictedAfter_iff_coupledEachStep`), because what comes at the next step is reached only by one step in time. **Failed candidate, kept:** as mutual dependence in time it is too strong. A ring of three is mutually dependent in time and fails it (`RingOfThree.apart`).
- **From some step on** (`UnrestrictedEventually`). This holds exactly where the flow is mutually dependent in time from every step (`Flow.unrestrictedEventually_iff_mutuallyDependentInTime`). That is the dated counterpart sought.

Neither is the condition over every step: by the region law (`rival_of_outside`, 07 §1) for the first, a significance holding exactly over every later step being a rival wherever something lies at or before, and by `Flow.not_unrestricted_inTime` for both (the second's step is chosen per standpoint and formation, so it is not a fixed region). The condition's source states it as each thing's continuation into the future. Which of the two forms is "the" condition in time is a reading. This note does not decide it.

## 4. The answer

**The positive half survives in time, in one form, non-vacuously.**

- With every occurrence a standpoint, read from some step on, the condition is mutual dependence in time from every step.
- Read over every later step, it is coupling at every next step.
- Both hold on a balanced flow with two formations (`Recurring.inTime`).
- Mutual dependence in time from any step gives mutual dependence, and G1's condition at the returning formations.

**It does not survive in three ways.**

- At the returning standpoints read in time it is vacuous.
- The time-blind condition does not give the dated one. In `LatePair` the time-blind condition holds and nothing affects anything in time (`LatePair.apart`).
- In time the condition is a matter of when. `Drawing` is mutually dependent in time from step 0 and not from step 1 (`Drawing.lapses`), while the time-blind condition stands at every step.

**The one-center bound.**

- On a net going forward in time, `«续无外»` is exactly `«续无外于后»` together with "nothing else at or before the center's step" (`«续无外当且仅当后与独»`).
- The second part alone gives one center, with no net (`«独则同一中心»`), and no act can meet it; the first part does not (`TwoSources.apart`). `«续无外则同一中心»` itself holds on every net without cycles; the split is stated for nets whose conditions come at earlier steps.
- Over what comes after, two centers meet the condition (`TwoSources.apart`), and on `Recurring` every occurrence does (`Recurring.oneCenter_counts`).
- So "按时间展开的事件……续无外只容一个中心" is true of what the condition counts: the occurrences before and beside a center included. It is not a fact about time.

**"Where relations close"**, said plainly:

- Read across all steps, the condition holds where the flow's relations close: every formation within every formation's influence closure.
- Read in time, it holds where each formation's acts, from each step on, come to bear on every formation's later continuation, and only from the steps where they do. It can lapse.
- In both cases exchanging counts taking as well as giving, so this includes mutual drain.

**Persistence, dated.** `Flow.persists_never_overdraws` uses its line's persisting once, at `T + n + 1`. `Flow.member_after_never_overdrew` is the finite form: a member at any step later than `T + n` rules out that window. It says nothing of a window closing at or after the member. J1 may derive the landed law from it (board rule 9); this piece does not edit `PersistingChoices`.

## 5. Kinds, and how far seen

- **Near-definitional:**
  - `returnsAlong_iff_sink`, `ownClosure_unrestricted_atReturning_acyclic_iff` and `Web.continuationStep_returns_iff`;
  - `«续无外当且仅当后与独»`, `«独则同一中心»`, `unrestrictedAfter_iff_forward` and `Flow.not_unrestricted_inTime`;
  - both dated iffs, `WithinTime.withinReach` and `member_after_never_overdrew`, the last a copy of the landed proof with the member given instead of persistence.
- **Witnesses** are checked on their models: `TwoSources`, `Recurring`, `RingOfThree`, `Drawing.lapses` and `LatePair`.
- **Nothing is new as mathematics.** The temporal-network notion behind it, time-respecting paths and temporal connectivity, is standard.
- **Proved:** everything named with a Lean name.
- **Readings, not proved:** what a reading of the standpoints and of the going on means, and the sentences on "where relations close".

## 6. The cold read

One AI reader of another model (Fable) read the module, the three records, 07 §4.11 and this note cold, for overclaim; its findings and what was done with each are in [READER.md](READER.md).

## 7. Left open, for J1 and J2

- **J1.** `Flow.persists_never_overdraws` could become a corollary of `member_after_never_overdrew`. `ReturnsAlong` moves to Frame; the sink lemmas move with it.
- **J2.** Read the pool and the lineage on `StepInTime`. A lineage's members are occurrences that come to stand, so J2's lineage relation would be `StepInTime` with descent edges in place of, or beside, the going on.
- **Not tried.** The going on restricted to presence.
