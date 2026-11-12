Kept as written; local paths in it point to the session's scratch folder.

AI-written map, 12 November 2026

# GrammarLaws.lean: the root's shared laws, mapped for the turning-in-time design

File: `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarLaws.lean` (2823 lines; imports `Becoming.Grammar`, `Becoming.GrammarMap`, `Becoming.Prelude`). Read only, by plain reading; nothing was built or run.

How to read the statements below. Every block is copied from the file (signature up to `:=`; for definitions whose body sits on the next lines the body is copied too). Section variables are implicit and do not show in the copied text: in `section Census` from line 1936 on, `{R E : «际» α} {k : α → α → Bool}`; in `section Stages` (2171-2466), in addition `{τ : α → Nat} {P : α → Prop}`. The root notions used but defined elsewhere: `«续» R E := «合» R E` (R and E both, Grammar.lean 126), `«有后» R E x := ∃ y, «续» R E x y` (135), `«有前»` (132), `«生» := ¬ «有前»` (138), `«亡» := ¬ «有后»` (141), `«不穷» R E x := ∀ y, (x = y ∨ «相续» R E x y) → «有后» R E y` (243), `«有常» R E := «则» («而» («逆» E) R) («而» R («逆» E))` (340, pointwise `«有常之逐点»` 343: `∀ u u', E u u' → ∀ v, R u v → ∃ v', R u' v' ∧ E v v'`), `«核» R E` (375: some symmetric constant S ⊆ E relates them), `«根»` (380), `«类»` (structure, 84), `«及»` (inductive transitive closure, 78), `«尽»` (GrammarMap.lean 229). Those files are not mine; only the statements quoted here were looked at.

Every declaration in this file is a theorem or a definition; there are no hypotheses (axioms) declared. Hypotheses below are always explicit arguments of a theorem. The file header (line 221) says every declaration has an empty axiom report; I did not check that (it needs a build).

## Inventory

All 246 declarations were listed; 164 that bear on (a)-(d) or on the questions are given below with their exact statements. Left out: the list helpers of `namespace GrammarLaws` (380-566), balance and counting (568-1054) other than the two class-count laws, and census helpers that only handle lists (`census_pairs`, `census_le`, `census_le_converse`, `census_count`, `length_keep`, `count_add_not`, `distinct_keep`, `count_pos_of_mem`, `eq_true_of_not_false`, `found_cons`, `found`, `found_unrefuted`, `found_or_all`, `pair_eq`, `stage_search`, and the three census-counted global forms 2085, 2111, 2152). They sit at the lines the declaration list gives (`grep -n '^theorem\|^def' GrammarLaws.lean`).

### Closure (闭), lines 228-368

- `«闭»` (def, line 235). Definition. P is closed under R: every member bears R only to members.

```lean
def «闭» (R : «际» α) (P : α → Prop) : Prop := ∀ x y, P x → R x y → P y
```

- `«所闭»` (def, line 238). Definition. y lies within x's closure: every R-closed region holding x holds y (reflexive-transitive closure, impredicatively).

```lean
def «所闭» (R : «际» α) : «际» α := fun x y => ∀ P : α → Prop, «闭» R P → P x → P y
```

- `«所闭之自反»` (theorem, line 241). Theorem. x lies within its own closure (no premise).

```lean
theorem «所闭之自反» (R : «际» α) (x : α) : «所闭» R x x
```

- `«所闭之传递»` (theorem, line 244). Theorem. Closure is transitive.

```lean
theorem «所闭之传递» {R : «际» α} {x y z : α} (h₁ : «所闭» R x y) (h₂ : «所闭» R y z) :
    «所闭» R x z
```

- `«缘在所闭»` (theorem, line 249). Theorem. One R step lies within the closure.

```lean
theorem «缘在所闭» {R : «际» α} {x y : α} (h : R x y) : «所闭» R x y
```

- `«所闭之闭»` (theorem, line 253). Theorem. x's closure is an R-closed region.

```lean
theorem «所闭之闭» (R : «际» α) (x : α) : «闭» R («所闭» R x)
```

- `«所闭之单调»` (theorem, line 257). Theorem. If R ⊆ S then closure under R ⊆ closure under S.

```lean
theorem «所闭之单调» {R S : «际» α} (h : «则» R S) : «则» («所闭» R) («所闭» S)
```

- `«所闭之对称»` (theorem, line 261). Theorem. If R is symmetric, its closure is symmetric.

```lean
theorem «所闭之对称» {R : «际» α} (h : «则» R («逆» R)) : «则» («所闭» R) («逆» («所闭» R))
```

- `«所闭之逆»` (theorem, line 267). Theorem. Closure under the converse of R from x to y is closure under R from y to x.

```lean
theorem «所闭之逆» {R : «际» α} {x y : α} : «所闭» («逆» R) x y ↔ «所闭» R y x
```

- `«所闭之界»` (theorem, line 276). Theorem. If y is within x's closure and z is not, then R y z fails.

```lean
theorem «所闭之界» {R : «际» α} {x y z : α} (within : «所闭» R x y) (beyond : ¬ «所闭» R x z) :
    ¬ R y z
```

- `«不出»` (def, line 282). Definition. Nothing in P goes out of P along R: no member bears R to a non-member.

```lean
def «不出» (R : «际» α) (P : α → Prop) : Prop := ∀ x y, P x → ¬ P y → ¬ R x y
```

- `«闭则不出»` (theorem, line 285). Theorem. A closed region is not gone out of.

```lean
theorem «闭则不出» {R : «际» α} {P : α → Prop} (closed : «闭» R P) : «不出» R P
```

- `«所闭不出»` (theorem, line 290). Theorem. x's closure is not gone out of.

```lean
theorem «所闭不出» (R : «际» α) (x : α) : «不出» R («所闭» R x)
```

- `«闭含所闭»` (theorem, line 294). Theorem. A closed region holding x holds everything within x's closure.

```lean
theorem «闭含所闭» {R : «际» α} {P : α → Prop} (closed : «闭» R P) {x y : α} (holds : P x)
    (within : «所闭» R x y) : P y
```

- `«所闭之证»` (theorem, line 300). Theorem. P is exactly x's closure iff P holds x, is closed, and lies within x's closure.

```lean
theorem «所闭之证» {R : «际» α} {P : α → Prop} {x : α} :
    (∀ y, P y ↔ «所闭» R x y) ↔ P x ∧ «闭» R P ∧ ∀ y, P y → «所闭» R x y
```

- `«闭而外则不所闭»` (theorem, line 308). Theorem. If a closed region holds x and not y, y is not within x's closure.

```lean
theorem «闭而外则不所闭» {R : «际» α} {P : α → Prop} {x y : α} (closed : «闭» R P) (holds : P x)
    (outside : ¬ P y) : ¬ «所闭» R x y
```

- `«闭之及»` (theorem, line 313). Theorem. A closed region holding x holds whatever x reaches (及, transitive closure).

```lean
theorem «闭之及» {R : «际» α} {P : α → Prop} (closed : «闭» R P) {x y : α} (holds : P x)
    (reach : «及» R x y) : P y
```

- `«及之所闭»` (theorem, line 320). Theorem. Reaching implies lying within the closure.

```lean
theorem «及之所闭» {R : «际» α} : «则» («及» R) («所闭» R)
```

- `«所闭当且仅当同一或及»` (theorem, line 325). Theorem. Within x's closure is exactly: equal to x, or reached from x.

```lean
theorem «所闭当且仅当同一或及» {R : «际» α} {x y : α} : «所闭» R x y ↔ x = y ∨ «及» R x y
```

- `«及当且仅当一步而所闭»` (theorem, line 336). Theorem. Reaching z is one step to some y and then y's closure holds z.

```lean
theorem «及当且仅当一步而所闭» {R : «际» α} {x z : α} : «及» R x z ↔ ∃ y, R x y ∧ «所闭» R y z
```

- `«借步之所闭在二所闭»` (theorem, line 347). Theorem. If every R' step is an R step or an R step from a taken at o, then o's R'-closure lies within o's or a's R-closure.

```lean
theorem «借步之所闭在二所闭» {R R' : «际» α} {o a g : α}
    (split : ∀ x y, R' x y → R x y ∨ (x = o ∧ R a y)) (within : «所闭» R' o g) :
    «所闭» R o g ∨ «所闭» R a g
```

- `«二所闭在借步之所闭»` (theorem, line 362). Theorem. Converse: with R ⊆ R' and a within o's R'-closure, o's or a's R-closure lies within o's R'-closure.

```lean
theorem «二所闭在借步之所闭» {R R' : «际» α} {o a g : α} (larger : «则» R R')
    (reaches : «所闭» R' o a) (within : «所闭» R o g ∨ «所闭» R a g) : «所闭» R' o g
```


### Finite runs (入): 定后, 历, 迭, 承, 定后于, lines from a list, 入, lines held by a list, rest (止), lines 1056-1833

- `«定后»` (def, line 1063). Definition. Fixed successor (functional): R˘;R ⊆ 静 (identity).

```lean
def «定后» (R : «际» α) : Prop := «则» («而» («逆» R) R) «静»
```

- `«定前»` (def, line 1066). Definition. Fixed predecessor (injective, merges nothing): R;R˘ ⊆ 静.

```lean
def «定前» (R : «际» α) : Prop := «则» («而» R («逆» R)) «静»
```

- `«定后之逐点»` (theorem, line 1068). Theorem. Pointwise form of 定后: two successors of one x are equal.

```lean
theorem «定后之逐点» {R : «际» α} : «定后» R ↔ ∀ x y z, R x y → R x z → y = z
```

- `«定前之逐点»` (theorem, line 1071). Theorem. Pointwise form of 定前: two predecessors of one z are equal.

