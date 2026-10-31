# UE25: communicating agents in the principle's terms (design)

30 October 2026. This design is AI-written. It is for board item UE25.

## 1. The gap

Under "What the theory forbids that the literature claims", the principle's page names three statements that UE1's [search](../ue1-fep-bridge/THIRD-PART-SEARCH.md) grades as forbidden on their natural reading, candidates 4–6:

- "both agents come to share the same model" (Friston and Frith 2015, the duet, §4);
- any dyad or ensemble "will come to share" a generative model (Friston, Ramstead and others 2024, §4.1);
- language is "an emergent property of free energy minimisation" (Friston, Parr and others 2024, abstract).

The page does not count them. The law that forbids them, [a code formed between formations](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#r-a-code-formed-between-formations) (`SharedCodes.never_agrees_of_both`), is stated for codes, each agent holding one form for each sense, and not for agents whose beliefs are learned by free-energy minimization. UE1's premise, "free-energy minimization is unchanged by permuting word labels", is stated in prose and not proved.

UE25 states the law for agents holding Dirichlet counts, which are the principle's beliefs about a likelihood mapping. It proves the premise in UE21's counting form, in the pure core.

## 2. The model

The model has finitely or infinitely many agents `I`, meanings `M` and words `F`.

- **Beliefs.** A belief state is `B : I → M → F → Nat`. Agent `i`'s Dirichlet counts of word `w` for meaning `m` stand for a likelihood mapping meanings to words, with the counts as concentration parameters, as in the principle's learning of the likelihood.
- **The core's code law applies directly.** The form type of `SharedCodes` is taken to be `F → Nat`. A renaming of words `σ : M → F → F` acts on count vectors by `rename σ m c := fun w => c (σ m w)`. So `Relabels π (rename σ) B B` says that agent `i`'s count of `w` is agent `π i`'s count of `σ m w`. No new symmetry machinery is needed.
- **Precision.** `Greatest c w := ∀ w', w' ≠ w → c w' < c w`: `w` is the unique word of greatest count. It is the word a posterior mean, or any increasing reading of the counts, names without a tie.

## 3. The laws (planned, all in the pure core)

1. **Free-energy minimization is unchanged by renaming the words** (the join to UE21). Two laws, by induction on the listing:
   - `total (a ∘ σ) hs = total a (hs.map σ)`;
   - `powerProduct (a ∘ σ) (n ∘ σ) hs = powerProduct a n (hs.map σ)`.

   So a count belief reaches the free-energy bound for weights `a` over the renamed listing exactly where the renamed belief reaches it for the renamed weights. The belief at the bound, the posterior in counts, renames with the weights. This proves UE1's premise.
2. **Precision under renaming.** `Greatest` holds of at most one word. Where `σ` is onto, `Greatest (c ∘ σ) v → Greatest c (σ v)`. A count vector that a renaming moving every word leaves unchanged has no greatest word.
3. **Never a shared precise word** (the headline). Take a law on belief states keeping the exchange of agents by `π` together with the renaming by `σ`, a start symmetric under them, and `σ m` onto and moving every word. Then at every step, where agent `i` has a greatest word for `m` and agent `π i` has one, the two words differ: the second is `σ m` of the first. This follows from `Law.KeepsRelation.run` and law 2.
4. **A shared model is imprecise.** Under the same law, where two exchanged agents hold the same counts for `m`, the counts are fixed by the renaming (`SharedCodes.agrees_only_fixed`, an instance). So where the renaming moves every word, the shared model has no greatest word for `m`.
5. **The principle's update rules keep both symmetries.**
   - *Exchanging sufficient statistics* (federated inference, §3.1 ¶7): `B' i m w = B i m w + B (π i) m w`, with `π` an involution. This keeps the relation. The two agents hold one model after one exchange, by commutativity of addition, so "come to share the same model" holds here literally. By law 4 that model is imprecise where the renaming moves every word.
   - *Learning by adding the counts heard* (the principle's update of Dirichlet parameters, `a ← a + counts`): each agent adds a count vector read off the other's counts by a reading that commutes with renaming. This keeps the relation whenever the reading does.
6. **Witnesses.** Two agents, two words, one meaning; the renaming exchanges the words and the exchange swaps the agents.
   - From all counts zero, each agent says the least-indexed word of greatest count, and the hearer adds it. Both then hold word 0 as greatest. The order is a preferred word, so the law does not keep the renaming.
   - From the asymmetric start `(1,0)`, `(0,0)`, one exchange of sufficient statistics gives both agents `(1,0)`, a shared precise word.

## 4. What the page gains

The law forbids, on a model in the principle's terms, that symmetric agents learning by free-energy minimization come to share a precise mapping of meanings to words. That is the natural reading of candidates 5 and 6, and of candidate 4 read as a shared language rather than identical synchrony.

Candidate 4 read literally is not forbidden: agents exchanging sufficient statistics do come to share one model, an imprecise one where the renaming moves every word.

None of the papers' systems is refuted:

- the duet gives both agents one model;
- the 2024 simulation starts each Dirichlet parameter at one plus a random variate;
- the ecosystems paper describes no system of its own.

Whether the page counts one entry, one law covering three papers as entry 2 covers two, is settled at writing. The count would then move from four to five.

## 5. Boundary

UE25 does not cover:

- speaking by sampling, that is, noise. The law then gives way to an invariant law, as UE24 shows for cells. Stating that for codes is a periphery step, UE24's kernel law for another symmetry, and is not part of UE25;
- how long agreement takes;
- the hermeneutics simulation's one-scalar difference;
- free energy over parameters as a real number. The counting form only covers beliefs in counts.

## 6. Names

Module `Becoming.CountedCodes`, a core leaf importing `Becoming.SharedCodes` and `Becoming.FreeEnergyCounting`. Record: `a-code-of-counts-learned-by-free-energy-minimization` (to be checked against the naming study at claim time). Words used: "count", "renaming", "greatest". No "draw", "agent's goal" or "language" in Lean names.
