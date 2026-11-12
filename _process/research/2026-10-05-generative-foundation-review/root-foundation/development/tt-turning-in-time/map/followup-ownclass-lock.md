AI-written map, 12 November 2026

# Follow-up map: own class (OwnClass 1-340), the per-member laws (GrammarPath 218-430), and the lock (RuleCapture `Locked`, GrammarRegularity `lockedAlike`, `lock_line`)

Read only: nothing built, run or edited except this file. PKG =
`/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`.
Line numbers are the file's line of the declaration keyword. Statements are copied; "says" is one plain sentence.
To read the files I also looked at a few definitions they use (named under "Supporting definitions").

## Supporting definitions (outside the assigned ranges, read so the statements can be read)

| name | file:line | kind | exact statement | says |
|---|---|---|---|---|
| `«类»` | Grammar.lean:84 | structure (Prop) | `structure «类» (E : «际» α) : Prop where refl : ∀ x, E x x  symm : ∀ {x y}, E x y → E y x  trans : ∀ {x y z}, E x y → E y z → E x z` | E is an equivalence relation. |
| `«续»` | Grammar.lean:126 | def | `def «续» (R E : «际» α) : «际» α := «合» R E` | a step that conditions and is alike. |
| `«相续»` | Grammar.lean:129 | def | `def «相续» (R E : «际» α) : «际» α := «及» («续» R E)` | a line under E: transitive closure of `«续»`. |
| `«有后»` / `«亡»` | Grammar.lean:135, 141 | def | `def «有后» (R E : «际» α) (x : α) : Prop := ∃ y, «续» R E x y` / `def «亡» (R E : «际» α) (x : α) : Prop := ¬ «有后» R E x` | has a successor under E / ends under E. |
| `«异»` | Grammar.lean:147 | def | `def «异» (R E F : «际» α) : «际» α := fun x y => «续» R E x y ∧ ¬ F x y` | continues under E while F tells them apart. |
| `«不穷»` | Grammar.lean:243 | def | `def «不穷» (R E : «际» α) (x : α) : Prop := ∀ y, (x = y ∨ «相续» R E x y) → «有后» R E y` | every occurrence the line from x reaches has a successor under E. |
| `«有常»` | Grammar.lean:340 | def | `def «有常» (R E : «际» α) : Prop := «则» («而» («逆» E) R) («而» R («逆» E))` | E is constant (global, every block). |
| `«核»` | Grammar.lean:375 | def | `def «核» (R E : «际» α) : «际» α := fun u u' => ∃ S : «际» α, «则» S E ∧ «则» S («逆» S) ∧ «有常» R S ∧ S u u'` | the core: related by some symmetric constant relation inside E. |
| `«闭»` | GrammarLaws.lean:235 | def | `def «闭» (R : «际» α) (P : α → Prop) : Prop := ∀ x y, P x → R x y → P y` | the region P is closed under R. |
| `«所闭»` | GrammarLaws.lean:238 | def | `def «所闭» (R : «际» α) : «际» α := fun x y => ∀ P : α → Prop, «闭» R P → P x → P y` | y lies in every closed region holding x (reflexive-transitive closure, impredicatively). |
| `«闭含所闭»` | GrammarLaws.lean:294 | theorem | `theorem «闭含所闭» {R : «际» α} {P : α → Prop} (closed : «闭» R P) {x y : α} (holds : P x) (within : «所闭» R x y) : P y` | a closed region holding x holds x's closure. |
| `«闭之及»` | GrammarLaws.lean:313 | theorem | `theorem «闭之及» {R : «际» α} {P : α → Prop} (closed : «闭» R P) {x y : α} (holds : P x) (reach : «及» R x y) : P y` | a closed region holding x holds what x reaches. |
| `Law.step` | GrammarCourse.lean:103 | def | `def step (next : S → S) : «际» S := fun s t => t = next s` | a determined law read as a net. |
| `Law.step_hasSucc_iff` | GrammarCourse.lean:107 | theorem | `theorem step_hasSucc_iff {next : S → S} {E : «际» S} {s : S} : «有后» (step next) E s ↔ E s (next s)` | a successor under E is being alike to the next configuration. |
| `Law.constant_iff_keeps` | GrammarCourse.lean:112 | theorem | `theorem constant_iff_keeps {next : S → S} {E : «际» S} : «有常» (step next) E ↔ KeepsRelation next E` | global constancy under a law is the law keeping E. |
| `Pace.turn` | Pace.lean:101 | def | `def turn (f : S → R → S) (h : S → R → R) : Bool → S × R → S × R \| true, p => (f p.1 p.2, h p.1 p.2) \| false, p => (f p.1 p.2, p.2)` | one turn; rule re-read only at a reading step. |
| `Pace.step` | Pace.lean:107 | def | `def step (f : S → R → S) (h : S → R → R) (reads : Nat → Bool) (p : S × R × Nat) : S × R × Nat := ((turn f h (reads p.2.2) (p.1, p.2.1)).1, (turn f h (reads p.2.2) (p.1, p.2.1)).2, p.2.2 + 1)` | the two-level law on (fast, rule, count); total and determined. |
| `Pace.stays_turned` | Pace.lean:162 | theorem | `theorem stays_turned {Q : S × R → Prop} (closed : ∀ b p, Q p → Q (turn f h b p)) (c : S × R) {t : Nat} (holds : Q (paced f h reads c t)) (k : Nat) : Q (paced f h reads c (t + k))` | a region every turn keeps holds along the course from where it holds. |
| `ClosedCapture.join` / `joinRead` | ClosedCapture.lean:220, 223 | def | `def join (fA : A → R → A) (fB : A × B → R → B) (p : A × B) (g : R) : A × B := (fA p.1 g, fB p g)` / `def joinRead (hA : A → R → R) (p : A × B) (g : R) : R := hA p.1 g` | share steps by fA; the beyond-coordinate by fB; the reading reads the share only. |
| `ClosedCapture.turn_join` | ClosedCapture.lean:240 | theorem | `theorem turn_join (fA : A → R → A) (fB : A × B → R → B) (hA : A → R → R) : ∀ (r : Bool) (p : (A × B) × R) (q : A × R), p.1.1 = q.1 → p.2 = q.2 → (turn (join fA fB) (joinRead hA) r p).1.1 = (turn fA hA r q).1 ∧ (turn (join fA fB) (joinRead hA) r p).2 = (turn fA hA r q).2` | one joined turn is the share's own turn on share and rule. Any `r`, any `p`. |
| `ClosedCapture.Accrues` | ClosedCapture.lean:273 | def | `def Accrues (fB : A × Nat → R → Nat) : Prop := ∀ p g, p.2 + 1 ≤ fB p g` | the loss grows by at least one per step. |
| `ClosedCapture.lock_outlives_loss` | ClosedCapture.lean:307 | theorem | `theorem lock_outlives_loss … (raises : Raises P favours fA) (monotone : ReadsShare P M hA) (upper : ∀ {g g'}, M.le g g' → favours g → favours g') (accrues : Accrues fB) {a : A} {b : Nat} {g : R} (locked : Locked M favours hA (a, g)) (t : Nat) : b + t ≤ (paced (join fA fB) (joinRead hA) reads ((a, b), g) t).1.2 ∧ Locked M favours hA ((paced … t).1.1, (paced … t).2) ∧ P.le a (paced … t).1.1 ∧ M.le g (paced … t).2` | from a locked start, at every step: loss ≥ b+t, locked, share and rule not below the start. |

