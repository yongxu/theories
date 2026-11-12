Kept as written; local paths in it point to the session's scratch folder.

AI-written map, 12 November 2026

# Root core: Grammar.lean and GrammarPath.lean, read against the pattern (a)-(d)

Files read in whole: `PKG/Grammar.lean` (931 lines), `PKG/GrammarPath.lean` (1481 lines), where PKG =
`/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`.
Nothing was built or run. Statements below are copied from the source; "says" is a plain gloss.
All variables `{α : Type u}` unless shown. "def" = definition, "thm" = theorem, "ind" = inductive.

## 0. Where the attempt `tmp/r7/the-loop/lean/Becoming/TurningInTime.lean` overlaps these files

- `TurningInTime.not_constant` (attempt line 131: alike `u u'`, `R u v`, `u'` has no next ⇒ `¬ «有常» R E`)
  is the same content as Grammar `«有亡之续则不有常»` (Grammar.lean:370) read at a single pair, and is the
  `E`-relative case of GrammarPath `«亡而网续则不至终有常»` (GrammarPath.lean:253) only in the reverse
  direction; its proof uses `«有常则可续»`, which is in GrammarLaws.lean:2592, not in my files.
  Precisely: Grammar's form needs `«续» R E x y` and `«亡» R E y` (no `E`-alike next); the attempt's needs
  `E u u'` and `R u v` with `u'` having no `R`-next at all. They are not literally the same statement but
  each is an immediate instance of `«有常之逐点»` (Grammar.lean:343).
- `TurningInTime.core_step` (attempt line 109) is `(«有常之逐点» R («核» R E)).mp («根» R E).2.1`, i.e. the
  second conjunct of `«根»` (Grammar.lean:380) through `«有常之逐点»` (Grammar.lean:343). Nothing new.
- `TurningInTime.core_apart` (attempt line 126: what goes on and what has no next are apart in the core)
  is, for the special case "u' has no R-next", a pairwise relative of `«亡于核下不变»` (Grammar.lean:523:
  ending under E is invariant under the core). `«亡于核下不变»` is stronger in respect (ending under `E`,
  i.e. no `E`-alike next) and needs `«类» E`; `core_apart` needs no class and speaks of `R` alone.
  `core_apart` follows from `«根»`.2.1 directly; it is not stated in my files as such.
- `TurningInTime.core_steps`, `alike_steps` use `«迭»` and `«同行»`, both defined in GrammarLaws.lean
  (lines 1124, 2568), not in my files. My files contain no `n`-step law and no `«同行»`.
- The attempt's gap "a class goes alike but is not constant" is named in my files as constancy up to the
  net's end, `«至终有常»` (GrammarPath.lean:222), as the second reader said.

## 1. Inventory

### Grammar.lean: operations (lines 46-113)

| name | kind, line | exact statement | says |
|---|---|---|---|
| `«际»` | abbrev 47 | `abbrev «际» (α : Type u) : Type u := α → α → Prop` | a relation on a carrier |
| `«而»` | def 54 | `def «而» (R S : «际» α) : «际» α := fun x z => ∃ y, R x y ∧ S y z` | composition, first R then S |
| `«逆»` | def 57 | `def «逆» (R : «际» α) : «际» α := fun x y => R y x` | converse |
| `«则»` | def 60 | `def «则» (R S : «际» α) : Prop := ∀ x y, R x y → S x y` | inclusion |
| `«谓»` | def 63 | `def «谓» (R S : «际» α) : Prop := ∀ x y, R x y ↔ S x y` | pointwise equivalence |
| `«合»` | def 66 | `def «合» (R S : «际» α) : «际» α := fun x y => R x y ∧ S x y` | meet |
| `«一»` | def 69 | `def «一» : «际» α := fun _ _ => True` | full relation |
| `«静»` | def 72 | `def «静» : «际» α := fun x y => x = y` | identity (carrier equality) |
| `«非»` | def 75 | `def «非» (R : «际» α) : «际» α := fun x y => ¬ R x y` | complement |
| `«及»` | ind 78 | `inductive «及» (R : «际» α) : «际» α \| one {x y : α} : R x y → «及» R x y \| more {x y z : α} : R x y → «及» R y z → «及» R x z` | transitive closure (reach) |
| `«类»` | structure 84 | `structure «类» (E : «际» α) : Prop where refl : ∀ x, E x x; symm : ∀ {x y}, E x y → E y x; trans : ∀ {x y z}, E x y → E y z → E x z` | equivalence relation (a class) |
| `«则之自反»` | thm 89 | `theorem «则之自反» (R : «际» α) : «则» R R` | inclusion reflexive |
| `«则之传递»` | thm 91 | `theorem «则之传递» {R S T : «际» α} (h₁ : «则» R S) (h₂ : «则» S T) : «则» R T` | inclusion transitive |
| `«及之传递»` | thm 94 | `theorem «及之传递» {R : «际» α} {x y z : α} (h₁ : «及» R x y) (h₂ : «及» R y z) : «及» R x z` | reach transitive |
| `«及之首步»` | thm 101 | `theorem «及之首步» {R : «际» α} {x y : α} (h : «及» R x y) : ∃ w, R x w` | a reach begins with a step |
| `«及之单调»` | thm 106 | `theorem «及之单调» {R S : «际» α} (h : «则» R S) : «则» («及» R) («及» S)` | reach monotone |
| `«一为类»` | thm 112 | `theorem «一为类» : «类» («一» : «际» α)` | the full relation is a class |

### Grammar.lean: continuation (lines 117-328)

