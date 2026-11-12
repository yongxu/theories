AI-written map, 12 November 2026

# The rest of the root (Grammar* files beside Grammar, GrammarLaws, GrammarPath): what bears on the turning pattern

Read only; nothing built or run. Folder PKG =
`/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`.
Line numbers are those of the file named. "thm" = theorem, "def" = definition. Statements are copied
from the source; where a long proof term follows `:=` it is left out. The pattern (a)-(d) is the one
in the task: (a) relation and class; (b) going alike yet not constant, the core telling what the class
does not; (c) a line the same in a respect up to its end while something it depends on runs down;
(d) turning before the end only if the untold difference comes to matter while there is a next.

Root terms used below (not in my files, for reading the statements): `«续» R E := «合» R E`
(Grammar 126); `«亡» R E x := ¬ «有后» R E x` (141); `«异» R E F x y := «续» R E x y ∧ ¬ F x y`
(147); `«有常» R E := «则» («而» («逆» E) R) («而» R («逆» E))` (340); `«核» R E u u' := ∃ S, «则» S E ∧
«则» S («逆» S) ∧ «有常» R S ∧ S u u'` (375); `«同行» R E := «则» («而» («而» («逆» R) E) R) E`
(GrammarLaws 2568); `«至终有常»` (GrammarPath 222); `«相须»`, `«足以定核»`, `«因于核»`, `«相须核»`
(Grammar 579, 612, 615, 618); `Law.orbit` (Recurrence 240); `KeepsRelation`, `KeepsAndCarries`,
`sameFuture_coarsest` (IdentificationRuns 310, 320, 328); `adaptive`, `adaptive_state_law_iff`
(Mechanism 225, 234); `GoAlike` (Laws 114).

---------------------------------------------------------------------------------------------------

## 1. GrammarCourse.lean

Header (4-60): "文 in the grammar: a course read through a map as continuation relative to a class".
A determined law's step is 缘, a map's values give a class; 文同 (same course through the map) is the
core of the value class; positions on a 文; moments of a course; learnability through the core.
"No definition of `Becoming.Grammar` changes." What does not join: counting, prefixes, `N + N - 1`
as a number, eventual agreement are stated beside the core.

