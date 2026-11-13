AI-written (Opus reader), 13 November 2026

Reader of DESIGN-R3 from ReadingLoop, Narrowing, Keeping and Blanket (and one GrammarLaws census law I found while checking). Paths are relative to PKG. Nothing was built or run.

## 1. G1, G2 and G3 are already stated in other forms

Quoted statements:

- `Narrowing.mem_learn` (Narrowing.lean:225): `h ∈ learn hs e ↔ h ∈ hs ∧ Fits h e`, where `learn` folds `revise hs o := hs.filter (fun h => h o.1 == o.2)` (:62).
- `ReadingLoop.Loop.kept_iff` (ReadingLoop.lean:589): `h ∈ (L.law.course (start hs s a e) (n + 1)).internal.1 ↔ h ∈ hs ∧ ∀ k, k < n → L.predict h (course k).sensory (course k).active = (course (k + 1)).sensory`.
- `ReadingLoop.filter_all` (ReadingLoop.lean:555): `(∀ x, x ∈ l → p x = true) → l.filter p = l`. This is one direction of G2. The other direction (if `filter p l = l`, every member passes) is not stated anywhere I read. `GrammarLaws.keep_all` (GrammarLaws.lean:463) repeats `filter_all` for the package's second filter, `GrammarLaws.keep` (:442).
- `«后者在后则所列亡者亡»` (GrammarLaws.lean:1978): `g ∈ GrammarLaws.ceasing k before after ↔ g ∈ before ∧ «亡» R E g`. This is the root's own statement that a listed unit dropped across a step is an ending.
- `Keeping` (`KeptFor`, `Plan.Keeps`) is about a guard held for `n` steps whatever values the steps keep. It has no lists and states nothing like G1.

Is G1 an instance? Not cleanly.
- **Through `mem_learn`:** parts must become rules, `p ↦ fun x => decide (p.need ≤ x)` with observations `(x_k, true)`. Two parts with the same need but different uses become the same rule, so membership of the rule does not give back membership of the part. You would need `filter_map_comm` (Narrowing.lean:139) and still lose the part.
- **Through `kept_iff`:** you would need `predict p x a := if p.need ≤ x then answer else answer + 1`. That is contrived. It is also off by one step (the answer sensed at `n + 1` is taken in at `n + 2`), and `Loop.law` is total while the design's net is cut.

So G1 is the same three-line induction on `mem_filter` that `mem_learn` and `kept_iff` already repeat, not a corollary of either. G3(ii) is `TurningInTime.kind_ends_while_net_goes` (TurningInTime.lean:610) with `κ := (p ∈ ·)`, but only for `TurningInTime.net need`. The design's net is a different relation (see section 5).

## 2. One definition: yes for membership, no for the laws that matter

A shared definition would look like this:

```
def sieve (test : Nat → α → Bool) (l : List α) : Nat → List α
  | 0 => l | n + 1 => (sieve test l n).filter (test n)
theorem mem_sieve : x ∈ sieve test l n ↔ x ∈ l ∧ ∀ k, k < n → test k x = true
theorem sieve_eq_self_iff : (sieve test l 1 = l) ↔ ∀ x ∈ l, test 0 x = true   -- G2
```

