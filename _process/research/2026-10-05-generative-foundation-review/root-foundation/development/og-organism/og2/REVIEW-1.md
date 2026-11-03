# OG2: independent review of the first design (AI-written, 2 November 2026)

One Opus agent read og2/DESIGN.md as first drafted, ran sim/sim.py and its own reimplementations, and searched for prior art in a limited way. Its scripts are in review1-scripts/. Kept as it came back; the second design takes it up.

# OG2 design review

No law is false at its central parameters, and L1 holds as written. §4.2's central claim fails, L3 isn't about institutions, and most laws are close to definitional.

## Findings by severity

**1. High: §4.2's door claim is built in, and the contrast with OG is wrong.**
- The door is a net parameter that no holder keeps. If it is kept only while a holder stands, hollow states are reachable at every ruled door: 60 of 60 ruled cases (s 1–4, l 0–4, q 0–2).
- The ruled half is `others = []` by definition, not a stock drained along a course.
- OG already ends with stock left. In my port, `.supply` at s=2, n=1, m=2, L₀=2 reaches level 1 with no reader. `«读者绝则无储»` covers only `.level`.
- No clause reads `others`. In the core of `samePresence`, hollow and empty are one block (4 parameter pairs).
- The cut route passes through `(q,[],[])`, so nobody is there. At l=0, q≥1, with no revision, that is the only route (s 1–5).
- Change: delete the bold sentence, since the revision route is the members' own act. Write: "Both ends empty the rebuild's source; what remains is what that rebuild doesn't read; the door, given from outside, decides whether non-holders exist."
- Add the more natural route (§8 Q3): with no cut and no revision, hollow is reached exactly where l≥s or q=0.

**2. High: `learning` is not learning.**
- Entrants hold at age 0, so l is a teaching age, and §4.1's "takes longer to learn" is false of the model.
- With a pupillage d, the rule is held at every step exactly where l+d&lt;s (0 mismatches, s≤8, l≤8, d≤7). If l=d, that is 2d&lt;s. Counterexample to L3's window: s=2, l=1, d=1.
- If pupils graduate with no teacher present, L4 fails: at s=3, l=2, d=1 a holder returns after a holderless state.
- Change: rename it `teachingAge`, add `d`, and state l+d&lt;s.

**3. High: this models any tradition, or any lineage.**
- Rename teacher to parent and quota to fecundity. A per-capita version has the same window as R₀=(s−l)q≥1.
- The quota is one bit: q=1 and q=3 gave 0 differences in (bit, age set, others).
- The rule regulates only its own entry, and no conduct.
- Change: give each holder its own value, inherited by entrants. This has three effects:
  - It removes a quota nobody holds at `holders=[]`, which AGENTS' no-smuggled-entities rule bars.
  - A lone revision to zero is purged: `((1,q0),(2,q1))` at s=3, l=1 recovers.
  - The number now matters: q2 outgrows q1 128:19 by step 8 (s=4, l=1).
- Also consider entrant kinds with different teaching ages, chosen by the rule (untested).
- One-page line: "a minimal model of a rule passing through members; no conduct modelled".

**4. Medium: how close each law is to definitional.**

| Law | Status |
|---|---|
| L1 | One arithmetic fact (g+1≥s ⇒ g≥l); depends on step order |
| L2 | Definitional |
| L3 | Says [l,s) is non-empty, plus L1. At l=s−1 (s≥2) teacher and pupil share no state, so overlap is not what it proves |
| L4 | Clause unfolded; same form as 04's `Web.ByPassing.empty_stays` (L1+L2 neighbour `passes_within`). Cite both; instance unproved |
| L5 | Ruled half definitional; open half about a list nothing reads |
| L6 | Leaving `Kept` is definitional; only the timing has content |
| L7 | A three-row table. `.given` and `.none` match OG's `.supply` and `.none` (q=1, large count; age lists identical on all 7-step courses). One row is new |
| L8 | See finding 7 |

**5. Medium: variants.**

| Variant | Result |
|---|---|
| Teach after ageing | L1 fails: `(1,[s−1])` goes empty. Window gains s≥2. Others survive |
| Strictly senior | Window max(l,1)&lt;s; fails only at s=1, l=0 |
| Others learn once a teacher exists | All survive |
| Others learn by watching at age l | q=0 persists on an open door; L3's quota half fails, and L6 with it; revision route fails 20/20 |
| Untaught at quota | L5's first bullet fails at q=0; revision route fails 20/20; L3 and L4 survive |
| Holders disagree | L1 survives if every teacher teaches. With one teacher a step it fails: s=1, l=0, `[(0,q0),(0,q1)]`. L6 needs unanimity |
| Mixed tenures | l=5, tenures [10,1,1,1], mean 3.25: persists. The window reads the longest stay, not the typical one (not in your list) |