| line | kind | name | exact statement | plain sentence |
|---|---|---|---|---|
| 71 | def | `sameValue` | `def sameValue (o : S → R) : «际» S := fun s s' => o s = o s'` | The class of a map's values: alike where the map gives one value. A projection read as a class. |
| 73 | thm | `sameValue_class` | `theorem sameValue_class (o : S → R) : «类» (sameValue o)` | Every value class is an equivalence (no premise). |
| 83 | thm | `core_within_core_iff` | `theorem core_within_core_iff {R E E' : «际» α} : «则» («核» R E) («核» R E') ↔ «则» («核» R E) E'` | E's core lies in E''s core exactly where it lies in E' (any relations, no premise). One class's regularity contained in another's. |
| 90 | thm | `contains_core_iff` | `theorem contains_core_iff {R E S : «际» α} (inside : «则» S E) (symm : «则» S («逆» S)) (constant : «有常» R S) : «则» («核» R E) S ↔ «谓» S («核» R E)` | A symmetric constant relation inside E contains E's core exactly where it is the core. |
| 103 | def | `Law.step` | `def step (next : S → S) : «际» S := fun s t => t = next s` | A determined law's step as 缘. TOTAL: every configuration has a next; there is no guard. |
| 107 | thm | `Law.step_hasSucc_iff` | `theorem step_hasSucc_iff {next : S → S} {E : «际» S} {s : S} : «有后» (step next) E s ↔ E s (next s)` | Under a law's step, having a successor under E is being E-alike with the next configuration. |
| 112 | thm | `Law.constant_iff_keeps` | `theorem constant_iff_keeps {next : S → S} {E : «际» S} : «有常» (step next) E ↔ KeepsRelation next E` | Constancy under a law's step is the law keeping the relation (`∀ x y, E x y → E (next x) (next y)`). |
| 120 | thm | `Law.kept_along` | `theorem kept_along {next : S → S} {E : «际» S} (keeps : KeepsRelation next E) {s s' : S} (h : E s s') : ∀ n, E (orbit next s n) (orbit next s' n)` | A kept relation holds at every step of the two orbits. |
| 128 | thm | `Law.core_is_sameFuture` | `theorem core_is_sameFuture {next : S → S} {o : S → R} : «谓» («核» (step next) (sameValue o)) (SameFuture next o)` | The core of a map's value class under a law is "same course through the map at every step". |
| 140 | thm | `Law.alike_iff_core` | `theorem alike_iff_core {next : S → S} {o : S → R} {s s' : S} : Alike (frameBy next o) (frameBy next o) s s' ↔ «核» (step next) (sameValue o) s s'` | Bisimulation likeness in the frame by the map is the core. |
| 146 | thm | `Law.keepsAndCarries_iff` | `theorem keepsAndCarries_iff {K : Type w} {next : S → S} {o : S → R} {π : S → K} : KeepsAndCarries next o π ↔ «则» (sameValue π) (sameValue o) ∧ «有常» (step next) (sameValue π)` | A description π keeps the values and carries the law exactly where its class lies in the value class and is constant. Going alike (`GoAlike (process next) π`, inside `KeepsAndCarries`) = constancy here, because the step is total and determined. |
| 155 | thm | `Law.coarsest_iff_core` | `theorem coarsest_iff_core {K : Type w} {next : S → S} {o : S → R} {π : S → K} (lawful : KeepsAndCarries next o π) : «则» («核» (step next) (sameValue o)) (sameValue π) ↔ «谓» (sameValue π) («核» (step next) (sameValue o))` | A lawful description contains the core exactly where it is the core. |
| 164 | thm | `Law.ends_iff_changes` | `theorem ends_iff_changes {next : S → S} {o : S → R} {s : S} : «亡» (step next) (sameValue o) s ↔ ¬ o s = o (next s)` | Under a value class along a law, a line ends exactly where the value changes at the next step. Ending here is only a change of value, never "no next". |
| 169 | thm | `Law.line_on_orbit` | `theorem line_on_orbit {next : S → S} {E : «际» S} {s y : S} (line : «相续» (step next) E s y) : ∃ n, y = orbit next s (n + 1)` | Every line along a law's step runs on the orbit. |
| 181 | thm | `Law.reached_while_same` | `theorem reached_while_same {next : S → S} {o : S → R} {s : S} (never : «不穷» (step next) (sameValue o) s) : ∀ n, (s = orbit next s n ∨ «相续» (step next) (sameValue o) s (orbit next s n)) ∧ o (orbit next s n) = o s` | Where the value line never ends, it reaches every orbit point and the value is unchanged there. |
| 200 | thm | `Law.unending_iff` | `theorem unending_iff {next : S → S} {o : S → R} {s : S} : «不穷» (step next) (sameValue o) s ↔ ∀ n, o (orbit next s n) = o s` | The value line never ends exactly where the course's value is constant from there. |
| 217 | thm | `Law.continues_in_core_iff` | `theorem continues_in_core_iff {next : S → S} {o : S → R} {s : S} : «续» (step next) («核» (step next) (sameValue o)) s (next s) ↔ «不穷» (step next) (sameValue o) s` | A step continues under the core exactly where the value line never ends from it. |
| 233 | thm | `Law.constant_iff_core` | `theorem constant_iff_core {next : S → S} {o : S → R} : «有常» (step next) (sameValue o) ↔ «谓» (sameValue o) («核» (step next) (sameValue o))` | The value class is constant exactly where it is its own core. |
| 241 | thm | `Law.stays_of_constant` | `theorem stays_of_constant {next : S → S} {o : S → R} (constant : «有常» (step next) (sameValue o)) {s : S} (still : o s = o (next s)) : ∀ n, o (orbit next s n) = o s` | Where the value class is constant, one unchanged step means unchanged for good. |
| 247 | thm | `Law.core_iff_below` | `theorem core_iff_below {next : S → S} {o : S → R} {l : List S} (closed : ∀ s, s ∈ l → next s ∈ l) {s s' : S} (mem : s ∈ l) (mem' : s' ∈ l) : «核» (step next) (sameValue o) s s' ↔ ∀ n, n < l.length + l.length - 1 → o (orbit next s n) = o (orbit next s' n)` | On a listed world closed under the law, the core is decided by the first `2N - 1` values. |
| 261 | thm | `Law.learnable_iff_core` | `theorem learnable_iff_core ... (world : ∀ s, s ∈ l) : (∃ pred : List R → Option V, ∀ s, Learnable.Predicts next reg val pred s) ↔ ∀ s s', «核» (step next) (sameValue reg) s s' → ∃ T, ∀ t, T ≤ t → sameValue val (orbit next s t) (orbit next s' t)` | (Type S : Type, DecidableEq R.) A feature is learnable from the reading exactly where core-alike configurations agree on it eventually. |
| 275 | thm | `Law.learnable_of_core_within` | `theorem learnable_of_core_within ... (world : ∀ s, s ∈ l) (within : «则» («核» (step next) (sameValue reg)) (sameValue val)) : ∃ pred : List R → Option V, ∀ s, Learnable.Predicts next reg val pred s` | A feature whose class contains the reading's core is learnable. "What one class tells is carried by another's core." |
| 292 | thm | `Steps.next_is_step` | `theorem Steps.next_is_step : «谓» Steps.next (Law.step Nat.succ)` | The moments of a course are the successor law's step. |
| 296 | thm | `SameAhead.is_core` | `theorem SameAhead.is_core {o : Nat → O} : «谓» («核» Steps.next (sameValue o)) (SameAhead o)` | Two moments are one state exactly where they lie in one core class of the course's value class. |
| 305 | thm | `SameAhead.next_by_root` | `theorem SameAhead.next_by_root {o : Nat → O} {t t' : Nat} (h : SameAhead o t t') : SameAhead o (t + 1) (t' + 1)` | A state goes on as itself, from the root theorem. |
| 312 | thm | `course_core_iff` | `theorem course_core_iff {next : S → S} {o : S → R} {s : S} {t t' : Nat} : «核» Steps.next (sameValue (Learnable.course next o s)) t t' ↔ «核» (Law.step next) (sameValue o) (Law.orbit next s t) (Law.orbit next s t')` | Along a course, core on moments = core on configurations. |
| 319 | thm | `SameAhead.no_continuation` | `theorem SameAhead.no_continuation {o : Nat → O} (new : ∀ t t', o t = o t' → t = t') (t t' : Nat) : ¬ «续» Steps.next («核» Steps.next (sameValue o)) t t'` | A course with a new value at every moment has no continuation under its core (the flame's form). |
| 326 | thm | `core_iff_below` | `theorem core_iff_below {o : Nat → O} {N : Nat} (bound : StatesBelow o N) {t t' : Nat} : «核» Steps.next (sameValue o) t t' ↔ ∀ n, n < N + N - 1 → o (t + n) = o (t' + n)` | With at most N states the core is read off `2N - 1` steps. |
| 331 | thm | `statesBelow_iff_core` | (see file) | At most N states = at most N core classes. |
| 347-395 | defs/thms | `TwoCourses.next`, `.value`, `.core_iff`, `.core_iff_bounded`, `.core_exact` | (see file) | Two courses as one net; core = agreement from there; bound exact. Not central to (a)-(d). |

## 2. GrammarRegularity.lean

Header (6-69): "The regularity of a line, kept and changed, and rules that change themselves (规律之守与变)".
States, for every carrier, relation and class, how the core is kept and left along a line; reads
processes changing their own rule, and closed capture, as models. "The general laws are short
corollaries of `«根»`, `«有常则续不尽»` and `«亡于核下不变»`; what they add is where along a line the
core is left." Not derived: that any actual rule is read from what it selects; that the loss is a loss
to any formation; which class carries an actual regularity.

| line | kind | name | exact statement | plain sentence |
|---|---|---|---|---|
| 86 | thm | `«守核则不穷»` | `theorem «守核则不穷» {R E : «际» α} {x y : α} (kept : «续» R («核» R E) x y) : «不穷» R («核» R E) y` | After one step under the core, the line under the core never ends. Any relations. |
| 94 | thm | `«相续之始有后»` | `theorem «相续之始有后» {R E : «际» α} {x y : α} (line : «相续» R E x y) : «有后» R E x` | A line's first occurrence has a successor. |
| 101 | thm | `«相续之末步»` | `theorem «相续之末步» {R E : «际» α} {x y : α} (line : «相续» R E x y) : ∃ w, «续» R E w y ∧ (x = w ∨ «相续» R E x w)` | Every line has a last step. |
| 111 | thm | `«守核之线不亡»` | `theorem «守核之线不亡» {R E : «际» α} {x y : α} (line : «相续» R («核» R E) x y) : «有后» R E y` | A line kept under the core leaves its end still continued under E. |
| 118 | thm | `«亡前核变»` | `theorem «亡前核变» {R E : «际» α} {x y : α} (c : «续» R E x y) (ends : «亡» R E y) : «异» R E («核» R E) x y` | A step under E into an E-end continues under E and is told apart by E's core. Any relation E (no class premise). THE ROOT'S FORM OF (b)/(c): what goes the same up to its end passes across the core's classes. |
| 125 | thm | `«有亡之线末步离核»` | `theorem «有亡之线末步离核» {R E : «际» α} {x y : α} (line : «相续» R E x y) (ends : «亡» R E y) : ∃ w, «异» R E («核» R E) w y ∧ (x = w ∨ «相续» R E x w)` | The last step of every line under E that ends leaves the core. |
| 132 | thm | `«有亡之线两端核异»` | `theorem «有亡之线两端核异» {R E : «际» α} (hE : «类» E) {x y : α} (line : «相续» R E x y) (ends : «亡» R E y) : ¬ «核» R E x y` | For a class E, the two ends of a line that ends are apart in the core. |
| 146 | thm | `Law.unending_iff_steps` | `theorem unending_iff_steps {next : S → S} {E : «际» S} {s : S} : «不穷» (step next) E s ↔ ∀ n, E (orbit next s n) (orbit next s (n + 1))` | Along a TOTAL law step, never ending under any relation E is E holding at every consecutive orbit pair. |
| 175 | thm | `Law.unending_alike` | `theorem unending_alike {next : S → S} {E : «际» S} (hE : «类» E) {s : S} (never : «不穷» (step next) E s) : ∀ n, E s (orbit next s n)` | Under a class, a never-ending line keeps every orbit point alike with its start. |
| 189 | def | `moveRel` | `def moveRel (P : Process S A) (a : A) : «际» S := fun s t => P.step s a t` | A process's move as 缘. |
| 194 | thm | `constant_of_goAlike` | `theorem constant_of_goAlike {P : Process S A} {π : S → K} (total : ∀ s a, ∃ t, P.step s a t) (alike : GoAlike P π) (a : A) : «有常» (moveRel P a) (sameValue π)` | Where every move is possible from everywhere, going alike gives constancy at each move. The premise `total` is the "there is a next" that the guard removes. |
| 201 | thm | `goAlike_of_constant` | `theorem goAlike_of_constant {P : Process S A} {π : S → K} (determined : Determined P) (constant : ∀ a, «有常» (moveRel P a) (sameValue π)) : GoAlike P π` | Where determined, constancy at every move gives going alike. |
| 207 | thm | `goAlike_iff_constant` | `theorem goAlike_iff_constant {P : Process S A} {π : S → K} (total : ∀ s a, ∃ t, P.step s a t) (determined : Determined P) : GoAlike P π ↔ ∀ a, «有常» (moveRel P a) (sameValue π)` | Determined and total: going alike = constant at every move. |
| 221 | thm | `adaptive_constant_iff` | `theorem adaptive_constant_iff {F : R → X → U → X} {G : R → X → R} : (∀ u, «有常» (moveRel (adaptive F G) u) (sameValue (Prod.fst : X × R → X))) ↔ ∀ g g' x u, F g x u = F g' x u` | The state's class (first coordinate) is constant under every move exactly where the rule (second coordinate) makes no difference to the next state. **This is the statement "a part carries a law of its own exactly where the rest makes no difference to its next step"**, in the grammar. `adaptive F G` is total and determined (step `(x, g) ↦ (F g x u, G g x)`). |
| 229 | thm | `adaptive_core_iff` | `theorem adaptive_core_iff {F : R → X → U → X} {G : R → X → R} : (∀ u, «则» (sameValue (Prod.fst : X × R → X)) («核» (moveRel (adaptive F G) u) (sameValue (Prod.fst : X × R → X)))) ↔ ∀ g g' x u, F g x u = F g' x u` | The state's class lies inside its own core under every move exactly where the rule makes no difference. (Docstring says "is its own core"; statement is inclusion, which with `«根»`.1 is the same.) |
| 239 | thm | `adaptive_core_apart` | `theorem adaptive_core_apart {F : R → X → U → X} {G : R → X → R} {g g' : R} {x : X} {u : U} (differs : ¬ F g x u = F g' x u) : ¬ «核» (moveRel (adaptive F G) u) (sameValue (Prod.fst : X × R → X)) (x, g) (x, g')` | Where two rules take one state by one move to different states, the state class's core tells the two configurations apart: the core reads the coordinate the class does not. (Q4.) |
| 263 | thm | `ClosedCapture.constant_iff_unread` | `theorem constant_iff_unread {f : A × B → R → A × B} {h : A × B → R → R} : (∀ reads : Nat → Bool, «有常» (Law.step (Pace.step f h reads)) (sameValue (loopPart (A := A) (B := B) (R := R)))) ↔ Unread f h` | The class of share, rule and step count is constant along every schedule exactly where nothing beyond the share is read. Same shape as `adaptive_constant_iff`. |
| 279 | def | `ClosedCapture.favouredAlike` | `def favouredAlike (favours : R → Prop) {S : Type u} : «际» (S × R × Nat) := fun p q => favours p.2.1 ↔ favours q.2.1` | Class "favours or not" of the rule in force. |
| 287 | def | `ClosedCapture.lockedAlike` | `def lockedAlike (M : Ideals.Preorder R) (favours : R → Prop) (hA : A → R → R) : «际» ((A × Nat) × R × Nat) := fun p q => Locked M favours hA (p.1.1, p.2.1) ↔ Locked M favours hA (q.1.1, q.2.1)` | Class "locked or not". |
| 296 | def | `ClosedCapture.loss` | `def loss (p : (A × Nat) × R × Nat) : Nat := p.1.2` | The coordinate beyond the share. |
| 312 | thm | `ClosedCapture.loss_alters` | `theorem loss_alters {fA : A → R → A} {fB : A × Nat → R → Nat} {h : A × Nat → R → R} {reads : Nat → Bool} (accrues : Accrues fB) (p : (A × Nat) × R × Nat) : ¬ loss p = loss (Pace.step (join fA fB) h reads p)` | Where every step adds to the loss, every step changes it. |
| 324 | thm | `ClosedCapture.lock_line` | `theorem lock_line ... (raises : Raises P favours fA) (monotone : ReadsShare P M hA) (upper : ∀ {g g'}, M.le g g' → favours g → favours g') (accrues : Accrues fB) {a : A} {b : Nat} {g : R} (locked : Locked M favours hA (a, g)) : «不穷» (Law.step (Pace.step (join fA fB) (joinRead hA) reads)) (lockedAlike M favours hA) ((a, b), g, 0) ∧ ∀ n, «异» (Law.step (Pace.step (join fA fB) (joinRead hA) reads)) (lockedAlike M favours hA) (sameValue loss) (Law.orbit … n) (Law.orbit … (n + 1))` | Under the premises of `lock_outlives_loss`, from a locked start the line under "locked or not" never ends, and each step is an alteration under the loss class. **(c) in its closed-capture form, but the loss RISES and the line never ends; there is no level running down and no end.** |
| 352 | thm | `ClosedCapture.loss_ends_line` | `theorem loss_ends_line {fA : A → R → A} {fB : A × Nat → R → Nat} {h : A × Nat → R → R} {reads : Nat → Bool} {favours : R → Prop} (accrues : Accrues fB) {N : Nat} (turns : ∀ p g, N ≤ p.2 → ¬ favours (h p g)) {a : A} {b : Nat} {g : R} {r : Nat} (at_r : reads r = true) (past : N ≤ b + r) (start : favours g) : ¬ «不穷» (Law.step (Pace.step (join fA fB) h reads)) (favouredAlike favours) ((a, b), g, 0)` | A reading that turns against favouring past a loss bound, with a reading step past the bound, makes the line under "favours or not" not unending. **(d)-like: the untold coordinate, once read, makes the difference; stated as ¬«不穷», not as an exhibited end.** |
| 371 | thm | `ClosedCapture.Beyond.closed_line` | (statement: `«不穷» … (lockedAlike order favours closedRead) ((twoToOne, 0), hi, 0) ∧ ∀ n, «异» … (sameValue loss) …`) | Witness: read from the share alone, locked for ever while the loss changes. |
| 386 | thm | `ClosedCapture.Beyond.open_line_ends` | (statement: `«续» … (favouredAlike favours) ((twoToOne, 0), hi, 0) (Law.orbit … 1) ∧ «亡» … (favouredAlike favours) (Law.orbit … 1)`) | Witness: read from the loss, the favouring line ends at the first step. |

## 3. GrammarScope.lean

Header (6-82): "The continuation condition on the root: everything on every center's continuing (续无外)".
Mostly about the continuation condition; the parts bearing on the pattern are the class of being
joined, "past one's own end", and "the core and endless lines".

| line | kind | name | exact statement | plain sentence |
|---|---|---|---|---|
| 94 | def | `«续无外»` | `def «续无外» (R E : «际» α) (center : Pos → α) : Prop := ∀ p x, «所及» R E (center p) x` | Every occurrence lies on every center's line under E. |
| 144 | thm | `«族之续即缘»` | `theorem «族之续即缘» (R : «际» α) : «谓» («续» R («同族» R «一»)) R` | Under the class of being joined, continuation is 缘. |
| 161 | thm | `«续即缘当且仅当含族»` | `theorem «续即缘当且仅当含族» (R : «际» α) {E : «际» α} (hE : «类» E) : «谓» («续» R E) R ↔ «则» («同族» R «一») E` | A class has 缘 as its continuation exactly where it contains the class of being joined. |
| 174 | thm | `«遍有后则族有常»` | `theorem «遍有后则族有常» (R : «际» α) (total : ∀ x, ∃ y, R x y) : «有常» R («同族» R «一»)` | Where every occurrence has a next, the class of being joined is constant. ("There is a next" as premise.) |
| 182 | thm | `«遍有后则缘在族核»` | `theorem «遍有后则缘在族核» (R : «际» α) (total : ∀ x, ∃ y, R x y) {x y : α} (h : R x y) : «续» R («核» R («同族» R «一»)) x y` | And then every condition continues under that class's core. |
| 200 | thm | `«过亡而续»` | `theorem «过亡而续» {R L O : «际» α} {c m z : α} (toEnd : «所及» R L c m) (ends : «亡» R O m) (next : «续» R L m z) : «所及» R L c z ∧ ¬ «相续» R O m z` | A coarser line goes on past where a line under O ends. (Two classes: one ends, the other continues.) |
| 210 | thm | `«核有续当且仅当有不穷»` | `theorem «核有续当且仅当有不穷» {R E : «际» α} : (∃ x y, «续» R («核» R E) x y) ↔ ∃ y, «不穷» R («核» R E) y` | The core continues something exactly where some line under it never ends. |
| 217 | thm | `«无不穷则核无续»` | `theorem «无不穷则核无续» {R E : «际» α} (ends : ∀ y, ¬ «不穷» R («核» R E) y) {x y : α} : ¬ «续» R («核» R E) x y` | Where no core line is endless, the core continues nothing. Relevant to (c): in a net where everything runs out, no class has a core that carries a step. |
| 318-391 | defs/thms | `LineOfDescent.Endless.*` (`step`, `member`, `member_ends`, `descent_constant`, `core_through_birth`, `descent_unending`, ...) | e.g. `theorem core_through_birth (n : Nat) : «续» step («核» step «一») (n, true) (n + 1, false) ∧ «亡» step member (n, true)` | Witness: member ends while the descent's core continues. |
| 403-475 | defs/thms | `LineOfDescent.Last.*` (`never_unending`, `core_no_continuation`, `descent_past_end`) | `theorem core_no_continuation : ∀ x y : Occ, ¬ «续» step («核» step «一») x y` | Witness: in a finite descent no class's core continues anything. |

## 4. GrammarReadings.lean

Header (3-37): the grammar's definitions read from the corpus: 化, 成坏, 同于, 复, 通.

| line | kind | name | exact statement | plain sentence |
|---|---|---|---|---|
| 50 | def | `«化»` | `def «化» (R E F : «际» α) : «际» α := fun x y => «续» R E x y ∧ ¬ F x y` | Alteration: continue under E while F tells apart. |
| 53 | thm | `«化之二说同形»` | `theorem «化之二说同形» (R E F : «际» α) : «谓» («化» R E F) («异» R E F)` | 化 is `«异»` (same definition). |
| 59 | def | `«成坏»` | `def «成坏» (L F : «际» α) : «际» α := fun x y => L x y ∧ ¬ F x y` | Alike under coarse L, apart under fine F. |
| 63 | thm | `«化为有缘之成坏»` | `theorem «化为有缘之成坏» (R E F : «际» α) : «谓» («化» R E F) («合» R («成坏» E F))` | 化 is 成坏 with a condition between. |
| 117 | thm | `«有常则往不穷»` | `theorem «有常则往不穷» {R E : «际» α} (hc : «有常» R E) {x : α} (hx : «有前» R E x) : «不穷» R E x` | Under a constant class, what has a past never ends going. |
| 160 | thm | `«非一非异»` | `theorem «非一非异» {R : «际» α} (irr : ∀ z, ¬ R z z) : (∀ x y, ¬ «续» R «静» x y) ∧ (∀ {x y}, R x y → ∃ E : «际» α, «类» E ∧ «化» R E «静» x y)` | Without self-conditioning, no continuation under identity, yet every condition continues under some class. |
| 172 | thm | `«因灭而续»` | `theorem «因灭而续» {R E : «际» α} (irr : ∀ z, ¬ R z z) {x y : α} (h : R x y) (e : E x y) : «亡» R «静» x ∧ «生» R «静» y ∧ «续» R E x y` | Ends under identity, continues under a coarser class. |

## 5. GrammarMap.lean

Header (3-50): the map of generation, keeping and degeneration at two grains; strong forms, branches,
calibrations against excluded middle.

| line | kind | name | exact statement | plain sentence |
|---|---|---|---|---|
| 62 | def | `«传»` | `def «传» (R L E : «际» α) (x y : α) : Prop := «续» R L x y ∧ «生» R E y` | Coarse L continues while a fine E line begins. |
| 65 | thm | `«传则异»` | `theorem «传则异» {R L E : «际» α} {x y : α} (h : «传» R L E x y) : «异» R L E x y` | A carrying renewal is an alteration. |
| 69 | def | `«所及»` | `def «所及» (R L : «际» α) (x y : α) : Prop := x = y ∨ «相续» R L x y` | Reached on the line. |
| 90 | def | `«有终»` | `def «有终» (R L : «际» α) (x : α) : Prop := ∃ y, «所及» R L x y ∧ «亡» R L y` | Some point the line reaches ends. |
| 111 | thm | `«有常则无终»` | `theorem «有常则无终» {R L : «际» α} (hc : «有常» R L) {x : α} (hx : «有前» R L x) : ¬ «有终» R L x` | A constant class has no end from a continued point. |
| 118 | thm | `«有终则粗不有常»` | `theorem «有终则粗不有常» {R L : «际» α} {x : α} (hx : «有前» R L x) (h : «有终» R L x) : ¬ «有常» R L` | What reaches an end after a continued step has a non-constant class. (Line form of `«有亡之续则不有常»`; the held attempt's `not_constant` is the one-step pair form.) |
| 125 | thm | `«不穷有终之定当且仅当排中»` | `theorem «不穷有终之定当且仅当排中» : (∀ (β : Type) (R L : «际» β) (x : β), «不穷» R L x ∨ «有终» R L x) ↔ ∀ P : Prop, P ∨ ¬ P` | "Never ends or reaches an end" for all models is excluded middle. Caution for any "turns or ends" dichotomy. |
| 220 | thm | `«相续之续»` | `theorem «相续之续» {R L : «际» α} {x z w : α} (h : «相续» R L x z) (c : «续» R L z w) : «相续» R L x w` | Extend a line by a step. |
| 225/229 | def | `«延»`, `«尽»` | `def «延» (R L : «际» α) (x : α) : Prop := ∃ S : α → Prop, S x ∧ ∀ z, S z → ∃ w, S w ∧ «续» R L z w`; `inductive «尽» (R L : «际» α) : α → Prop \| mk {x : α} : (∀ y, «续» R L x y → «尽» R L y) → «尽» R L x` | Goes on along some branch / ends on every branch. |
| 261 | thm | `«尽而续可定则有终»` | `theorem «尽而续可定则有终» {R L : «际» α} {x : α} (h : «尽» R L x) : (∀ y, «所及» R L x y → «有后» R L y ∨ ¬ «有后» R L y) → «有终» R L x` | Ending on every branch reaches an end where having a next is decided. |
| 384 | def | `Map.step` | `def step : «际» Nat := fun m n => n = m + 1` | Successor net. |
| 464 | def | `Map.short` | `def short : «际» Bool := fun a b => a = false ∧ b = true` | Two occurrences, one step, then none. |
| 466 | thm | `Map.short_end` | `theorem short_end : «亡» short «一» true` | The short life ends. |
| 510 | def | `Map.StepWhere.relation` | `def relation (P : Prop) : «际» Bool := fun x y => short x y ∧ P` | **A relation gated by a guard** (a proposition P, not a state predicate). |
| 518 | thm | `Map.StepWhere.has_next_iff` | `theorem has_next_iff (P : Prop) : «有后» (relation P) «一» false ↔ P` | Under the gated step, having a next is the guard. The only "guard ↔ next" lemma in my files, for a one-point constant guard. |
| 584 | thm | `«尽则有终当且仅当排中»` | `theorem «尽则有终当且仅当排中» : (∀ (β : Type) (R L : «际» β) (x : β), «尽» R L x → «有终» R L x) ↔ ∀ P : Prop, P ∨ ¬ P` | Every-branch ending reaching an end, for all models, is excluded middle; witnessed by the gated step. Caution: a guard that is any proposition makes "where is the end" undecidable; a decidable guard (e.g. `need ≤ level` on Nat) avoids it. |

## 6. GrammarCrossing.lean

Header (3-42): not going out of a region (不出); closedness; crossings on a line. Bears on the pattern
only through the place-on-a-line law:

| line | kind | name | exact statement | plain sentence |
|---|---|---|---|---|
| 150 | thm | `«内至外之线有出步»` | `theorem «内至外之线有出步» {R E : «际» α} {P : α → Prop} (split : ∀ u v, «续» R E u v → (P u → P v) ∨ (P u ∧ ¬ P v)) {x y : α} (line : «相续» R E x y) (inside : P x) (outside : ¬ P y) : ∃ u v, «续» R E u v ∧ (P u ∧ ¬ P v) ∧ (x = u ∨ «相续» R E x u) ∧ (v = y ∨ «相续» R E v y)` | A line from inside a region to outside has a step going out, placed on the line (from `«两端分则中有标»`). Usable to place "the step at which a level falls below a mark / the way turns". |
| 159 | thm | `«定则内至外之线有出步»` | `theorem «定则内至外之线有出步» {R E : «际» α} {P : α → Prop} (decided : ∀ a, P a ∨ ¬ P a) {x y : α} (line : «相续» R E x y) (inside : P x) (outside : ¬ P y) : ∃ u v, «续» R E u v ∧ (P u ∧ ¬ P v) ∧ (x = u ∨ «相续» R E x u) ∧ (v = y ∨ «相续» R E v y)` | Same, membership decided. The held attempt's `Turning.first_less` (a step from not-less to less) is this law's case on the orbit. |

## 7. GrammarTransport.lean

Header (3-56): the grammar's terms kept by one-to-one correspondence; `«尽»`/`«延»` pulled back along
maps. Relevant items:

| line | kind | name | exact statement | plain sentence |
|---|---|---|---|---|
| 104 | thm | `«尽之拉回»` | `theorem «尽之拉回» {α : Type u} {κ : Type v} {R L : «际» α} {R' L' : «际» κ} (φ : α → κ) (P : α → Prop) (closed : «闭» («续» R L) P) (maps : ∀ x y, P x → «续» R L x y → «续» R' L' (φ x) (φ y)) : ∀ x, P x → «尽» R' L' (φ x) → «尽» R L x` | Ending on every branch reflects along a map carrying continuation from a closed region. A tool for proving a model's ending from a simpler image (e.g. a level count). |
| 122 | thm | `«延之拉回»` | `theorem «延之拉回» {α : Type u} {κ : Type v} {R L : «际» α} {R' L' : «际» κ} (φ : α → κ) (lifts : ∀ x r, «续» R' L' (φ x) r → ∃ y, «续» R L x y ∧ φ y = r) (x : α) : «延» R' L' (φ x) → «延» R L x` | Going on along some branch reflects along a lifting map. |
| 198 | thm | `«部分恒等之像»` | `theorem «部分恒等之像» {P : α → Prop} {P' : β → Prop} (hP : ∀ x, P x ↔ P' (e.to x)) : «谓» («像» e.to («合» «静» (fun x _ => P x))) («合» «静» (fun x _ => P' x))` | A predicate is carried as its partial identity `«合» «静» (fun x _ => P x)`. **This is the grammar's way to write a guard**: a guarded step is `«而» («合» «静» (fun x _ => P x)) (Law.step next)` (not stated anywhere in my files). |
| 375, 417, 422, 552 | thm | `«不穷之对应»`, `«有常之对应»`, `«核之对应»`, `«同行之对应»` | e.g. `theorem «核之对应» (hR : «谓» («像» e.to R) R') (hE : «谓» («像» e.to E) E') (x y : α) : «核» R E x y ↔ «核» R' E' (e.to x) (e.to y)` | Endlessness, constancy, core, going alike kept by correspondence. `«至终有常»`, `«因于核»`, `«足以定核»`, `«迭内»`-based terms beyond those listed are not transported here (docstring 41-42 says added when a consumer reads them). |
| 516, 524 | thm | `«迭之像»`, `«迭之对应»` | `theorem «迭之对应» (hR : «谓» («像» e.to R) R') (n : Nat) (x y : α) : «迭» R n x y ↔ «迭» R' n (e.to x) (e.to y)` | n steps kept. |

## 8. GrammarCases.lean

Header (4-85): test systems of the source texts as witnesses: decay, no clear boundary, descent at two
grains, two family lines, shared conditions, a third thing, a belief.

| line | kind | name | exact statement | plain sentence |
|---|---|---|---|---|
| 98 | def | `Decay.possible` | `def possible : «际» Occ := fun x y => y.1 = x.1 + 1 ∧ (x.2 = true → y.2 = true)` | Net of possibilities for a nucleus. |
| 101 | def | `Decay.intactAlike` | `def intactAlike : «际» Occ := fun x y => x.2 = y.2` | "Intact or not". |
| 124 | thm | `Decay.possible_constant` | `theorem possible_constant : «有常» possible intactAlike` | Constant in the net of possibilities. |
| 132 | thm | `Decay.time_not_in_core` | `theorem time_not_in_core (t t' : Nat) : «核» possible intactAlike (t, false) (t', false)` | Time is not in that core (memorylessness). |
| 137 | def | `Decay.history` | `def history : «际» Occ := fun x y => x.2 = decide (2 ≤ x.1) ∧ y.1 = x.1 + 1 ∧ y.2 = decide (2 ≤ y.1)` | One history, intact at 0 and 1, decayed from 2. |
| 141 | thm | `Decay.history_within` | `theorem history_within : «则» history possible` | The history lies in the net. |
| 152 | thm | `Decay.history_apart` | `theorem history_apart : ¬ «核» history intactAlike (0, false) (1, false)` | **Witness of (b)/(c) already in the root**: along the history, "intact" is unchanged from 0 to 1, then 1 ends under the class; the core holds the two intact moments apart (time left is in the core). Proved by `«亡于核下不变»`. |
| 189-219 | thms | `Overlap.continues_each`, `b_positions`, `tolerance_line_apart` | (see file) | Overlapping identities: several classes. |
| 279 | thm | `TwoLines.family_constant` | `theorem family_constant : «有常» step family` | Family line constant. |
| 286 | thm | `TwoLines.core_through_birth` | `theorem core_through_birth (f : Bool) (n : Nat) : «续» step («核» step family) (f, n, true) (f, n + 1, false) ∧ «亡» step member (f, n, true)` | Member ends, family core goes on. |
| 376 | thm | `SharedCondition.affecting_member_outside` | `theorem affecting_member_outside (n : Nat) : ¬ «所及» affecting (sameValue living) (.a 0) (.b n)` | Under a class that holds the shared condition apart, one line does not reach the other. |
| 557 | thm | `ThirdAffects.third_constant` | `theorem third_constant : «有常» step (sameValue third)` | (see header) |
| 617 | thm | `ThirdFed.constant_takes_third` | `theorem constant_takes_third {E : «际» Occ} (constant : «有常» step E) {m n : Nat} (held : E (.r m) (.a n)) : E (.s (m + 1)) (.a (n + 1)) ∨ E (.s (m + 1)) (.r (n + 1))` | A constant class holding a stage of the condition with a member takes in what the condition feeds. (Class depending on the way things are joined.) |
| 639 | thm | `Belief.rate_changes_on_step` | `theorem rate_changes_on_step : moveRel (adaptive spread grow) () (1, 0) (1, 1) := rfl` | The rate changes with the number. |
| 643 | thm | `Belief.rate_read_in_regularity` | `theorem rate_read_in_regularity : ¬ «核» (moveRel (adaptive spread grow) ()) (sameValue (Prod.fst : Nat × Nat → Nat)) (1, 0) (1, 1)` | Instance of `adaptive_core_apart`: the rate, not in the class, is in its core. |

## 9. GrammarCandidates.lean

Header (4-38): the corpus's candidate theorems, tested: correlatives, no own position, precedence, what
no finite test separates. Relevant items:

| line | kind | name | exact statement | plain sentence |
|---|---|---|---|---|
| 307 | thm | `«断则无相续»` | `theorem «断则无相续» {R E : «际» α} {x : α} (h : «亡» R E x) (y : α) : ¬ «相续» R E x y` | What ends starts no line. |
| 396 | thm | `«状所可别»` | `theorem «状所可别» {S P : «际» α} {x y : α} (h : (S x y ∧ ¬ P x y) ∨ (¬ S x y ∧ P x y)) : ¬ «合» S P x y` | Alike under one class, apart under another: the joint class tells them apart. (Q4, trivial.) |
| 415 | thm | `«薪尽火传»` | `theorem «薪尽火传» (n : Nat) : «亡» «薪火» «静» n ∧ «不穷» «薪火» «一» n` | Each stick ends under identity; the fire's line never ends. |
| 522 | def | `«诘»` | `def «诘» (R E : «际» α) : Nat → «际» α \| 0 => E \| k + 1 => fun u u' => E u u' ∧ (∀ v, R u v → ∃ v', R u' v' ∧ «诘» R E k v v') ∧ (∀ v', R u' v' → ∃ v, R u v ∧ «诘» R E k v v')` | Not told apart at stage k (bisimulation stages). |
| 528 | thm | `«对称有常则不可诘»` | `theorem «对称有常则不可诘» {R E S : «际» α} (hSE : «则» S E) (hs : «则» S («逆» S)) (hc : «有常» R S) : ∀ k u u', S u u' → «诘» R E k u u'` | A symmetric constant relation in E is told apart at no stage. |
| 539 | thm | `«核则不可致诘»` | `theorem «核则不可致诘» {R E : «际» α} {u u' : α} (h : «核» R E u u') (k : Nat) : «诘» R E k u u'` | The core is never told apart at a finite stage. Stagewise step matching; nearest relative of the held attempt's `core_steps`. |
| 567 | thm | `«层即诘»` | `theorem «层即诘» {R E : «际» α} : ∀ k x y, «层» R E k x y ↔ «诘» R E k x y` | The two stage definitions agree. |
| 596 | thm | `«每层不分而有常则核当且仅当每层不分»` | `theorem «每层不分而有常则核当且仅当每层不分» {R E : «际» α} (hE : «则» E («逆» E)) (hc : «有常» R (fun u u' => ∀ k, «层» R E k u u')) {x y : α} : «核» R E x y ↔ ∀ k, «层» R E k x y` | Under a constancy premise the core is what no stage separates. |
| 612 | def | `«歧网之步»` | `def «歧网之步» : «际» «歧网» \| .«甲», y => ∃ n, y = .«链» n 0 \| .«乙», y => (∃ n, y = .«链» n 0) ∨ y = .«无尽» 0 \| .«链» n i, y => i < n ∧ y = .«链» n (i + 1) \| .«无尽» j, y => y = .«无尽» (j + 1)` | A branching net whose chain step `.«链» n i` is **guarded** (`i < n ∧ y = …`): a counter that runs out. |
| 650 | thm | `«无尽与链不同核»` | `theorem «无尽与链不同核» {S : «际» «歧网»} (hc : «有常» «歧网之步» S) : ∀ d j n i, i + d = n → ¬ S (.«无尽» j) (.«链» n i)` | No constant relation holds the endless chain with a finite one at any distance from its end: a guarded run-out is in every core. Close to "the core tells how long is left". |
| 673 | thm | `«致诘不尽»` | `theorem «致诘不尽» : ∃ (β : Type) (R : «际» β) (u u' : β), (∀ k, «诘» R «一» k u u') ∧ ¬ «核» R «一» u u'` | No finite stage separates, yet not in one core class (infinite branching). |

## 10. GrammarConditionals.lean

Header (4-25): the corpus's conditional laws; new laws: 相推 gives 全生成, bounded room on a line,
"what the core puts together never ends alike", dependence `«依»`; witnesses.

| line | kind | name | exact statement | plain sentence |
|---|---|---|---|---|
| 43 | thm | `«亡者异当且仅当有后»` | `theorem «亡者异当且仅当有后» {R E F : «际» α} {x : α} (ends : «亡» R E x) : (∃ y, «异» R F E x y) ↔ «有后» R F x` | What ends under E alters into F exactly where it has an F-successor. (d)-adjacent: an end under one class with a next under another is an alteration. |
| 108 | thm | `«亡而通则异»` | `theorem «亡而通则异» {R E F : «际» α} {x : α} (ends : «亡» R E x) (h : «通» R F x) : ∃ y, «异» R F E x y` | What ends under E and passes through under F alters. |
| 174 | thm | `«步皆分则皆亡»` | `theorem «步皆分则皆亡» {R E : «际» α} (leaves : ∀ a b, R a b → ¬ E a b) (x : α) : «亡» R E x` | Where E parts every step, everything ends under E. |
| 264 | thm | `«线不返则短于所列»` | `theorem «线不返则短于所列» {R E : «际» α} {l : List α} {g : Nat → α} {n : Nat} (noReturn : ∀ i, i ≤ n → ¬ «相续» R E (g i) (g i)) (steps : ∀ i, i < n → «续» R E (g i) (g (i + 1))) (held : ∀ i, i ≤ n → g i ∈ l) : n < l.length` | A non-returning line held by a list is shorter than the list. A grammar-level bound on how long a line in finite room can last. |
| 287 | thm | `«不返而有限则非不穷»` | `theorem «不返而有限则非不穷» {R E : «际» α} {x : α} {l : List α} (noReturn : ∀ y, (x = y ∨ «相续» R E x y) → ¬ «相续» R E y y) (held : ∀ y, (x = y ∨ «相续» R E x y) → y ∈ l) : ¬ «不穷» R E x` | A non-returning line in finite room is not endless (no end exhibited constructively). Root-level form of "running out": a level that only falls is a non-returning line in finite room. |
| 370 | thm | `«非有常之类不含于核之例»` | `theorem «非有常之类不含于核之例» : ∃ (R : «际» Bool), ¬ «有常» R «一» ∧ ¬ «核» R «一» false true` | Witness: a class holding a goer and a non-goer alike is not constant and its core holds them apart. Witness form of the held attempt's `not_constant` + `core_apart`. |
| 401 | def | `«依»` | `def «依» (R : «际» α) (P Q : α → Prop) : Prop := ∀ y, Q y → ∃ x, R x y ∧ P x` | Q depends on P along R: every Q-occurrence has a P-condition. Dependence of predicates, not of classes. |
| 407 | thm | `«所依无则依者无»` | `theorem «所依无则依者无» {R : «际» α} {P Q : α → Prop} (dep : «依» R P Q) (none : ¬ ∃ x, P x) : ¬ ∃ y, Q y` | Where what is depended on is absent, the dependent is absent. (d)'s "what would bring the difference is itself running out" has only this static form. |
| 414 | thm | `«依之传»` | `theorem «依之传» {R R' : «际» α} {P Q S : α → Prop} (first : «依» R P Q) (second : «依» R' Q S) : «依» («而» R R') P S` | Dependences compose. |
| 539 | thm | `«类内有常则线相随»` | `theorem «类内有常则线相随» {R E S : «际» α} (hE : «类» E) (hSE : «则» S E) (hc : «有常» R S) : ∀ {u' z' : α}, «相续» R E u' z' → ∀ {u : α}, S u' u → ∃ z, «相续» R E u z ∧ S z' z` | A line under class E from u' is matched place by place from anything S-related to it, S within E and constant. The line (相续) version of the held attempt's `core_steps`. |
| 560 | thm | `«核同则同不穷»` | `theorem «核同则同不穷» {R E : «际» α} (hE : «类» E) {y y' : α} (hk : «核» R E y y') (endless : «不穷» R E y) : «不穷» R E y'` | What the core puts with a never-ending occurrence never ends: core-alike occurrences agree on endlessness. The infinite counterpart of "core-alike lines are equally long" (the reader's M3 suggestion). |
| 595 | thm | `«不穷与亡不同核之例»` | `theorem «不穷与亡不同核之例» : ∃ (R : «际» (Option Unit)), «不穷» R «一» (some ()) ∧ «亡» R «一» none ∧ ¬ «核» R «一» (some ()) none` | Witness: never-ending and ending apart in the core. |
| 671 | thm | `«相须之例»` | `theorem «相须之例» : «相须» (fun (u v : Bool × Bool × Bool) => u.1 = u.2.1 ∧ v.1 = u.1 ∧ v.2.1 = u.2.1) (fun u v => u.1 = v.1) (fun u v => u.2.1 = v.2.1) ∧ «合» … (false, false, false) (false, false, true) ∧ (false, false, false) ≠ ((false, false, true) : Bool × Bool × Bool)` | Witness of mutual need (joint class constant, neither alone), on a relation with a **guard** (`u.1 = u.2.1`: a point goes on only where its first two bits agree). (Q3, Q4.) |

## 11. GrammarTesting.lean

Header (3-25): testing within the net (验): stages `«层»` approximating the core; one direction a
theorem; a wider net tells apart what a narrower one does not.

| line | kind | name | exact statement | plain sentence |
|---|---|---|---|---|
| 38 | def | `«层»` | `def «层» (R E : «际» α) : Nat → «际» α \| 0 => E \| k + 1 => fun x y => «层» R E k x y ∧ (∀ v, R x v → ∃ v', R y v' ∧ «层» R E k v v') ∧ (∀ v', R y v' → ∃ v, R x v ∧ «层» R E k v v')` | Stages of the core. |
| 45 | thm | `«核在每层之内»` | `theorem «核在每层之内» (R E : «际» α) : ∀ k, «则» («核» R E) («层» R E k)` | The core lies in every stage. (Its proof uses the held attempt's `core_step` inline.) |
| 56 | thm | `«可分则不在核»` | `theorem «可分则不在核» {R E : «际» α} {x y : α} (h : ∃ k, ¬ «层» R E k x y) : ¬ «核» R E x y` | What a finite stage tells apart is not in the core. A way to prove "the core tells the level" in a model: exhibit a stage. |
| 128 | thm | `«恒温与平衡»` | `theorem «恒温与平衡» : «核» Room.closed Room.alike Room.balanced Room.held ∧ ¬ «核» Room.opened Room.alike Room.balanced Room.held` | A wider net tells apart what a narrower one does not. (Q4: which relation is read decides what the core tells.) |

---------------------------------------------------------------------------------------------------

## Answers to the questions

**(1) What each file is for** is in each section's header line above.

**(2) GrammarCourse and GrammarRegularity: a law's run, a description, going alike.**
- A law's run: `Law.step next : «际» S := fun s t => t = next s` (GrammarCourse 103), with `Law.orbit`
  (Recurrence 240) as the run; lines along it lie on the orbit (`Law.line_on_orbit`, 169).
- A description (projection) `o : S → R` or `π : S → K` is read as the class `sameValue o` (71).
- Going alike: in GrammarCourse it enters through `KeepsAndCarries next o π` (which contains
  `GoAlike (process next) π`); `Law.keepsAndCarries_iff` (146) makes it `«则» (sameValue π) (sameValue o)
  ∧ «有常» (step next) (sameValue π)`, through `Learning.goAlike_iff_lumped` (LearningRuns 113) and
  `Law.constant_iff_keeps` (112). Because `Law.step` is total and determined, going alike and constancy
  coincide there; the gap of (b) cannot appear on `Law.step`. In GrammarRegularity, for a process with
  moves, `constant_of_goAlike` (194) needs `total`, `goAlike_of_constant` (201) needs `Determined`, and
  `goAlike_iff_constant` (207) needs both. The gap of (b) (going alike yet not constant) is exactly a
  failure of `total`; the root's general form of that gap is `«局定后则有常当且仅当同行可续»`
  (GrammarLaws 2612) and `«至终有常»` (GrammarPath 222), not in my files.
- **A part carries a law of its own exactly where the rest makes no difference to its next step:**
  `adaptive_constant_iff` (GrammarRegularity 221): `(∀ u, «有常» (moveRel (adaptive F G) u) (sameValue
  (Prod.fst : X × R → X))) ↔ ∀ g g' x u, F g x u = F g' x u`; the core form `adaptive_core_iff` (229);
  the process form `adaptive_state_law_iff` (Mechanism 234, `GoAlike (adaptive F G) Prod.fst ↔ ∀ g g' x
  u, F g x u = F g' x u`); the closed-capture form `ClosedCapture.constant_iff_unread` (263); and the
  value form `Law.constant_iff_core` (GrammarCourse 233). Where it fails, `adaptive_core_apart` (239)
  says the state class's core tells the two rules apart.

**(3) A relation built from a step function with a guard.** No general definition or lemma in my files.
`Law.step` (GrammarCourse 103) is unguarded; `Law.step_hasSucc_iff`, `Law.ends_iff_changes`,
`Law.unending_iff`, `Law.unending_iff_steps`, `Law.line_on_orbit`, `Law.unending_alike` are its laws and
all rely on totality. Guarded relations occur only as concrete witnesses: `Map.StepWhere.relation`
(GrammarMap 510, guard a proposition, with `has_next_iff` 518 and `ends` 514); the chain step of
`«歧网之步»` (GrammarCandidates 612, guard `i < n`, with `«无尽与链不同核»` 650 and `«链与无尽不可诘»`
624); the relation of `«相须之例»` (GrammarConditionals 671, guard `u.1 = u.2.1`); `Decay.history`
(GrammarCases 137, determined, not a guard). The grammar's means to write a guard is the partial
identity `«合» «静» (fun x _ => P x)` (GrammarTransport 198, `«部分恒等之像»`); a guarded step would be
`«而» («合» «静» (fun x _ => P x)) (Law.step next)` but nothing states or uses that. Outside my files the
reader-1 report points to `Law.steps_orbit`, `Law.step_fixed` (Recurrence 255, 263) for the
unguarded process; the held attempt's `Course.cond`, `ends_iff`, `steps_iff`, `lasts_or_ended`,
`never_ends_iff`, `cond_fixed` are the guarded forms not yet in the package.

**(4) One class depending on another; a class telling apart what another does not.**
- Telling apart: `«亡前核变»`, `«有亡之线末步离核»`, `«有亡之线两端核异»` (GrammarRegularity 118, 125,
  132: the core of E tells apart what E holds alike, at a line's end); `adaptive_core_apart` (239) and
  `Belief.rate_read_in_regularity` (GrammarCases 643: the core of the state class tells the rule);
  `ClosedCapture.lock_line` (324: locked-class alike while the loss class tells every step apart, as
  `«异»`); `Decay.history_apart` (GrammarCases 152); `«恒温与平衡»` (GrammarTesting 128: a wider relation
  tells apart); `«状所可别»` (GrammarCandidates 396); `«成坏»`, `«化»` (GrammarReadings 59, 50);
  `«过亡而续»` (GrammarScope 200: one class ends where another continues).
- Containment of regularities: `core_within_core_iff` (GrammarCourse 83), `Law.learnable_of_core_within`
  (275).
- Dependence: `«依»` / `«所依无则依者无»` / `«依之传»` (GrammarConditionals 401, 407, 414) are about
  predicates along R, not classes. `«相须之例»` (671) instances the root's `«相须»`. The root's class
  dependence terms `«足以定核»`, `«因于核»`, `«相须核»` (Grammar 612, 615, 618) are used in none of my
  eleven files.

## Where the held attempt (TurningInTime.lean) restates what my files have

- `TurningInTime.core_step` (109): the pointwise use of `(«根» R E).2.1` via `«有常之逐点»`, done inline
  in `«核在每层之内»` (GrammarTesting 49), `adaptive_core_apart` (GrammarRegularity 242),
  `SameAhead.next_by_root` (GrammarCourse 307).
- `TurningInTime.core_steps` (114): the `«迭»` analogue of `«类内有常则线相随»` (GrammarConditionals 539,
  lines under a class, S within E constant) and of `«核则不可致诘»` (GrammarCandidates 539, stages). No
  `«迭»` form exists in my files.
- `TurningInTime.core_apart` (126): covered by `«有亡之线两端核异»` (GrammarRegularity 132) and
  `«亡前核变»` (118) for lines, by `«亡于核下不变»` (Grammar 523) in general; witnessed by
  `«不穷与亡不同核之例»` (GrammarConditionals 595) and `«非有常之类不含于核之例»` (370).
- `TurningInTime.not_constant` (131): `«有终则粗不有常»` (GrammarMap 118) in line form; `«有亡之续则不有常»`
  (Grammar 370) in step form; witness `«非有常之类不含于核之例»`.
- `TurningInTime.Course.alike` (193) is `sameValue Prod.fst` (GrammarCourse 71); `alike_class` (210) is
  `sameValue_class Prod.fst`.
- `TurningInTime.Course.step` (186) is `adaptive F G`'s step (Mechanism 225) with one move, `X := Way`,
  `R := Nat`, `F x w () := c.renew w x`, `G x w := c.left w x` (the level read as the "rule"); `Course.cond`
  adds the guard `c.need ≤ s.2`. So `Course.goesAlike_iff` (318) and `differs_between` (330) are, on the
  unguarded step, `adaptive_constant_iff`; `core_tells` (370) is of the kind of `adaptive_core_apart`
  (though proved there from ending, not from the rule).
- `TurningInTime.Course.never_ends_iff` (284) is the guarded form of `Law.unending_iff_steps`
  (GrammarRegularity 146); `Course.ends_iff` (242) the guarded form of `Law.step_hasSucc_iff` /
  `Law.ends_iff_changes`.
- `Turning.first_less` (591) is a case of `«定则内至外之线有出步»` (GrammarCrossing 159) read on the orbit.

## Not read, or not settled

- I did not read Grammar.lean, GrammarLaws.lean or GrammarPath.lean in full (only the definitions cited
  above); Recurrence, Mechanism, IdentificationRuns, LearningRuns, Laws, ClosedCapture, Pace,
  RuleCapture only at the lines cited. The premises inside `ClosedCapture.lock_line` (`Raises`,
  `ReadsShare`, `Accrues`, `Locked`) were not unfolded.
- I did not check that every declaration builds or has an empty axiom report; the headers say so.
- Whether `Course.step` matches `adaptive` definitionally (argument order of `renew`, `left`) I read
  from the attempt's lines 179-186; not checked in Lean.
- GrammarCrossing's region laws and GrammarCandidates' correlative/mark/contact/disputation sections and
  GrammarScope's World section were read but not listed: they do not bear on (a)-(d).
