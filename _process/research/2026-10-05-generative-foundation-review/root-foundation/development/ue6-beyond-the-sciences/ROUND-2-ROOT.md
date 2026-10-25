# UE6 round 2: novelty search over the root's laws

**AI search, 25 October 2026 (Claude Opus, read-only plus web search). A bounded search, not established novelty.** "Not found" means not found in this search. Read: [01-ROOT](../../../../../../theories/becoming/chapters/01-ROOT.md) §§1–8, [02-MAP](../../../../../../theories/becoming/chapters/02-MAP.md) §1, [07](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md) §§4.5–4.6, the ten named records, and the Lean definitions in the `Grammar*` modules. Round 1 ([ASTRA-NOVELTY](ASTRA-NOVELTY.md)) covered the model-level candidates.

## The key identification

Constancy, `«有常» R E := E˘;R ⊆ R;E˘`, is pointwise `E u u' ∧ R u v → ∃v', R u' v' ∧ E v v'`. That is the simulation condition on an unlabelled transition system. For a symmetric `E` it is exactly bisimulation. The core `«核» R E` is the greatest bisimulation contained in `E`, so for a class `E` it is the coarsest stable refinement of the partition `E`. A position (begins, ends) is a predicate of the form "has an `E`-alike predecessor or successor". So the core's laws are bisimulation and partition refinement, and the continuation laws are order theory on `R ⊓ E`.

## Verdicts, grouped

**A. The calculus and its order**

1. *One-symbol calculus; reach without cycles is a strict order; a cycle is one co-present cluster; "every condition precedes its result iff acyclic."* **KNOWN.** The operations are Tarski's calculus of relations (Tarski 1941, *JSL* 6:73–89; Schmidt and Ströhlein, *Relations and Graphs*, 1993). Mutual reach is strong connectivity, and the condensation of any digraph is a DAG (Tarjan 1972, *SIAM J. Comput.* 1:146–160). Causal sets take acyclic reach as their order (Bombelli, Lee, Meyer and Sorkin 1987, *PRL* 59:521).

**B. Continuation and lines**

2. *Continuation is `R ⊓ E`: condition met with sameness.* **RESTATED.** The standard unity relation for persistence, causal connection plus similarity: Lewin's *Genidentität* (1922) and Reichenbach, *The Direction of Time* (1956) ([overview](https://en.wikipedia.org/wiki/Genidentity)); immanent causation plus qualitative continuity in Zimmerman (1997) and Sider, *Four-Dimensionalism* (2001). The closest is Whitehead, *Process and Reality* (1929) II.3: a society is a nexus whose members inherit a common "defining characteristic" from one another, and an enduring object is one in serial ("personal") order ([summary](https://www.bu.edu/wcp/Papers/PPer/PPerYong.htm)).
3. *Coarsening keeps continuations; a line stays in its class; the family is a class; any single condition is a continuation under some class; merge; fission breaks transitivity.* **KNOWN.** The fission point is Wiggins (1967), *Identity and Spatio-Temporal Continuity*, and Parfit (1971), *Phil. Review* 80:3–27.

**C. The four marks**

4. *Beginning, abiding, altering and ending are relative to a class; none stands alone; ending under a finer class but not a coarser one (fire passed on).* **RESTATED.** The four marks are the four *saṃskṛta-lakṣaṇa* (jāti, sthiti, anyathātva, anityatā), *Abhidharmakośabhāṣya* II.45. That they do not stand by themselves is the argument of Nāgārjuna, *MMK* ch. 7. Sortal-relative beginnings and endings are Geach's relative identity (1967) and Sider's multiple temporal-counterpart relations ("All the world's a stage", *AJP* 74, 1996). Fire passed on: 《庄子·养生主》; the *Milindapañha* lamp.
5. *A change between the ends has a marked step.* **KNOWN.** This is the discrete intermediate-value argument (induction on the line).

**D. Constancy and the core**