```lean
theorem «定前之逐点» {R : «际» α} : «定前» R ↔ ∀ x y z, R x z → R y z → x = y
```

- `«定前即逆之定后»` (theorem, line 1075). Theorem. 定前 R iff 定后 of the converse.

```lean
theorem «定前即逆之定后» {R : «际» α} : «定前» R ↔ «定后» («逆» R)
```

- `«历»` (def, line 1082). Definition. Passing through a word of relations: [] is identity, a :: as is F a then 历 F as.

```lean
def «历» {A : Type v} (F : A → «际» α) : List A → «际» α
  | [] => «静»
  | a :: as => «而» (F a) («历» F as)
```

- `«历之接»` (theorem, line 1087). Theorem. Passing through as ++ bs is passing through as then bs.

```lean
theorem «历之接» {A : Type v} (F : A → «际» α) : ∀ (as bs : List A) {x z : α},
    «历» F (as ++ bs) x z ↔ «而» («历» F as) («历» F bs) x z
```

- `«历之末步»` (theorem, line 1096). Theorem. Passing through as ++ [a] is passing through as then one F a step.

```lean
theorem «历之末步» {A : Type v} (F : A → «际» α) (as : List A) (a : A) {x z : α} :
    «历» F (as ++ [a]) x z ↔ ∃ y, «历» F as x y ∧ F a y z
```

- `«历之逆»` (theorem, line 1104). Theorem. The reversed word under converse relations is the word read backward.

```lean
theorem «历之逆» {A : Type v} (F : A → «际» α) : ∀ (as : List A) {x y : α},
    «历» (fun a => «逆» (F a)) as.reverse x y ↔ «历» F as y x
```

- `«历之定前»` (theorem, line 1115). Theorem. If every letter's relation merges nothing, two passages to one z from x and from y give x = y.

```lean
theorem «历之定前» {A : Type v} {F : A → «际» α} (merges : ∀ a, «定前» (F a)) :
    ∀ (as : List A) {x y z : α}, «历» F as x z → «历» F as y z → x = y
```

- `«迭»` (def, line 1124). Definition. n steps: 0 is identity, n+1 is R then n steps (first step first).

```lean
def «迭» (R : «际» α) : Nat → «际» α
  | 0 => «静»
  | n + 1 => «而» R («迭» R n)
```

- `«迭即历»` (theorem, line 1130). Theorem. n steps are 历 of n copies of R (pointwise equivalence 谓).

```lean
theorem «迭即历» (R : «际» α) : ∀ n, «谓» («历» (fun (_ : Unit) => R) (List.replicate n ())) («迭» R n)
```

- `«迭则及»` (theorem, line 1136). Theorem. n+1 steps reach.

```lean
theorem «迭则及» {R : «际» α} : ∀ (n : Nat) {x y : α}, «迭» R (n + 1) x y → «及» R x y
```

- `«及即迭»` (theorem, line 1141). Theorem. Reaching is some positive number of steps.

```lean
theorem «及即迭» {R : «际» α} {x y : α} : «及» R x y ↔ ∃ n, «迭» R (n + 1) x y
```

- `«迭之接»` (theorem, line 1151). Theorem. a steps then b steps are b + a steps.

```lean
theorem «迭之接» {R : «际» α} : ∀ (a b : Nat) {x y z : α}, «迭» R a x y → «迭» R b y z → «迭» R (b + a) x z
```

- `«迭之周»` (theorem, line 1160). Theorem. A loop of p steps at x is a loop of p*k steps for every k.

```lean
theorem «迭之周» {R : «际» α} {p : Nat} {x : α} (loop : «迭» R p x x) : ∀ k, «迭» R (p * k) x x
```

- `«迭之末步»` (theorem, line 1167). Theorem. n+1 steps are n steps then one last step.

```lean
theorem «迭之末步» {R : «际» α} : ∀ (n : Nat) {x z : α}, «迭» R (n + 1) x z ↔ ∃ y, «迭» R n x y ∧ R y z
```

- `«迭内»` (def, line 1176). Definition. Within n steps: k steps for some k ≤ n.

```lean
def «迭内» (R : «际» α) (n : Nat) : «际» α := fun x y => ∃ k, k ≤ n ∧ «迭» R k x y
```

- `«迭内之接»` (theorem, line 1179). Theorem. Within m then within n is within m + n.

```lean
theorem «迭内之接» {R : «际» α} {m n : Nat} {x y z : α} :
    «迭内» R m x y → «迭内» R n y z → «迭内» R (m + n) x z
```

- `«静或缘»` (def, line 1185). Definition. Staying or one R step (reflexive closure of one step).

```lean
def «静或缘» (R : «际» α) : «际» α := fun x y => x = y ∨ R x y
```

- `«迭内即静或缘之迭»` (theorem, line 1188). Theorem. Within n steps of R is exactly n steps of (stay or R).

```lean
theorem «迭内即静或缘之迭» {R : «际» α} : ∀ (n : Nat) {x y : α}, «迭内» R n x y ↔ «迭» («静或缘» R) n x y
```

- `«承»` (def, line 1205). Definition. a takes P on: every R-predecessor of a lies in P (vacuously true where nothing conditions a).

```lean
def «承» (R : «际» α) (P : α → Prop) : α → Prop := fun a => ∀ b, R b a → P b
```

- `«承之迭»` (theorem, line 1211). Theorem. If each round S(n+1) is exactly 承 R (S n), round n is exactly 承 of n steps applied to S 0.

```lean
theorem «承之迭» {R : «际» α} {S : Nat → α → Prop} (round : ∀ n a, S (n + 1) a ↔ «承» R (S n) a) :
    ∀ n a, S n a ↔ «承» («迭» R n) (S 0) a
```

- `«存承之迭»` (theorem, line 1224). Theorem. If each round keeps and takes on, round n is exactly 承 of within-n-steps applied to S 0.

```lean
theorem «存承之迭» {R : «际» α} {S : Nat → α → Prop}
    (round : ∀ n a, S (n + 1) a ↔ S n a ∧ «承» R (S n) a) :
    ∀ n a, S n a ↔ «承» («迭内» R n) (S 0) a
```

- `«迭之分»` (theorem, line 1238). Theorem. b + a steps split as a steps then b steps.

```lean
theorem «迭之分» {R : «际» α} : ∀ (a : Nat) {b : Nat} {x z : α},
    «迭» R (b + a) x z → ∃ y, «迭» R a x y ∧ «迭» R b y z
```

- `«迭之逆»` (theorem, line 1248). Theorem. n steps of the converse from x to y are n steps of R from y to x.

```lean
theorem «迭之逆» {R : «际» α} : ∀ (n : Nat) {x y : α}, «迭» («逆» R) n x y ↔ «迭» R n y x
```

- `«或有后则或迭»` (theorem, line 1258). Theorem. If everything reached from x in k < n steps has a successor (double-negated), then n steps from x exist (double-negated). Availability gives steps.

```lean
theorem «或有后则或迭» {R : «际» α} {x : α} : ∀ (n : Nat),
    (∀ k y, k < n → «迭» R k x y → ¬¬ ∃ z, R y z) → ¬¬ ∃ y, «迭» R n x y
```

- `«迭则同一或及»` (theorem, line 1268). Theorem. n steps lead to x itself or to what x reaches.

```lean
theorem «迭则同一或及» {R : «际» α} : ∀ (n : Nat) {x y : α}, «迭» R n x y → x = y ∨ «及» R x y
```

- `«不穷则迭»` (theorem, line 1274). Theorem. If the 续 R E line from x never ends (不穷), there are 续-steps of every length n from x.

```lean
theorem «不穷则迭» {R E : «际» α} {x : α} (endless : «不穷» R E x) :
    ∀ n, ∃ y, «迭» («续» R E) n x y
```

- `«定后于»` (def, line 1284). Definition. Successor fixed at what x reaches: functional within x's closure only.

```lean
def «定后于» (R : «际» α) (x : α) : Prop := ∀ a, «所闭» R x a → ∀ b c, R a b → R a c → b = c
```

- `«定后则定后于»` (theorem, line 1287). Theorem. Global fixed successor gives fixed-at for every x.

```lean
theorem «定后则定后于» {R : «际» α} (fixed : «定后» R) (x : α) : «定后于» R x
```

- `«定后于之后»` (theorem, line 1291). Theorem. Fixed at x gives fixed at anything within x's closure.

```lean
theorem «定后于之后» {R : «际» α} {x y : α} (fixed : «定后于» R x) (within : «所闭» R x y) :
    «定后于» R y
```

- `«所闭当且仅当有迭»` (theorem, line 1301). Theorem. Within x's closure is exactly n steps for some n.

```lean
theorem «所闭当且仅当有迭» {R : «际» α} {x y : α} : «所闭» R x y ↔ ∃ n, «迭» R n x y
```

- `«分处定后则迭之定于»` (theorem, line 1311). Theorem. If the successor is fixed only where two lines (to y or to z) from a could part, n steps from a to y and to z give y = z.

```lean
theorem «分处定后则迭之定于» {R : «际» α} : ∀ (n : Nat) {a y z : α},
    (∀ v b b', «所闭» R a v → («所闭» R b y ∨ «所闭» R b z) → («所闭» R b' y ∨ «所闭» R b' z) →
      R v b → R v b' → b = b') →
    «迭» R n a y → «迭» R n a z → y = z
```

- `GrammarLaws.reorder` (theorem, line 1323). Theorem. Arithmetic helper k+1+d = d+1+k.

```lean
theorem GrammarLaws.reorder (k d : Nat) : k + 1 + d = d + 1 + k
```

