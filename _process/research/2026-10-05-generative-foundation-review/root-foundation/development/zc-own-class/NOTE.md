# ZC: a center's own class, what the net fixes (route (b), G2 with G5)

AI-written (Claude Opus 5.5, a side session of the zero-axiom reading), 9 November 2026. Board row ZC. Ren's words for route (b) ("ok - 这一类请平行化认真完成，非常重要") are kept with route (b)'s first landing in `sources/15-codex-theory-conversations/2026-11-09-route-b-ethics-forms.md`. The Lean is [`Becoming.OwnClass`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/OwnClass.lean). Its home is 07 §4.10, and its records are `what-the-net-fixes-of-ones-own-class` and `the-own-class-read-on-a-flow`.

## 1. The question

Chapter 7 reads the self whose continuation acting presupposes as a line under a class on the root. §4.6 asks two things of that class at oneself:

- **P2**, constancy up to the net's end at one's own class (`«本类至终有常» R E m`): whatever an occurrence alike to `m` conditions, every alike occurrence that conditions anything conditions something alike to it;
- **P4**, that the class hold one's effects (`«所缘同于» R E m`): everything `m` conditions is alike to `m`.

§4.7 says the laws "move the whole question into the class" and "no law of the dynamics singles that class out". The Open list keeps the de se question: which class a center's own line runs under.

The zero-axiom readings of 9 November (`/Users/ren/tmp/za-how-far/`) named this G2. Opus conjectured that the classes meeting P2 and P4 at a point are closed under joins only, because constancy is a ∀∃ condition like bisimulation, and predicted a finite witness of two incomparable classes whose meet fails. Opus marked this as unchecked. If the family were closed under meets instead, it would have a least class, and the net would fix de se there.

## 2. What holds

**The conjecture is false for P2 and P4 together. Its prediction that meets fail holds of P2 alone; whether P2 alone is closed under joins is not checked.**

1. *P2 ∧ P4 is one closure.* At an `m` that conditions something, P2 ∧ P4 ⟹ the block `E m` is closed under `R`. This is `«本类常闭则所缘同类»` (GrammarPath) read as a region. Conversely, if the block is closed, P4 is its case at `m`. P2 holds wherever it is decided, of each alike occurrence, whether it conditions something: if `u'` conditions some `w`, then `w` lies in the block, and so does `v`, so `w` serves as the witness `v'`. The decision is needed because P2 is a disjunction, and the core uses no classical principle. (`«本类常闭则类闭»`, `«类闭则本类常闭»`, `«本类常闭当且仅当类闭»`.)
2. *Closed under meets.* The ∀∃ in P2 is defeated by P4. Under P4 every effect of an alike occurrence lies in the block of every class in the family, so the witness that one class's P2 gives serves the meet. That witness is used only to decide whether `u'` conditions anything. This holds for binary meets (`«本类常闭之交»`) and for meets of any family with a member (`«本类常闭之遍交»`). The family needs a member because the empty meet is the one, and the one meets P2 only where the decision is available.
3. *Not closed under joins.* Take `m → a` and `z → w`. Let `E` have the blocks `{m,a}`, `{x,z}`, `{w}`, and `F` the blocks `{m,a,x}`, `{z}`, `{w}`. Each block of `m` is closed. The least class containing both, `J`, has the block `{m,a,x,z}` (`J_least`), and `z → w` leaves that block (`J_fails`). So the opposite of the conjecture holds: meets yes, joins no.
4. *The least class.* `«后类» R m` holds `m` alike with everything in `«所闭» R m` (itself and everything downstream) and nothing else with anything. It is a class, and its block at `m` is the closure. Let `E` meet P2 and P4 at `m`. Then the region `{y | m = y ∨ (E m y ∧ m conditions something)}` is closed under `R`, so `E m ⊇ «所闭» R m` and `«后类» R m ⊆ E` (`«本类常闭则含后类»`). This needs no premise that `m` acts. And `«后类» R m` meets P2 and P4 whenever some class does: that class's P2 decides each `u'` in the closure, and both effects lie in the closure (`«后类本类常闭»`). Together these give `«后类最细»`. With no class given, `«后类» R m` meets P2 wherever it is decided, of each occurrence downstream of `m`, whether it conditions something (`«判则后类本类常闭»`); its P4 needs no premise.
5. *The reach is the one's.* Under any class meeting P2 and P4 at `m`, `«所及» R E m t ↔ «所及» R «一» m t`. A line runs along `R`; conversely, `«本类常闭则后皆续»` applies once a path from `m` supplies a first step (`«本类常闭则所及即一之所及»`). Given P2, P4 ⟺ this equality, since the backward direction is `«后皆续则所缘同于»`. So with each center under its own such class, the condition along the net is `«续无外» R «一» center`, which along an acyclic net forces one center.
6. *P2 alone.* The identity `«静»` meets P2 everywhere. It is the self of one moment. It fails P4 wherever `m` conditions something other than itself. P2 alone is not meet-closed: take `m → a, b` and `m' → c, d`. `E` pairs `a~c, b~d` and `F` pairs `a~d, b~c`. Each meets P2 at `m`, and the meet does not (`MeetBreaks`). Opus's intuition is right here. At an idle `n` in the same block, P4 is vacuous, both classes meet P2 and P4, and the meet fails P2. So the meet law needs its premise that `m` conditions something. The least class still exists there: it is `«后类»`, the identity on `m`'s block.

