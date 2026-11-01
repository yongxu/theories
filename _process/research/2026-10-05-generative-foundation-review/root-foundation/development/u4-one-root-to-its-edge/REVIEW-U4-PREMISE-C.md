# C's entry among the premises of the ethics: a reading of `ReadsNoOrder.not_entails`

A reading made on 1 November 2026, after DU landed (study section 489), by the session that owns the record one-root-to-its-edge (an AI reading; no person's review). LN's landing found that the record's boundary field still said C had no theorem of not being entailed, although DU's core leaf now proves one. This file reads whether that theorem states what the field's entry claims. The record cites it as the entry's review.

## What the entry claims

The field's entry for C (role `order`, premise `Becoming.Comparison`) had `not_entailed: null` with the reason: no theorem shows that no statement reading only the dynamics entails `Comparison` with "better" free. Naming a theorem there claims what the scope entry claims with `Becoming.ReadsOnlyDynamics.not_entails`: no statement that reads only the dynamics, and holds, entails the premise. The theorem must be a theorem of the core run whose type names the premise. That is Q1 of `tools/research/boundary.py`, which `master_laws.py` computes.

## The theorem

`Becoming.ReadsNoOrder.not_entails` (PremiseWitnesses.lean, in the core since receipt 20261101T000137.132110Z):

```lean
def ReadsNoOrder {D : Type} (law : D → (S → S → Prop) → Prop) : Prop :=
  ∀ d better better', law d better → law d better'

theorem ReadsNoOrder.not_entails {D : Type} {law : D → (S → S → Prop) → Prop}
    (reads : ReadsNoOrder law) {frame : Frame S A C} {living : C → Prop} {d : D}
    (entails : ∀ better, law d better → Comparison frame living better)
    {s t : S} (extension : Extension frame living s t)
    {better : S → S → Prop} : ¬ law d better
```

with `Comparison F living Better := ∀ s t, Extension F living s t → Better s t`, and `Extension` the keeping of every claim with some living claim realized anew.

## Reading, against the scope entry's theorem

1. **What reads only the dynamics.** `ReadsNoOrder` is `ReadsOnlyDynamics` with the order in the place of the significance: a statement about any data whose truth does not change with the order. The data are of any type, so the datum may be a world, a web or the frame itself. The frame and the counting of living claims are fixed outside the statement and may be chosen from the datum. This is the sense in which the field's two entries say "reading only the dynamics": the statement's truth does not change with the premise's free slot.
2. **Entailment.** The theorem asks entailment at the one datum only, for every order. `ReadsOnlyDynamics.not_entails` asks it at every datum. So in this respect it is the stronger of the two.
3. **Its condition.** The frame has an extension. This plays the part of "a standpoint and a formation" in the scope entry, and it is needed. Where a frame has no extension, `Comparison` holds at every order vacuously, so every statement entails it. The entry's basis now states the condition, as the scope entry's basis states its own.
4. **What follows.** The statement fails at that datum for every order. So no statement reading no order, and holding at some order, entails C there. That is the scope entry's claim, with the order in the place of the significance.
5. **Depth.** The proof applies the hypothesis at the order relating nothing, at which C fails at the extension. It is immediate, as the scope entry's theorem is. The field asks for a theorem stating that the premise is not entailed, not for a deep one, and the basis says it is immediate.
6. **What it does not show.** It gives no warrant for C, and does not say that C fails. It says nothing of an order read off a description of configurations (`Comparison`'s own module treats that case), and nothing under further premises. Under self-concern, `Web.extension_ranked_of_increasingInOwn` gives what C asks, one way, between listed level paths; self-concern is a premise there, not the dynamics.

DU's own text says the same: its module calls the theorem "the pattern of `ReadsOnlyDynamics.not_entails` for the condition, with the order in the place of the significance", and 08 §7 states it so.

**Verdict.** The theorem states what the entry claims, under the condition of a frame with an extension. So `not_entailed` becomes `Becoming.ReadsNoOrder.not_entails` and the reason for its absence goes. The basis adds the condition. The record's non-implication on the warrant of the premises now says that neither is entailed by statements of the dynamics, each under its condition, and that each warrant is open. A history note says so. Nothing else in the record changes: the standings, the counts and the scope entry are untouched.
