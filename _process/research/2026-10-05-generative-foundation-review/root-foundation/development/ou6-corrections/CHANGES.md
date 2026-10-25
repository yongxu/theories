# OU6: what changed in the grammar

Board item OU6, 24 October 2026: the corrections the [review of the grammar against its sources](../one-unfolding-root/reviews/2026-10-23-sources-against-v10.md) §5 asked for. Every declaration below has an empty axiom report; the three modules and their sixteen dependents build clean. Lean: `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`.

## `Becoming.Grammar` (70 theorems in 118 declarations; 64 theorems in 106 declarations before)

| Before | After | What it states |
|---|---|---|
| `«位同则四相同»` | `«位同则生亡同»` | for a class, what its two-way core relates shares beginning and shares ending (the statement is unchanged, only the name and docstring) |
| — | `«位同则住同»` | for a class, what its two-way core relates shares abiding too; altering is a relation between two occurrences with a finer class, not a mark of one occurrence |
| `«亡于细者不必亡于粗»` (docstring) | same name | an occurrence can end under the finer class and not end under the coarser (the docstring said "abides", which the theorem does not show) |
| `«息»`: nothing on the line from `x` renews (a negation) | `«息»`, inductive: `x` ceases where everything `x` renews into ceases | ceasing, positively: the least property so closed, dual to `«生生»`, the greatest family each member of which renews into a member (that every chain of renewals from a ceasing occurrence is finite is not stated) |
| — | `«复生至» R E x w` | renewing into: `x` conditions a beginning whose line reaches `w` |
| `«生生不息»` | same name, new proof | renewal without end does not cease, by induction: the two exclude each other by construction |
| — | `«自不复生则息»` | what does not itself renew ceases: ceasing concerns what an occurrence renews into, not its line |
| — | `«不复生则息»` | where nothing on the line from `x` renews, `x` ceases (the old reading implies the new) |
| `«一之下皆息»` | same name | under the one everything ceases |
| `«火因于薪»`: `«因于核» step alike sameFuel` | `«火薪相须»`: `«相须核» step alike sameFuel` | in the four-moment flame, "flame or not" and "the same fuel left" each suffice for the other's regularity and neither is constant: they need each other through the core, both ways |
| — | `«火之见证不择类»` | every class that, with "flame or not", tells the four moments apart suffices for the flame's regularity: the witness picks no class |
| — | `TwoFlames` (`Bool × Flame`) with `step`, `alike`, `sameFuel`, `sameFlame` | two flames side by side, each through the four moments |
| — | `«两火以薪定理»` | in two flames, "the same fuel left" suffices for the regularity of "flame or not", while the joint class relates two distinct occurrences (one of each flame at one moment) |
| — | `«两火同火不足以定理»` | "the same flame" does not suffice: it relates a flame's first two moments, whose futures differ |

## `Becoming.GrammarReadings` (12 theorems in 17 declarations)

| Before | After | What it states |
|---|---|---|
| `«通»` := `«不穷» R E x` | `«通»` := `«不穷» R E x ∧ «不穷» («逆» R) E x` | 通, from 「往來不窮謂之通」 (XCS-11-010) with 往來 read as a relation and its converse (the classification's reading of the unit): going along 缘 never ends and coming along its converse never ends |
| `«有常则通»` | `«有常则往不穷»` | under a constant class, a line with a past never ends going (the old content, now named for what it shows) |
| — | `«两向有常则通»` | for a class constant under 缘 and under its converse, an occurrence that abides passes through |
| — | `«有常而不通»` | counting up from zero under the one: constant, one has a predecessor and its line never ends going, yet it is not 通 (coming back ends at zero): constancy one way is not enough |
| — | `«昼夜往来不穷»` | day and night (two occurrences, each the condition of the other) go and come without end: every occurrence is 通 |
| `«同于为类»` (module header) | same | 同 is a class where each thing belongs to one and to one only: sufficiency, not "exactly where" |

## `Becoming.GrammarMap` (39 theorems in 58 declarations)

| Before | After | What it states |
|---|---|---|
| `«全生有终之定当且仅当排中»` | `«不穷有终之定当且仅当排中»` | that from every point of every model the coarse line never ends or reaches an end is exactly excluded middle (statement unchanged; the old name spoke of generation) |
| — | `«全三域之定当且仅当排中»` | placing every point of every model in one of the three strong regions (全生成, 全守, 有终) is exactly excluded middle; the converse direction is `«全三域之周»` |
| `«阶全生成»` (docstring) | same | a sequence of classes, no order between them assumed (the docstring said "each finer than the next") |
| header | — | the coarse net `«粗»` is not used in the module (the header said it was); the strong forms cover every point with excluded middle as a hypothesis (the header said "where going on and renewal are decided") |
| `«全生成»`, `«全守»`, `«有终»` and the theorems on them (docstrings) | same names | 全生成 and 全守 are generation and keeping in the strong form, and 有终 is reaching an end, not degeneration (`«退化»`, ending on every branch): the docstrings had called 有终 degeneration, against chapter 02 |
| — | `«生生即延»`, `«息即尽»` | read along renewing into under the one, renewal without end is going on along some branch, and ceasing is ending on every branch |

## Not changed

The order 穷 → 变 → 通 is not proved: with 通 as going and coming, constancy one way no longer gives 通, but where the order holds is still open. The flame witnesses decide a description against a named alternative (fuel against sameness of flame), not in general; that every flame continues only through its fuel is not proved. That what does not renew without end ceases is not proved. The witness `Map.Short.degeneration` keeps its name, though it states only an end (有终); that the same point degenerates is `Map.Short.ends`, and its docstring says so.