| name | kind, line | exact statement | says |
|---|---|---|---|
| `«续»` | def 126 | `def «续» (R E : «际» α) : «际» α := «合» R E` | y continues x under E: `R x y` and `E x y` |
| `«相续»` | def 129 | `def «相续» (R E : «际» α) : «际» α := «及» («续» R E)` | a line: reach of continuation |
| `«有前»` | def 132 | `def «有前» (R E : «际» α) (y : α) : Prop := ∃ x, «续» R E x y` | y has an E-alike condition |
| `«有后»` | def 135 | `def «有后» (R E : «际» α) (x : α) : Prop := ∃ y, «续» R E x y` | x conditions something E-alike to it |
| `«生»` | def 138 | `def «生» (R E : «际» α) (y : α) : Prop := ¬ «有前» R E y` | begins: no E-alike condition |
| `«亡»` | def 141 | `def «亡» (R E : «际» α) (x : α) : Prop := ¬ «有后» R E x` | ends: conditions nothing E-alike to it (it may still condition something unalike) |
| `«住»` | def 144 | `def «住» (R E : «际» α) (x : α) : Prop := «有前» R E x ∧ «有后» R E x` | abides |
| `«异»` | def 147 | `def «异» (R E F : «际» α) : «际» α := fun x y => «续» R E x y ∧ ¬ F x y` | alteration: continues under E while F tells them apart (F need not be finer by the definition; the docstring says "finer") |
| `«复生»` | def 152 | `def «复生» (R E : «际» α) (x : α) : Prop := ∃ y, R x y ∧ «生» R E y ∧ «有后» R E y` | x conditions a beginning under E that goes on one step |
| `«续含于缘»` | thm 155 | `theorem «续含于缘» (R E : «际» α) : «则» («续» R E) R` | continuation is inside R |
| `«相续含于及»` | thm 158 | `theorem «相续含于及» (R E : «际» α) : «则» («相续» R E) («及» R)` | a line is inside reach of R |
| `«一之续»` | thm 162 | `theorem «一之续» (R : «际» α) : «谓» («续» R «一») R` | under the one, continuation is R |
| `«粗化»` | thm 166 | `theorem «粗化» (R : «际» α) {E E' : «际» α} (h : «则» E E') : «则» («续» R E) («续» R E')` | coarser class keeps every continuation |
| `«亡于粗则亡于细»` | thm 170 | `theorem «亡于粗则亡于细» (R : «际» α) {E E' : «际» α} (h : «则» E E') {x : α} (hx : «亡» R E' x) : «亡» R E x` | ending under coarser ⇒ ending under finer |
| `«住于细则住于粗»` | thm 175 | `theorem «住于细则住于粗» (R : «际» α) {E E' : «际» α} (h : «则» E E') {x : α} (hx : «住» R E x) : «住» R E' x` | abiding under finer ⇒ under coarser |
| `«亡于细者不必亡于粗»` | thm 182 | `theorem «亡于细者不必亡于粗» : ∃ (α : Type) (R E E' : «际» α) (x : α), «则» E E' ∧ «亡» R E x ∧ ¬ «亡» R E' x` | witness (Bool, identity vs one): ending under finer does not give ending under coarser |
| `«四相之定当且仅当排中»` | thm 191 | `theorem «四相之定当且仅当排中» : (∀ (α : Type) (R E : «际» α) (x : α), «生» R E x ∨ «有前» R E x) ↔ ∀ P : Prop, P ∨ ¬ P` | deciding positions everywhere is excluded middle |
| `«分叉»` | thm 205 | `theorem «分叉» : ∃ (α : Type) (R : «际» α) (a b c : α), «相续» R «一» a b ∧ «相续» R «一» a c ∧ ¬ «相续» R «一» b c ∧ ¬ «相续» R «一» c b ∧ b ≠ c` | fission witness |
| `«无环»` | def 221 | `def «无环» (R : «际» α) : Prop := ∀ x, ¬ «及» R x x` | no cycles |
| `«无环则及为序»` | thm 224 | `theorem «无环则及为序» {R : «际» α} (h : «无环» R) : (∀ x, ¬ «及» R x x) ∧ (∀ {x y z}, «及» R x y → «及» R y z → «及» R x z) ∧ (∀ {x y}, «及» R x y → ¬ «及» R y x)` | acyclic ⇒ reach is a strict order |
| `«同族»` | ind 232 | `inductive «同族» (R E : «际» α) : «际» α \| refl (x : α) : «同族» R E x x \| step {x y : α} : «续» R E x y → «同族» R E x y \| symm ... \| trans ...` | equivalence closure of continuation |
| `«同族为类»` | thm 238 | `theorem «同族为类» (R E : «际» α) : «类» («同族» R E)` | family is a class |
| `«不穷»` | def 243 | `def «不穷» (R E : «际» α) (x : α) : Prop := ∀ y, (x = y ∨ «相续» R E x y) → «有后» R E y` | every occurrence on the line from x (x included) has an E-alike next |
| `«一之生»` | thm 247 | `theorem «一之生» (R : «际» α) (y : α) : «生» R «一» y ↔ ∀ x, ¬ R x y` | under the one, begins = unconditioned |
| `«一之下无复生»` | thm 251 | `theorem «一之下无复生» (R : «际» α) (x : α) : ¬ «复生» R «一» x` | no renewal under the one |
| `«生生»` | def 259 | `def «生生» (R E : «际» α) (x : α) : Prop := ∃ S : α → Prop, (∀ z, S z → ∃ y w, R z y ∧ «生» R E y ∧ «相续» R E y w ∧ S w) ∧ S x` | x in some family each member of which conditions a beginning whose line reaches a member again (coinductive / greatest) |
| `«生生之展»` | thm 264 | `theorem «生生之展» {R E : «际» α} {x : α} (h : «生生» R E x) : ∃ y w, R x y ∧ «生» R E y ∧ «相续» R E y w ∧ «生生» R E w` | unfold 生生 one step |
| `«生生最大»` | thm 272 | `theorem «生生最大» {R E : «际» α} {S : α → Prop} (hS : ∀ z, S z → ∃ y w, R z y ∧ «生» R E y ∧ «相续» R E y w ∧ S w) {x : α} (hx : S x) : «生生» R E x` | greatest family |
| `«生生则复生»` | thm 278 | `theorem «生生则复生» {R E : «际» α} {x : α} (h : «生生» R E x) : «复生» R E x` | 生生 ⇒ 复生 |
| `«一之下无生生»` | thm 284 | `theorem «一之下无生生» (R : «际» α) (x : α) : ¬ «生生» R «一» x` | no 生生 under the one |
| `«生住不并»` | thm 289 | `theorem «生住不并» {R E : «际» α} {x : α} : ¬ («生» R E x ∧ «住» R E x)` | begins excludes abides |
| `«住亡不并»` | thm 293 | `theorem «住亡不并» {R E : «际» α} {x : α} : ¬ («住» R E x ∧ «亡» R E x)` | abides excludes ends |
| `«四相俱时»` | thm 300 | `theorem «四相俱时» {R : «际» α} {x y z : α} (nr : ¬ R y y) (hxy : R x y) (hyz : R y z) : «生» R «静» y ∧ «亡» R «静» y ∧ «住» R «一» y ∧ «异» R «一» «静» y z` | one occurrence holds all four positions, relative to class |
| `«四相无自立»` | thm 311 | `theorem «四相无自立» {R : «际» α} (irr : ∀ z, ¬ R z z) {x y z : α} (hxy : R x y) (hyz : R y z) : «住» R «一» y ∧ «生» R «静» y ∧ «亡» R «静» y` | three of the four, without self-conditioning |
| `«任一缘可为续»` | thm 318 | `theorem «任一缘可为续» {R : «际» α} {x y : α} (h : R x y) : ∃ E : «际» α, «类» E ∧ «续» R E x y` | any R-step is a continuation under some class |
| `«蜡烛之合»` | thm 326 | `theorem «蜡烛之合» {R E : «际» α} {a c b : α} (ha : R a b) (hc : R c b) (ea : E a b) (ec : E c b) : «续» R E a b ∧ «续» R E c b` | merge (two candles); trivial pairing |

### Grammar.lean: constancy and core (lines 332-446)