6. *Constancy never lets a continuation end; a class with an ending line is not constant.* **KNOWN.** It is Paige–Tarjan stability of a block with respect to itself: in a stable partition, either every member of a block has a successor in block B or none does (Paige and Tarjan 1987, *SIAM J. Comput.* 16:973–989, [record](https://www.cs.princeton.edu/research/techreps/TR-038-86)).
7. *The root theorem: the core exists, is the greatest, is a class and is monotone; `E` is constant iff `E ⊆ core`.* **KNOWN.** The greatest bisimulation is the union of all (Knaster–Tarski): Park (1981); Milner, *Communication and Concurrency* (1989); Rutten, "Universal coalgebra", *TCS* 249 (2000). The greatest bisimulation inside a given equivalence is the relational coarsest partition problem (Kanellakis and Smolka 1990, *Inf. Comput.* 86:43–68; Paige–Tarjan 1987).
8. *Closure: `E;R;E ⊆ R;E` iff constant.* **KNOWN.** This is the relational form of "the quotient by `E` is well defined", that is, a bisimulation equivalence (Schmidt–Ströhlein 1993; de Roever and Engelhardt, *Data Refinement*, 1998, simulation as relational inclusion). The probabilistic analogue is strong lumpability (Kemeny and Snell, *Finite Markov Chains*, 1960, §6.3).
9. *The two-way core; what it relates shares beginning, abiding and ending.* **KNOWN.** These are back-and-forth bisimulations (De Nicola, Montanari and Vaandrager, CONCUR'90, LNCS 458:152–165, [doi](https://doi.org/10.1007/BFb0039058)) and bisimulation for tense logic (Blackburn, de Rijke and Venema, *Modal Logic*, 2001, ch. 2).
10. *A kept regularity can always be kept; the last step of an ending line leaves the core; the two ends of such a line lie in different core classes.* **KNOWN.** These are corollaries of 6–7.
11. *Flame: in the finite acyclic flame no step lies in the core of "burning"; the core continues something iff some core line never ends.* **KNOWN.** In a well-founded graph, bisimilar nodes have equal rank and every edge lowers rank, so no edge joins two bisimilar nodes (Dovier, Piazza and Policriti, CAV 2001 and *TCS* 311, 2004, [description](https://bispy-bisimulation-in-python.readthedocs.io/en/stable/algorithms/dovier_piazza_policriti.html); Aczel, *Non-Well-Founded Sets*, 1988). Fire and fuel needing each other through the core is definitional given identity is constant. Its content is *MMK* ch. 10 (fire and fuel), and that is RESTATED.

**E. Renewal and grains**

12. *The coarse net `L;(R ⊓ ¬L);L`; renewal at every grain; 生生 as the greatest renewing family and 息 as its inductive dual; nothing under the one.* **KNOWN.** These are the quotient graph without self-loops and the ν/μ duality of Knaster–Tarski (Kozen 1983, modal μ-calculus).
13. *The map: 延 and 尽 exclude each other; 全生成, 全守 and 有终 exclude pairwise and cover with LEM; the mixed region; order-k generation keeps order k+1 from degenerating; each dichotomy is exactly excluded middle.* **KNOWN**: 延 is CTL's EG and 尽 is AF-deadlock; the strong forms are the Büchi, co-Büchi and finite cases of a path; the mixed region is branching-time trivia (Emerson and Halpern 1986, *JACM* 33); the higher-order law unfolds a definition; "well-founded or has an infinite path" for every model is classical. The two-grain reading is autopoiesis (Maturana and Varela 1980).

**F. Testing**

14. *Finite stages approximate the core from above; the converse fails under infinite branching; a wider net separates what a narrower one does not (thermostat versus balanced room).* **KNOWN.** The approximants are Hennessy and Milner (1985, *JACM* 32:137–161) and Milner (1989). Discrimination growing with the contexts admitted is testing equivalence (De Nicola and Hennessy 1984, *TCS* 34); interventions separating equivalent mechanisms are Woodward (2003) and Pearl (2009).

**G. The condition on the root and the class of being joined**

15. *Reached along the net implies within the family; both are preserved under coarsening; without cycles, every center reaching everything forces one center that nothing conditions.* **KNOWN.** This is the uniqueness of a least element under antisymmetry.
16. *Continuation is 缘 iff `E` contains the class of being joined; where `R` is serial that class is constant and every step lies in its core.* **KNOWN.** `R ⊆ E` iff the equivalence closure of `R` is in `E`, for an equivalence `E`. In a serial graph the weak-component partition is stable.

**H. The path laws (PF, PF2, OC1)**

17. *What a line must pass, its class must hold; through a shared condition the members affect, a line under the one reaches the other family, and through a common cause it does not.* **KNOWN.** The first is a cut argument. The second is the fork-versus-chain distinction: no directed path runs through a fork X←C→Y, and one does run through X→C→Y (Reichenbach 1956; Pearl 2009).
18. *Constant and holding a member's effects, so everything downstream is alike and on the line (`«常闭则后皆续»`, `«本类常闭则所及皆及»`).* **KNOWN.** In a stable partition, a block one of whose members has all its successors inside it is closed under successors: an invariant set, or a closed class of a strongly lumpable chain (Kemeny–Snell 1960, §6.3).
19. *Constancy up to the net's end; the same at a member's class; merging what lies outside keeps it, and the two-block split asks least; finer outside divisions can break it; what leaves a class follows its line.* **RESTATED.** Pieces:
    - "At the member's class" is Paige–Tarjan stability of one block with respect to the other blocks.
    - Merging and splitting the splitters is their inheritance of stability under union, which is also why their algorithm splits by both B and S−B.
    - Exempting simulators that have no successor is an obvious weakening of one-step simulation, parallel to partial against total correctness. I did not locate a named prior notion with exactly this exemption; operational-semantics notes treat termination predicates as an enrichment of (bi)simulation ([arXiv:2510.12295](https://arxiv.org/pdf/2510.12295)). The laws stated with it are one-step unfoldings.
20. *The path's conclusion (P1–P4): concern for one's own continuation reaches everything downstream of what one conditions, past one's end, with no step of invariance.* **RESTATED** as content. The formal law is 18. Prior: Śāntideva, *Bodhicaryāvatāra* 8.97–103 ([8.101](https://bodhicitta.tsadra.org/index.php/Texts/Bodhicary%C4%81vat%C4%81ra/Verses/8.101)), the future self a continuum like any other; Johnston, *Surviving Death* (2010), the good "live on in the onward rush of humankind" ([publisher](https://press.princeton.edu/node/62000)); Scheffler, *Death and the Afterlife* (2013); 程颢「仁者以天地万物为一体」 and 张载《西铭》.

**I. Corpus candidates and need with time**

21. *Correlatives are had together; "everything ends under identity iff nothing is its own condition"; a mark's complement returns only with double negation.* **KNOWN** as logic: domain and range are non-empty together, and irreflexivity and DNE are standard. RESTATED as content from *MMK* ch. 8 (agent and action) and Sautrāntika momentariness.
22. *Need read with time: a feeding closure up to a step holds only what gives by then; read across every step it overreaches.* This is a model-level law. **KNOWN**: reachability along time-respecting paths is smaller than static reachability and not transitive (Kempe, Kleinberg and Kumar 2002, *JCSS* 64:820–842; Holme and Saramäki 2012, *Phys. Rep.* 519:97–125). The `Overlapping` witness is the textbook example.

**Counts:** 22 laws or groups; **KNOWN 18, RESTATED 4 (items 2, 4, 19, 20), NOT FOUND 0.**

## Is there a survivor?

**No.** No root-level law, and no short consequence of two of them that I could find, both escapes a neighbouring field and would surprise its specialist. The reason is structural:

- Every root theorem holds for every carrier, relation and class, so it forbids no observation; its novelty could only be mathematical.
- Mathematically, the core laws are bisimulation and partition refinement, the map laws are branching-time temporal logic with constructive calibrations, and the path laws are block stability.
- A concurrency theorist given the identification above would foresee each one.

The two closest candidates fail as follows:

1. **"In every finite history, no class's core carries a single step; so the only self-sustaining regularities a finite unfolding has are 'up to the net's end'"** (items 11 and 19 combined). This is the rank theorem for well-founded graphs plus a definition. Proved, and not new.
2. **"The organism's class fails constancy up to the net's end wherever its last stage conditions anything, while a lineage or shared-condition class meets it; so a self defined as a regularity of its own reaches past its end"** (items 19 and 20 with `«亡而网续则本类不至终有常»`). The formal part is a one-step unfolding. What is distinctive is the premise P2, a *choice of criterion* for which class a self runs under, and the conclusion is Śāntideva's and Johnston's. Picking the self's sortal by a stability criterion is a new *argument form*, refutable only by arguing against P2 and P4; it is a philosophical proposal, not a law.

One thing was **not found**, and it is a correspondence, not a law. I did not find the persistence literature (Wiggins, Sider, Parfit, genidentity) identifying "persisting as the same F" with "lying in the greatest bisimulation inside F", or the four *lakṣaṇa* with positions under a class's two-way core. The nearest are analogies: bisimulation as an identity criterion for computational artefacts (Angius and Primiero, *J. Logic Comput.* 28, 2018) and for AI personality clones ([arXiv:2608.11225](https://arxiv.org/pdf/2608.11225), explicitly only an analogy). This bridge may be the root's real contribution: one calculus in which the Abhidharma marks, sortal-relative persistence and bisimulation are the same objects. But it forbids nothing either side did not, so by UE's criterion ("farther = forbids more") it does not reach beyond the sciences together. The verdict would change only with a root law some actual system could violate; none has one, the grammar quantifying over every model.