- `«亡者不在长迭»` (theorem, line 1329). Theorem. With the local fixed successor, if x is k steps from m and has no R-successor, no occurrence x' lies k' > k steps from m (False). A line ends at its length; nothing lies beyond the end.

```lean
theorem «亡者不在长迭» {R : «际» α} {k k' : Nat} {m x x' : α} (below : k < k')
    (fixed : ∀ v b b', «所闭» R m v → («所闭» R b x ∨ «所闭» R b x') →
      («所闭» R b' x ∨ «所闭» R b' x') → R v b → R v b' → b = b')
    (steps : «迭» R k m x) (steps' : «迭» R k' m x') (ends : ¬ ∃ w, R x w) : False
```

- `«定后则线至多一亡»` (theorem, line 1354). Theorem. With the local fixed successor, two occurrences within m's closure that each have no R-successor are equal: a line ends at most once.

```lean
theorem «定后则线至多一亡» {R : «际» α} {m x x' : α}
    (fixed : ∀ v b b', «所闭» R m v → («所闭» R b x ∨ «所闭» R b x') →
      («所闭» R b' x ∨ «所闭» R b' x') → R v b → R v b' → b = b')
    (reach : «所闭» R m x) (reach' : «所闭» R m x')
    (ends : ¬ ∃ w, R x w) (ends' : ¬ ∃ w, R x' w) : x = x'
```

- `«线终不过所列»` (theorem, line 1374). Theorem. Distinct listed occurrences D, each with no R-successor and within the closure of a member of L, under the local fixed successor, number at most |L|.

```lean
theorem «线终不过所列» {R : «际» α} {L D : List α} (dD : Distinct D)
    (fixed : ∀ v b b', (∃ m, m ∈ L ∧ «所闭» R m v) →
      (∃ x, x ∈ D ∧ «所闭» R b x) → (∃ x, x ∈ D ∧ «所闭» R b' x) → R v b → R v b' → b = b')
    (reached : ∀ x, x ∈ D → ∃ m, m ∈ L ∧ «所闭» R m x)
    (ends : ∀ x, x ∈ D → ¬ ∃ w, R x w) : D.length ≤ L.length
```

- `GrammarLaws.line_ends_unrefuted` (theorem, line 1394). Theorem. Same with reaching from L only double-negated.

```lean
theorem GrammarLaws.line_ends_unrefuted {R : «际» α} {L D : List α} (dD : Distinct D)
    (fixed : ∀ v b b', (∃ m, m ∈ L ∧ «所闭» R m v) →
      (∃ x, x ∈ D ∧ «所闭» R b x) → (∃ x, x ∈ D ∧ «所闭» R b' x) → R v b → R v b' → b = b')
    (reached : ∀ x, x ∈ D → ¬¬ ∃ m, m ∈ L ∧ «所闭» R m x)
    (ends : ∀ x, x ∈ D → ¬ ∃ w, R x w) : D.length ≤ L.length
```

- `«线亡不过所列»` (theorem, line 1408). Theorem. The same for 亡 under 续 R E: endings on 续-lines from L number at most |L|.

```lean
theorem «线亡不过所列» {R E : «际» α} {L D : List α} (dD : Distinct D)
    (fixed : ∀ v b b', (∃ m, m ∈ L ∧ «所闭» («续» R E) m v) →
      (∃ x, x ∈ D ∧ «所闭» («续» R E) b x) → (∃ x, x ∈ D ∧ «所闭» («续» R E) b' x) →
      «续» R E v b → «续» R E v b' → b = b')
    (reached : ∀ x, x ∈ D → ∃ m, m ∈ L ∧ «所闭» («续» R E) m x)
    (ends : ∀ x, x ∈ D → «亡» R E x) : D.length ≤ L.length
```

- `«线亡不过所列之未否»` (theorem, line 1418). Theorem. Same, reaching double-negated.

```lean
theorem «线亡不过所列之未否» {R E : «际» α} {L D : List α} (dD : Distinct D)
    (fixed : ∀ v b b', (∃ m, m ∈ L ∧ «所闭» («续» R E) m v) →
      (∃ x, x ∈ D ∧ «所闭» («续» R E) b x) → (∃ x, x ∈ D ∧ «所闭» («续» R E) b' x) →
      «续» R E v b → «续» R E v b' → b = b')
    (reached : ∀ x, x ∈ D → ¬¬ ∃ m, m ∈ L ∧ «所闭» («续» R E) m x)
    (ends : ∀ x, x ∈ D → «亡» R E x) : D.length ≤ L.length
```

- `«线生不过所列»` (theorem, line 1428). Theorem. Mirror: beginnings (生) on 续-lines to L, merging nothing locally, number at most |L|.

```lean
theorem «线生不过所列» {R E : «际» α} {L D : List α} (dD : Distinct D)
    (merges : ∀ v a a', (∃ m, m ∈ L ∧ «所闭» («续» R E) v m) →
      (∃ x, x ∈ D ∧ «所闭» («续» R E) x a) → (∃ x, x ∈ D ∧ «所闭» («续» R E) x a') →
      «续» R E a v → «续» R E a' v → a = a')
    (reaching : ∀ x, x ∈ D → ∃ m, m ∈ L ∧ «所闭» («续» R E) x m)
    (begins : ∀ x, x ∈ D → «生» R E x) : D.length ≤ L.length
```

- `«线生不过所列之未否»` (theorem, line 1442). Theorem. Same, reaching double-negated.

```lean
theorem «线生不过所列之未否» {R E : «际» α} {L D : List α} (dD : Distinct D)
    (merges : ∀ v a a', (∃ m, m ∈ L ∧ «所闭» («续» R E) v m) →
      (∃ x, x ∈ D ∧ «所闭» («续» R E) x a) → (∃ x, x ∈ D ∧ «所闭» («续» R E) x a') →
      «续» R E a v → «续» R E a' v → a = a')
    (reaching : ∀ x, x ∈ D → ¬¬ ∃ m, m ∈ L ∧ «所闭» («续» R E) x m)
    (begins : ∀ x, x ∈ D → «生» R E x) : D.length ≤ L.length
```

- `«迭之定于»` (theorem, line 1456). Theorem. With successor fixed at what x reaches, n steps from x lead to one occurrence.

```lean
theorem «迭之定于» {R : «际» α} : ∀ (n : Nat) {x y z : α}, «定后于» R x →
    «迭» R n x y → «迭» R n x z → y = z
```

- `«迭之定»` (theorem, line 1462). Theorem. With a global fixed successor, n steps lead to one occurrence.

```lean
theorem «迭之定» {R : «际» α} (fixed : «定后» R) : ∀ (n : Nat) {x y z : α},
    «迭» R n x y → «迭» R n x z → y = z
```

- `«迭之定前»` (theorem, line 1468). Theorem. Merging nothing, n steps to one z come from one occurrence.

```lean
theorem «迭之定前» {R : «际» α} (merges : «定前» R) : ∀ (n : Nat) {x y z : α},
    «迭» R n x z → «迭» R n y z → x = y
```

- `«入»` (def, line 1475). Definition. x is drawn in: some closed region excluding x holds something x reaches.

```lean
def «入» (R : «际» α) (x : α) : Prop := ∃ P : α → Prop, «闭» R P ∧ ¬ P x ∧ ∃ y, «及» R x y ∧ P y
```

- `«入当且仅当有不返»` (theorem, line 1478). Theorem. Drawn in iff x reaches some y that does not reach x back (any relation).

```lean
theorem «入当且仅当有不返» {R : «际» α} {x : α} : «入» R x ↔ ∃ y, «及» R x y ∧ ¬ «及» R y x
```

- `«定后于环则所及皆返»` (theorem, line 1492). Theorem. With successor fixed at what x reaches and x reaching itself, everything x reaches reaches x.

```lean
theorem «定后于环则所及皆返» {R : «际» α} {x : α} (fixed : «定后于» R x) (loop : «及» R x x) {y : α}
    (reach : «及» R x y) : «及» R y x
```

- `«定后环则所及皆返»` (theorem, line 1507). Theorem. Global form.

```lean
theorem «定后环则所及皆返» {R : «际» α} (fixed : «定后» R) {x : α} (loop : «及» R x x) {y : α}
    (reach : «及» R x y) : «及» R y x
```

- `«定后于则返者不入»` (theorem, line 1512). Theorem. With successor fixed at x's reach, x reaching itself is not drawn in.

```lean
theorem «定后于则返者不入» {R : «际» α} {x : α} (fixed : «定后于» R x) (loop : «及» R x x) :
    ¬ «入» R x
```

- `«定后则返者不入»` (theorem, line 1518). Theorem. Global form.

```lean
theorem «定后则返者不入» {R : «际» α} (fixed : «定后» R) {x : α} (loop : «及» R x x) : ¬ «入» R x
```

- `«有后不返则入»` (theorem, line 1522). Theorem. x with a successor that does not reach itself is drawn in (any relation).

```lean
theorem «有后不返则入» {R : «际» α} {x y : α} (next : R x y) (never : ¬ «及» R x x) : «入» R x
```

- `«定后于有后则入当且仅当不返»` (theorem, line 1527). Theorem. With local fixed successor and some successor: drawn in iff not reaching itself.

```lean
theorem «定后于有后则入当且仅当不返» {R : «际» α} {x : α} (fixed : «定后于» R x)
    (next : ∃ y, R x y) : «入» R x ↔ ¬ «及» R x x
```

- `«定后有后则入当且仅当不返»` (theorem, line 1534). Theorem. Global form.

```lean
theorem «定后有后则入当且仅当不返» {R : «际» α} (fixed : «定后» R) {x : α} (next : ∃ y, R x y) :
    «入» R x ↔ ¬ «及» R x x
```