## Inventory: OwnClass.lean 1-340

All are theorems unless marked def. `R E : «际» α`, α : Type u.

| name | line | exact statement | says |
|---|---|---|---|
| `«本类常闭则类闭»` | 99 | `theorem «本类常闭则类闭» {R E : «际» α} (hE : «类» E) {m : α} (atClass : «本类至终有常» R E m) (goes : ∃ w, R m w) (held : «所缘同于» R E m) : «闭» R (E m)` | E a class, P2 and P4 at m, m conditions something: m's block is closed under R. |
| `«类闭则本类常闭»` | 105 | `theorem «类闭则本类常闭» {R E : «际» α} (hE : «类» E) {m : α} (closed : «闭» R (E m)) (decided : ∀ u, E m u → (∃ w, R u w) ∨ ∀ w, ¬ R u w) : «本类至终有常» R E m ∧ «所缘同于» R E m` | E a class, m's block closed, and decided for each block member whether it conditions something: P2 and P4 at m. No `goes` premise. |
| `«本类常闭当且仅当类闭»` | 116 | `theorem «本类常闭当且仅当类闭» {R E : «际» α} (hE : «类» E) {m : α} (goes : ∃ w, R m w) (decided : ∀ u, E m u → (∃ w, R u w) ∨ ∀ w, ¬ R u w) : «本类至终有常» R E m ∧ «所缘同于» R E m ↔ «闭» R (E m)` | under goes and decided, P2∧P4 at m iff m's block closed. |
| `«合为类»` | 125 | `theorem «合为类» {E F : «际» α} (hE : «类» E) (hF : «类» F) : «类» («合» E F)` | meet of classes is a class. |
| `«本类常闭之交»` | 132 | `theorem «本类常闭之交» {R E F : «际» α} (hE : «类» E) (hF : «类» F) {m : α} (goes : ∃ w, R m w) (atE : «本类至终有常» R E m) (heldE : «所缘同于» R E m) (atF : «本类至终有常» R F m) (heldF : «所缘同于» R F m) : «本类至终有常» R («合» E F) m ∧ «所缘同于» R («合» E F) m` | P2∧P4 closed under binary meet at a member that conditions something. |
| `«皆»` | 146 | def `def «皆» {ι : Sort v} (E : ι → «际» α) : «际» α := fun x y => ∀ i, E i x y` | meet of a family. |
| `«皆为类»` | 149 | `theorem «皆为类» {ι : Sort v} {E : ι → «际» α} (each : ∀ i, «类» (E i)) : «类» («皆» E)` | meet of a family of classes is a class. |
| `«本类常闭之遍交»` | 155 | `theorem «本类常闭之遍交» {ι : Sort v} {R : «际» α} {E : ι → «际» α} (each : ∀ i, «类» (E i)) {m : α} (goes : ∃ w, R m w) (i₀ : ι) (atClass : ∀ i, «本类至终有常» R (E i) m) (held : ∀ i, «所缘同于» R (E i) m) : «本类至终有常» R («皆» E) m ∧ «所缘同于» R («皆» E) m` | same for a nonempty family. |
| `«后类»` | 170 | def `def «后类» (R : «际» α) (m : α) : «际» α := fun x y => x = y ∨ («所闭» R m x ∧ «所闭» R m y)` | m with all that follows it as one block; singletons elsewhere. Defined from R and m alone. |
| `«后类为类»` | 172 | `theorem «后类为类» (R : «际» α) (m : α) : «类» («后类» R m)` | it is a class. |
| `«后类之本»` | 183 | `theorem «后类之本» {R : «际» α} {m x : α} : «后类» R m m x ↔ «所闭» R m x` | m's block under it is m's closure. |
| `«本类常闭则后皆同»` | 191 | `theorem «本类常闭则后皆同» {R E : «际» α} (hE : «类» E) {m : α} (atClass : «本类至终有常» R E m) (held : «所缘同于» R E m) {x : α} (within : «所闭» R m x) : E m x` | P2∧P4 at m (no goes): everything in m's closure is alike to m. |
| `«本类常闭则含后类»` | 204 | `theorem «本类常闭则含后类» {R E : «际» α} (hE : «类» E) {m : α} (atClass : «本类至终有常» R E m) (held : «所缘同于» R E m) : «则» («后类» R m) E` | every class meeting P2∧P4 at m contains `«后类» R m`. |
| `«后类本类常闭»` | 213 | `theorem «后类本类常闭» {R E : «际» α} (hE : «类» E) {m : α} (atClass : «本类至终有常» R E m) (held : «所缘同于» R E m) : «本类至终有常» R («后类» R m) m ∧ «所缘同于» R («后类» R m) m` | if any class meets P2∧P4 at m, so does `«后类»`. |
| `«判则后类本类常闭»` | 227 | `theorem «判则后类本类常闭» {R : «际» α} {m : α} (decided : ∀ u, «所闭» R m u → (∃ w, R u w) ∨ ∀ w, ¬ R u w) : «本类至终有常» R («后类» R m) m ∧ «所缘同于» R («后类» R m) m` | decided downstream of m suffices for `«后类»` to meet P2∧P4 at m; no other premise. |
| `«返则后类本类常闭»` | 238 | `theorem «返则后类本类常闭» {R : «际» α} {m : α} (returns : ReturnsAlong R m) : «本类至终有常» R («后类» R m) m ∧ «所缘同于» R («后类» R m) m` | if m's closure returns to m, `«后类»` meets P2∧P4, no decision. |
| `«后类最细»` | 257 | `theorem «后类最细» {R : «际» α} {m : α} (met : ∃ E, «类» E ∧ «本类至终有常» R E m ∧ «所缘同于» R E m) : («本类至终有常» R («后类» R m) m ∧ «所缘同于» R («后类» R m) m) ∧ ∀ E, «类» E → «本类至终有常» R E m → «所缘同于» R E m → «则» («后类» R m) E` | `«后类»` is the least class meeting P2∧P4 at m, wherever one exists. |
| `«本类常闭则所及即一之所及»` | 269 | `theorem «本类常闭则所及即一之所及» {R E : «际» α} (hE : «类» E) {m : α} (atClass : «本类至终有常» R E m) (held : «所缘同于» R E m) (t : α) : «所及» R E m t ↔ «所及» R «一» m t` | under P2∧P4 the line under E from m reaches what the line under the one reaches. |
| `«后类之所及即一之所及»` | 284 | `theorem «后类之所及即一之所及» (R : «际» α) (m t : α) : «所及» R («后类» R m) m t ↔ «所及» R «一» m t` | same for `«后类»`, no premise. |
| `«各后类续无外即一之续无外»` | 296 | `theorem «各后类续无外即一之续无外» {Pos : Type} {R : «际» α} {center : Pos → α} : (∀ p x, «所及» R («后类» R (center p)) (center p) x) ↔ «续无外» R «一» center` | per-center version, no premise. |
| `«本类常则闭当且仅当所及即一之所及»` | 303 | `theorem «本类常则闭当且仅当所及即一之所及» {R E : «际» α} (hE : «类» E) {m : α} (atClass : «本类至终有常» R E m) : «所缘同于» R E m ↔ ∀ t, («所及» R E m t ↔ «所及» R «一» m t)` | given P2, P4 iff the reach equals the one's reach. |
| `«各本类常闭则续无外即一之续无外»` | 312 | `theorem «各本类常闭则续无外即一之续无外» {Pos : Type} {R : «际» α} {E : Pos → «际» α} {center : Pos → α} (each : ∀ p, «类» (E p)) (atClass : ∀ p, «本类至终有常» R (E p) (center p)) (held : ∀ p, «所缘同于» R (E p) (center p)) : (∀ p x, «所及» R (E p) (center p) x) ↔ «续无外» R «一» center` | per-center version under P2∧P4 at each center. |
| `«静之本类至终有常»` | 322 | `theorem «静之本类至终有常» (R : «际» α) (m : α) : «本类至终有常» R «静» m` | identity meets P2 everywhere. |
| `«静最细»` | 327 | `theorem «静最细» (R : «际» α) (m : α) : «本类至终有常» R «静» m ∧ ∀ E : «际» α, «类» E → «则» «静» E` | identity meets P2 and is in every class (near-definitional). |
| `«静不闭»` | 332 | `theorem «静不闭» {R : «际» α} {m v : α} (step : R m v) (other : m ≠ v) : ¬ «所缘同于» R «静» m` | identity fails P4 where m conditions something other than itself. |