| name | kind, line | exact statement | says |
|---|---|---|---|
| `«有常»` | def 340 | `def «有常» (R E : «际» α) : Prop := «则» («而» («逆» E) R) («而» R («逆» E))` | E constant under R: `E˘;R ⊆ R;E˘` |
| `«有常之逐点»` | thm 343 | `theorem «有常之逐点» (R E : «际» α) : «有常» R E ↔ ∀ u u', E u u' → ∀ v, R u v → ∃ v', R u' v' ∧ E v v'` | pointwise: whatever an E-mate's step reaches, u' reaches something E-alike (forward simulation; E need not be a class) |
| `«有常则续不尽»` | thm 356 | `theorem «有常则续不尽» {R E : «际» α} (h : «有常» R E) {y : α} (hy : «有前» R E y) : «有后» R E y` | under constancy, what has a predecessor has a successor |
| `«有常则相续不尽»` | thm 363 | `theorem «有常则相续不尽» {R E : «际» α} (h : «有常» R E) {x y : α} (hxy : «相续» R E x y) : «有后» R E y` | under constancy no line ends after its first step |
| `«有亡之续则不有常»` | thm 370 | `theorem «有亡之续则不有常» {R E : «际» α} {x y : α} (hxy : «续» R E x y) (hy : «亡» R E y) : ¬ «有常» R E` | a class under which some line ends is not constant |
| `«核»` | def 375 | `def «核» (R E : «际» α) : «际» α := fun u u' => ∃ S : «际» α, «则» S E ∧ «则» S («逆» S) ∧ «有常» R S ∧ S u u'` | core: related by some symmetric constant relation inside E |
| `«根»` | thm 380 | `theorem «根» (R E : «际» α) : «则» («核» R E) E ∧ «有常» R («核» R E) ∧ «则» («核» R E) («逆» («核» R E)) ∧ ∀ S, «则» S E → «则» S («逆» S) → «有常» R S → «则» S («核» R E)` | the core is the greatest symmetric constant relation inside E |
| `«有常可复合»` | thm 391 | `theorem «有常可复合» {R S₁ S₂ : «际» α} (h₁ : «有常» R S₁) (h₂ : «有常» R S₂) : «有常» R («而» S₁ S₂)` | constant relations compose |
| `«静有常»` | thm 401 | `theorem «静有常» (R : «际» α) : «有常» R «静»` | identity is constant |
| `«核为类»` | thm 406 | `theorem «核为类» (R : «际» α) {E : «际» α} (hE : «类» E) : «类» («核» R E)` | core of a class is a class |
| `«闭合当且仅当有常»` | thm 436 | `theorem «闭合当且仅当有常» (R : «际» α) {E : «际» α} (hE : «类» E) : «有常» R E ↔ «则» («而» («而» E R) E) («而» R E)` | for a class, constancy = closure of the coarse net (`E;R;E ⊆ R;E`); bisimulation/lumpability correspondence is stated in the docstring as "not proved here" |

### Grammar.lean: grains (lines 450-480)

| name | kind, line | exact statement | says |
|---|---|---|---|
| `«类内之缘成环»` | thm 456 | `theorem «类内之缘成环» {R L : «际» α} (hL : «类» L) {x y : α} (h : R x y) (l : L x y) : «而» («而» L R) L x x ∧ «而» («而» L R) L y y` | an R inside a class is a loop at the class grain |
| `«粗»` | def 463 | `def «粗» (R L : «际» α) : «际» α := «而» («而» L («合» R («非» L))) L` | coarse net: R between different L-classes |
| `«粗只连异类»` | thm 466 | `theorem «粗只连异类» {R L : «际» α} (hL : «类» L) {x z : α} (h : «粗» R L x z) : ¬ L x z` | coarse net joins only different classes |
| `«粗复生»` | def 474 | `def «粗复生» (L R E : «际» α) (x : α) : Prop := ∃ y, «而» L R x y ∧ «生» R E y ∧ «有后» R E y` | renewal at the grain of L |
| `«复生则粗复生»` | thm 478 | `theorem «复生则粗复生» {L R E : «际» α} (hL : «类» L) {x : α} (h : «复生» R E x) : «粗复生» L R E x` | renewal ⇒ coarse renewal |

### Grammar.lean: position (two-way core) (lines 484-565)

| name | kind, line | exact statement | says |
|---|---|---|---|
| `«位核»` | def 492 | `def «位核» (R E : «际» α) : «际» α := fun u u' => ∃ S : «际» α, «则» S E ∧ «则» S («逆» S) ∧ «有常» R S ∧ «有常» («逆» R) S ∧ S u u'` | two-way core (forward and backward constant) |
| `«位根»` | thm 496 | `theorem «位根» (R E : «际» α) : «则» («位核» R E) E ∧ «有常» R («位核» R E) ∧ «有常» («逆» R) («位核» R E) ∧ «则» («位核» R E) («逆» («位核» R E)) ∧ ∀ S, «则» S E → «则» S («逆» S) → «有常» R S → «有常» («逆» R) S → «则» S («位核» R E)` | greatest such |
| `«位核含于核»` | thm 513 | `theorem «位核含于核» (R E : «际» α) : «则» («位核» R E) («核» R E)` | two-way core ⊆ core |
| `«位核含于逆核»` | thm 518 | `theorem «位核含于逆核» (R E : «际» α) : «则» («位核» R E) («核» («逆» R) E)` | two-way core ⊆ converse core |
| `«亡于核下不变»` | thm 523 | `theorem «亡于核下不变» {R E : «际» α} (hE : «类» E) {y y' : α} (hk : «核» R E y y') (hy : «亡» R E y) : «亡» R E y'` | for a class E, ending under E is invariant along the core |
| `«生于逆核下不变»` | thm 534 | `theorem «生于逆核下不变» {R E : «际» α} (hE : «类» E) {y y' : α} (hk : «核» («逆» R) E y y') (hy : «生» R E y) : «生» R E y'` | beginning invariant along the converse core |
| `«生于位核下不变»` | thm 544 | `theorem «生于位核下不变» {R E : «际» α} (hE : «类» E) {y y' : α} (hk : «位核» R E y y') (hy : «生» R E y) : «生» R E y'` | beginning invariant along the two-way core |
| `«位同则生亡同»` | thm 551 | `theorem «位同则生亡同» {R E : «际» α} (hE : «类» E) {y y' : α} (hk : «位核» R E y y') : («生» R E y → «生» R E y') ∧ («亡» R E y → «亡» R E y')` | beginning and ending read off the two-way core |
| `«位同则住同»` | thm 558 | `theorem «位同则住同» {R E : «际» α} (hE : «类» E) {y y' : α} (hk : «位核» R E y y') (hy : «住» R E y) : «住» R E y'` | abiding too |

### Grammar.lean: sufficing (lines 569-683)