- `«无后者不入亦不返»` (theorem, line 1540). Theorem. An x that conditions nothing (∀ y, ¬ R x y) is neither drawn in nor reaches itself.

```lean
theorem «无后者不入亦不返» {R : «际» α} {x : α} (nothing : ∀ y, ¬ R x y) : ¬ «入» R x ∧ ¬ «及» R x x
```

- `«入而返之例»` (theorem, line 1549). Theorem (witness). On Bool, false conditions itself and true; true conditions nothing; false is drawn in and reaches itself.

```lean
theorem «入而返之例» : ∃ (R : «际» Bool) (x : Bool), «入» R x ∧ «及» R x x
```

- `«非定后返而不入之例»` (theorem, line 1560). Theorem (witness). A relation with no global fixed successor where none reaches itself and is not drawn in.

```lean
theorem «非定后返而不入之例» :
    ∃ (R : «际» (Option Bool)), ¬ «定后» R ∧ «及» R none none ∧ ¬ «入» R none
```

- `«遍后则有线»` (theorem, line 1577). Theorem. If every occurrence has a successor, from every x there is a line g of every length n.

```lean
theorem «遍后则有线» {R : «际» α} (total : ∀ x, ∃ y, R x y) :
    ∀ (n : Nat) (x : α), ∃ g : Nat → α, g 0 = x ∧ ∀ i, i < n → R (g i) (g (i + 1))
```

- `«线不并»` (def, line 1588). Definition. Merging nothing at the first N places of the line g.

```lean
def «线不并» (R : «际» α) (g : Nat → α) (N : Nat) : Prop :=
  ∀ i j z, i < N → j < N → R (g i) z → R (g j) z → g i = g j
```

- `«定前则线不并»` (theorem, line 1592). Theorem. 定前 gives 线不并 for every line.

```lean
theorem «定前则线不并» {R : «际» α} (merges : «定前» R) (g : Nat → α) (N : Nat) : «线不并» R g N
```

- `«线不并则可退»` (theorem, line 1597). Theorem. Merging nothing at the line's places, g i = g (i+d) gives g 0 = g d.

```lean
theorem «线不并则可退» {R : «际» α} {g : Nat → α} {N : Nat} (merges : «线不并» R g N)
    (steps : ∀ i, i < N → R (g i) (g (i + 1))) : ∀ i d, i + d ≤ N → g i = g (i + d) → g 0 = g d
```

- `«定前则线可退»` (theorem, line 1611). Theorem. Global form.

```lean
theorem «定前则线可退» {R : «际» α} (merges : «定前» R) {g : Nat → α} {N : Nat}
    (steps : ∀ i, i < N → R (g i) (g (i + 1))) : ∀ i d, i + d ≤ N → g i = g (i + d) → g 0 = g d
```

- `«线则及»` (theorem, line 1616). Theorem. A line of steps from place m reaches place m + (k+1).

```lean
theorem «线则及» {R : «际» α} {g : Nat → α} {N : Nat} (steps : ∀ i, i < N → R (g i) (g (i + 1))) :
    ∀ k m, m + (k + 1) ≤ N → «及» R (g m) (g (m + (k + 1)))
```

- `«线则所闭»` (theorem, line 1623). Theorem. Every place m ≤ N of a line lies within the closure of its first place.

```lean
theorem «线则所闭» {R : «际» α} {g : Nat → α} {N : Nat} (steps : ∀ i, i < N → R (g i) (g (i + 1))) :
    ∀ m, m ≤ N → «所闭» R (g 0) (g m)
```

- `kept_onward` (theorem, line 1633). Theorem. A predicate on Nat kept by every step, holding at a, holds at every b ≥ a.

```lean
theorem kept_onward {I : Nat → Prop} (keeps : ∀ n, I n → I (n + 1)) {a b : Nat} (holds : I a)
    (later : a ≤ b) : I b
```

- `«线有限不并则回»` (theorem, line 1647). Theorem. A line held by a list l, merging nothing at its places, comes back to g 0 within |l| steps.

```lean
theorem «线有限不并则回» {R : «际» α} {l : List α} {g : Nat → α} (merges : «线不并» R g l.length)
    (steps : ∀ i, i < l.length → R (g i) (g (i + 1))) (held : ∀ n, n ≤ l.length → g n ∈ l) :
    ∃ d, 0 < d ∧ d ≤ l.length ∧ g d = g 0
```

- `«线有限不并则返»` (theorem, line 1659). Theorem. Then g 0 reaches itself.

```lean
theorem «线有限不并则返» {R : «际» α} {l : List α} {g : Nat → α} (merges : «线不并» R g l.length)
    (steps : ∀ i, i < l.length → R (g i) (g (i + 1))) (held : ∀ n, n ≤ l.length → g n ∈ l) :
    «及» R (g 0) (g 0)
```

- `«线有限定前则返»` (theorem, line 1670). Theorem. Global form.

```lean
theorem «线有限定前则返» {R : «际» α} {l : List α} (merges : «定前» R) {g : Nat → α}
    (steps : ∀ i, i < l.length → R (g i) (g (i + 1))) (held : ∀ n, n ≤ l.length → g n ∈ l) :
    «及» R (g 0) (g 0)
```

- `«定后于线有限则末返»` (theorem, line 1680). Theorem. A line held by a list with successor fixed at g 0's reach: its last place g |l| reaches itself.

```lean
theorem «定后于线有限则末返» {R : «际» α} {l : List α} {g : Nat → α} (fixed : «定后于» R (g 0))
    (steps : ∀ i, i < l.length → R (g i) (g (i + 1))) (held : ∀ n, n ≤ l.length → g n ∈ l) :
    «及» R (g l.length) (g l.length)
```

- `«有限遍后定前则皆返»` (theorem, line 1703). Theorem. On a listed carrier, every occurrence with a successor and nothing merged: every occurrence reaches itself.

```lean
theorem «有限遍后定前则皆返» {R : «际» α} {all : List α} (every : ∀ x, x ∈ all)
    (total : ∀ x, ∃ y, R x y) (merges : «定前» R) (x : α) : «及» R x x
```

- `«定后于二返则不并»` (theorem, line 1712). Theorem. Two self-reaching occurrences, each with successor fixed at its reach, sharing a successor z, are equal.

```lean
theorem «定后于二返则不并» {R : «际» α} {x y z : α} (fx : «定后于» R x) (fy : «定后于» R y)
    (loopx : «及» R x x) (loopy : «及» R y y) (rx : R x z) (ry : R y z) : x = y
```

- `«皆返定后则定前»` (theorem, line 1730). Theorem. Fixed successor and every occurrence reaching itself give 定前.

```lean
theorem «皆返定后则定前» {R : «际» α} (fixed : «定后» R) (loops : ∀ x, «及» R x x) : «定前» R
```

- `«有限遍后定后则定前当且仅当皆返»` (theorem, line 1736). Theorem. Listed carrier, total, fixed successor: 定前 iff every occurrence reaches itself.

```lean
theorem «有限遍后定后则定前当且仅当皆返» {R : «际» α} {all : List α} (every : ∀ x, x ∈ all)
    (total : ∀ x, ∃ y, R x y) (fixed : «定后» R) : «定前» R ↔ ∀ x, «及» R x x
```

- `«屡»` (def, line 1749). Definition. Steps of F recur along g: after every N a later step g t → g (t+1) is an F step.

```lean
def «屡» (F : «际» α) (g : Nat → α) : Prop := ∀ N, ∃ t, N ≤ t ∧ F (g t) (g (t + 1))
```

- `«或屡»` (def, line 1753). Definition. F steps recur from T on, double-negated.

```lean
def «或屡» (F : «际» α) (g : Nat → α) (T : Nat) : Prop :=
  ∀ N, T ≤ N → ¬¬ ∃ t, N ≤ t ∧ F (g t) (g (t + 1))
```

- `«屡则或屡»` (theorem, line 1757). Theorem. Recurring gives recurring double-negated.

```lean
theorem «屡则或屡» {F : «际» α} {g : Nat → α} (recurs : «屡» F g) (T : Nat) : «或屡» F g T
```

- `«线或在所闭»` (theorem, line 1762). Theorem. If every step from T on is double-negated Q, each later place is double-negated within Q's closure from g T.

```lean
theorem «线或在所闭» {Q : «际» α} {g : Nat → α} {T : Nat}
    (still : ∀ t, T ≤ t → ¬¬ Q (g t) (g (t + 1))) : ∀ k, ¬¬ «所闭» Q (g T) (g (T + k))
```

- `«尽则不或屡»` (theorem, line 1773). Theorem. Steps from T are (double-negated) Q steps and every course of Q-closure then F from g T ends (尽 is well-foundedness of 所闭 Q ; F): the F steps do not recur even double-negated. This is the "falling whole number stops falling" law in grammar form.

```lean
theorem «尽则不或屡» {Q F : «际» α} {g : Nat → α} {T : Nat}
    (still : ∀ t, T ≤ t → ¬¬ Q (g t) (g (t + 1))) (ends : «尽» («而» («所闭» Q) F) «一» (g T)) :
    ¬ «或屡» F g T
```

- `«尽则不屡»` (theorem, line 1792). Theorem. Outright form.

```lean
theorem «尽则不屡» {Q F : «际» α} {g : Nat → α} {T : Nat}
    (still : ∀ t, T ≤ t → Q (g t) (g (t + 1))) (ends : «尽» («而» («所闭» Q) F) «一» (g T)) :
    ¬ «屡» F g
```

- `«止而不入之例»` (theorem, line 1800). Theorem (witness). A line on Bool that falls once and rests at a fixed point: falls end, do not recur, and the resting place is not drawn in.

