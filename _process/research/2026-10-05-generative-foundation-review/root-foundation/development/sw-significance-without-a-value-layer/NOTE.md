# SW: significance without a value layer

Board item SW, 24 October 2026. Prompted by [Ren's remark](../../../../../../sources/15-codex-theory-conversations/2026-10-24-significance-a-dualist-word.md) that significance was a dualist word. AI-authored throughout. No new Lean: every theorem cited is landed. This note argues a reading and proposes text; chapter 7, the glossary and the one page change only through their owners (§6).

## 1. What SD1 proves, exactly

`Becoming.Significance` takes a significance `sig : Pos → Nat → F → Prop` as a free parameter. `ReadsOnlyDynamics law` says `∀ d sig sig', law d sig → law d sig'`. `ReadsOnlyDynamics.not_entails` substitutes the empty significance and is done in one line. So the theorem says: a predicate that nothing else in the representation reads is fixed by nothing else in it. That is true and checked, but it holds by construction of the representation, and [chapter 7 §1](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-what-the-dynamics-leave-open) already says it is "a fact about the representation". The front pages make it the ethics' lead sentence, and the 24 October assessment drew "the proofs are silent where most needed" from it. That inference overreaches: the silence belongs to the slot, not to the unfolding.

## 2. Where the layer enters

Chapter 7 §1 says evaluation forms within the unfolding: a center's own region is its closure along a relation the unfolding reads (`Web.selfValuation_own_least`). The definition that follows does not use this. `sig` admits any predicate on standpoints, steps and formations, tied to no region. That is the fact/value split carried by a formal variable, which the method rules out ("no name or formal variable smuggles in an independent ontology"). The word fits the slot: significance as something a standpoint confers on a continuation, with a valuer on one side and what is valued on the other.

## 3. The reading already in the work

§4.2 has the structural reading formalized. Held de se, a standpoint's significance is what lies within its own center's closure along a relation: `selfAscribed (ownClosure rel) center`. Then

`ownClosure_unrestricted_iff : Unrestricted (selfAscribed (ownClosure rel) center) ↔ ∀ p g, WithinClosure rel (center p) g`.

The right side reads only `rel` and `center`. Where `rel` is a relation the dynamics define (feeding, `Flow.WithinFeeding`; affecting, the reach closure), the condition is a statement about the dynamics, true or false of a given unfolding, and SD1 does not reach it. Read this way, "the continuation of g has significance from p" says that g's continuation lies within what p continues with. That matches the source's own gloss: "how much does one consider something to be a part of its system dynamics" ([10 October](../../../../../../sources/15-codex-theory-conversations/2026-10-10-wanting-continuation-one-axiom.md)).

## 4. What moves and what stays

- **Moves.** What the represented dynamics leave open is no longer a value that no fact touches. It is which relation a center continues along. That choice is among things the unfolding has, its relations and the classes put over it. Its consequences are exact (`forced_iff_within`, `ownClosure_standpointInvariant_iff`, `ownClosure_unrestricted_of_whole`), and it is the question PW §6a and GS2 already ask: which class does a line continue under?
- **Stays open.** Whether the dynamics fix that relation. The representation still supplies `rel`, and a relation the facts privilege (an organism's life) would make the narrower closure the self's own. The step of invariance is the same open question, now asked without the word: is the self drawn along a relation narrower than being related at all? The monist start bears on it, though it settles nothing. In one unfolding the widest relation is not a further posit, and a narrower one is a class put over it.
- **Stays a premise.** C, "widening is better", still alone orders. The reading does not make the condition true. Along the total relation it is trivially true, along the empty relation it is a standpoint's own good, and which holds of a self is the open question. Nothing is defined so that it holds. The condition keeps its standing, stated and not asserted, which fits its source: it was offered to keep the work going toward continuation, not as a claim needing a warrant of its own.

## 5. The word

Naming rule: a renaming sweep needs a name that states a wrong meaning. "Significance" does. The formal object is a predicate of inclusion, defined "with no valence, not a number", and the word adds a valuer conferring value, a layer the object does not have. Proposal for live text, with Lean names unchanged (joined modules keep their names until an owner moves them):
- in words, "g's continuation lies within p's continuing" (or "counts for p", matching the scope role "whose losses count");
- the condition: "for anything, its continuation lies within what everything continues with", with the source's sentence quoted as its origin;
- living significance: kept as a name for the record, with its gloss restated.

The owners decide. If the word stays, the glossary entry should at least carry the de se reading of §3.

## 6. Proposals, by owner

1. **One page and overview (NR's owner).** The ethics paragraph should lead with the structure, not the non-entailment. Suggested lead: *Read as lying within what a center continues with along a relation, the continuation condition is a statement about relations: it holds exactly where every center's closure is the whole (`ownClosure_unrestricted_iff`). What the represented dynamics leave open is which relation is a center's own. Supplied instead as a free predicate, significance is fixed by no statement about the dynamics, by construction.*
2. **Chapter 7 (the IV3 line's owner).** Thesis line and §1: state the same order (the structural reading first, SD1 as a fact about the free parameter), and tie the definition of `sig` to §1's own region, or say that it is untied.
3. **GS2's owner.** State the condition on `«续»` as inclusion in what a line under a class continues with, with no separate significance formalism. Then `Unrestricted` is the instance where the class is the whole, and the board question "what it is for a line relative to a class to have significance" becomes "what lies within a line's continuing under a class".
4. **Glossary.** The significance row gains the de se reading, or the name of §5.

## 7. 道法自然

The theory already holds the criterion this reading meets. [Chapter 6](../../../../../../theories/becoming/chapters/06-CLASSICAL-TEXTS.md#three-layer-verdict) reads 道法自然 as taking a model that stops at what is so of itself, with no commander outside it. [Chapter 7 §1](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#evaluation) says no position outside the unfolding owns value. The method allows no formal variable that carries an independent layer. A significance supplied as a free predicate is a standard from outside, and it fails all three. Read as what lies within a center's own continuing (§3), it meets them: the standard is the unfolding's own relations.

Two limits keep this from overreaching:
- 自然 is not "whatever happens is good". Degeneration, ending and loss are so of themselves as much as generation is. So 道法自然 fixes where a standard may come from, not which course is better. C still alone orders, and 生生不息 (which OPENING sets beside 道法自然) is the direction C names, not a consequence of 自然.
- What is so of itself does not settle which relation a self continues along (§4). The step stays argued. 道法自然 counts against a narrower relation only as far as that relation is a model put over the unfolding from outside it, and whether some narrower relation is the self's own is exactly the open question.

For the work itself, the same reading applies: the change moves through the pages' owners, by the handovers in §6, and is not forced over their uncommitted edits.
