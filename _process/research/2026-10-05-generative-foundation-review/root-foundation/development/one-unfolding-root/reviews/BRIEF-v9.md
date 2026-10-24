# Brief: adversarial review of plan version 9 (read-only)

You are reviewing a research plan, not writing code. **Do not edit, create, commit or delete any file in the repository.** A formal reviewer may write scratch Lean files only under the scratch directory named in its own instructions, and compile them with `lean <file>` (Lean 4; for the repository's version run `elan run leanprover/lean4:v4.29.1 lean <file>`), checking `#print axioms`.

## The plan

`/Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/one-unfolding-root/PLAN.md` (Chinese, version 9). Read all of it. Version 8 is at `history/PLAN-v8.md` beside it; the earlier reviews (of version 6) are in `reviews/`.

It proposes to re-found a formal theory of becoming (the Lean 4 package "Becoming", whose core uses only Lean's prelude and has empty axiom reports) on a strictly monist, relational base: classical Chinese grammar read as a point-free relational calculus that holds in every frame, frames being its models. Version 9 moves the root's centre to **续 (continuity)**: arising, persisting, changing and passing away (生、住/存、异/变、亡) are four positions of one continuation; what continues conditions further becoming (续而复生), a recursion giving higher orders. The relation's main reading is **缘** (one occurrence is a condition of another); time and whole states are derived from it. 续 is defined as `合 R E` (linked by 缘 and alike under a distinction E); whether a continuation "has its own 理" is decided by E being 有常 (E˘;R ⊆ R;E˘). The two source texts that prompted version 9 are at `/Users/ren/theories/sources/15-codex-theory-conversations/2026-10-23-continuity-as-root/` (written by another AI).

## Why this review exists

Every earlier version fell back into dualism without noticing (two kinds of relata; eight separately given fields; layers; a product of independent dimensions; an asymmetric "law-setting vs governed" reading; a frame chosen before the texts). The owner wants the plan to be **completely monist** and not empty. A pair is acceptable only if it is defined as one relation read from its two ends; a hierarchy only as a description, never as layers of reality; each analytic distinction must state its relational basis.

## What to check

1. **续 and its four corrections (§4.3).** Is `续 R E := R ⊓ E` the right definition? Does "续 must be contained in 缘" plus "the criterion is a distinction E" really block arbitrary splicing, or can a contrived E still manufacture continuations within one 缘 net? Is the stated correction right (consecutive moments of a pattern that ends are generally not in one `核 R E` class, so 续 is not defined through 核)? Are the sketched theorems true as stated: coarsening; 一's continuation is the whole 缘 net; fission makes "sameness" non-transitive; "every occurrence either begins or has a predecessor, for every model" is equivalent to excluded middle; for an equivalence E, `有常 R E` iff `E;R;E ⊆ R;E`?
2. **缘 as the main reading (§4.1, §六).** Does taking occurrences (事) as the carrier smuggle an atomism (a pluralism of ultimate events, like Abhidharma dharmas)? Is "time = transitive closure of 缘" sound, including when 缘 has cycles? Are whole states really derivable as cuts?
3. **Recursion (§4.6) and the map (§七).** Is the coarse net `L;R;L` and "续之续" well defined? Is 复生 vs 息 a genuine single-net reading, non-overlapping as claimed? Does the meta-attractor stay symmetric and relational?
4. **Three minima (§三).** Is the mapping (立言 ↔ definitions, laws of all systems ↔ grammar theorems, 穷理 ↔ conditional laws, 验 ↔ bisimilarity under a wider relation, 成文 ↔ operations measured by total description length) sound? Is "验 = non-bisimilarity under a wider relation" correct and monist?
5. **Classical readings (§一, §5.2–5.4).** Check every quotation against the repository texts listed in §5.3 and the readings given: 《大乘起信论》 四相, 《金师子章》 六相, 《中论》 (观因缘品, 观去来品, 观三相品, 观成坏品), 《庄子·养生主》 火传, 《荀子·正名》 化 and 一实, 《墨经》 definitions. Are the 相分 registrations of the Buddhist texts right and complete (理事, 一心/本觉/真如, 二谛, 刹那)? Does the plan read these texts into its own structure?
6. **Words**: any term in the Chinese or English that carries a split (事 as atom, 缘 as cause/effect, 条件/构形, 判据 as an observer's choice, reader/read, self/other, agent).
7. **Overclaims**: novelty, proofs, what prior work shows, what classical texts say.

## Output

Reply in English (quote the Chinese exactly). Under 1,500 words.

1. **Verdict**: is version 9 fully monist and formally sound? One paragraph.
2. **Findings**, most serious first. For each: location (section and an exact quote), what is wrong, why, and a concrete fix. Mark each as *dualism*, *hidden layer*, *formal error*, *textual error* or *overclaim*.
3. **What is already sound** (brief).