```lean
theorem «止而不入之例» : ∃ (Q F : «际» Bool) (g : Nat → Bool),
    (∀ t, Q (g t) (g (t + 1))) ∧ (∃ t, F (g t) (g (t + 1))) ∧
      «尽» («而» («所闭» Q) F) «一» (g 0) ∧ ¬ «屡» F g ∧ ¬ «入» Q (g 1)
```

- `«入而屡之例»` (theorem, line 1823). Theorem (witness). Successor on Nat: F steps recur and 0 is drawn in.

```lean
theorem «入而屡之例» : ∃ (Q F : «际» Nat) (g : Nat → Nat),
    (∀ t, Q (g t) (g (t + 1))) ∧ «屡» F g ∧ «入» Q (g 0)
```


### Census counted and ends on lines at stages (所覆), lines 1940-2559 (selected: the laws on 生/亡, stages, steps; list-only helpers omitted)

- `«定后定前则前并生对后并亡»` (theorem, line 1942). Theorem. Listed once before and after a step, 续 decided by k, fixed successor and predecessor of 续: before ++ arising pairs with after ++ ceasing.

```lean
theorem «定后定前则前并生对后并亡» (dec : ∀ x y, «续» R E x y ↔ k x y = true)
    (before after : List α) (dB : Distinct before) (dA : Distinct after)
    (fixedAfter : «定后» («续» R E)) (fixedBefore : «定前» («续» R E)) :
    «对» (fun x y => «续» R E x y ∨ x = y) (before ++ GrammarLaws.arising k before after)
      (after ++ GrammarLaws.ceasing k before after)
```

- `«前者在前则所列生者生»` (theorem, line 1957). Theorem. Where every predecessor of a unit after is listed before, the listed arising units are exactly the units after that begin (生).

```lean
theorem «前者在前则所列生者生» (dec : ∀ x y, «续» R E x y ↔ k x y = true) {before after : List α}
    (predecessorsBefore : ∀ x f, f ∈ after → «续» R E x f → x ∈ before) {f : α} :
    f ∈ GrammarLaws.arising k before after ↔ f ∈ after ∧ «生» R E f
```

- `«后者在后则所列亡者亡»` (theorem, line 1978). Theorem. Where every successor of a unit before is listed after, the listed ceasing units are exactly the units before that end (亡).

```lean
theorem «后者在后则所列亡者亡» (dec : ∀ x y, «续» R E x y ↔ k x y = true) {before after : List α}
    (successorsAfter : ∀ g y, g ∈ before → «续» R E g y → y ∈ after) {g : α} :
    g ∈ GrammarLaws.ceasing k before after ↔ g ∈ before ∧ «亡» R E g
```

- `GrammarLaws.stage_steps` (theorem, line 2176). Theorem. If every 续 step raises the stage τ by one, n 续-steps raise it by n.

```lean
theorem GrammarLaws.stage_steps (stage : ∀ x y, «续» R E x y → τ y = τ x + 1) :
    ∀ (n : Nat) {x y : α}, «迭» («续» R E) n x y → τ y = τ x + n
```

- `GrammarLaws.fixed_of_noSplit` (theorem, line 2185). Theorem. In a region P nothing outside continues into, no-split among P gives the local fixed successor hypothesis of 线终不过所列.

```lean
theorem GrammarLaws.fixed_of_noSplit (back : «闭» («逆» («续» R E)) P)
    (noSplit : ∀ v b b', P b → P b' → «续» R E v b → «续» R E v b' → b = b')
    {L D : List α} (inD : ∀ x, x ∈ D → P x) :
    ∀ v b b', (∃ m, m ∈ L ∧ «所闭» («续» R E) m v) →
      (∃ x, x ∈ D ∧ «所闭» («续» R E) b x) → (∃ x, x ∈ D ∧ «所闭» («续» R E) b' x) →
      «续» R E v b → «续» R E v b' → b = b'
```

- `GrammarLaws.trace` (theorem, line 2242). Theorem. Tracing back k stages, with 生 or 有前 decided after N: either something begins after N or y is within the 续-closure of a member of a list covering stage N.

```lean
theorem GrammarLaws.trace (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (back : «闭» («逆» («续» R E)) P)
    {N : Nat} {L : List α} (covers : ∀ x, P x → τ x = N → x ∈ L)
    (decided : ∀ y, P y → N < τ y → «生» R E y ∨ «有前» R E y) :
    ∀ k y, P y → τ y = N + k →
      (∃ z, N < τ z ∧ P z ∧ «生» R E z) ∨ ∃ m, m ∈ L ∧ «所闭» («续» R E) m y
```

- `GrammarLaws.trace_unrefuted` (theorem, line 2262). Theorem. Same with nothing beginning after N up to y's stage: the line from the covering list is not refuted.

```lean
theorem GrammarLaws.trace_unrefuted (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (back : «闭» («逆» («续» R E)) P)
    {N : Nat} {L : List α} (covers : ∀ x, P x → τ x = N → x ∈ L) :
    ∀ k y, P y → τ y = N + k →
      (∀ z, P z → N < τ z → τ z ≤ N + k → ¬ «生» R E z) →
      ¬¬ ∃ m, m ∈ L ∧ «所闭» («续» R E) m y
```

- `«间无生则间亡不过所覆»` (theorem, line 2282). Theorem. Region closed backward, one stage per step, no split, list L covering stage N, nothing beginning in (N, U): distinct units ending in [N, U) number at most |L|.

```lean
theorem «间无生则间亡不过所覆» (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (back : «闭» («逆» («续» R E)) P)
    (noSplit : ∀ v b b', P b → P b' → «续» R E v b → «续» R E v b' → b = b')
    {N U : Nat} {L : List α} (covers : ∀ x, P x → τ x = N → x ∈ L)
    (quiet : ∀ z, P z → N < τ z → τ z < U → ¬ «生» R E z)
    {D : List α} (dD : Distinct D)
    (ends : ∀ x, x ∈ D → N ≤ τ x ∧ τ x < U ∧ P x ∧ «亡» R E x) : D.length ≤ L.length
```

- `«所覆后亡屡则有生»` (theorem, line 2299). Theorem. With a cover at N, beginning-or-predecessor decided after N, and endings at arbitrarily late stages: something begins after N.

```lean
theorem «所覆后亡屡则有生» (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (back : «闭» («逆» («续» R E)) P)
    (noSplit : ∀ v b b', P b → P b' → «续» R E v b → «续» R E v b' → b = b')
    {N : Nat} {L : List α} (covers : ∀ x, P x → τ x = N → x ∈ L)
    (decided : ∀ y, P y → N < τ y → «生» R E y ∨ «有前» R E y)
    (ending : ∀ M, ∃ x, M ≤ τ x ∧ P x ∧ «亡» R E x) :
    ∃ y, N < τ y ∧ P y ∧ «生» R E y
```

- `«有覆而亡屡则生屡»` (theorem, line 2320). Theorem. Covers at arbitrarily late stages and endings recurring: beginnings recur.

```lean
theorem «有覆而亡屡则生屡» (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (back : «闭» («逆» («续» R E)) P)
    (noSplit : ∀ v b b', P b → P b' → «续» R E v b → «续» R E v b' → b = b')
    (covered : ∀ M, ∃ N, ∃ L : List α, M ≤ N ∧ ∀ x, P x → τ x = N → x ∈ L)
    {T : Nat} (decided : ∀ y, P y → T < τ y → «生» R E y ∨ «有前» R E y)
    (ending : ∀ M, ∃ x, M ≤ τ x ∧ P x ∧ «亡» R E x) :
    ∀ M, ∃ y, M < τ y ∧ P y ∧ «生» R E y
```

- `«所覆后亡屡则生未否»` (theorem, line 2338). Theorem. Undecided form: a beginning after N is not refuted.

```lean
theorem «所覆后亡屡则生未否» (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (back : «闭» («逆» («续» R E)) P)
    (noSplit : ∀ v b b', P b → P b' → «续» R E v b → «续» R E v b' → b = b')
    {N : Nat} {L : List α} (covers : ∀ x, P x → τ x = N → x ∈ L)
    (ending : ∀ M, ¬¬ ∃ x, M ≤ τ x ∧ P x ∧ «亡» R E x) :
    ¬¬ ∃ y, N < τ y ∧ P y ∧ «生» R E y
```

- `«有覆而亡屡则生不止»` (theorem, line 2352). Theorem. Undecided form: beginnings never stop.

```lean
theorem «有覆而亡屡则生不止» (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (back : «闭» («逆» («续» R E)) P)
    (noSplit : ∀ v b b', P b → P b' → «续» R E v b → «续» R E v b' → b = b')
    (covered : ∀ M, ∃ N, ∃ L : List α, M ≤ N ∧ ∀ x, P x → τ x = N → x ∈ L)
    (ending : ∀ M, ¬¬ ∃ x, M ≤ τ x ∧ P x ∧ «亡» R E x) :
    ¬ ∃ M, ∀ y, M < τ y → P y → ¬ «生» R E y
```

- `GrammarLaws.onward_within` (theorem, line 2365). Theorem. Region closed forward, nothing ending in [N, U): a unit at stage ≥ N has k 续-steps after it (double-negated) wherever τ x + k ≤ U. Steps counted up to a bound from no-ending.

```lean
theorem GrammarLaws.onward_within (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (on : «闭» («续» R E) P)
    {N U : Nat} (quiet : ∀ z, P z → N ≤ τ z → τ z < U → ¬ «亡» R E z)
    {x : α} (from_ : N ≤ τ x) (h : P x) : ∀ k, τ x + k ≤ U → ¬¬ ∃ y, «迭» («续» R E) k x y
```