| name | kind, line | exact statement | says |
|---|---|---|---|
| `«自持»` | def 575 | `def «自持» (R E : «际» α) : Prop := «有常» R E` | holding by itself = constant (alias) |
| `«相须»` | def 579 | `def «相须» (R E₁ E₂ : «际» α) : Prop := «有常» R («合» E₁ E₂) ∧ ¬ «有常» R E₁ ∧ ¬ «有常» R E₂` | mutual need via constancy |
| `«因于»` | def 582 | `def «因于» (R E₁ E₂ : «际» α) : Prop := «有常» R («合» E₁ E₂) ∧ «有常» R E₂ ∧ ¬ «有常» R E₁` | leaning on via constancy |
| `«有常之同谓»` | thm 585 | `theorem «有常之同谓» {R E E' : «际» α} (h : «谓» E E') (hc : «有常» R E) : «有常» R E'` | constancy respects pointwise equality of classes |
| `«相须之对称»` | thm 590 | `theorem «相须之对称» {R E₁ E₂ : «际» α} (h : «相须» R E₁ E₂) : «相须» R E₂ E₁` | symmetric |
| `«无自相须»` | thm 594 | `theorem «无自相须» {R E : «际» α} : ¬ «相须» R E E` | nothing needs itself |
| `«核之单调»` | thm 598 | `theorem «核之单调» (R : «际» α) {E E' : «际» α} (h : «则» E E') : «则» («核» R E) («核» R E')` | core monotone in the class |
| `«类有常当且仅当含于核»` | thm 602 | `theorem «类有常当且仅当含于核» (R : «际» α) {E : «际» α} (hE : «类» E) : «有常» R E ↔ «则» E («核» R E)` | a class is constant iff it is inside its core |
| `«足以定核»` | def 612 | `def «足以定核» (R E₁ E₂ : «际» α) : Prop := «则» («合» E₁ E₂) («核» R E₁)` | E₂ suffices for E₁'s regularity: alike under both ⇒ alike under E₁'s core |
| `«因于核»` | def 615 | `def «因于核» (R E₁ E₂ : «际» α) : Prop := «足以定核» R E₁ E₂ ∧ ¬ «有常» R E₁` | E₁'s regularity lies in E₂ |
| `«相须核»` | def 618 | `def «相须核» (R E₁ E₂ : «际» α) : Prop := «足以定核» R E₁ E₂ ∧ «足以定核» R E₂ E₁ ∧ ¬ «有常» R E₁ ∧ ¬ «有常» R E₂` | mutual need through the core |
| `«合有常则足以定核»` | thm 623 | `theorem «合有常则足以定核» (R : «际» α) {E₁ E₂ : «际» α} (h₁ : «类» E₁) (h₂ : «类» E₂) (hc : «有常» R («合» E₁ E₂)) : «足以定核» R E₁ E₂ ∧ «足以定核» R E₂ E₁` | constant joint class ⇒ each suffices for the other |
| `«因于则因于核»` | thm 633 | `theorem «因于则因于核» (R : «际» α) {E₁ E₂ : «际» α} (h₁ : «类» E₁) (h₂ : «类» E₂) (h : «因于» R E₁ E₂) : «因于核» R E₁ E₂` | 因于 ⇒ 因于核 |
| `«相须则相须核»` | thm 638 | `theorem «相须则相须核» (R : «际» α) {E₁ E₂ : «际» α} (h₁ : «类» E₁) (h₂ : «类» E₂) (h : «相须» R E₁ E₂) : «相须核» R E₁ E₂` | 相须 ⇒ 相须核 |
| `«复生至»` | def 646 | `def «复生至» (R E : «际» α) (x w : α) : Prop := ∃ y, R x y ∧ «生» R E y ∧ «相续» R E y w` | x renews into w |
| `«息»` | ind 654 | `inductive «息» (R E : «际» α) : α → Prop \| mk {x : α} : (∀ w, «复生至» R E x w → «息» R E w) → «息» R E x` | ceasing: least property closed under 复生至 (well-founded) |
| `«生生不息»` | thm 660 | `theorem «生生不息» {R E : «际» α} {x : α} (h : «生生» R E x) : ¬ «息» R E x` | 生生 excludes 息 |
| `«自不复生则息»` | thm 671 | `theorem «自不复生则息» {R E : «际» α} {x : α} (h : ¬ «复生» R E x) : «息» R E x` | not renewing ⇒ ceases |
| `«不复生则息»` | thm 677 | `theorem «不复生则息» {R E : «际» α} {x : α} (none : ∀ y, (x = y ∨ «相续» R E x y) → ¬ «复生» R E y) : «息» R E x` | old reading ⇒ new |
| `«一之下皆息»` | thm 682 | `theorem «一之下皆息» (R : «际» α) (x : α) : «息» R «一» x` | under the one all cease |

### Grammar.lean: lines (lines 687-733)

| name | kind, line | exact statement | says |
|---|---|---|---|
| `«两端分则中有标»` | thm 697 | `theorem «两端分则中有标» {R E K P : «际» α} (split : ∀ x y, «续» R E x y → K x y ∨ P x y) (trans : ∀ {a b c}, K a b → K b c → K a c) {x y : α} (line : «相续» R E x y) : ¬ K x y → ∃ u v, «续» R E u v ∧ P u v ∧ (x = u ∨ «相续» R E x u) ∧ (v = y ∨ «相续» R E v y)` | if every step keeps K or bears mark P, and K is transitive, a line whose ends K does not relate has a P-step placed on it |
| `«线内同类»` | thm 718 | `theorem «线内同类» {R E : «际» α} (hE : «类» E) {x y : α} (line : «相续» R E x y) : E x y` | a line's ends are alike |
| `«生于细而续于粗则异»` | thm 725 | `theorem «生于细而续于粗则异» {R E F : «际» α} {x y : α} (begins : «生» R F y) (continues : «续» R E x y) : «异» R E F x y` | beginning under F and continuing under E is alteration (no finer/coarser premise in the statement) |
| `«生于粗则生于细»` | thm 731 | `theorem «生于粗则生于细» (R : «际» α) {E E' : «际» α} (h : «则» E E') {y : α} (begins : «生» R E' y) : «生» R E y` | beginning under coarser ⇒ under finer |

### Grammar.lean: the flame and two flames (lines 737-929)