**6. Medium: corrected statements.**
- L2: add 1≤tenure, because `older⁰ [0] = [0]`.
- L3: add "revisions keep 1≤quota". At s=3, l=1, a revision to 0 ends it at step 3; q=0 revised to 1 is held.
- L3: "gone by tenure" holds only from founders (s=3, l=3, `[3]` goes at step 4). Delete "from every level of entrants".
- L5: restrict to `.members`. `.given` with q≥1 returns, and hollow is unreachable there, so the family law fails.
- L5: the cut must be max(tenure,1) steps. At s=0, l=0, q=1 the stated route leaves a holder.
- L6: "by tenure" counts from the post-revision state, and is tenure+1 from before it (s=1, l=0, q=1). Revising back on the last exit is too late: `(0,[2])` goes to `(1,[],[])`. A holder too young to teach can revise, so state whether that is meant.
- §3: "each was run" overclaims. `sim.py` never runs L2, L6 or L8, and its hollow search has no revision.

**7. Medium: L8 should not stand as a law.**
- It is 01 §2 (`«任一缘可为续»`) and §9.8 renamed. The design's §4 citation is wrong.
- `.given` is unnecessary: under `.members`, `(1,[2]) → (1,[])` already continues under `sameQuota` and not `samePresence`.
- "No line" contradicts the law, since a line exists under `sameQuota`. `samePresence` also has an endless line among no-holder states.
- Change: use one sentence, or replace it with the core of `samePresence`, which ignores `others`. That says something, once proved.

**8. Low: module.** Keep its own leaf. Extending needs a new `Source` constructor, which reopens case splits in landed proofs. Its rebuild also adds one unit below a count, not `quota`. Rename `.given` (it means "does not age" in OG) to `.outside`, and state the dictionary to OG as a theorem. `Rule` beside "the rule" also misleads.

**9. Medium: overclaims.**
- "Entrenchment clause's exact content": L1's hypothesis restricts courses from outside, and no clause exists. Write "L1's hypothesis excludes".
- Hart, "ruled by the rule itself": false of the door. Cut it.
- "Hollow institution" usually includes holders who don't comply, which this can't express. "Holder" merges recognition, compliance and implementation, against AGENTS. Rename the state "members with no holder" and add the merge to §5.
- §4.1 "forbids an institution": add the hypotheses (one tenure, whole rule, no records).
- §7's "05's section on institutions" doesn't exist in 05's headings. Name a section.

## Prior art

I found no statement of the window law in cultural transmission or organizational memory. The search was limited, so this doesn't show there is none.

Closest:
- **Leslie-model R₀** ([source](https://aimspress.com/aimspress-data/mbe/2025/6/PDF/mbe-22-06-047.pdf)): the same threshold by my derivation, and the nearest statement. Cite it.
- **Enquist et al. 2010** ([source](https://lalandlab.wp.st-andrews.ac.uk/files/2015/08/Enquistetal2010.pdf)): threshold on fidelity times number of cultural parents, with no time in it.
- **Harrison and Carroll** ([source](https://www.gsb.stanford.edu/faculty-research/books/culture-demography-organization)): hiring, socialization and turnover, by simulation.
- **Overlapping-generation trait extinction** ([source](https://pubmed.ncbi.nlm.nih.gov/33482220/)): search summary only; the page wouldn't load.
- **Crémer 1986** ([source](https://ideas.repec.org/a/oup/qjecon/v101y1986i1p33-49..html)): finite-lived agents in a long-lived organization (abstract only).
- **Acemoglu, Egorov and Sonin 2012** ([source](https://nber.org/papers/w14239)): current members setting who joins.

The searches did not confirm Jacobs and Campbell 1961, or the article title I recalled for Harrison and Carroll.

## What I verified and how

- I ran `sim.py` (0 counterexamples) and re-implemented the rule, testing L1, L3, L4 and L5 under the variants by exhaustive small-parameter runs and bounded reachability.
- Most sweeps covered s≤7 and l≤9; L4, L5 and the family law covered s≤4, l≤4. Tenure 0 was hand-run only.
- The OG comparison is a Python port, not Lean. The core used partition refinement on an age-set abstraction, q∈{0,1}, at (s,l) = (3,1), (4,2), (3,0), (2,1).
- No Lean was written or run, so nothing here is proved. I read 01 and 04 only at the cited passages, and 05 by headings and grep.
- Nothing in the repository changed. The scripts are in `/private/tmp/claude-501/-Users-ren-theories/568486ee-fafd-4bf5-b667-a3da885f62a8/scratchpad/og2-review/`: `base.py`, `edges.py`, `variants.py`, `delay.py`, `disagree.py`, `hetero.py`, `more.py`.