Header claims checked against statements: lines 16-36 match the statements above. Line 84 "Every declaration has an empty axiom report" I did not check (no Lean run). Lines 75-82 are marked "[a reading, not a theorem]", correctly.

## Inventory: GrammarPath.lean 150-430 (assigned 218-430; the three definitions just before 218 are used throughout)

| name | line | exact statement | says |
|---|---|---|---|
| `«所缘同于»` (P4) | 159 | def `def «所缘同于» (R E : «际» α) (m : α) : Prop := ∀ v, R m v → E m v` | everything m conditions is alike to m. |
| `«后皆同类则后皆续»` | 164 | `theorem «后皆同类则后皆续» {R E : «际» α} (hE : «类» E) {c t : α} (all : ∀ s, «及» R c s → E c s) (down : «及» R c t) : «相续» R E c t` | where all downstream is alike, all downstream lies on the line. |
| `«后皆续当且仅当后皆同类»` | 175 | `theorem «后皆续当且仅当后皆同类» {R E : «际» α} (hE : «类» E) {m : α} : (∀ t, «及» R m t → «所及» R E m t) ↔ (∀ t, «及» R m t → E m t)` | the reach is all downstream iff all downstream is alike. |
| `«后皆续则所缘同于»` | 184 | `theorem «后皆续则所缘同于» {R E : «际» α} (hE : «类» E) {m : α} (reach : ∀ t, «及» R m t → «所及» R E m t) : «所缘同于» R E m` | one-step case: full reach gives P4. |
| `«后皆续当且仅当自与线皆闭»` | 192 | `theorem «后皆续当且仅当自与线皆闭» {R E : «际» α} (hE : «类» E) {m : α} : (∀ t, «及» R m t → «所及» R E m t) ↔ «所缘同于» R E m ∧ ∀ y, «相续» R E m y → «所缘同于» R E y` | full reach iff P4 at m and at every stage of its line. |
| `«亡而网续则后不皆续»` | 214 | `theorem «亡而网续则后不皆续» {R E : «际» α} (hE : «类» E) {m y : α} (line : «相续» R E m y) (ends : «亡» R E y) (goes : ∃ w, R y w) : ¬ ∀ t, «及» R m t → «所及» R E m t` | a line that ends where the net still goes on does not take in all downstream. |
| `«至终有常»` | 222 | def `def «至终有常» (R E : «际» α) : Prop := ∀ u u', E u u' → ∀ v, R u v → (∃ v', R u' v' ∧ E v v') ∨ ∀ w, ¬ R u' w` | constancy up to the net's end, global. |
| `«有常则至终有常»` | 226 | `theorem «有常则至终有常» {R E : «际» α} (constant : «有常» R E) : «至终有常» R E` | constancy gives it. |
| `«本类至终有常»` (P2) | 235 | def `def «本类至终有常» (R E : «际» α) (m : α) : Prop := ∀ u u', E m u → E m u' → ∀ v, R u v → (∃ v', R u' v' ∧ E v v') ∨ ∀ w, ¬ R u' w` | `«至终有常»` asked only of m's block. |
| `«至终有常则本类至终有常»` | 239 | `theorem «至终有常则本类至终有常» {R E : «际» α} (hE : «类» E) (constant : «至终有常» R E) (m : α) : «本类至终有常» R E m` | global gives per member. |
| `«至终有常之逐类»` | 246 | `theorem «至终有常之逐类» {R E : «际» α} (hE : «类» E) : «至终有常» R E ↔ ∀ m, «本类至终有常» R E m` | global iff at every member. |
| `«亡而网续则不至终有常»` | 253 | `theorem «亡而网续则不至终有常» {R E : «际» α} {x y : α} (hxy : «续» R E x y) (ends : «亡» R E y) (goes : ∃ w, R y w) : ¬ «至终有常» R E` | a line ending while the net goes on refutes constancy to the end; any E. |
| `«亡而网续则本类不至终有常»` | 264 | `theorem «亡而网续则本类不至终有常» {R E : «际» α} {m x y : α} (mx : E m x) (my : E m y) (hxy : «续» R E x y) (ends : «亡» R E y) (goes : ∃ w, R y w) : ¬ «本类至终有常» R E m` | the per-member version. |
| `«本类常闭则所缘同类»` | 273 | `theorem «本类常闭则所缘同类» {R E : «际» α} (hE : «类» E) {m : α} (atClass : «本类至终有常» R E m) (goes : ∃ w, R m w) (held : «所缘同于» R E m) {u v : α} (alike : E u m) (step : R u v) : E v m` | P2, P4, goes at m: any member of m's block conditions only block members. |
| `«至终常闭则所缘同类»` | 282 | `theorem «至终常闭则所缘同类» {R E : «际» α} (hE : «类» E) (constant : «至终有常» R E) {m : α} (goes : ∃ w, R m w) (held : «所缘同于» R E m) {u v : α} (alike : E u m) (step : R u v) : E v m` | global form. |
| `«本类常闭则后皆续»` | 291 | `theorem «本类常闭则后皆续» {R E : «际» α} (hE : «类» E) {m : α} (atClass : «本类至终有常» R E m) (goes : ∃ w, R m w) (held : «所缘同于» R E m) {c t : α} (alike : E c m) (down : «及» R c t) : E t m ∧ «相续» R E c t` | from any block member, all downstream is alike and on the line. |
| `«至终常闭则后皆续»` | 305 | `theorem «至终常闭则后皆续» {R E : «际» α} (hE : «类» E) (constant : «至终有常» R E) {m : α} (goes : ∃ w, R m w) (held : «所缘同于» R E m) {c t : α} (alike : E c m) (down : «及» R c t) : E t m ∧ «相续» R E c t` | global form. |
| `«常闭则所缘同类»` | 312 | `theorem «常闭则所缘同类» {R E : «际» α} (hE : «类» E) (constant : «有常» R E) {m : α} (held : «所缘同于» R E m) {u v : α} (alike : E u m) (step : R u v) : E v m` | under 有常, no goes needed. |
| `«常闭则后皆续»` | 320 | `theorem «常闭则后皆续» {R E : «际» α} (hE : «类» E) (constant : «有常» R E) {m : α} (held : «所缘同于» R E m) {c t : α} (alike : E c m) (down : «及» R c t) : E t m ∧ «相续» R E c t` | under 有常. |
| `«本类常闭则所及皆及»` | 331 | `theorem «本类常闭则所及皆及» {R E : «际» α} (hE : «类» E) {m x c t : α} (atClass : «本类至终有常» R E m) (goes : ∃ w, R m w) (held : «所缘同于» R E m) (toC : «所及» R E x c) (alike : E c m) (down : «及» R c t) : «所及» R E x t` | a line reaching m's block carries on to all downstream. |
| `«至终常闭则所及皆及»`, `«常闭则所及皆及»` | 338, 346 | global and 有常 forms of the above (same shape, `constant` replacing `atClass`; the 有常 form drops `goes`). | |
| `«本类出类随行»` | 355 | `theorem «本类出类随行» {R E : «际» α} (hE : «类» E) {m c u : α} (atClass : «本类至终有常» R E m) (alike : E c m) (effect : R m u) (outside : ¬ E m u) (goes : ∃ w, R c w) : ∃ x, R c x ∧ E u x ∧ ¬ E c x` | under P2, an effect leaving the class is matched at every alike member that goes on. |
| `«出类随行»`, `«本类出类随线»`, `«出类随线»` | 367, 376, 387 | global / along-the-line variants of the above. | |
| `«出类不随则本类不至终有常»` | 396 | `theorem «出类不随则本类不至终有常» {R E : «际» α} (hE : «类» E) {m c u : α} (alike : E c m) (effect : R m u) (outside : ¬ E m u) (goes : ∃ w, R c w) (clean : ∀ x, R c x → ¬ E u x) : ¬ «本类至终有常» R E m` | an unmatched exit refutes P2 at m. |
| `«出类不随则不至终有常»` | 406 | global form. | |
| `«本类常则闭当且仅当后皆同类»` | 414 | `theorem «本类常则闭当且仅当后皆同类» {R E : «际» α} (hE : «类» E) {m : α} (atClass : «本类至终有常» R E m) : «所缘同于» R E m ↔ ∀ t, «及» R m t → E m t` | given P2, P4 iff all downstream alike. |
| `«至终常类之闭当且仅当后皆同类»` | 426 | global form. | |