- `«间无亡则间生不过所覆»` (theorem, line 2381). Theorem. Mirror: closed forward, no merge, cover at U, nothing ending in [N, U): distinct beginnings in [N, U] number at most |L|.

```lean
theorem «间无亡则间生不过所覆» (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (on : «闭» («续» R E) P)
    (noMerge : ∀ v a a', P a → P a' → «续» R E a v → «续» R E a' v → a = a')
    {N U : Nat} {L : List α} (covers : ∀ x, P x → τ x = U → x ∈ L)
    (quiet : ∀ z, P z → N ≤ τ z → τ z < U → ¬ «亡» R E z)
    {D : List α} (dD : Distinct D)
    (begins : ∀ x, x ∈ D → N ≤ τ x ∧ τ x ≤ U ∧ P x ∧ «生» R E x) : D.length ≤ L.length
```

- `«有界覆而生屡则亡不止»` (theorem, line 2402). Theorem. Covers bounded by K from T on and beginnings recurring: endings never stop.

```lean
theorem «有界覆而生屡则亡不止» (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (on : «闭» («续» R E) P)
    (noMerge : ∀ v a a', P a → P a' → «续» R E a v → «续» R E a' v → a = a')
    {K T : Nat}
    (bounded : ∀ S, T ≤ S → ∃ L : List α, L.length ≤ K ∧ ∀ x, P x → τ x = S → x ∈ L)
    (beginning : ∀ M, ∃ x, M ≤ τ x ∧ P x ∧ «生» R E x) :
    ¬ ∃ N, ∀ x, N ≤ τ x → P x → ¬ «亡» R E x
```

- `GrammarLaws.trace_on` (theorem, line 2419). Theorem. Ending-or-successor decided from N: from x at stage ≥ N either something ends from N on or there are k 续-steps from x.

```lean
theorem GrammarLaws.trace_on (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (on : «闭» («续» R E) P)
    {N : Nat} (decided : ∀ x, P x → N ≤ τ x → «亡» R E x ∨ «有后» R E x) :
    ∀ k x, P x → N ≤ τ x →
      (∃ z, N ≤ τ z ∧ P z ∧ «亡» R E z) ∨ ∃ y, «迭» («续» R E) k x y
```

- `«有界覆而生屡则亡屡»` (theorem, line 2436). Theorem. Decided form: endings recur.

```lean
theorem «有界覆而生屡则亡屡» (stage : ∀ x y, «续» R E x y → τ y = τ x + 1)
    (on : «闭» («续» R E) P)
    (noMerge : ∀ v a a', P a → P a' → «续» R E a v → «续» R E a' v → a = a')
    {K T : Nat}
    (bounded : ∀ S, T ≤ S → ∃ L : List α, L.length ≤ K ∧ ∀ x, P x → τ x = S → x ∈ L)
    (decided : ∀ x, P x → T ≤ τ x → «亡» R E x ∨ «有后» R E x)
    (beginning : ∀ M, ∃ x, M ≤ τ x ∧ P x ∧ «生» R E x) :
    ∀ N, ∃ x, N ≤ τ x ∧ P x ∧ «亡» R E x
```

- `GrammarLaws.census_run` (theorem, line 2497). Theorem. Run of lists u t from T: no split, predecessors listed before, 生 decided by b; endings recurring give beginnings recurring.

```lean
theorem GrammarLaws.census_run {b : α → Bool} {u : Nat → List α} {T : Nat}
    (noSplit : ∀ t, T ≤ t → ∀ x y y', x ∈ u t → y ∈ u (t + 1) → y' ∈ u (t + 1) →
      «续» R E x y → «续» R E x y' → y = y')
    (predecessorsBefore : ∀ t, T ≤ t → ∀ x y, y ∈ u (t + 1) → «续» R E x y → x ∈ u t)
    (begins : ∀ t, T ≤ t → ∀ y, y ∈ u (t + 1) → (b y = true ↔ «生» R E y))
    (ending : «屡» (fun before _ => ∃ x, x ∈ before ∧ «亡» R E x) u) :
    «屡» (fun _ after => ∃ y, y ∈ after ∧ «生» R E y) u
```

- `«定后前者在前则亡屡者生屡»` (theorem, line 2549). Theorem. Same under a global fixed successor of 续.

```lean
theorem «定后前者在前则亡屡者生屡» {b : α → Bool} {u : Nat → List α} {T : Nat}
    (predecessorsBefore : ∀ t, T ≤ t → ∀ x y, y ∈ u (t + 1) → «续» R E x y → x ∈ u t)
    (fixedAfter : «定后» («续» R E))
    (begins : ∀ t, T ≤ t → ∀ y, y ∈ u (t + 1) → (b y = true ↔ «生» R E y))
    (ending : «屡» (fun before _ => ∃ x, x ∈ before ∧ «亡» R E x) u) :
    «屡» (fun _ after => ∃ y, y ∈ after ∧ «生» R E y) u
```


### Lumping (同行), lines 2561-2712

- `«同行»` (def, line 2568). Definition. E goes alike under R: R˘;E;R ⊆ E. No successor is asked for.

```lean
def «同行» (R E : «际» α) : Prop := «则» («而» («而» («逆» R) E) R) E
```

- `«同行之逐点»` (theorem, line 2571). Theorem. Pointwise: E x x', R x y, R x' y' give E y y'. Vacuous where x' has no successor.

```lean
theorem «同行之逐点» {R E : «际» α} :
    «同行» R E ↔ ∀ x x', E x x' → ∀ y y', R x y → R x' y' → E y y'
```

- `«有常局定后则同行»` (theorem, line 2578). Theorem. Constancy, with the successor fixed at every x' that E relates something to, gives going alike.

```lean
theorem «有常局定后则同行» {R E : «际» α} (constant : «有常» R E)
    (fixed : ∀ x x', E x x' → ∀ v w, R x' v → R x' w → v = w) : «同行» R E
```

- `«有常定后则同行»` (theorem, line 2588). Theorem. Global form: constancy and 定后 give 同行.

```lean
theorem «有常定后则同行» {R E : «际» α} (constant : «有常» R E) (fixed : «定后» R) : «同行» R E
```

- `«有常则可续»` (theorem, line 2592). Theorem. Constancy gives availability: E u u' and R u v give some R u' v'.

```lean
theorem «有常则可续» {R E : «际» α} (constant : «有常» R E) :
    ∀ u u' v, E u u' → R u v → ∃ v', R u' v'
```

- `«同行可续则有常»` (theorem, line 2600). Theorem. Going alike plus availability gives constancy (no fixed successor needed).

```lean
theorem «同行可续则有常» {R E : «际» α} (alike : «同行» R E)
    (onward : ∀ u u' v, E u u' → R u v → ∃ v', R u' v') : «有常» R E
```

- `«同行遍后则有常»` (theorem, line 2607). Theorem. Going alike plus a successor everywhere gives constancy.

```lean
theorem «同行遍后则有常» {R E : «际» α} (alike : «同行» R E) (total : ∀ x, ∃ y, R x y) : «有常» R E
```

- `«局定后则有常当且仅当同行可续»` (theorem, line 2612). Theorem. With the successor fixed where E leads: constancy iff going alike and availability. The gap between 同行 and 有常 is exactly availability.

```lean
theorem «局定后则有常当且仅当同行可续» {R E : «际» α}
    (fixed : ∀ x x', E x x' → ∀ v w, R x' v → R x' w → v = w) :
    «有常» R E ↔ «同行» R E ∧ ∀ u u' v, E u u' → R u v → ∃ v', R u' v'
```

- `«同行当且仅当有常»` (theorem, line 2619). Theorem. With a fixed successor that every occurrence has, going alike and constancy are equivalent.

```lean
theorem «同行当且仅当有常» {R E : «际» α} (fixed : «定后» R) (total : ∀ x, ∃ y, R x y) :
    «同行» R E ↔ «有常» R E
```

- `«类同行遍后则含于核»` (theorem, line 2625). Theorem. A class going alike under a total R lies inside its own core.

```lean
theorem «类同行遍后则含于核» {R E : «际» α} (hE : «类» E) (alike : «同行» R E) (total : ∀ x, ∃ y, R x y) :
    «则» E («核» R E)
```

- `«定后则类之核同行»` (theorem, line 2631). Theorem. With a fixed successor, the core of a class E is a class, lies in E and goes alike.

```lean
theorem «定后则类之核同行» {R E : «际» α} (hE : «类» E) (fixed : «定后» R) :
    «类» («核» R E) ∧ «则» («核» R E) E ∧ «同行» R («核» R E)
```

- `«遍后则其内同行之类含于核»` (theorem, line 2637). Theorem. Under a total R, every class S ⊆ E going alike lies in E's core (E need not be a class; no fixed successor).

```lean
theorem «遍后则其内同行之类含于核» {R E : «际» α} (total : ∀ x, ∃ y, R x y) :
    ∀ S, «类» S → «则» S E → «同行» R S → «则» S («核» R E)
```

- `«定后遍后则核为其内最粗同行之类»` (theorem, line 2643). Theorem. With fixed and total R, the core of a class E is the coarsest class inside E that goes alike.

```lean
theorem «定后遍后则核为其内最粗同行之类» {R E : «际» α} (hE : «类» E) (fixed : «定后» R)
    (total : ∀ x, ∃ y, R x y) :
    («类» («核» R E) ∧ «则» («核» R E) E ∧ «同行» R («核» R E)) ∧
      ∀ S, «类» S → «则» S E → «同行» R S → «则» S («核» R E)
```

- `«后不定则核可不同行»` (theorem, line 2652). Theorem (witness). On Nat with 0 → 1 and 0 → 2, E the identity: the core does not go alike.