| name | kind, line | exact statement | says |
|---|---|---|---|
| `Flame` | ind 740 | `inductive Flame \| f₀ \| f₁ \| f₂ \| ash` | four moments |
| `Flame.step` | def 745 | f₀→f₁, f₁→f₂, f₂→ash, ash→nothing (by `casesOn`) | each moment conditions the next |
| `Flame.burns` | def 752 | `f₀,f₁,f₂ ↦ true; ash ↦ false` | |
| `Flame.alike` | def 759 | `def alike : «际» Flame := fun x y => burns x = burns y` | flame or not |
| `Flame.alike_class` | thm 761 | `theorem alike_class : «类» alike` | |
| `Flame.not_core_f₁` | thm 764 | `theorem not_core_f₁ {S : «际» Flame} (hSE : «则» S alike) (hs : «则» S («逆» S)) (hc : «有常» step S) (h : S f₁ f₂) : False` | f₁,f₂ not in any symmetric constant S ⊆ alike |
| `Flame.not_core_f₀` | thm 775 | `theorem not_core_f₀ {S : «际» Flame} (hSE : «则» S alike) (hs : «则» S («逆» S)) (hc : «有常» step S) (h : S f₀ f₁) : False` | nor f₀,f₁ |
| `«以核为判据则火无续»` | thm 791 | `theorem «以核为判据则火无续» : «续» Flame.step Flame.alike Flame.f₀ Flame.f₁ ∧ «续» Flame.step Flame.alike Flame.f₁ Flame.f₂ ∧ ∀ x y, ¬ «续» Flame.step («核» Flame.step Flame.alike) x y` | the flame continues under "flame or not", but under its core nothing continues |
| `Flame.fuel` | def 806 | `f₀ ↦ 2, f₁ ↦ 1, f₂ ↦ 0, ash ↦ 0` | fuel left (a Nat, but used only through equality) |
| `Flame.sameFuel` | def 813 | `def sameFuel : «际» Flame := fun x y => fuel x = fuel y` | |
| `Flame.joint_eq` | thm 817 | `theorem joint_eq {x y : Flame} (h : «合» alike sameFuel x y) : x = y` | the joint class is identity |
| `«火薪相须»` | thm 832 | `theorem «火薪相须» : «相须核» Flame.step Flame.alike Flame.sameFuel` | flame-or-not and same-fuel need each other through the core; proved because the joint class is identity |
| `«火之见证不择类»` | thm 849 | `theorem «火之见证不择类» {E₂ : «际» Flame} (apart : «则» («合» Flame.alike E₂) «静») : «足以定核» Flame.step Flame.alike E₂` | any E₂ that with alike separates all moments suffices; the witness picks no class |
| `TwoFlames` | abbrev 856 | `abbrev TwoFlames : Type := Bool × Flame` | |
| `TwoFlames.step` | def 861 | `def step : «际» TwoFlames := fun x y => x.1 = y.1 ∧ Flame.step x.2 y.2` | |
| `TwoFlames.alike`, `.sameFuel`, `.sameFlame` | defs 864, 867, 870 | `fun x y => Flame.alike x.2 y.2`; `fun x y => Flame.sameFuel x.2 y.2`; `fun x y => x.1 = y.1` | |
| `«两火以薪定理»` | thm 878 | `theorem «两火以薪定理» : «足以定核» TwoFlames.step TwoFlames.alike TwoFlames.sameFuel ∧ «合» TwoFlames.alike TwoFlames.sameFuel (true, Flame.f₀) (false, Flame.f₀) ∧ (true, Flame.f₀) ≠ ((false, Flame.f₀) : TwoFlames)` | in two flames fuel suffices, and the joint class relates two distinct occurrences |
| `«两火同火不足以定理»` | thm 892 | `theorem «两火同火不足以定理» : ¬ «足以定核» TwoFlames.step TwoFlames.alike TwoFlames.sameFlame` | same-flame does not suffice |
| `«两火火薪相须»` | thm 911 | `theorem «两火火薪相须» : «相须核» TwoFlames.step TwoFlames.alike TwoFlames.sameFuel ∧ «合» TwoFlames.alike TwoFlames.sameFuel (true, Flame.f₀) (false, Flame.f₀) ∧ (true, Flame.f₀) ≠ ((false, Flame.f₀) : TwoFlames)` | mutual need holds where the joint class is not identity |

### GrammarPath.lean (imports Grammar, GrammarMap, GrammarCrossing)

Used from other files (not mine): `«所及»` (GrammarMap.lean:69, `def «所及» (R L : «际» α) (x y : α) : Prop := x = y ∨ «相续» R L x y`), `«所及之传递»` (GrammarMap.lean:71), `«定则内至外之线有出步»` (GrammarCrossing.lean:159), `«有常则可续»` (GrammarLaws.lean:2592, `(constant : «有常» R E) : ∀ u u' v, E u u' → R u v → ∃ v', R u' v'`, reached transitively).