## Inventory: the lock

| name | file:line | kind | exact statement | says |
|---|---|---|---|---|
| `RuleCapture.Raises` | RuleCapture.lean:145 | def | `def Raises (P : Ideals.Preorder S) (favours : R → Prop) (f : S → R → S) : Prop := ∀ x g, favours g → P.le x (f x g)` | a favouring rule does not lower the share. Hypothesis-shaped. |
| `RuleCapture.ReadsShare` | RuleCapture.lean:150 | def | `def ReadsShare (P : Ideals.Preorder S) (M : Ideals.Preorder R) (h : S → R → R) : Prop := ∀ x y g g', P.le x y → M.le (h x g) (h y g')` | the reading is monotone in the share alone. |
| `RuleCapture.Locked` | RuleCapture.lean:160 | def | `def Locked (M : Ideals.Preorder R) (favours : R → Prop) (h : S → R → R) (p : S × R) : Prop := favours p.2 ∧ M.le p.2 (h p.1 p.2)` | rule favours and is not above what the reading gives. A predicate on (share, rule) only. |
| `RuleCapture.turn_locked` | RuleCapture.lean:169 | theorem | `theorem turn_locked (raises : Raises P favours f) (monotone : ReadsShare P M h) (upper : ∀ {g g'}, M.le g g' → favours g → favours g') : ∀ (b : Bool) (p : S × R), Locked M favours h p → Locked M favours h (turn f h b p) ∧ P.le p.1 (turn f h b p).1 ∧ M.le p.2 (turn f h b p).2` | under raises, monotone, upper: every turn, reading or not, from every locked p keeps the lock and lowers neither share nor rule. This is already a closure of the Locked region under `turn f h b`, for each b, though not written with `«闭»`. |
| `RuleCapture.locked_stays` | RuleCapture.lean:182 | theorem | `theorem locked_stays (raises : Raises P favours f) (monotone : ReadsShare P M h) (upper : ∀ {g g'}, M.le g g' → favours g → favours g') {c : S × R} {t : Nat} (locked : Locked M favours h (paced f h reads c t)) : ∀ k, Locked M favours h (paced f h reads c (t + k))` | locked at t, locked at every later step (`stays_turned` applied to `turn_locked`). |
| `RuleCapture.locked_rises` / `locked_not_below` | RuleCapture.lean:190, 205 | theorem | (stepwise / from-t) share and rule do not fall from a locked step on; same three premises. | |
| `ClosedCapture.favouredAlike` | GrammarRegularity.lean:279 | def | `def favouredAlike (favours : R → Prop) {S : Type u} : «际» (S × R × Nat) := fun p q => favours p.2.1 ↔ favours q.2.1` | alike in whether the rule favours. |
| `ClosedCapture.lockedAlike` | GrammarRegularity.lean:287 | def | `def lockedAlike (M : Ideals.Preorder R) (favours : R → Prop) (hA : A → R → R) : «际» ((A × Nat) × R × Nat) := fun p q => Locked M favours hA (p.1.1, p.2.1) ↔ Locked M favours hA (q.1.1, q.2.1)` | two configurations alike in whether (share, rule) is locked; the loss `p.1.2` and count `p.2.2` are not read. Fixed to loss type Nat. |
| `ClosedCapture.lockedAlike_class` | GrammarRegularity.lean:291 | theorem | `theorem lockedAlike_class (M : Ideals.Preorder R) (favours : R → Prop) (hA : A → R → R) : «类» (lockedAlike M favours hA)` | it is a class. |
| `ClosedCapture.loss` | GrammarRegularity.lean:296 | def | `def loss (p : (A × Nat) × R × Nat) : Nat := p.1.2` | |
| `ClosedCapture.turn_fast` | GrammarRegularity.lean:299 | theorem | `theorem turn_fast {S : Type u} (f : S → R → S) (h : S → R → R) : ∀ (r : Bool) (p : S × R), (turn f h r p).1 = f p.1 p.2` | |
| `ClosedCapture.orbit_paced` | GrammarRegularity.lean:305 | theorem | `theorem orbit_paced {S : Type u} (f : S → R → S) (h : S → R → R) (reads : Nat → Bool) (c : S × R) (t : Nat) : Law.orbit (Pace.step f h reads) (c.1, c.2, 0) t = ((paced f h reads c t).1, (paced f h reads c t).2, t)` | orbit of the paced step from count 0 is the course. |
| `ClosedCapture.loss_alters` | GrammarRegularity.lean:312 | theorem | `theorem loss_alters {fA : A → R → A} {fB : A × Nat → R → Nat} {h : A × Nat → R → R} {reads : Nat → Bool} (accrues : Accrues fB) (p : (A × Nat) × R × Nat) : ¬ loss p = loss (Pace.step (join fA fB) h reads p)` | every step alters the loss. |
| `ClosedCapture.lock_line` | GrammarRegularity.lean:324 | theorem | `theorem lock_line {P : Ideals.Preorder A} {M : Ideals.Preorder R} {favours : R → Prop} {fA : A → R → A} {fB : A × Nat → R → Nat} {hA : A → R → R} {reads : Nat → Bool} (raises : Raises P favours fA) (monotone : ReadsShare P M hA) (upper : ∀ {g g'}, M.le g g' → favours g → favours g') (accrues : Accrues fB) {a : A} {b : Nat} {g : R} (locked : Locked M favours hA (a, g)) : «不穷» (Law.step (Pace.step (join fA fB) (joinRead hA) reads)) (lockedAlike M favours hA) ((a, b), g, 0) ∧ ∀ n, «异» (Law.step (Pace.step (join fA fB) (joinRead hA) reads)) (lockedAlike M favours hA) (sameValue loss) (Law.orbit (Pace.step (join fA fB) (joinRead hA) reads) ((a, b), g, 0) n) (Law.orbit (Pace.step (join fA fB) (joinRead hA) reads) ((a, b), g, 0) (n + 1))` | from a locked start at count 0, the line under lockedAlike never ends, and every orbit step is an alteration under the loss. Proved along the orbit via `lock_outlives_loss` and `Law.unending_iff_steps`, not via a closed region. `accrues` is used only for the `«异»` half (and inside `lock_outlives_loss`, whose `Locked` conjunct does not need it). |
| `ClosedCapture.loss_ends_line` | GrammarRegularity.lean:352 | theorem | `theorem loss_ends_line … (accrues : Accrues fB) {N : Nat} (turns : ∀ p g, N ≤ p.2 → ¬ favours (h p g)) {a : A} {b : Nat} {g : R} {r : Nat} (at_r : reads r = true) (past : N ≤ b + r) (start : favours g) : ¬ «不穷» (Law.step (Pace.step (join fA fB) h reads)) (favouredAlike favours) ((a, b), g, 0)` | a reading that turns against favouring past a loss bound ends the line under favouredAlike. |
| `Beyond.closed_line` / `Beyond.open_line_ends` | GrammarRegularity.lean:371, 386 | theorem | witnesses of the two above on counts. | |
| `«守核则不穷»`, `«守核之线不亡»`, `«亡前核变»`, `«有亡之线末步离核»`, `«有亡之线两端核异»` | GrammarRegularity.lean:86, 111, 118, 125, 132 | theorem | e.g. `theorem «亡前核变» {R E : «际» α} {x y : α} (c : «续» R E x y) (ends : «亡» R E y) : «异» R E («核» R E) x y`; `theorem «有亡之线两端核异» {R E : «际» α} (hE : «类» E) {x y : α} (line : «相续» R E x y) (ends : «亡» R E y) : ¬ «核» R E x y` | a step into an end leaves the core; the two ends of an ending line are apart in the core. (Outside the assigned range, read because they bear on (b).) |
| `Law.unending_iff_steps`, `Law.unending_alike` | GrammarRegularity.lean:146, 175 | theorem | `theorem unending_iff_steps {next : S → S} {E : «际» S} {s : S} : «不穷» (step next) E s ↔ ∀ n, E (orbit next s n) (orbit next s (n + 1))` | along a law, never ending is every orbit step alike. |