```lean
theorem «后不定则核可不同行» : ∃ (R E : «际» Nat),
    R 0 1 ∧ R 0 2 ∧ (∀ x y, E x y ↔ x = y) ∧
      «类» E ∧ ¬ «定后» R ∧ «核» R E 0 0 ∧ ¬ «核» R E 1 2 ∧ ¬ «同行» R («核» R E)
```

- `«同行之历»` (theorem, line 2669). Theorem. If each letter goes alike under E, E-alike starts passing through the same word reach E-alike ends.

```lean
theorem «同行之历» {A : Type v} {F : A → «际» α} {E : «际» α} (alike : ∀ a, «同行» (F a) E) :
    ∀ (as : List A) {x x' y y' : α}, E x x' → «历» F as x y → «历» F as x' y' → E y y'
```

- `«同行之迭»` (theorem, line 2677). Theorem. Going alike: E-alike starts with n steps each reach E-alike ends (both n-step lines assumed to exist).

```lean
theorem «同行之迭» {R E : «际» α} (alike : «同行» R E) :
    ∀ (n : Nat) {x x' y y' : α}, E x x' → «迭» R n x y → «迭» R n x' y' → E y y'
```

- `«同行于迭»` (theorem, line 2684). Theorem. Going alike under R gives going alike under n steps of R.

```lean
theorem «同行于迭» {R E : «际» α} (alike : «同行» R E) (n : Nat) : «同行» («迭» R n) E
```

- `«像»` (def, line 2691). Definition. The image of R along a map π.

```lean
def «像» (π : α → κ) (R : «际» α) : «际» κ := fun k k' => ∃ s u, π s = k ∧ R s u ∧ π u = k'
```

- `«保之像»` (theorem, line 2696). Theorem. The image of R along φ lies in R' iff φ preserves R into R'.

```lean
theorem «保之像» {α : Type u} {κ : Type v} (φ : α → κ) (R : «际» α) (R' : «际» κ) :
    «则» («像» φ R) R' ↔ ∀ x y, R x y → R' (φ x) (φ y)
```

- `«像定后当且仅当同行»` (theorem, line 2705). Theorem. The image along π has a fixed successor iff sameness under π goes alike under R.

```lean
theorem «像定后当且仅当同行» {π : α → κ} {R : «际» α} :
    «定后» («像» π R) ↔ «同行» R (fun s s' => π s = π s')
```


### Order (广), lines 2714-2821

- `«逾»` (def, line 2721). Definition. R exceeds S: some pair in R not in S.

```lean
def «逾» (R S : «际» α) : Prop := ∃ x y, R x y ∧ ¬ S x y
```

- `«广»` (def, line 2724). Definition. R widens S: S ⊆ R and R exceeds S.

```lean
def «广» (R S : «际» α) : Prop := «则» S R ∧ «逾» R S
```

- `«齐»` (def, line 2727). Definition. R and S keep the same: mutual inclusion.

```lean
def «齐» (R S : «际» α) : Prop := «则» R S ∧ «则» S R
```

- `«杂»` (def, line 2730). Definition. Mixed: each exceeds the other.

```lean
def «杂» (R S : «际» α) : Prop := «逾» R S ∧ «逾» S R
```

- `«逾则不则»` (theorem, line 2733). Theorem. Exceeding excludes inclusion.

```lean
theorem «逾则不则» {R S : «际» α} (h : «逾» R S) : ¬ «则» R S
```

- `«广则不则»` (theorem, line 2738). Theorem. Widening: S ⊆ R and not R ⊆ S.

```lean
theorem «广则不则» {R S : «际» α} (h : «广» R S) : «则» S R ∧ ¬ «则» R S
```

- `«广非自»` (theorem, line 2742). Theorem. Nothing widens itself.

```lean
theorem «广非自» (R : «际» α) : ¬ «广» R R
```

- `«广不可逆»` (theorem, line 2746). Theorem. Widening is asymmetric.

```lean
theorem «广不可逆» {R S : «际» α} (h : «广» R S) : ¬ «广» S R
```

- `«广之传递»` (theorem, line 2750). Theorem. Widening is transitive.

```lean
theorem «广之传递» {R S T : «际» α} (h₁ : «广» R S) (h₂ : «广» S T) : «广» R T
```

- `«齐即谓»` (theorem, line 2755). Theorem. Keeping the same is pointwise equivalence.

```lean
theorem «齐即谓» {R S : «际» α} : «齐» R S ↔ «谓» R S
```

- `«齐之对称»` (theorem, line 2758). Theorem. Keeping the same is symmetric.

```lean
theorem «齐之对称» {R S : «际» α} (h : «齐» R S) : «齐» S R
```

- `«杂之对称»` (theorem, line 2760). Theorem. Mixed is symmetric.

```lean
theorem «杂之对称» {R S : «际» α} (h : «杂» R S) : «杂» S R
```

- `«广则非齐»` (theorem, line 2763). Theorem. Widening excludes keeping.

```lean
theorem «广则非齐» {R S : «际» α} (h : «广» R S) : ¬ «齐» R S
```

- `«广则非杂»` (theorem, line 2767). Theorem. Widening excludes mixed.

```lean
theorem «广则非杂» {R S : «际» α} (h : «广» R S) : ¬ «杂» R S
```

- `«齐则非杂»` (theorem, line 2771). Theorem. Keeping excludes mixed.

```lean
theorem «齐则非杂» {R S : «际» α} (h : «齐» R S) : ¬ «杂» R S
```

- `«四比之周»` (theorem, line 2776). Theorem. With inclusion-or-exceeding decided both ways, one of widen, widened, keep, mixed holds.

```lean
theorem «四比之周» {R S : «际» α} (one : «则» R S ∨ «逾» R S) (other : «则» S R ∨ «逾» S R) :
    «广» R S ∨ «广» S R ∨ «齐» R S ∨ «杂» R S
```

- `strictJoin_trans` (theorem, line 2788). Theorem. A transitive S joined to the strict part of a transitive P ⊇ S is transitive (on α → α → Prop).

```lean
theorem strictJoin_trans {α : Type u} {S P : α → α → Prop}
    (sTrans : ∀ {a b c}, S a b → S b c → S a c) (pTrans : ∀ {a b c}, P a b → P b c → P a c)
    (within : ∀ {a b}, S a b → P a b) {a b c : α} :
    (S a b ∨ (P a b ∧ ¬ P b a)) → (S b c ∨ (P b c ∧ ¬ P c b)) → (S a c ∨ (P a c ∧ ¬ P c a))
```

- `strictJoin_irrefl` (theorem, line 2800). Theorem. That join is irreflexive where S is.

```lean
theorem strictJoin_irrefl {α : Type u} {S P : α → α → Prop} {a : α} (irrefl : ¬ S a a) :
    ¬ (S a a ∨ (P a a ∧ ¬ P a a))
```

- `«则逾之定当且仅当排中»` (theorem, line 2807). Theorem. Deciding inclusion vs exceeding for all relations on all types is equivalent to excluded middle.

```lean
theorem «则逾之定当且仅当排中» :
    (∀ (α : Type) (R S : «际» α), «则» R S ∨ «逾» R S) ↔ ∀ P : Prop, P ∨ ¬ P
```


### Balance: class counts (only the two that read a class), lines 1031-1045

- `«类之对当且仅当类类等数»` (theorem, line 1031). Theorem. Under a class decided by a test, a pairing exists iff the counts agree in every class.

```lean
theorem «类之对当且仅当类类等数» (cls : «类» E) (dec : ∀ x y, E x y ↔ e x y = true)
    {a b : List α} : «对» E a b ↔ ∀ z, «计» (e z) a = «计» (e z) b
```

- `«续之对则类类等数»` (theorem, line 1041). Theorem. A pairing under 续 R E with E a decided class keeps the count in every class.

```lean
theorem «续之对则类类等数» {R E : «际» α} {e : α → α → Bool} (cls : «类» E)
    (dec : ∀ x y, E x y ↔ e x y = true) {a b : List α} (h : «对» («续» R E) a b) (z : α) :
    «计» (e z) a = «计» (e z) b
```

## Answers to the questions

### (1) Lumping (同行) and everything after it

Everything from line 2561 to the end (sections Lumping and Order) is given above in full, every declaration of the two sections included: 2 definitions and 18 theorems in Lumping (`«同行»`, `«像»` are the definitions; `«后不定则核可不同行»` is a witness), 4 definitions and 15 theorems in Order. The pieces that bear on the pattern:

- (a)-(b) in the root's terms: `«同行»` (2568) is "alike goes to alike" and asks for **no successor**: `«同行之逐点»` (2571) is vacuous where `x'` has no `R`-successor. Constancy `«有常»` is going alike **plus availability**: `«同行可续则有常»` (2600) needs no fixed successor; the other direction, `«有常局定后则同行»` (2578), needs the successor fixed only at the `x'` that `E` leads to; together `«局定后则有常当且仅当同行可续»` (2612), whose docstring says "the exact gap between the two: availability". This is (b) said already: E goes alike while among the alike one has a next and another has none, and then E is not constant. The root's contrapositive in Grammar.lean is `«有亡之续则不有常»` (Grammar.lean 370, not my file).
- The core: `«定后则类之核同行»` (2631), `«遍后则其内同行之类含于核»` (2637), `«定后遍后则核为其内最粗同行之类»` (2643), `«类同行遍后则含于核»` (2625), and the witness that off a fixed successor the core need not go alike (`«后不定则核可不同行»`, 2652).
- Lines: `«同行之历»` (2669), `«同行之迭»` (2677), `«同行于迭»` (2684).
- Read alone: `«像定后当且仅当同行»` (2705): a part read alone through π has a law (fixed successor of the image) exactly where what π leaves out makes no difference to where it goes. Its docstring rightly says "possibly partial (nothing is said about a successor existing)".
- Order (2714-2821) does not bear on (a)-(d); it is listed because the question asked for everything after Lumping.