Each module's laws would become:
- **G1:** the way at step `n` is `sieve (fun k p => decide (p.need ≤ level k)) w n`.
- **`kept_iff`:** an identification (`internal.1` at `n + 1` is a `sieve` whose test at `k` is the course's own answer at `k`), then `mem_sieve`.
- **`mem_learn`:** `learn hs e` is a `sieve` indexed by `e`'s positions. `faithful_kept`, `kept_alike`, `actual_retained` and `counterevidence_of_*` follow from `mem_sieve`.

The statements of landed theorems need not change, only their proofs.

They should stay apart in what they claim. In Narrowing the tests are fixed from outside the list. In the Loop and in the design, the test sequence is produced by a course that depends on what is kept (`choose`, `use`). `mem_sieve` takes the course as given and says nothing about that feedback. G4, G5 and G7 live entirely in the feedback. One definition removes duplicated proofs; it does not show a shared turn.

## 3. "A candidate's ending … would be the same turn": not stated, and false of `Loop.law`

- ReadingLoop uses neither `«亡»` nor any net. `Loop.law` is a `Blanketed` law. Its `step` (Blanket.lean:118) is total, and `course` is `Law.orbit`. So the whole never ends, and the design's turn (ending where the net ends versus while it goes on) has only one side there.
- The `[p]`-alone analogue of G3(iii) fails. With one candidate refuted, the internal part becomes `[]` and the formation goes on with `choose [] s`.
- The class "`h ∈ internal.1`" does not end at the refuting answer. The internal part's second field stores `(s, a)`, the drop happens one step later, and the class that ends at the refutation is `Loop.Fitting` (:638), not membership.
- What does exist in root terms is the census law `«后者在后则所列亡者亡»`: a unit dropped across a step ends. It is about units, not lines under a class in a cut net.

Recommendation: drop the sentence, or say "same list shape only".

## 4. Words

How these modules already use the words:
- **"part":** the four parts of one law in `Blanket.Parts` (:103). The ReadingLoop header speaks of the "internal part" (:12), and Keeping says "two plans for two parts" (`Plan.zip`). TurningInTime's header (:41–42) also calls labels "parts of its configurations and step".
- **"kept":** used in three senses. A candidate not dropped (Loop, Narrowing). A guard held for `n` steps (`KeptFor`). A kind closed under every step (TurningInTime's `Kept`).
- **"candidate":** something proposed that evidence can drop.
- **"reading":** a relation `B : M → W → Prop`, or an AI-reading paragraph.

A member of a way called a "part" would sit inside the internal part of a configuration, while `Parts` is the whole configuration, so the clash is real. "Candidate" is wrong, because nothing refutes these. GrammarLaws' census calls listed members "units" (:1837 ff.), and the census is the root's own statement of a listed member's ending. **"Unit"** is the word the package supports. Keep "goes on" rather than "kept".

## 5. Sentences that say more than G1 to G7

- **G5, "`AloneOutside`, `kept`, `turns`, `uses`, `uses₁` are theorems":** false with `W := List Part`.
  - `AloneOutside (· < m) id after` needs `filter (need ≤ x) w = w` for every `w` at every `x ≥ m`, and it fails at `w = [(m+1, 0)]`.
  - With `Kept := first absent`, `uses : ∀ w, Kept w → use w = H₂` fails at `[]` (`use = 0`) and at `[(3, 100)]`.
  - `kept` is required at every `x`, including `x < n`, where `[p₂]` becomes `[]`.
  - The design's net (guard `∃ p ∈ s.1, p.need ≤ s.2`) is not `TurningInTime.net n`: at `([], y)` with `n ≤ y` one has a next and the other does not.
  - G5 needs a three-state `W` (both, second, none) or restricted hypotheses, and a lemma that the two lines agree.
- **G4, "parts end one after another":** a filter can drop several at once.
- **G7, "can only make the turn later" and "the part that uses most":** G7 is monotonicity of never ending, not timing, and G5 assumes `n ≤ m` only, not `h ≥ H₂`.
- **"The mark is not something a reader adds … an ending of the same kind":** the kind is the same by construction, because one `≤` defines both. It is a choice of the model, not a finding.
- **"three levels become two needs and a use":** `H₁` is `h + H₂`, a sum of two uses.
- **G2, "makes a difference exactly where…":** G2 gives a mark that depends on the way, while `AloneOutside` asks for one uniform over all ways. This is the same gap as G5's.
- G3(i) and G3(iii) are fine, and near-definitional. G1 is fine as stated if it is read on `pair`'s orbit, or on the line while it goes on.