## What already states part of the pattern

- (a)/(b) at a member: P2 = `«本类至终有常»` (GrammarPath 235), P4 = `«所缘同于»` (159); their joint form is closure of the block, `«本类常闭当且仅当类闭»` (OwnClass 116). "E not constant while one alike has a next and another none": `«亡而网续则本类不至终有常»` (GrammarPath 264), `«亡而网续则不至终有常»` (253); the core telling them apart: `«亡前核变»`, `«有亡之线两端核异»` (GrammarRegularity 118, 132).
- (c) a line the same in a respect to the end while something it depends on changes every step: `lock_line` (GrammarRegularity 324), with `loss_alters`. But in `lock_line` the loss is only *altered* (grows), not a level that runs down to a point of no return; and the course never ends, so (c)'s "up to its end" is here "for ever".
- (d) turning when the unread coordinate comes to make a difference: `loss_ends_line` (352) and `turned_by_loss` (ClosedCapture 291), under favouredAlike, not lockedAlike.
- Overlap with the held attempt (TurningInTime.lean): its `not_constant` (lines 131-135) is in substance `«亡而网续则不至终有常»`'s 有常 analogue (the root's `«有常则可续»`, as the second reader said); its per-member counterpart already in my files is `«亡而网续则本类不至终有常»` (GrammarPath 264). Its `core_apart` (126) is close to `«亡前核变»` (GrammarRegularity 118) and `«有亡之线两端核异»` (132), which state the same separation for a line under E that ends; `core_apart` states it for any pair `u, u'` with `R u v` and `u'` having no next under R (the root has that as `«亡于核下不变»`, per the reader). Its `Course.never_ends_iff` (284) is a `«不穷» … «一»` statement; nothing in my files states one for a level model.