**What this changes in the map.** P2 and P4 fix the class's reach, uniquely, as the downstream of `m`, and they fix the least class. They do not fix the class: `JoinBreaks.E`, `JoinBreaks.F` and, where it is decided, the one all meet both at `m`. Nothing the line reaches turns on which of them it is. The least class is the widest self of 07 §4.7's table ("everything one conditions"). Granted P2, a self whose line reaches forward less than the one's fails P4 (`«本类常则闭当且仅当所及即一之所及»`). A class narrower than the one can still hold its effects (`«后类»`). So, granted P2, the de se question on §4.6's path reduces exactly to P4, the crux of §4.7. The net offers both the moment (P2 without P4) and `«后类»`. `«后类»` holds one's effects, and it meets P2 wherever any class meets both, or wherever that is decided. No law stated here chooses between them. Without P2 the question is wider: classes holding one's effects can then differ in reach (`Inconstant`, `OtherLeaves` in GrammarPath). This is a theorem about the classes. It is no claim about what acting presupposes.

## 3. G5: the class read on a flow

On a flow, take `R = L.Affects W` and the class `Flow.CouplingClass L W obs f := «内外» (L.WithinCoupling W obs f)`, where `«内外» S x y := (S x ↔ S y)`. Then:

- P4 ⟺ everything `f` affects lies within its coupling closure. With `thresholdOnly`, that is ⟺ whatever `f` affects can affect `f` back at some remove. Every effect returns at one step.
- The reach ⟺ every formation within reach of `f` lies within its coupling closure. With `thresholdOnly` that is ⟺ `Flow.ReachReturns`. For every coupling by level, `ReachReturns` gives the reach through `ReachReturns.represented`.
- The line stays within the reach and within the coupling closure. With `thresholdOnly` it is exactly `Flow.InOneLoop W f`.
- P2 ∧ P4 ⟹ the coupling closure is closed under affecting (`Flow.couplingClass_closed`). This is more than return. The root witness `ReturnsNotRegular` has `f ↔ k`, `g → f` and `g → h`: the reach holds at `f` and P2 fails. No flow is built whose affecting relation is that net.
- Root forms: `«返之所及即环»` (the line under "can reach `f` or not" is `f`'s loop), `«返之后皆续当且仅当皆返»`, and `«无环则返之所及唯己»` (on an acyclic net, only `f`).

**Near-definitional, and said so.** The class holds by construction what it is drawn on. The proofs compose `«线内同类»`, `«后皆续当且仅当后皆同类»`, `withinCoupling_thresholdOnly` and `withinReach_iff_influence`. Only the loop characterization needs a small induction (`«返之线»`). The content is a reading. Read with a class drawn on what a formation can represent, §4.6's path reaches the loop, which lies within what can affect the formation, the influence closure. That is route (b)'s outer bound; the feeding closure lies inside it, and the loop is not shown to lie within the feeding closure. Read with a class drawn on effects, the path gives `«后类»`. P4 is what tells the two apart.

## 4. What is not shown

- Which class is one's own, or whether acting presupposes a class that meets P4 (§4.7's crux).
- That an actual self's class meets P2.
- That an actual net is decided in the sense the converse of the closure form asks. Finite nets with decidable conditioning are.
- Anything about order: P4 ranks nothing.
- G1's centers. Here a center is any occurrence or formation, and nothing reads which are centers.

## 5. Cold read

Claude Fable read the Lean, 07 §4.10, this note and the two record drafts cold, before landing ([COLD-READ.md](COLD-READ.md), with the full report and what was done for each finding). It found the theorem text and the records' laws exact. It found six substantive faults in the Readings. One was a false sentence: a self narrower than the one need not fail P4, and only a self whose forward reach is narrower does, given P2. The others were "the net fixes it" for what fixes only the least class and the reach; `«后类»`'s P2 stated without its premise; P2 presupposed in "nothing left but P4"; `couplingClass_closed`'s premise dropped; and the loop equated with "what it depends on" where it lies within the influence closure. All thirteen findings were taken. One lemma was added: `«判则后类本类常闭»`.