| name | kind, line | exact statement | says |
|---|---|---|---|
| `«所经必同»` | thm 127 | `theorem «所经必同» {R E : «际» α} (hE : «类» E) {P : α → Bool} {C : α → Prop} (exits : ∀ u v, P u = true → «续» R E u v → P v = false → C v) {x y : α} (inside : P x = true) (outside : P y = false) (reached : «所及» R E x y) : ∃ c, C c ∧ E x c ∧ «所及» R E x c` | a line leaving a decided region under E holds a member of the exit set C, alike to its start, on the line |
| `«所经不同则不及»` | thm 149 | `theorem «所经不同则不及» {R E : «际» α} (hE : «类» E) {P : α → Bool} {C : α → Prop} (exits : ∀ u v, P u = true → «续» R E u v → P v = false → C v) {x y : α} (inside : P x = true) (outside : P y = false) (apart : ∀ c, C c → ¬ E x c) : ¬ «所及» R E x y` | if no exit is alike to the start, nothing outside is reached |
| `«所缘同于»` | def 159 | `def «所缘同于» (R E : «际» α) (m : α) : Prop := ∀ v, R m v → E m v` | E holds m's effects: everything m conditions is alike to m |
| `«后皆同类则后皆续»` | thm 164 | `theorem «后皆同类则后皆续» {R E : «际» α} (hE : «类» E) {c t : α} (all : ∀ s, «及» R c s → E c s) (down : «及» R c t) : «相续» R E c t` | everything downstream alike ⇒ on the line |
| `«后皆续当且仅当后皆同类»` | thm 175 | `theorem «后皆续当且仅当后皆同类» {R E : «际» α} (hE : «类» E) {m : α} : (∀ t, «及» R m t → «所及» R E m t) ↔ (∀ t, «及» R m t → E m t)` | reach = everything downstream alike |
| `«后皆续则所缘同于»` | thm 184 | `theorem «后皆续则所缘同于» {R E : «际» α} (hE : «类» E) {m : α} (reach : ∀ t, «及» R m t → «所及» R E m t) : «所缘同于» R E m` | reach ⇒ effects held |
| `«后皆续当且仅当自与线皆闭»` | thm 192 | `theorem «后皆续当且仅当自与线皆闭» {R E : «际» α} (hE : «类» E) {m : α} : (∀ t, «及» R m t → «所及» R E m t) ↔ «所缘同于» R E m ∧ ∀ y, «相续» R E m y → «所缘同于» R E y` | reach = m and every stage of its line hold their effects |
| `«亡而网续则后不皆续»` | thm 214 | `theorem «亡而网续则后不皆续» {R E : «际» α} (hE : «类» E) {m y : α} (line : «相续» R E m y) (ends : «亡» R E y) (goes : ∃ w, R y w) : ¬ ∀ t, «及» R m t → «所及» R E m t` | a line from m that ends while its last stage still conditions something excludes full reach |
| `«至终有常»` | def 222 | `def «至终有常» (R E : «际» α) : Prop := ∀ u u', E u u' → ∀ v, R u v → (∃ v', R u' v' ∧ E v v') ∨ ∀ w, ¬ R u' w` | constancy up to the net's end: the pointwise form of 有常 with the escape "u' conditions nothing" |
| `«有常则至终有常»` | thm 226 | `theorem «有常则至终有常» {R E : «际» α} (constant : «有常» R E) : «至终有常» R E` | |
| `«本类至终有常»` | def 235 | `def «本类至终有常» (R E : «际» α) (m : α) : Prop := ∀ u u', E m u → E m u' → ∀ v, R u v → (∃ v', R u' v' ∧ E v v') ∨ ∀ w, ¬ R u' w` | the same asked only within m's block |
| `«至终有常则本类至终有常»` | thm 239 | `theorem «至终有常则本类至终有常» {R E : «际» α} (hE : «类» E) (constant : «至终有常» R E) (m : α) : «本类至终有常» R E m` | |
| `«至终有常之逐类»` | thm 246 | `theorem «至终有常之逐类» {R E : «际» α} (hE : «类» E) : «至终有常» R E ↔ ∀ m, «本类至终有常» R E m` | |
| `«亡而网续则不至终有常»` | thm 253 | `theorem «亡而网续则不至终有常» {R E : «际» α} {x y : α} (hxy : «续» R E x y) (ends : «亡» R E y) (goes : ∃ w, R y w) : ¬ «至终有常» R E` | a line that ends at an occurrence still conditioning something (unalike) breaks 至终有常; any E |
| `«亡而网续则本类不至终有常»` | thm 264 | `theorem «亡而网续则本类不至终有常» {R E : «际» α} {m x y : α} (mx : E m x) (my : E m y) (hxy : «续» R E x y) (ends : «亡» R E y) (goes : ∃ w, R y w) : ¬ «本类至终有常» R E m` | same at m's block |
| `«本类常闭则所缘同类»` | thm 273 | `theorem «本类常闭则所缘同类» {R E : «际» α} (hE : «类» E) {m : α} (atClass : «本类至终有常» R E m) (goes : ∃ w, R m w) (held : «所缘同于» R E m) {u v : α} (alike : E u m) (step : R u v) : E v m` | |
| `«至终常闭则所缘同类»` | thm 282 | `theorem «至终常闭则所缘同类» {R E : «际» α} (hE : «类» E) (constant : «至终有常» R E) {m : α} (goes : ∃ w, R m w) (held : «所缘同于» R E m) {u v : α} (alike : E u m) (step : R u v) : E v m` | |
| `«本类常闭则后皆续»` | thm 291 | `theorem «本类常闭则后皆续» {R E : «际» α} (hE : «类» E) {m : α} (atClass : «本类至终有常» R E m) (goes : ∃ w, R m w) (held : «所缘同于» R E m) {c t : α} (alike : E c m) (down : «及» R c t) : E t m ∧ «相续» R E c t` | |
| `«至终常闭则后皆续»` | thm 305 | same with `(constant : «至终有常» R E)` in place of `atClass` | |
| `«常闭则所缘同类»` | thm 312 | `theorem «常闭则所缘同类» {R E : «际» α} (hE : «类» E) (constant : «有常» R E) {m : α} (held : «所缘同于» R E m) {u v : α} (alike : E u m) (step : R u v) : E v m` | |
| `«常闭则后皆续»` | thm 320 | `theorem «常闭则后皆续» {R E : «际» α} (hE : «类» E) (constant : «有常» R E) {m : α} (held : «所缘同于» R E m) {c t : α} (alike : E c m) (down : «及» R c t) : E t m ∧ «相续» R E c t` | |
| `«本类常闭则所及皆及»` | thm 331 | `theorem «本类常闭则所及皆及» {R E : «际» α} (hE : «类» E) {m x c t : α} (atClass : «本类至终有常» R E m) (goes : ∃ w, R m w) (held : «所缘同于» R E m) (toC : «所及» R E x c) (alike : E c m) (down : «及» R c t) : «所及» R E x t` | |
| `«至终常闭则所及皆及»` | thm 338 | same with `constant : «至终有常» R E` | |
| `«常闭则所及皆及»` | thm 346 | `theorem «常闭则所及皆及» {R E : «际» α} (hE : «类» E) (constant : «有常» R E) {m x c t : α} (held : «所缘同于» R E m) (toC : «所及» R E x c) (alike : E c m) (down : «及» R c t) : «所及» R E x t` | |
| `«本类出类随行»` | thm 355 | `theorem «本类出类随行» {R E : «际» α} (hE : «类» E) {m c u : α} (atClass : «本类至终有常» R E m) (alike : E c m) (effect : R m u) (outside : ¬ E m u) (goes : ∃ w, R c w) : ∃ x, R c x ∧ E u x ∧ ¬ E c x` | |
| `«出类随行»` | thm 367 | same with `constant : «至终有常» R E` | |
| `«本类出类随线»` | thm 376 | `theorem «本类出类随线» {R E : «际» α} (hE : «类» E) {m c u : α} (atClass : «本类至终有常» R E m) (line : «所及» R E m c) (effect : R m u) (outside : ¬ E m u) (goes : ∃ w, R c w) : ∃ x, R c x ∧ E u x ∧ ¬ E c x` | |
| `«出类随线»` | thm 387 | same with `constant : «至终有常» R E` | |
| `«出类不随则本类不至终有常»` | thm 396 | `theorem «出类不随则本类不至终有常» {R E : «际» α} (hE : «类» E) {m c u : α} (alike : E c m) (effect : R m u) (outside : ¬ E m u) (goes : ∃ w, R c w) (clean : ∀ x, R c x → ¬ E u x) : ¬ «本类至终有常» R E m` | |
| `«出类不随则不至终有常»` | thm 406 | same conclusion `¬ «至终有常» R E` | |
| `«本类常则闭当且仅当后皆同类»` | thm 414 | `theorem «本类常则闭当且仅当后皆同类» {R E : «际» α} (hE : «类» E) {m : α} (atClass : «本类至终有常» R E m) : «所缘同于» R E m ↔ ∀ t, «及» R m t → E m t` | |
| `«至终常类之闭当且仅当后皆同类»` | thm 426 | same with `constant : «至终有常» R E` | |
| `«常类之闭当且仅当后皆同类»` | thm 432 | same with `constant : «有常» R E` | |
| `«外合不失本类之常»` | thm 440 | `theorem «外合不失本类之常» {R E F : «际» α} {m : α} (coarser : ∀ x y, E x y → F x y) (same : ∀ x, F m x → E m x) (atClass : «本类至终有常» R E m) : «本类至终有常» R F m` | |
| `«外分唯系出类之同»` | thm 450 | `theorem «外分唯系出类之同» {R E F : «际» α} (hE : «类» E) (hF : «类» F) {m : α} (same : ∀ x, E m x ↔ F m x) (outside : ∀ u v v', E m u → R u v → E m v ∨ (E v v' ↔ F v v')) : «本类至终有常» R E m ↔ «本类至终有常» R F m` | |
| `«本类常当且仅当与己相随»` | thm 473 | `theorem «本类常当且仅当与己相随» {R E : «际» α} (hE : «类» E) {m : α} (goes : ∃ w, R m w) : «本类至终有常» R E m ↔ (∀ u v, E m u → R u v → ∃ w, R m w ∧ E v w) ∧ (∀ u w, E m u → R m w → (∃ v, R u v ∧ E w v) ∨ ∀ z, ¬ R u z)` | |
| `«外分唯系己出之同»` | thm 494 | (statement at 494-497; premises `same`, `goes`, `own : ∀ w x, R m w → E m w ∨ (E w x ↔ F w x)`; conclusion `«本类至终有常» R E m ↔ «本类至终有常» R F m`) | |
| `«闭则外分无关»` | thm 523 | `... (same : ∀ x, E m x ↔ F m x) (goes : ∃ w, R m w) (held : «所缘同于» R E m) (atClass : «本类至终有常» R E m) : «本类至终有常» R F m ∧ «所缘同于» R F m` | |
| `«二分»` | def 531 | `def «二分» (P : α → Bool) : «际» α := fun x y => P x = P y` | split class |
| `«二分为类»` | thm 534 | `theorem «二分为类» (P : α → Bool) : «类» («二分» P)` | |
| `«异三则同»` | thm 537 | `theorem «异三则同» : ∀ {a b c : Bool}, ¬ a = c → ¬ b = c → b = a` | Bool helper |
| `«本类之常至二分»` | thm 548 | `theorem «本类之常至二分» {R E : «际» α} (hE : «类» E) {P : α → Bool} {m : α} (decides : ∀ x, E m x ↔ P x = P m) (atClass : «本类至终有常» R E m) : «本类至终有常» R («二分» P) m` | |
| `«二分本类常当且仅当内外皆随»` | thm 563 | (lines 563-567) | |
| `«内外皆缘则二分本类常»` | thm 590 | (lines 590-593) | |
| witnesses | namespaces | `Unclosed` (603), `Inconstant` (671), `FiniteFamilies` (723), `FiniteSharedCondition` (816), `CleanStep` (952), `FiniteWake` (1015), `FinerOutside` (1091), `FinerWake` (1169), `UnevenOutside` (1277), `OtherLeaves` (1382) | finite witnesses; FiniteFamilies and FiniteSharedCondition use `Nat` stages with `x.2 < 3`, i.e. a finite net in which lines end |