## Answer to the question

**Short answer: yes for `«闭» R (E m)` with `E = lockedAlike M favours hA` and `m` any locked configuration; no as an identity with `«后类»`; and the step that is not yet proved is one lemma of closure (a few lines from `turn_join` and `turn_locked`), with no `Accrues` premise.** I worked this out by reading only. It has not been checked in Lean.

Fix `next := Pace.step (join fA fB) (joinRead hA) reads`, `R := Law.step next`, `E := lockedAlike M favours hA` (so B = Nat and the carrier is `(A × Nat) × R × Nat`). Watch the clash: in ClosedCapture `R` is the type of rules, so the net needs another name.

1. **The region closed (new; not in my files).** The statement needed:
   `«闭» (Law.step (Pace.step (join fA fB) (joinRead hA) reads)) (fun q => Locked M favours hA (q.1.1, q.2.1))`
   under `raises : Raises P favours fA`, `monotone : ReadsShare P M hA`, `upper`. Proof sketch: `R x y` is `y = next x`. By `Pace.step`'s definition `(next x).1.1 = (turn (join fA fB) (joinRead hA) (reads x.2.2) (x.1, x.2.1)).1.1` and `(next x).2.1 = (turn …).2`. `turn_join … (reads x.2.2) (x.1, x.2.1) (x.1.1, x.2.1) rfl rfl` makes these the share's own `turn fA hA (reads x.2.2) (x.1.1, x.2.1)`, and `(turn_locked raises monotone upper _ _ lock).1` gives Locked. This holds for **every** configuration x: any count, any loss, any `reads`, because `turn_locked` is `∀ b`. It is stronger than `lock_line`, which works along one orbit from count 0. `fB` is arbitrary here, and `Accrues` is not used.