### (2) 迭, 及, 定后, 所闭/闭/不出, 入, falls that stop, steps counted

All given above. In short:
- 迭: definition 1124; `«迭即历»` 1130, `«迭则及»` 1136, `«及即迭»` 1141, `«迭之接»` 1151, `«迭之周»` 1160, `«迭之末步»` 1167, `«迭内»` 1176 and `«迭内之接»` 1179, `«静或缘»` 1185 and `«迭内即静或缘之迭»` 1188, `«承之迭»` 1211, `«存承之迭»` 1224, `«迭之分»` 1238, `«迭之逆»` 1248, `«或有后则或迭»` 1258, `«迭则同一或及»` 1268, `«不穷则迭»` 1274, `«所闭当且仅当有迭»` 1301, `«分处定后则迭之定于»` 1311, `«亡者不在长迭»` 1329, `«迭之定于»` 1456, `«迭之定»` 1462, `«迭之定前»` 1468, `«同行之迭»` 2677, `«同行于迭»` 2684, `GrammarLaws.stage_steps` 2176, `GrammarLaws.onward_within` 2365, `GrammarLaws.trace_on` 2419.
- 及: `«闭之及»` 313, `«及之所闭»` 320, `«所闭当且仅当同一或及»` 325, `«及当且仅当一步而所闭»` 336, and the 入 laws.
- 定后/定前 and local forms: definitions 1063, 1066, 1284 (`«定后于»`), 1588 (`«线不并»`); pointwise 1068, 1071; 1075; 1287; 1291; the local "fixed where lines part" hypotheses of 1311, 1329, 1354, 1374.
- 闭/所闭/不出: section Closure 228-368, all listed; `kept_onward` 1633.
- 入: definition 1475 and 1478-1560.
- A falling whole number stops falling: the grammar form is `«尽则不或屡»` (1773) and `«尽则不屡»` (1792): where every course of `Q`-closure-then-`F` from the line's place ends (`«尽»`, well-founded), the `F` steps do not recur. The header (lines 161-164) says `Amounts.rests_unrefuted` and `Amounts.rests` are this law at amounts (Amounts.lean, not read). There is no law in this file stated on `Nat` directly for "a falling number stops"; the closest on `Nat` is `kept_onward` (1633), which is the closure law, not a fall law.
- Steps counted: the 迭 laws above, plus `GrammarLaws.stage_steps` (stage grows by the number of steps).

### (3) An occurrence that conditions nothing; a successor existing (availability)

Conditions nothing (`∀ y, ¬ R x y`, or `¬ ∃ w, R x w`, or `«亡» R E x`):
- `«无后者不入亦不返»` (1540): such an x is neither drawn in nor reaches itself.
- `«亡者不在长迭»` (1329), `«定后则线至多一亡»` (1354), `«线终不过所列»` (1374), `GrammarLaws.line_ends_unrefuted` (1394): `ends : ¬ ∃ w, R x w`; a line ends at most once and nothing lies on a longer line from the same start. These are the nearest thing in the file to "a line has a length".
- `«线亡不过所列»` (1408), `«线亡不过所列之未否»` (1418), the stage laws 2282-2443, census 1978: `«亡» R E x`.
- `«承»` (1205): its docstring says an occurrence with no condition lies in every taken-on region (this is about being conditioned by nothing, the converse side).
- The witness `«入而返之例»` (1549): `true` conditions nothing.

Availability (a successor exists):
- Lumping: `«有常则可续»` 2592 (constancy gives it), `«同行可续则有常»` 2600, `«局定后则有常当且仅当同行可续»` 2612, `«同行遍后则有常»` 2607, `«同行当且仅当有常»` 2619, `«类同行遍后则含于核»` 2625, `«遍后则其内同行之类含于核»` 2637, `«定后遍后则核为其内最粗同行之类»` 2643 (`total : ∀ x, ∃ y, R x y`).
- Runs: `«或有后则或迭»` 1258 (successors, double-negated, give n steps), `«不穷则迭»` 1274, `«遍后则有线»` 1577, `«有限遍后定前则皆返»` 1703, `«有限遍后定后则定前当且仅当皆返»` 1736, `«有后不返则入»` 1522, `«定后于有后则入当且仅当不返»` 1527, `«定后有后则入当且仅当不返»` 1534.
- Stages: `GrammarLaws.onward_within` 2365 (no ending in a stretch gives k steps up to the stretch's bound), `GrammarLaws.trace_on` 2419 (ending or successor decided).

### (4) Going alike restricted to a region or up to an end

- No law here states `«同行»` restricted to a region (no "同行 within P" or "同行 at what x reaches"). The localisations in the file are of the other hypotheses: the fixed successor (`«有常局定后则同行»`'s `fixed` only where E leads; `«定后于»` within a closure; `«线不并»` on a line's places; the "fixed where lines part" hypotheses), and availability (`onward` in `«同行可续则有常»`, only where E leads from one that has a successor).
- "Up to an end": `«同行»` itself already is going alike up to the end, since it says nothing once one of the pair has no successor (pointwise form, 2571), and `«同行之迭»` (2677) keeps E-alike exactly for as many steps as **both** lines take (both n-step lines are premises). So no separate "going alike up to an end" is needed; restating one would duplicate `«同行»`.
- Outside my file, the root's constancy up to an end is `«至终有常»` (GrammarPath.lean 222, definition: `∀ u u', E u u' → ∀ v, R u v → (∃ v', R u' v' ∧ E v v') ∨ ∀ w, ¬ R u' w`) with `«有常则至终有常»` after it. I only read those lines.
- Region-bounded stretches exist in the stage laws: `quiet` hypotheses over `[N, U)` and `GrammarLaws.onward_within` give steps "up to U" in a region closed forward with nothing ending there.

### (5) Lines from alike occurrences have equal length; the core keeps n steps

- No law in this file says lines from alike occurrences have equal length, or that if one has n steps the alike one has n steps. `«同行之迭»` assumes both n-step lines. The header itself lists as not shown (line 215) "the n-step lines law for lines of different lengths".
- No law here says the core (or any constant relation) keeps n steps (`«有常» R S → «有常» («迭» R n) S`, or "core-related u u' and n steps from u give n steps from u' core-related"). I searched the whole package folder for `«有常» («迭»`, `«有常» («历»`, `«核» («迭»`, `有常之迭`, `核之迭`: no match. The second reader of the held attempt said the same of `core_steps`.
- Nearest: `«同行于迭»` (going alike lifts to n steps); `«迭之定于»`/`«迭之定»` (n steps lead to one place); `«亡者不在长迭»` and `«定后则线至多一亡»` (one line, one length); `«亡于核下不变»` (Grammar.lean 523, not my file: for a class, ending is not told apart by the core, one step).

## Against the held attempt (tmp/r7/the-loop/lean/Becoming/TurningInTime.lean)

- `alike_steps` (TurningInTime 137) is `«同行之迭»` (GrammarLaws 2677) up to variable names: the same statement (`«同行» R E → ∀ n {u u' v v'}, E u u' → «迭» R n u v → «迭» R n u' v' → E v v'`). Also `«同行于迭»` (2684) as a relation-level form.
- `not_constant` (131) is a one-call contrapositive of `«有常则可续»` (2592). With the class going alike it is also the reverse half of `«局定后则有常当且仅当同行可续»` (2612).
- `core_step` (109) is the pointwise form of `(«根» R E).2.1` through `«有常之逐点»` (Grammar.lean); no law of my file states it.
- `core_steps` (114): not in my file and not found in the package by the search above. Its natural general form, constancy carried to n steps, is not stated anywhere I searched. It is provable from `«迭»` (1124) by induction or as a case of a 历 law (no 历 law for constancy exists; `«同行之历»` is the going-alike one).
- `core_apart` (126): not in my file (the reader points to `«亡于核下不变»`, Grammar.lean 523).
- The course part (`Course`, `steps_iff`, `never_ends_iff`, `falls`, `gone`, `ends_below_least_use`): `ends_below_least_use`'s conclusion uses what `«迭内»` (1176) names, as the reader says; `never_ends_iff` is at `«不穷»` (Grammar.lean 243), whose step form is `«不穷则迭»` (1274); "falls then gone" is what `«尽则不屡»` (1792) says in the grammar, if the course's level drop is read as `F` under `Q` with `«尽»` shown from the level being a whole number. I did not check whether the attempt's proofs could be replaced by those calls.

## Not read or not settled

- Proof bodies were read for the Closure, Runs, Lumping and Order sections and for the census laws at 1942-1995; for the Stages section and `census_run` only the statements were read closely, not every proof line.
- Lines 370-1054 (list helpers, balance, counting) were read only by name and the two class-count laws; I judged they do not bear on (a)-(d).
- Grammar.lean, GrammarMap.lean, GrammarPath.lean and Amounts.lean: only the lines quoted above. Whether `«尽»` at the course's relation follows from a whole-number level, and how `Amounts.rests` instantiates `«尽则不屡»`, I did not check.
- The empty-axiom claim of the header (line 221) was not checked (it needs a build).
- I did not check whether every docstring matches its statement in the Stages section line by line. Where I checked (Closure, Runs, Lumping, Order) I found none claiming more than the statement. Two docstrings say a little less: `«同行之迭»`'s "keeps lines of every length alike" leaves unsaid that both lines are assumed to exist (the statement does assume it); the header's sentence on 定后于 laws is accurate.