Selected witness theorems (exact):
- `FiniteFamilies.one_not_constant : ¬ «有常» step («一» : «际» Occ)` (747)
- `FiniteFamilies.family_constant_to_end : «至终有常» step family` (754)
- `FiniteFamilies.member_not_constant_at : ¬ «本类至终有常» step member (false, 0)` (766)
- `FiniteFamilies.member_no_reach : ¬ ∀ t, «及» step (false, 0) t → «所及» step member (false, 0) t` (782)
- `FiniteFamilies.family_takes_in_all {f : Bool} {t : Occ} (down : «及» step (f, 0) t) : «所及» step family (f, 0) t` (796)
- `FiniteSharedCondition.reaches_other_past_end : «所及» step held (.a, 0) (.b, 2)` (937)
- `CleanStep.ends_where_net_ends {y : Occ} (line : «相续» step own .m y) (ends : «亡» step own y) : ∀ w, ¬ step y w` (1005) with `CleanStep.not_constant_at : ¬ «本类至终有常» step own .m` (992)
- `FiniteWake.constant_to_end : «至终有常» step own` (1064), `FiniteWake.not_constant : ¬ «有常» step own` (1077)
- `OtherLeaves.reach_without_condition : ¬ «本类至终有常» step («二分» inClass) .m ∧ «所缘同于» step («二分» inClass) .m ∧ ∀ t, «及» step .m t → «所及» step («二分» inClass) .m t` (1472)

## 2. Answers

### (1) Every term of the root, with its definition
Given above, exactly. In short: 续 = `«合» R E`; 相续 = `«及» («续» R E)`; 有前 y = `∃ x, «续» R E x y`;
有后 x = `∃ y, «续» R E x y`; 生 = `¬ 有前`; 亡 = `¬ 有后`; 住 = 有前 ∧ 有后; 异 R E F x y = 续 R E x y ∧ ¬ F x y;
不穷 x = every y with `x = y ∨ 相续 x y` has 有后; 复生 x = `∃ y, R x y ∧ 生 y ∧ 有后 y`; 复生至 x w =
`∃ y, R x y ∧ 生 y ∧ 相续 y w`; 生生 = greatest family closed under 复生至 (given as ∃ S); 息 = inductive,
least closed under 复生至; 有常 = `E˘;R ⊆ R;E˘`; 核 = ∃ symmetric constant S ⊆ E relating them; 位核 = same
with constancy under `«逆» R` too; 粗 R L = `(L ; (R ∧ ¬L)) ; L`; 粗复生; 至终有常 (GrammarPath 222); 自持 =
有常 (alias); 相须, 因于 (via 有常 of the joint class); 足以定核 = `«合» E₁ E₂ ⊆ «核» R E₁`; 因于核 = 足以定核 ∧
¬ 有常 R E₁; 相须核 = both 足以定核 ∧ neither 有常. Further in GrammarPath: 所缘同于, 本类至终有常, 二分.
Also 无环, 同族. Note: 有常, 至终有常 and 核 do not require E to be a class; 亡于核下不变 etc. do.

### (2) Which theorems already say ...
- *Alike leads to alike unless there is no next.* That is the definition `«至终有常»` (GrammarPath 222),
  not a theorem. For full constancy, the pointwise reading `«有常之逐点»` (Grammar 343). Note: 至终有常 and
  有常 are *simulation* forms (u' has *some* step alike to u's step), not the "going alike" form
  `«同行»` (every pair of steps of alike occurrences lands alike), which is in GrammarLaws.lean:2568, not
  here. My files contain no statement of "alike leads to alike" in the 同行 sense.
- *A line under a class ends only where nothing follows.* Said in the docstring of `«至终有常»`, and
  proved in contrapositive form: `«亡而网续则不至终有常»` (253) and `«亡而网续则本类不至终有常»` (264):
  a line that ends at an occurrence that still conditions something breaks 至终有常. The forward direction
  "under 至终有常, a line ends only where nothing follows" is not stated as its own theorem in these files;
  it is the same contrapositive. `CleanStep` (992, 1005) shows the converse fails: every line from m ends
  only where the net does, yet 本类至终有常 fails. For full constancy: `«有常则续不尽»` (356),
  `«有常则相续不尽»` (363), `«有亡之续则不有常»` (370).
- *Ending is invariant under the core.* `«亡于核下不变»` (Grammar 523), needs `«类» E`. Also beginning under
  the converse core (534), the two-way core (544, 551), abiding (558).