2. **The block of a locked member is that region.** If `Locked M favours hA (m.1.1, m.2.1)`, then `lockedAlike … m y ↔ Locked … (y.1.1, y.2.1)` (`.mp locked` one way; `⟨fun _ => ly, fun _ => locked⟩` the other). So (1) gives `«闭» R (lockedAlike M favours hA m)`. No propositional extensionality is needed if the closure is restated pointwise through this iff. If m is not locked, `E m` is the unlocked region, and nothing in my files says that region is closed. In general it is not: a reading step can lock it (`uniform_locks`, RuleCapture ~312, shows a favouring, unlocked start locked after a reading step; that it is unlocked before was not checked).
3. **P2 and P4 follow.** `«类闭则本类常闭» (lockedAlike_class M favours hA) closed (fun u _ => .inl ⟨next u, rfl⟩)` gives `«本类至终有常» R E m ∧ «所缘同于» R E m`. `decided` is met because `Law.step next` is total, as the question supposes. `goes` (`⟨next m, rfl⟩`) is needed only for the iff `«本类常闭当且仅当类闭»`, not for this direction. The P2 disjunction's right branch never fires, since every configuration has a next.
4. **What then follows from laws that already exist (no new proof):** `«本类常闭则后皆续»` gives every downstream configuration of any locked member alike to it and on the line; `«本类常闭则所及即一之所及»` gives the reach equal to the one's reach; `«本类常闭则含后类»` gives `«则» («后类» R m) (lockedAlike …)`; `«本类出类随行»` is vacuous here because nothing leaves the block. The `«不穷»` half of `lock_line` is not produced by any law in my files from P2∧P4. It would need a small lemma, e.g. "P4 and a closed block under a total R give `«不穷» R E m`": any y the line reaches is alike to m (`«线内同类»` plus symmetry), and `next y` is in the closed block, so `«有后»` holds by `Law.step_hasSucc_iff` and transitivity. Whether such a lemma exists elsewhere in the package I did not search fully. The search found `«不穷则迭»` (GrammarLaws 1274), which goes the other way.
5. **"As `«后类»` of a locked start": not as an identity.** `«后类» R m` has m's block equal to `«所闭» R m` (`«后类之本»`), and for a determined law that is m's orbit. The locked region is strictly larger in general. For example `((a, b'), g, 0)` with `b' ≠ b` is locked when `(a, g)` is, and it is not on the orbit from `((a, b), g, 0)`, because only the start has count 0. Proving it is off the closure would need a lemma that `«所闭»` of `Law.step` is the orbit, which I did not locate. Worse, `«判则后类本类常闭»` gives P2∧P4 for `«后类» R m` at **every** m of a total law, locked or not, because `decided` is trivial. So stating the lock through `«后类»` carries no lock content: all of the lock is in the inclusion `«则» («后类» R m) (lockedAlike …)`, or `«闭含所闭»` with (1).
6. **What E does not tell.** `lockedAlike` is not shown to be `«有常»` (GrammarCourse `constant_iff_keeps` would need the unlocked block kept too). So (b)'s "E not constant, told by its core" applies at unlocked members. At a locked member, P2∧P4 hold and the core plays no role inside the block. A candidate join, not proved: the relation "both locked" is symmetric, lies inside `lockedAlike`, and is constant under R (by (1)). So by `«根»`'s maximality (`(«根» R E).2.2.2`) it lies in `«核» R (lockedAlike …)`: the locked block lies within one core class. To prove it: `«有常» R (fun p q => L p ∧ L q)` via `«有常之逐点»` and (1), symmetry, and inclusion.

