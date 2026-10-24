# Brief: adversarial monism review of a research plan (read-only)

You are reviewing a research plan, not writing code. **Do not edit, create, commit or delete any file. Read only.**

## The plan

`/Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/one-unfolding-root/PLAN.md` (Chinese, version 6). Read all of it.

It proposes to re-found a formal theory of becoming (a Lean 4 package, "Becoming", whose core uses only Lean's prelude and has empty axiom reports) on a strictly monist, relational base, and to take classical Chinese (《系辞》, 《老子》) as an already existing generative grammar to be reconstructed and tested, rather than building a new symbol system in a dualist modern language and putting Chinese labels on it.

## Why this review exists

Every earlier version of this work fell back into dualism without noticing: the old base `World` posits relata of two roles (formations `F` and conditions `C`) with eight separately given fields (level, active, requires, need, draws; present, take, give); a Chinese edition translated that structure into classical diction ("一类之物 … 步间相与取与"); later drafts reintroduced layers ("第一层…第七层"), a product of independent dimensions, and an asymmetric "law-setting reading vs governed reading" for meta-attractors. The owner wants the plan to be **completely monist**. Your job is to find every place where it still is not.

## What counts as dualism here (the project's own rule)

The primary ontology is one relational unfolding: first how relations form, persist and change, then how actor, patient, knowing, evaluation, capacity and responsibility differentiate within it. Each analytic distinction (subject/object, action/condition, fact/value, part/whole, inside/outside, state/parameter, law/history, reader/read) must state its relational basis; no name or formal variable may smuggle in an independent ontology. A pair is acceptable only if it is defined as **one relation read from its two ends**. A hierarchy of levels is acceptable only as a description, never as layers of reality.

## What to check

1. **The base (§四).** Does `Unfolding` (a type of ways `Way` and one relation `becomes`) smuggle a split (state vs transition, being vs becoming, configuration vs move)? Are the three disclosed commitments (discrete, modal, definite/non-contextual) the only ones, or is something hidden? Is "reading = equivalence relation / kernel of a function" a reader/read split?
2. **Every definition and Lean sketch** (`Carries`, `Within`, `theorem one`, `Step`, `Stage`, 相因, 被驱, 深, 势, 几, 化, 元吸引). Any primitive that presupposes separate entities, any asymmetric pair not defined as one relation's two ends, any hidden level. Also check the sketches are mathematically sound as stated (e.g. is `Within E` really the largest symmetric carrying relation inside E; does "a stage that stabilizes is the closure" hold without extra assumptions; does `Carries` plus symmetry give a bisimulation).
3. **The map (§五)**: does it still build from pre-separated dimensions? Does 元吸引 as 相因之势 remain symmetric throughout? Are generation/degeneration (开/闭) treated as one change read two ways?
4. **The classical direction (§二, §4.6)**: does the plan really go from the texts to the formal root, or does it still impose its own structure and pick quotations to fit? Are any readings of the texts dualist (乾坤, 阴阳, 刚柔, 天尊地卑, 形而上/形而下, 体用)? Are polysemies handled honestly?
5. **Words** in the Chinese and English text that carry a split: 物 used as a primitive, 取/与, 者/他者, 内/外, 主/客, 能/所, self/other, agent, actor, owner, giver/taker, observer, selector, controller, parameter vs state, structure vs dynamics.
6. **Overclaims**: any place the plan claims more than it can (novelty, proofs, what prior work shows, what classical texts say).

## Output

Reply in English (quote the Chinese exactly). Under 1,500 words.

1. **Verdict**: is the plan fully monist? One paragraph.
2. **Findings**, most serious first. For each: location (section and an exact quote), what split or hidden layer or error it carries, why, and a concrete fix (replacement wording or definition). Mark each as *dualism*, *hidden layer*, *formal error*, *textual error* or *overclaim*.
3. **What is already sound** (brief), so it is not changed by mistake.