- *A class's regularity lies in another class.* Definitions `«足以定核»` (612), `«因于核»` (615),
  `«相须核»` (618); theorems `«合有常则足以定核»` (623), `«因于则因于核»` (633), `«相须则相须核»` (638); cases
  `«火薪相须»` (832), `«两火以薪定理»` (878), `«两火火薪相须»` (911); negative `«两火同火不足以定理»` (892).
- *Begins under a fine class and continues under a coarse one.* `«生于细而续于粗则异»` (Grammar 725):
  `(begins : «生» R F y) (continues : «续» R E x y) : «异» R E F x y`. It carries no premise that F is finer
  than E; the name and docstring say finer/coarser, the statement holds for any E, F. `«四相俱时»` (300)
  is the identity/one instance. `«亡于粗则亡于细»` (170), `«生于粗则生于细»` (731), `«住于细则住于粗»` (175),
  `«粗化»` (166) give monotonicity; `«亡于细者不必亡于粗»` (182) the strictness witness. No theorem says
  "turns" in the sense (d) (a line comes to differ in a respect before its end).

### (3) The flame and two flames
Proved (Grammar 737-929): in `Flame` (f₀→f₁→f₂→ash), under "flame or not" f₀ continues to f₁ and f₁ to
f₂, and under the core of "flame or not" nothing continues (`«以核为判据则火无续»`), via `not_core_f₀`,
`not_core_f₁` (no symmetric constant S ⊆ alike relates consecutive moments). "Flame or not" and "same fuel"
need each other through the core (`«火薪相须»`), proved because their joint class is identity
(`Flame.joint_eq`) and identity is constant; neither is constant because a line under each ends (by
`«有亡之续则不有常»`: under alike, f₁→f₂ then f₂ has no burning next; under sameFuel, f₂→ash (both fuel 0)
and ash has no next). `«火之见证不择类»`: any E₂ that with alike gives identity suffices, so the witness
does not single out fuel. In `TwoFlames` (Bool × Flame), fuel suffices while the joint class relates two
distinct occurrences (`«两火以薪定理»`), same-flame does not suffice (`«两火同火不足以定理»`), and mutual need
holds through the core (`«两火火薪相须»`). Docstring caution: `«以核为判据则火无续»` says "the core's futures
differ by how long is left"; the statement proves only that no two consecutive moments are core-related.
The fuel is a `Nat` but only its equality is used; nothing about fuel decreasing, a draw or a point of
no return is stated. There is no "level under a draw" in my files.

### (4) GrammarPath as a whole
Its header (lines 5-114): chapter 7 §4.6 joins two routes into one path to the future; this module states
for every carrier, relation and class what a line under a class must hold to leave a region (所经必同),
that a regularity holding a member's effects takes in all that follows (常闭则后皆续), weakened to
constancy up to the net's end (至终有常) because in a net where every line ends no class under which
anything continues is constant, then localized to a member's class (本类至终有常), with what leaves the
class (出类随行/随线), how outside division matters, the split (二分), and that neither premise can be
dropped (Unclosed, Inconstant), and what the reach asks without regularity (后皆续当且仅当后皆同类).
Laws about lines that end: `«亡而网续则后不皆续»` (214), `«亡而网续则不至终有常»` (253),
`«亡而网续则本类不至终有常»` (264), `CleanStep.ends_where_net_ends` (1005), FiniteFamilies member_* (766,
776, 782), FiniteSharedCondition member_* (921, 931). About 至终有常: 222, 226, 235, 239, 246, 253, 264,
273-434 (all 至终/本类 forms), 440-597. About reach and nets: `«所经必同»` (127), `«所经不同则不及»` (149),
`«后皆同类则后皆续»` (164), `«后皆续当且仅当后皆同类»` (175), `«后皆续则所缘同于»` (184),
`«后皆续当且仅当自与线皆闭»` (192), the `所及皆及` family (331, 338, 346), and witnesses
`family_takes_in_all`, `other_family_outside`, `reaches_other_past_end`, `fourth_outside`.

### (5) A root notion of "a difference that makes a difference"
In my files, no definition names "two alike occurrences going to unalike ones". What comes closest:
- failure of `«有常»` / `«至终有常»` read pointwise: some `E u u'`, `R u v`, and u' has steps but none
  E-alike to v. The negation of `«至终有常»` is exactly "there exist alike u, u' and a step u→v such that
  u' has some next and no next alike to v". This is a simulation failure, not a 同行 failure (同行, in
  GrammarLaws, would be "u→v, u'→v' with v, v' unalike").
- the core `«核»`: two E-alike occurrences not related by the core are ones whose futures E tells apart
  somewhere; but "not in the core" is not given a positive witness form in these files.
- `«异»` (147): a step that continues under E while F tells its ends apart; a difference along one step,
  not between two alike occurrences.
- `«出类随行»` / `«出类不随则本类不至终有常»` (355-409): a member's effect leaving the class must be followed
  by every alike occurrence; one that does not follow breaks 本类至终有常. This is the nearest positive
  "difference that makes a difference" law in GrammarPath.
- `«两端分则中有标»` (697): where a transitive K fails between a line's ends, a marked step lies on the line.
  This is a general "where the difference arises along a line" law; it is the tool a statement of (d)
  could use to place the step where the line turns.

### (6) What the root says cannot be said in it
Grammar header (36-39): every result is pointwise; no equality of relations, so no `propext` or
`funext`; equality on the carrier is a commitment of the model, used by `«静»` and the flame. The
`«不穷»` docstring (241-242) says that an endless chain exists is a further step needing dependent choice.
`«息»` docstring: "That every chain of renewals from a ceasing occurrence is finite is not stated."
`«四相之定当且仅当排中»` (191) shows deciding positions is excluded middle. `«生生»` docstring: it does not
tell renewal that sustains life from turnover that destroys it ("takes more than continuation",
PLAN.md §七). `«闭合当且仅当有常»`: the lumpability/closure correspondence is "not proved here". Neither
header says anything about amounts or counting; there is no number of steps (`«迭»` is in GrammarLaws),
no level, no measure. The flame's `fuel : Nat` is used only through equality.

## 3. Not read or not settled
- GrammarLaws.lean (where `«同行»`, `«迭»`, `«定后»`, `«有常则可续»`, `«局定后则有常当且仅当同行可续»`,
  `«同行之迭»` live), GrammarMap.lean and GrammarCrossing.lean were not read beyond the lines quoted.
  Whether 同行 and 至终有常 are already related by a theorem there is not settled here.
- I did not read the second reader's report in full; overlap claims in section 0 are from the attempt's
  own header and its first 150 lines compared against my two files.
- Statements of `«外分唯系己出之同»`, `«二分本类常当且仅当内外皆随»`, `«内外皆缘则二分本类常»` are pointed to by
  line rather than copied in full; they bear on (a)-(d) only indirectly.