So the existing statements already give: `turn_locked` (the content of closure), `turn_join` (the transfer from joined to share's turn), `lockedAlike_class`, and `«类闭则本类常闭»` / `«本类常闭当且仅当类闭»` (from closure to P2∧P4). The lemma still to prove is (1), with (2) as its corollary at a locked member. An optional lemma would give `«不穷»` from P4 plus a closed block under a total net, so that `lock_line`'s first half becomes a case.

## Cautions

- `lock_line` is stated at a start with count 0 and the shape `((a, b), g, 0)`. The closure statement holds at every configuration. A restatement "at a locked member" is the more general one and should not be filed as a duplicate of `lock_line`. But `lock_line`'s `«不穷»` half would then be a corollary, so do not restate it separately.
- `lock_line`'s `«异»` half needs `Accrues`, and the closure does not. Keep the two apart, or the closure inherits an unneeded premise.
- Name clashes: `R` is the rule type in RuleCapture/ClosedCapture and the net in OwnClass/GrammarPath. `step` exists as `Law.step`, `Pace.step` and `TurningInTime.Course.step`. `turn_locked` (RuleCapture 169) and `turn_locked_at` / `locked_step` (PoolFromCourse 152, 185) already exist, so a new `locked_closed` or similar should be checked against PoolFromCourse, which I did not read beyond lines 145-195.
- `«后类»` meets P2∧P4 at every member of a total law (`«判则后类本类常闭»`), so a theorem "the lock's 后类 meets P2 and P4" would say nothing about the lock.
- `«类闭则本类常闭»` needs the closed block `«闭» R (E m)`, not closure of `E` (a relation), and `«闭»` takes a predicate. `lockedAlike … m` is the predicate.
- `lockedAlike` is defined only for the loss type `Nat` (`(A × Nat) × R × Nat`), although `join` and `turn_join` take any `B`.
- GrammarRegularity header line 50 says "from a locked start the line … never ends". The statement asks the start to be `((a, b), g, 0)` with `Locked M favours hA (a, g)`, plus raises, monotone, upper and accrues. The header names these as "the premises of lock_outlives_loss", which is accurate.

## Not read or not settled

- Not read: OwnClass 341-836 (except the region lemmas 346-427, skimmed), GrammarPath outside 150-430, RuleCapture 220-897 (except greps), ClosedCapture outside 131-143 and 210-332, PoolFromCourse beyond 145-195, Grammar/GrammarLaws beyond the definitions cited.
- Not settled: whether a lemma "the closure `«所闭»` of `Law.step next` from s is the orbit" exists. Whether a lemma "P4 plus closed block plus total net gives `«不穷»`" exists elsewhere. Whether some witness in RuleCapture shows `lockedAlike` not `«有常»`. The axiom-report claims (no Lean run).
