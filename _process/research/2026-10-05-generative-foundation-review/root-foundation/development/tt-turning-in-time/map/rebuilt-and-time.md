Kept as written; local paths in it point to the session's scratch folder.

AI-written map, 12 November 2026

# Rebuilt readers, rebuilt rules, the condition in time, reading in time, and the optimum's drive

Read only. Nothing was built, run or changed but this file. PKG is
`/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`.
Line numbers are each file's own. Statements are copied from the source; where a statement runs on
past its first line into the proof term, only the statement is copied. "Theorem", "def", "abbrev"
and "hypothesis" (a named premise of a theorem) are kept apart. The held attempt is
`/Users/ren/theories/tmp/r7/the-loop/lean/Becoming/TurningInTime.lean` (called TT below).

The pattern, as the task states it: (a) R and a class E; (b) going alike while one has a next and
another none, so E is not constant, and the core tells what E does not; (c) a line the same in a
respect up to its end while a level it depends on runs down, with a point of no return; (d) it turns
in time only if what the respect does not tell comes to make a difference while there is a next, and
what would bring it is often itself running out.

---

## 1. ReaderRebuilding.lean (OG): where a reader is rebuilt from

Imports `Becoming.GrammarLaws`. Namespace `Becoming.ReaderRebuilding`.

### The net, exactly

- 67 `inductive Source where | given | supply | level | none` (def). Where a spent unit is rebuilt from.
- 75 `structure Rule where span : Nat  count : Nat  setLevel : Nat  source : Source` (def): span `s`,
  set count `n`, set level `m`, source.
- 82 `structure St where level : Nat  ages : List Nat` (def): an occurrence is the level and the
  reader's units by age.
- 87 `def read (m k l : Nat) : Nat := if l < m then (if l + k < m then l + k else m) else l`:
  `k` units each take one while the level is below `m`.
- 90 `def older (s : Nat) : List Nat → List Nat | [] => [] | a :: as => if a + 1 < s then (a + 1) :: older s as else older s as`.
- 95 `def age (r : Rule) (as : List Nat) : List Nat := match r.source with | .given => as | .supply => older r.span as | .level => older r.span as | .none => older r.span as`.
- 103 `def rebuild (r : Rule) (on : Bool) (l : Nat) (as : List Nat) : St :=` if `as.length < r.count`
  then by source: `.level`: `0 => ⟨0, as⟩`, `l + 1 => ⟨l, 0 :: as⟩`; `.supply`: `true => ⟨l, 0 :: as⟩`,
  `false => ⟨l, as⟩`; `.given`, `.none` => `⟨l, as⟩`; else `⟨l, as⟩`. At most one unit is made per step.
- 119 `def step (r : Rule) (on : Bool) (x : St) : St :=
  rebuild r on (if on then read r.setLevel x.ages.length (x.level - 1) else x.level - 1)
    (age r x.ages)`.
  Order: draw one (truncated at 0), read with the unit count before ageing (only if supplied), age,
  rebuild. Rebuild from the level spends one further unit of level.
- 124 `def net (r : Rule) : «际» St := fun x y => ∃ on, y = step r on x` (the supply is a free branch).
- 127 `def supplied (r : Rule) : «际» St := fun x y => y = step r true x`.
- 130 `def run (r : Rule) (on : Bool) : Nat → St → St | 0, x => x | k + 1, x => run r on k (step r on x)`
  (a constant `on` throughout).
- 135 `def Present (x : St) : Prop := x.ages ≠ []`.
- 138 `def fresh (n l : Nat) : St := ⟨l, List.replicate n 0⟩`.
- 296 `def Quiet (r : Rule) (on : Bool) (l : Nat) : Prop := (r.source = .supply ∧ on = false) ∨ r.source = .none ∨ (r.source = .level ∧ on = false ∧ l = 0)`.
- 453 `def BuysTime (r : Rule) : Prop := (∀ k, ∃ l, Present (run r false (k + 1) (fresh r.count l))) ∧ ∃ k, (run r false k (fresh r.count 0)).ages = []`.
- 490 `abbrev EndsAt (r : Rule) (l h : Nat) : Prop := 0 < (run r false (h - 1) (fresh r.count l)).ages.length ∧ (run r false h (fresh r.count l)).ages.length = 0`.

What is rebuilt from what: a spent reader unit, from one unit of the level (`.level`), from the
supply while on (`.supply`), never (`.none`), or the reader does not age (`.given`). The level is
raised only by the read, which needs supply on and at least one unit.

### Main laws (all theorems)

- 196 `theorem «供则读者不绝» {r : Rule} (hs : r.source = .level) (hn : 1 ≤ r.count)
    (hm : 1 ≤ r.setLevel) (l : Nat) {as : List Nat} (present : as ≠ []) :
    Present (step r true ⟨l, as⟩)`
  Rebuilt from the level, `n ≥ 1`, `m ≥ 1`: a present reader is present after a supplied step from
  every level.
- 209 `theorem «供则读者之域闭» {r : Rule} (hs : r.source = .level) (hn : 1 ≤ r.count)
    (hm : 1 ≤ r.setLevel) : «闭» (supplied r) Present`
  The same as closure of `Present` under the supplied step (root's `«闭»`).
- 220 `theorem cut_level (r : Rule) (x : St) : x.level ≤ (step r false x).level + 2`
  Any rule: a cut step draws at most two units.
- 230 `theorem cut_present {r : Rule} (hs : r.source = .level) (hn : 1 ≤ r.count) {x : St}
    (hl : 2 ≤ x.level) : Present (step r false x)`.
- 244 `theorem «断而有储则读者存» {r : Rule} (hs : r.source = .level) (hn : 1 ≤ r.count) :
    ∀ (k : Nat) (x : St), 2 * (k + 1) ≤ x.level → Present (run r false (k + 1) x)`
  Under a cut, rebuilt from the level, `n ≥ 1`: from level at least `2(k+1)`, present after `k+1`
  steps, whatever the ages at start. A lower bound on the horizon, not the horizon.
- 301 `theorem quiet_step {r : Rule} {on : Bool} {x : St} (q : Quiet r on x.level) :
    (step r on x).ages = older r.span x.ages ∧ Quiet r on (step r on x).level`.
- 335 `theorem quiet_end {r : Rule} {on : Bool} :
    ∀ (k j : Nat) (x : St), Quiet r on x.level → x.ages = List.replicate r.count j →
      r.span ≤ j + (k + 1) → (run r on (k + 1) x).ages = []`.
- 356 `theorem «断则取于供者尽» {r : Rule} (hs : r.source = .supply) (hspan : 1 ≤ r.span) (l : Nat) :
    (run r false r.span (fresh r.count l)).ages = []`.
- 365 `theorem «不复建者尽» {r : Rule} (hs : r.source = .none) (hspan : 1 ≤ r.span) (on : Bool)
    (l : Nat) : (run r on r.span (fresh r.count l)).ages = []`.
- 374 `theorem cut_empty_end {r : Rule} (hs : r.source = .level) (hspan : 1 ≤ r.span) :
    (run r false r.span (fresh r.count 0)).ages = []`.
- 386 `theorem «读者绝则无储» {r : Rule} (hs : r.source = .level) (hn : 1 ≤ r.count) (on : Bool)
    (x : St) (gone : (step r on x).ages = []) : (step r on x).level = 0`
  Rebuilt from the level: the reader ends at a step only with the level at 0.
- 404 `theorem «取于储者绝而不复» {r : Rule} (hs : r.source = .level) :
    «闭» (net r) (fun x => x = ⟨0, []⟩)`
  The single state level 0, no units, is closed under the whole net (supply on or off). No premise
  on `count` or `setLevel`.
- 423 `theorem «取于供者复» {r : Rule} (hs : r.source = .supply) (hn : 1 ≤ r.count) (l : Nat) :
    Present (step r true ⟨l, []⟩)`.
- 462 `theorem «以储买时当且仅当取于储» {r : Rule} (hn : 1 ≤ r.count) (hspan : 1 ≤ r.span) :
    BuysTime r ↔ r.source = .level`
  The family law. `BuysTime` is about fresh starts only.
- 497 `theorem «一元二期之时» : ∀ l, l < 15 → EndsAt ⟨2, 1, 2, .level⟩ l (2 * (l / 3 + 1)) := by decide`;
  501 `«一元三期之时» : ∀ l, l < 16 → EndsAt ⟨3, 1, 2, .level⟩ l (3 * (l / 4 + 1))`;
  505 `«取于供者之时» : ∀ l, l < 16 → EndsAt ⟨3, 1, 2, .supply⟩ l 3`. Decided for finitely many levels.

### What the header lists as not proved (lines 51-59)

"that the reader rebuilt from the level ends under a cut from every stock; that its horizon never
decreases in the stock; any rate for `n ≥ 2`". Not modelled: the flame and the equilibrium of the
design's family, the supply's and sink's amounts, turnover read as carrying, the organism's class
ending where its matter goes on. That the model describes a cell is "a correspondence duty". No bridge
to Flow or to RegimeMargin is stated or claimed. The general law "each further `s + 1` units buy `s`
steps" is called a conjecture the decided cases check (48-49).

---

## 2. RuleRebuilding.lean (OG2): a rule rebuilt from the members it limits

Imports `Becoming.GrammarLaws`. Namespace `Becoming.RuleRebuilding`.

### The net, exactly

- 129 `inductive Source where | members | outside | none`.
- 136 `structure Rule where tenure : Nat  teachingAge : Nat  renewal : Nat  untaught : Nat  strength : Nat  source : Source`
  (`s`, `l`, `g`, `f`, `c`, source).
- 145 `structure St where quota : Nat  level : Nat  holders : List Nat  others : List Nat`
  (counts by cohort, youngest first).
- 152 `structure Move where on : Bool  rev : Option Nat` (entrants on offer; a revision).
- 174 `def take (x : St) : Nat := sumL x.holders + sumL x.others` (each member draws one unit).
- 177 `def teachers (r : Rule) (x : St) : Nat := after r.teachingAge x.holders` (holders of age ≥ `l`,
  before ageing).
- 180 `def taught : Source → Nat → Nat → Nat | .members, _, 0 => 0 | .members, q, _ + 1 => q | .outside, q, _ => q | .none, _, _ => 0`.
- 187 `def entrant (r : Rule) (on : Bool) (x : St) : Nat := match on with | true => taught r.source x.quota (teachers r x) | false => 0`.
- 194 `def door (r : Rule) (on : Bool) (x : St) : Nat := match on with | true => r.untaught - r.strength * teachers r x | false => 0`.
- 200 `def reviseHeld : Nat → Nat → Option Nat → Nat | 0, q, _ => q | _ + 1, q, Option.none => q | _ + 1, _, Option.some v => v`.
- 206 `def revised (r : Rule) (rev : Option Nat) (x : St) : Nat` (members and none: `reviseHeld (sumL x.holders) x.quota rev`; outside: `x.quota`).
- 214 `abbrev Ends (r : Rule) (x : St) : Prop := x.level = 0 ∨ x.level + r.renewal < take x`.
- 217 `def onward (r : Rule) (m : Move) (x : St) : St :=
  ⟨revised r m.rev x, x.level + r.renewal - take x,
    keep r.tenure (entrant r m.on x :: x.holders), keep r.tenure (door r m.on x :: x.others)⟩`.
- 222 `def step (r : Rule) (m : Move) (x : St) : St :=
  if Ends r x then ⟨x.quota, 0, [], []⟩ else onward r m x`.
- 226 `def net (r : Rule) : «际» St := fun x y => ∃ m, y = step r m x`.
- 229 `def run (r : Rule) (c : Nat → Move) : Nat → St → St | 0, x => x | k + 1, x => step r (c k) (run r c k x)`
  (choices indexed by step, not by state).
- 234 `def always : Nat → Move := fun _ => ⟨true, Option.none⟩`.
- 237 `def Held (x : St) : Prop := 0 < sumL x.holders`; 240 `def NoHolder (x : St) : Prop := sumL x.holders = 0`;
  243 `def Gone (x : St) : Prop := x.level = 0 ∧ sumL x.holders = 0 ∧ sumL x.others = 0`.
- 246 `def leak (r : Rule) (q : Nat) : Nat := r.untaught - r.strength * q * (r.tenure - r.teachingAge)`.
- 251 `def steady (r : Rule) (q L : Nat) : St := ⟨q, L, List.replicate r.tenure q, List.replicate r.tenure (leak r q)⟩`.
- 255 `def nobody (r : Rule) (q L : Nat) : St := ⟨q, L, List.replicate r.tenure 0, List.replicate r.tenure r.untaught⟩`.
- 259 `abbrev Band (r : Rule) (q : Nat) : Prop := r.teachingAge < r.tenure ∧ 1 ≤ q ∧ (q + leak r q) * r.tenure ≤ r.renewal`.
- 487 `def Closed (r : Rule) (c : Nat → Move) (F : St → Prop) : Prop := ∀ i y, F y → ¬ Ends r y → F (onward r (c i) y)`.
- 839 `def Steady (r : Rule) (q : Nat) (y : St) : Prop := ∃ L, y = steady r q L`.
- 1097 `def Within (r : Rule) (P Q : Nat) (x : St) : Prop := x.holders.length = r.tenure ∧ Each (fun a => P ≤ a ∧ a ≤ Q) x.holders ∧ x.others.length ≤ r.tenure ∧ Each (· ≤ leak r P) x.others ∧ P ≤ x.quota ∧ x.quota ≤ Q ∧ 1 ≤ x.level`.
- 1106 `abbrev Fits (r : Rule) (P Q : Nat) : Prop := r.source = .members ∧ r.teachingAge < r.tenure ∧ 1 ≤ P ∧ P ≤ Q ∧ (Q + leak r P) * r.tenure ≤ r.renewal`.
- 1111 `def onIn (r : Rule) (P Q : Nat) : «际» St := fun x y => ∃ rev, RevIn P Q rev ∧ y = step r ⟨true, rev⟩ x`.
- 1345 `def Goes (r : Rule) (x : St) : Prop := ∀ k, 1 ≤ (run r always k x).level`;
  1348 `def EndsUp (r : Rule) (x : St) : Prop := ∃ k, Gone (run r always k x)`.

What is rebuilt from what: the holders (the rule) are rebuilt each step from the teachers' count
(`.members`), from outside (`.outside`, at the quota whatever the teachers), or not at all. The
level is a shared stock, renewed by a constant `g` and drawn by one unit per member; the gated end
(`Ends`) is a modelling choice "with the form of `Flow`'s gated ending ... and no law here uses
`Flow`" (21-23).

### Main laws (all theorems)

The constant-take lemma (L1), the nearest thing in these files to (c):
- 493 `theorem «恒取不逾生则存» {r : Rule} {c : Nat → Move} {F : St → Prop} {A : Nat}
    (hc : Closed r c F) (ht : ∀ y, F y → take y = A) (hA : A ≤ r.renewal) {x : St} (hx : F x)
    (hL : 1 ≤ x.level) : ∀ k, F (run r c k x) ∧ x.level ≤ (run r c k x).level`.
- 509 `theorem «恒取逾生则减» {r : Rule} {c : Nat → Move} {F : St → Prop} {d : Nat}
    (hc : Closed r c F) (ht : ∀ y, F y → take y = r.renewal + d) (hd : 1 ≤ d) {x : St} (hx : F x)
    {r₀ k : Nat} (hL : x.level = r₀ + k * d) :
    ∀ i m, i + m = k → F (run r c i x) ∧ (run r c i x).level = r₀ + m * d`.
- 539 `theorem «恒取逾生则尽» {r : Rule} {c : Nat → Move} {F : St → Prop} {d : Nat}
    (hc : Closed r c F) (ht : ∀ y, F y → take y = r.renewal + d) (hd : 1 ≤ d) {x : St} (hx : F x) :
    ∃ k, Gone (run r c (k + 1) x) ∧ ∀ i, i ≤ k → F (run r c i x)`
  A family `F` closed under the non-ending steps, with constant take `g + d`, `d ≥ 1`: `F` holds at
  every step up to `k` and the state is `Gone` at `k + 1`. So the respect `F` is kept to the end while
  the level falls by `d` a step. No point of no return is stated; the end is not a threshold here.
- 866 `theorem steady_kept ... (hA : (q + leak r q) * r.tenure ≤ r.renewal) {L : Nat} (hL : 1 ≤ L) (k : Nat) :
    Steady r q (run r always k (steady r q L)) ∧ L ≤ (run r always k (steady r q L)).level`
  (premises `hsrc : r.source = .members ∨ r.source = .outside`, `hl : r.teachingAge < r.tenure`, `hq : 1 ≤ q`).
- 872 `theorem steady_ends {r : Rule} (hsrc : r.source = .members ∨ r.source = .outside)
    (hl : r.teachingAge < r.tenure) {q : Nat} (hq : 1 ≤ q)
    (hA : r.renewal < (q + leak r q) * r.tenure) (L : Nat) :
    ∃ k, Gone (run r always (k + 1) (steady r q L)) ∧
      ∀ i, i ≤ k → Held (run r always i (steady r q L))`
  Held to the end, then gone.
- 897 `theorem «稳者恒持当且仅当在带» {r : Rule} (hm : r.source = .members) {q L : Nat} (hL : 1 ≤ L) :
    (∀ k, Held (run r always k (steady r q L))) ↔ Band r q`; 922 `«外授之稳同带»` the same with
  `(ho : r.source = .outside) (hl : r.teachingAge < r.tenure)`.
- 984 `theorem «带之二式» (r : Rule) (q : Nat) :
    (q + leak r q) * r.tenure ≤ r.renewal ↔
      q * r.tenure ≤ r.renewal ∧
        (r.untaught + q) * r.tenure ≤
          r.renewal + r.strength * (r.tenure - r.teachingAge) * q * r.tenure`.
- 1197 `theorem «域闭» {r : Rule} {P Q : Nat} (hf : Fits r P Q) : «闭» (onIn r P Q) (Within r P Q)`;
  1203 `«域中储不减» ... (hx : Within r P Q x) (hy : onIn r P Q x y) : x.level ≤ y.level`.
- 658 `theorem «不及任则持尽» {r : Rule} (hs : r.source = .members) (hsl : r.tenure ≤ r.teachingAge)
    (c : Nat → Move) {x : St} (hlen : x.holders.length ≤ r.tenure) :
    ∀ k, r.tenure ≤ k → sumL (run r c k x).holders = 0`.
- 698 `theorem «无持者不复» {r : Rule} (hs : r.source = .members ∨ r.source = .none) :
    «闭» (net r) NoHolder`.
- 773 `theorem «无持者额不与» ... (hx : NoHolder x) : ∀ k, (run r c k x).level = (run r c k y).level ∧ (run r c k x).holders = (run r c k y).holders ∧ (run r c k x).others = (run r c k y).others`
  (with `hl hh ho`: equal level, holders, others): with no holder the quota is read by nothing.
- 457 `theorem «尽而不复» (r : Rule) : «闭» (net r) Gone`.
- 1292 `theorem «无持而门开逾生则尽» {r : Rule} (hs : r.source = .members ∨ r.source = .none)
    {c : Nat → Move} (hon : ∀ i, (c i).on = true) (hsp : 1 ≤ r.tenure)
    (hA : r.renewal < r.untaught * r.tenure) {x : St} (hx : NoHolder x) :
    ∃ k, Gone (run r c k x)`.
- 1368 `theorem «稳开二试» {r : Rule} (hm : r.source = .members) (hl : r.teachingAge < r.tenure) {q L : Nat}
    (hq : 1 ≤ q) (hL : 1 ≤ L) :
    (Goes r (steady r q L) ↔ (q + leak r q) * r.tenure ≤ r.renewal) ∧
    (Goes r (nobody r q L) ↔ r.untaught * r.tenure ≤ r.renewal) ∧
    (r.renewal < (q + leak r q) * r.tenure → EndsUp r (steady r q L)) ∧
    (r.renewal < r.untaught * r.tenure → EndsUp r (nobody r q L))`.
- 1457 `theorem «改额为零则持尽» {r : Rule} (hm : r.source = .members) {x : St} (hx : Held x) (on : Bool)
    {c : Nat → Move} (hrev : ∀ i v, (c i).rev = Option.some v → v = 0) :
    ∀ k, r.tenure ≤ k →
      sumL (run r c k (step r ⟨on, Option.some 0⟩ x)).holders = 0`.
- 1482 `theorem «带不定改后»` (decided witnesses: the band does not settle what follows a revision).
- 1772 `theorem «隙之律» {r : Rule} (hm : r.source = .members) (hs : r.tenure = r.teachingAge + 1) {q L : Nat}
    (hq : 1 ≤ q) (hL : 1 ≤ L) {b : List Bool} (hb : b.length = r.tenure) (hk : 1 ≤ heldCount b) :
    (∀ n, Held (run r always n (strands r q b L))) ↔
      heldCount b * (q + (r.untaught - r.strength * q)) + emptyCount b * r.untaught ≤ r.renewal`;
  1792 `«隙过生持至尽»` (over that bound: held to the last state before `Gone`, the same shape as 872).
- 1885 `theorem «改而成隙则尽»` (decided: a revision to 0 and back makes gaps, held to step 17, `Gone` at 18).
- 1896 `theorem «同规随类» :
    «类» (fun x y : St => Held x ↔ Held y) ∧ «类» (fun x y : St => x.quota = y.quota) ∧
      Within rB 3 5 (steady rB 3 1) ∧ onIn rB 3 5 (steady rB 3 1)
        (step rB ⟨true, Option.some 5⟩ (steady rB 3 1)) ∧
      «续» (net rB) (fun x y => Held x ↔ Held y) (steady rB 3 1)
        (step rB ⟨true, Option.some 5⟩ (steady rB 3 1)) ∧
      ¬ «续» (net rB) (fun x y => x.quota = y.quota) (steady rB 3 1)
        (step rB ⟨true, Option.some 5⟩ (steady rB 3 1))`
  The one place in these files that reads the model with the root's `«类»` and `«续»`: one step
  continues under the class "held or not" and not under "the same quota", at one rule (a witness).

### What the header lists as not proved (lines 115-118)

"a classification of the ends; laws for states with gaps at `l < s − 1`; the interval of quotas
`«带之二式»` solves to; a bridge to `Flow`". Not modelled: why a teacher turns anyone away, conduct
other than entry, sanctions, who decides a revision, mixed tenures, schism, records, partial passing,
purposes, capture ("the revision is a free branch, not chosen by those it favours"). Correspondence to
any institution is "a correspondence duty". Header 54-56: "This is the steady state's law and not the
rule's". 97-99 (L10): "The law of a revision is the region, not the band."

---

## 3. ConditionInTime.lean (J3): the continuation condition in time

Imports FlowCenters, GroupEnding, SelectionTerm, Identity, PersistingChoices. No level, no draw.

### Main laws

- 98 `theorem returnsAlong_of_sink {c : X} (sink : ∀ g, ¬ rel c g) : ReturnsAlong rel c` (no premise).
- 106 `theorem returnsAlong_iff_sink (acyclic : «无环» rel) {c : X} :
    ReturnsAlong rel c ↔ ∀ g, ¬ rel c g`.
- 116 `theorem ownClosure_unrestricted_atReturning_acyclic_iff (acyclic : «无环» rel) :
    Unrestricted (selfAscribed (ownClosure rel) (Subtype.val : Returning rel → X)) ↔
      ((∃ c, ∀ g, ¬ rel c g) → ∀ f g : X, f = g)`.
- 133 `theorem Web.continuationStep_returns_iff {F : Type} {R : Nat → F → F → Prop} {x : Nat × F} :
    ReturnsAlong (Web.continuationStep R) x ↔ ∀ g, ¬ R x.1 x.2 g`
  On the net read off a continuation, an occurrence returns exactly where nothing continues it.
- 148 `def «续无外于后» (R E : «际» α) (time : α → Nat) (center : Pos → α) : Prop :=
  ∀ p x, time (center p) < time x → «所及» R E (center p) x`.
- 152 `theorem «及则后» {R : «际» α} {time : α → Nat} (forward : ∀ x y, R x y → time x < time y)
    {x y : α} (reach : «及» R x y) : time x < time y`.
- 159 `theorem «后则无环» {R : «际» α} {time : α → Nat} (forward : ∀ x y, R x y → time x < time y) :
    «无环» R`.
- 168 `theorem «续无外当且仅当后与独» {R E : «际» α} {time : α → Nat} {center : Pos → α}
    (forward : ∀ x y, R x y → time x < time y) :
    «续无外» R E center ↔
      «续无外于后» R E time center ∧ ∀ p x, time x ≤ time (center p) → center p = x`.
- 183 `theorem «独则同一中心» {time : α → Nat} {center : Pos → α}
    (alone : ∀ p x, time x ≤ time (center p) → center p = x) (p q : Pos) : center p = center q`.
- 191 `theorem «续无外则续无外于后» ... (none : «续无外» R E center) : «续无外于后» R E time center`.
- 238 `TwoSources.apart : «无环» net ∧ center true ≠ center false ∧ «续无外于后» net «一» time center ∧ ¬ «续无外» net «一» center`.
- 259 `def AffectsBefore (x y : Nat × F) : Prop :=
  x.1 < y.1 ∧ ∃ c, W.requires y.1 y.2 c ∧ x.2 ∈ L.present x.1 ∧
    (0 < L.take x.1 x.2 c ∨ 0 < L.give x.1 x.2 c)`.
- 264 `def StepInTime (x y : Nat × F) : Prop :=
  (y.1 = x.1 + 1 ∧ y.2 = x.2) ∨ L.AffectsBefore W x y`.
- 268 `def WithinTime (x y : Nat × F) : Prop := WithinClosure (L.StepInTime W) x y`.
- 273 `def MutuallyDependentFrom (t : Nat) : Prop := ∀ f g, ∃ u, L.WithinTime W (t, f) (u, g)`;
  277 `def MutuallyDependentInTime : Prop := ∀ t, L.MutuallyDependentFrom W t`.
- 298 `theorem stepInTime_acyclic : «无环» (L.StepInTime W)`.
- 306 `theorem not_returnsAlong_stepInTime (x : Nat × F) : ¬ ReturnsAlong (L.StepInTime W) x`.
- 324 `theorem WithinTime.withinReach {x y : Nat × F} (within : L.WithinTime W x y) :
    L.WithinReach W x.2 y.2`.
- 362 `theorem MutuallyDependentFrom.mutuallyDependent {t : Nat} (dependent : L.MutuallyDependentFrom W t) :
    L.MutuallyDependent W`.
- 386 `def datedOwnClosure (rel : «际» (Nat × F)) (center : Pos → Nat × F) : Pos → Nat → F → Prop :=
  fun p t g => WithinClosure rel (center p) (t, g)`;
  391 `def UnrestrictedAfter (sig : Pos → Nat → F → Prop) (step : Pos → Nat) : Prop := ∀ p t g, step p < t → sig p t g`;
  396 `def UnrestrictedEventually (sig : Pos → Nat → F → Prop) : Prop := ∀ p g, ∃ T, ∀ t, T ≤ t → sig p t g`.
- 406 `theorem unrestrictedAfter_iff_forward {rel : «际» (Nat × F)} {center : Pos → Nat × F} :
    UnrestrictedAfter (datedOwnClosure rel center) (fun p => (center p).1) ↔
      «续无外于后» rel «一» Prod.fst center`.
- 421 `theorem not_unrestricted_inTime (f : F) :
    ¬ Unrestricted (datedOwnClosure (L.StepInTime W) (id : Nat × F → Nat × F))`.
- 430 `theorem unrestrictedEventually_iff_mutuallyDependentInTime :
    UnrestrictedEventually (datedOwnClosure (L.StepInTime W) (id : Nat × F → Nat × F)) ↔
      L.MutuallyDependentInTime W`.
- 441 `theorem unrestrictedAfter_iff_coupledEachStep :
    UnrestrictedAfter (datedOwnClosure (L.StepInTime W) (id : Nat × F → Nat × F))
        Prod.fst ↔
      ∀ t f g, f = g ∨ L.AffectsBefore W (t, f) (t + 1, g)`.
- Witnesses `Recurring.inTime` (508), `RingOfThree.apart` (607, a failed candidate kept),
  `Drawing.lapses` (637), `LatePair.apart` (723).

Header note: `Flow.member_after_never_overdrew` "was proved here first and now stands in
`Becoming.PersistingChoices`" (78-81); it is not in this file. The header calls the first two
sections near-definitional, which the statements bear out.

---

## 4. ReadOffInTime.lean (K3): when a selection read off continuation reads a loss

Imports BeyondCoupling, ConditionInTime, Propagation, RegimeMargin.

### Definitions it uses from elsewhere (not defined here)

- Admission.lean 378 `def Admits (l : C → Nat) (t : Nat) (f : F) : Prop := ∀ c, W.requires t f c → W.need t f c ≤ l c`.
- Counterfactual.lean 132 `def AgreeUpTo (l l' : Nat → C → Nat) (t : Nat) : Prop := ∀ s, s ≤ t → ∀ c, l s c = l' s c`.
- Selection.lean 149 `def SelectsThroughAll (W : Web F C) (obs : F → C → Prop) (group : F → Prop) (t : Nat)
    (select : (Nat → C → Nat) → Prop) : Prop := ∀ l l', W.AlikeThroughAll obs group l l' t → (select l ↔ select l')`.
- Propagation.lean 104 `def gap (a b : Nat) : Nat := (a - b) + (b - a)`.
- `keeps` is not a definition anywhere in this module: it is a variable
  `{feasible keeps : (Nat → C → Nat) → Prop}` (598, 657), "what is asked of a course", supplied.

### Web namespace and the point of no return

- 137 `def FirstApart (group : F → Prop) (l l' : Nat → C → Nat) (T : Nat) : Prop :=
  (∃ g, group g ∧ ¬ (W.Admits (l T) T g ↔ W.Admits (l' T) T g)) ∧
    ∀ g, group g → ∀ t, t < T → (W.Admits (l t) t g ↔ W.Admits (l' t) t g)`.
- 143 `def TellsApartAt (sel : Nat → (Nat → C → Nat) → Prop) (l l' : Nat → C → Nat) (T : Nat) : Prop :=
  ¬ (sel T l ↔ sel T l') ∧ ∀ s, s < T → (sel s l ↔ sel s l')`.
- 151 `theorem alikeThroughAll_thresholdOnly_iff :
    W.AlikeThroughAll thresholdOnly group l l' T ↔
      ∀ g, group g → ∀ t, t ≤ T → (W.Admits (l t) t g ↔ W.Admits (l' t) t g)`.
- 159 `theorem FirstApart.alike_before (first : W.FirstApart group l l' T) {s : Nat} (before : s < T)
    (reads : W.SelectsThroughAll thresholdOnly group s select) : select l ↔ select l'`.
- 166 `theorem FirstApart.separates (first : W.FirstApart group l l' T) :
    ∃ select, W.SelectsThroughAll thresholdOnly group T select ∧ select l ∧ ¬ select l'`.
- 184 `theorem TellsApartAt.not_before ... (reads : ∀ s, W.SelectsThroughAll thresholdOnly group s (sel s))
    (first : W.FirstApart group l l' T₀) (tells : TellsApartAt sel l l' T) : T₀ ≤ T`.
- 196 `theorem first_of_decided {P Q : Nat → Prop} (decided : ∀ t, P t ∨ Q t) :
    ∀ n, (∀ t, t ≤ n → P t) ∨ ∃ m, m ≤ n ∧ Q m ∧ ∀ t, t < m → P t`
  (top level in `Becoming`, generic: a first failing step where each step is decided).
- 219 `theorem firstApart_of_apart (decided : ...) {n : Nat} {g : F} (member : group g) (differ : ¬ (W.Admits (l n) n g ↔ W.Admits (l' n) n g)) :
    ∃ T, T ≤ n ∧ W.FirstApart group l l' T`.
- 591 `def Recoverable (feasible keeps : (Nat → C → Nat) → Prop) (l : Nat → C → Nat) (N : Nat) : Prop :=
  ∃ l', feasible l' ∧ AgreeUpTo l' l N ∧ keeps l'`
  (in `section NoReturn`, top level in `Becoming`, not in `Web`).
- 595 `def NoReturnAt (feasible keeps : (Nat → C → Nat) → Prop) (l : Nat → C → Nat) (N : Nat) : Prop :=
  ¬ Recoverable feasible keeps l N ∧ ∀ n, n < N → Recoverable feasible keeps l n`.
- 601 `theorem Recoverable.earlier (rec : Recoverable feasible keeps l N) {n : Nat} (le : n ≤ N) :
    Recoverable feasible keeps l n`.
- 607 `theorem NoReturnAt.recoverable_iff (point : NoReturnAt feasible keeps l N) {n : Nat} :
    Recoverable feasible keeps l n ↔ n < N`.
- 615 `NoReturnAt.unique`; 625 `theorem NoReturnAt.parts (point : NoReturnAt feasible keeps l (N + 1)) :
    (∃ l', feasible l' ∧ AgreeUpTo l' l N ∧ keeps l') ∧
      ∀ l', feasible l' → AgreeUpTo l' l (N + 1) → ¬ keeps l'`.
- 632 `theorem noReturnAt_of_past (decided : ∀ n, Recoverable feasible keeps l n ∨
      ¬ Recoverable feasible keeps l n) {n : Nat} (past : ¬ Recoverable feasible keeps l n) :
    ∃ N, N ≤ n ∧ NoReturnAt feasible keeps l N`.
- 647 `def ReadableInTime (W : Web F C) (group : F → Prop) (feasible keeps : (Nat → C → Nat) → Prop)
    (l l' : Nat → C → Nat) : Prop :=
  ∃ T, W.FirstApart group l l' T ∧ Recoverable feasible keeps l T`.
- 653 `def ReadsInTime (sel : Nat → (Nat → C → Nat) → Prop) (feasible keeps : (Nat → C → Nat) → Prop)
    (l l' : Nat → C → Nat) : Prop :=
  ∃ T, TellsApartAt sel l l' T ∧ Recoverable feasible keeps l T`.
- 661 `theorem readableInTime_iff (first : W.FirstApart group l l' T)
    (point : NoReturnAt feasible keeps l N) : W.ReadableInTime group feasible keeps l l' ↔ T < N`.
- 669 `theorem ReadsInTime.readable (reads : ∀ s, W.SelectsThroughAll thresholdOnly group s (sel s))
    (first : W.FirstApart group l l' T) (inTime : ReadsInTime sel feasible keeps l l') :
    W.ReadableInTime group feasible keeps l l'`.
- 678 `theorem too_late_of_alike
    (alike : ∀ g, group g → ∀ t, t ≤ D → (W.Admits (l t) t g ↔ W.Admits (l' t) t g))
    (past : ¬ Recoverable feasible keeps l D) :
    ¬ W.ReadableInTime group feasible keeps l l' ∧
      ∀ sel, (∀ s, W.SelectsThroughAll thresholdOnly group s (sel s)) →
        ¬ ReadsInTime sel feasible keeps l l'`.
- 699 `too_late_of_unreached` (TimedResponse's deadline premises `balanced balanced' present start responds`
  up to `D`, `far : ∀ g, group g → ¬ Flow.ReachedInTime L L' W obs source g D`,
  `past : ¬ Recoverable feasible keeps W.level D`; same conclusion at `W.level W'.level`).
- 719 `theorem too_late_within_margin
    (within : ∀ g, group g → ∀ t, t ≤ D → W.Admits (l' t) t g ∧
      ∀ c, W.requires t g c → gap (l t c) (l' t c) ≤ l' t c - W.need t g c)
    (past : ¬ Recoverable feasible keeps l D) : <same conclusion>`.
- 743 `theorem too_late_of_own
    (within : ∀ m, keeps m → ∀ g, group g → ∀ t, W.Admits (m t) t g)
    (kept' : ∀ g, group g → ∀ t, W.Admits (l' t) t g) :
    ¬ W.ReadableInTime group feasible keeps l l' ∧
      ∀ sel, (∀ s, W.SelectsThroughAll thresholdOnly group s (sel s)) →
        ¬ ReadsInTime sel feasible keeps l l'`
  Exactly: where every course that keeps what is asked admits every member of the group at every
  step, and `l'` admits every member at every step, the courses are not readable in time and no
  family read off the group's continuations reads them in time. No `feasible` premise, no
  `FirstApart` premise, no `NoReturnAt` premise: the conclusion holds for any `feasible`. The
  docstring's "the loss is read only once it has happened, past its point of no return" is a reading
  of this; the statement says only "not in time". It is the formal shape of (d)'s second clause: what
  would read the difference (the group) is among what the course keeps.
- 557 `theorem admits_of_gap_within_margin (admitted : W.Admits (l' t) t g)
    (within : ∀ c, W.requires t g c → gap (l t c) (l' t c) ≤ l' t c - W.need t g c) :
    W.Admits (l t) t g`; 568 `admits_iff_gap_within_margin` (adds `lower : ∀ c, W.requires t g c → l t c ≤ l' t c`).
- Route: 237 `def AffectsBeforeBy`, 242 `AffectsBeforeEither`, 248 `StepInTimeEither`, 253 `WithinTimeEither`,
  259 `def ReachedInTime (L L' : Flow F C) (W : Web F C) (obs : F → C → Prop)
    (source : Nat → F → Prop) (g : F) (T : Nat) : Prop :=
  ∃ x z u, source x.1 x.2 ∧ WithinTimeEither L L' W obs x z ∧
    AffectsBeforeEither L L' W obs z (u, g) ∧ u ≤ T`;
  480 `TimedResponse.reachedBy_iff_reachedInTime`; 517 `Web.selectsAlike_unreached`; 533 `Web.FirstApart.not_unreached`.

### FourReaders (the one model with a level, 762-1370)

- 782 `inductive Stop | s0 | s1 | s2 | never` (the clearer stops before step 0, 1, 2, or never).
- 789 `def habitat : Stop → Nat → Nat` is a table (4,4,...; 4,3,3,...; 4,3,2,2,...; 4,3,2,1,0,0,...),
  not generated by a law; `flow k` (849) is given and `balances` (934) checks it against the table.
- 967 `def Feasible (l : Nat → Place → Nat) : Prop := ∃ k, ∀ t c, l t c = levels k t c`;
  971 `def DwellerKept (l : Nat → Place → Nat) : Prop := ∀ t, (web .never).Admits (l t) t .dweller`.
- 977 `theorem recoverable_iff {N : Nat} : Recoverable Feasible DwellerKept (levels .never) N ↔ N ≤ 2`.
- 1011 `theorem noReturn :
    NoReturnAt Feasible DwellerKept (levels .never) 3 ∧
      (web .never).Admits (levels .never 3) 3 .dweller ∧
      ¬ (web .never).Admits (levels .never 4) 4 .dweller`.
- 1034 `theorem regime_point {x : Nat} (high : x ≤ 4) :
    (∃ n, (Law.run (RegimeMargin.step giving 1) x).state n = 0) ↔ x < 2` (from `RegimeMargin.ends_iff_below`).
- 1068 `theorem stopped_is_regime : ∀ k n, habitat k (n + stopAt k) =
    (Law.run (RegimeMargin.step giving 1) (habitat k (stopAt k))).state n`.
- 1097 `theorem recoverable_iff_regime {N : Nat} :
    Recoverable Feasible DwellerKept (levels .never) N ↔
      ¬ ∃ n, (Law.run (RegimeMargin.step giving 1) (habitat .never N)).state n = 0`
  The one theorem in these files that identifies a course point of no return with a regime's exact
  point, on one witness.
- 1180 `near_inTime`, 1188 `mid_atThePoint`, 1197 `dweller_late` (uses `too_late_of_own`), 1362 `listener_late`.

### Its link to the lock's reading step (question 2)

The module states no theorem about the lock or MA2/MA4b. Header 13-16: MA2's timing law
(`ClosedCapture.Thinned`) and MA4b (`Becoming.ReadInTime`) "take the step at which the others read the
loss as supplied". Header 119-122: "Readings, not proved: MA2's and MA4b's reading step is here the
first step apart of a selection read off the others' continuations, and MA4b's deadline bounds what is
here the point of no return; their models differ from this one." The word "lock" does not occur. Also
stated (117-119): which way a reading turns a course is not stated (`Clearing.read_not_direction`).

---

## 5. BeyondCoupling.lean: what selection read off continuation cannot reach

No level dynamics; selection over the whole run.

- 143 `def ReadOffContinuations (group : F → Prop) (select : (Nat → C → Nat) → Prop) : Prop :=
  ∀ l l', (∀ g, group g → ∀ t, W.Admits (l t) t g ↔ W.Admits (l' t) t g) → (select l ↔ select l')`.
- 148 `def ReadOffCouplings (obs : F → C → Prop) (group : F → Prop) (select : (Nat → C → Nat) → Prop) :
    Prop :=
  ∀ l l', (∀ g, group g → ∀ t, W.AlikeThrough obs g l l' t) → (select l ↔ select l')`.
- 153 `def ContinuationClass (group : F → Prop) (l : Nat → C → Nat) : (Nat → C → Nat) → Prop :=
  fun m => ∀ g, group g → ∀ t, W.Admits (l t) t g ↔ W.Admits (m t) t g`.
- 165 `theorem readOffCouplings_thresholdOnly_iff :
    W.ReadOffCouplings thresholdOnly group select ↔ W.ReadOffContinuations group select`.
- 200 `theorem readOffCouplings_alike_iff {l l' : Nat → C → Nat} :
    (∀ select, W.ReadOffCouplings obs group select → (select l ↔ select l')) ↔
      ∀ g, group g → ∀ t, W.AlikeThrough obs g l l' t`.
- 211 `theorem readOffContinuations_alike_iff {l l' : Nat → C → Nat} :
    (∀ select, W.ReadOffContinuations group select → (select l ↔ select l')) ↔
      ∀ g, group g → ∀ t, W.Admits (l t) t g ↔ W.Admits (l' t) t g`.
- 226 `theorem separates_continuations {l l' : Nat → C → Nat} {g : F} (member : group g) {t : Nat}
    (differ : ¬ (W.Admits (l t) t g ↔ W.Admits (l' t) t g)) :
    ∃ select, W.ReadOffContinuations group select ∧ select l ∧ ¬ select l'`.
- 236 `theorem not_tracks_of_alike {S X : Type} {level : S → X} {select : X → Prop} {s s' : S}
    (alike : select (level s) ↔ select (level s')) {P : S → Prop} (holds : P s) (fails : ¬ P s') :
    ¬ ∀ σ, select (level σ) ↔ P σ`.
- 256 `theorem act_courses_unselected_throughout` (premises `na naAct naAct' through actThrough feasible
  feasible' agree members reads`; conclusion
  `select ((law.withAct part act).levels present start) ↔ select ((law.withAct part act').levels present start)`).
- 278 `def ActReadsWithin` (a premise on how significance acts, "not a law"); 292
  `significance_courses_unselected`.
- 329 `theorem returning_pool_covers (members : List F) (listed : ∀ g, g ∈ members)
    (decided : ∀ a b, Decidable (L.WithinReach W a b)) (obs : F → C → Prop) (g : F) :
    WithinClosureOf (L.CoupledFrom W obs) (L.ReachReturns W) g`.
- 357 `ownClosure_not_unrestricted_of_acyclic`; 367 `Flow.ownClosure_rival_of_within`; 409 `routeB_universal_closed`.

Header 122-127: "What is not derived: which act a significance gives ...; that any formation holds a
significance, or counts the dweller; who selects, or that a selection is read off a continuation; the
direction in which a coupled-in loss turns a selection; the relation and the centers of route (b)'s
form." Stated limit picked up by ReadOffInTime: reading in time is not stated here.

---

## 6. Optimum.lean: header and `least_iff` / `least_of_room` (545-650)

- 545 `def Exceeds (ds : List C) (o' o : C → Nat) : Prop :=
  (∀ c, c ∈ ds → o c ≤ o' c) ∧ ∃ c, c ∈ ds ∧ o c < o' c`.
- 550 `def Rising (ds : List C) (better : (C → Nat) → (C → Nat) → Prop) : Prop :=
  ∀ o o', Exceeds ds o' o → better o' o`.
- 555 `def Room (ds rest : List C) (eligible : (C → Nat) → Prop) : Prop :=
  ∀ o o', eligible o → eligible o' → ∀ c, c ∈ rest → o' c < o c →
    ∃ o'', eligible o'' ∧ Exceeds ds o'' o`.
- 560 `def Least (rest : List C) (eligible : (C → Nat) → Prop) (o : C → Nat) : Prop :=
  ∀ c, c ∈ rest → ∀ o', eligible o' → o c ≤ o' c`.
- Frontier.lean 72 `def Frontier (eligible : H → Prop) (better : H → H → Prop) (a : H) : Prop :=
  eligible a ∧ ∀ b, eligible b → ¬ better b a`.
- 591 `theorem least_iff :
    (∀ better, Rising ds better → ∀ o, Frontier eligible better o → Least rest eligible o) ↔
      ∀ o o', eligible o → eligible o' → ∀ c, c ∈ rest → o' c < o c →
        ¬ ¬ ∃ o'', eligible o'' ∧ Exceeds ds o'' o`.
- 605 `theorem least_of_room (rising : Rising ds better) (room : Room ds rest eligible) {o : C → Nat}
    (optimum : Frontier eligible better o) : Least rest eligible o`
  Every optimum (frontier member) of an order rising with the family `ds` stands, at each condition of
  `rest`, no higher than any eligible outcome, given room. Premises: `Rising`, `Room`, `Frontier`.
- 618 `def Shared`; 638 `Shared.room` (adds `apart : ∀ c, c ∈ rest → ¬ c ∈ ds`, `inside : d ∈ ds`);
  645 `least_of_shared`.

Is anything renewed in it (question 5)? No. `least_of_room` is a one-shot choice over a set of
outcomes `C → Nat`; there is no step, no time, no renewal, no state carried forward, no class of
occurrences. The "drive" is a property of frontiers of orders, not of a line. Renewal enters Optimum
only later in the file (header 108-142; `Optimum.Reoptimizes`, the `Levels` section from 2228), which
I read only as statements (below).

Optimum's course laws outside my region (read as statements only, section `Levels`, variables
2230 `variable {x g d : Nat → Nat} {r m : Nat}`): these bear directly on (c)-(d) and the held attempt.
- 2246 `theorem never_rises (step : ∀ t, x (t + 1) = x t + g t - d t) {t : Nat} (renews : g t ≤ r)
    (over : r < d t) : x (t + 1) ≤ x t`.
- 2255 `theorem level_stays_below (step : ∀ t, x (t + 1) = x t + g t - d t) (renews : ∀ t, g t ≤ r)
    (over : ∀ t, r < d t) {s : Nat} (below : x s < m) : ∀ j, x (s + j) < m`.
- 2289 `theorem ends_within (step : ∀ t, x (t + 1) = x t + g t - d t) (renews : ∀ t, g t ≤ r)
    (over : ∀ t, r < d t) (needs : 0 < m) :
    ∀ t, x 0 < m + t → x t < m`.
- 2357 `theorem gated_stays_below (step : ∀ t, x (t + 1) = x t + g t - d t)
    (unsupported : ∀ t, x t < m → g t = 0) {s : Nat} (below : x s < m) : ∀ j, x (s + j) < m`.
- 2369 `theorem reread_kept_iff (step : ∀ t, x (t + 1) = x t + g t - d t) {T : Nat}
    (renews : ∀ t, t < T → g t ≤ r) (over : ∀ t, t < T → r < d t) (keeps : ∀ t, T ≤ t → m ≤ x t → m ≤ x (t + 1)) :
    (∀ t, m ≤ x t) ↔ m ≤ x T`.
- 2396 `theorem reread_deadline_iff (step : ∀ t, x (t + 1) = x t + g t - d t)
    (renewing : ∀ t, m ≤ x t → g t = r) (renews : ∀ t, g t ≤ r) {k T : Nat}
    (draws : ∀ t, t < T → d t = k) (over : r < k) (needs : 0 < m) :
    m ≤ x T ↔ m + T * (k - r) ≤ x 0`.
These take the draw `d t` as varying from step to step (only `r < d t`), on a bare level sequence.

---

## 7. Answers

### (1) ReaderRebuilding and RuleRebuilding

ReaderRebuilding: state `St = ⟨level, ages⟩`; step = draw 1 (truncated), read (only if supplied; raises
the level by the pre-ageing unit count, capped at `m`), age (not for `.given`), rebuild one unit where
fewer than `n` remain, from one unit of the level / from the supply if on / never. The net branches
on the supply bit. Main laws: L0 kept while supplied (196, 209; `hs`, `hn`, `hm`); L1 lower bound
`2(k+1)` (244; `hs`, `hn`); supply/none end at the span under a cut (356, 365; `hspan`); L2 reader
ends only with level 0 (386) and `⟨0, []⟩` absorbing under the whole net (404, only `hs`); the family
law (462; `hn`, `hspan`). Not proved (header): ending under a cut from every stock; monotone horizon;
rates for `n ≥ 2`. No bridge to Flow or RegimeMargin is mentioned.

RuleRebuilding: state `St = ⟨quota, level, holders, others⟩`, move `⟨on, rev⟩`; step = gated end
(`level = 0 ∨ level + g < take` → level 0, no member, quota kept), else level `level + g − take`,
holders enter (taught by source), others pass the door `f − c·T`, cohorts kept to `s`, revision where
a holder stood and the source is not outside. The rule (holders) is rebuilt from the members'
teachers, from outside, or not at all; the level is renewed by constant `g`. Main laws: constant-take
L1 (493, 509, 539); band (897, 922); region (1197, 1203); drain (658, 677); no holder from no holder
(698, 737, 773); end closed (457); open entry (1255, 1276, 1292); two tests (1368); gaps (1772, 1792);
`«同规随类»` (1896). Not proved (header 115-116): a classification of the ends; laws for gaps at
`l < s − 1`; the interval `«带之二式»` solves to; a bridge to `Flow`.

### (2) ReadOffInTime

Definitions are copied in §4. `Admits` is Admission.lean's; `Recoverable` and `NoReturnAt` are top
level in `Becoming` (section `NoReturn`), not in `Web`; `ReadableInTime`, `ReadsInTime` are in `Web`;
`keeps` is a supplied predicate, never defined. `too_late_of_own` is copied in §4 with its exact
reading. The link to the lock's (MA2/MA4b) reading step is a reading only, stated in the header, with
"their models differ from this one".

### (3) ConditionInTime and BeyondCoupling

Copied in §3 and §5. ConditionInTime's substantive laws: `«续无外当且仅当后与独»` (168),
`unrestrictedEventually_iff_mutuallyDependentInTime` (430), `unrestrictedAfter_iff_coupledEachStep`
(441). BeyondCoupling's: `readOffContinuations_alike_iff` (211), `readOffCouplings_alike_iff` (200),
`act_courses_unselected_throughout` (256), `routeB_universal_closed` (409).

### (4) Is each model a case of "one respect (how it goes on) renewed alone except where a level lies between two marks, with a level under a draw"?

- **ReaderRebuilding: no, not as stated.** There is a level under a draw (one unit a step, and one
  more where the rebuild draws on it), and a respect that stays the same up to the end (`Present`,
  with `«读者绝则无储»` and `«取于储者绝而不复»`). But nothing in the state is "how it goes on" that a
  renewal changes: the source is a fixed field of `Rule`, and the only choice is the supply bit, a free
  branch of `net`, not a function of the level. Marks do not exist. The level alone is not a
  determined state: whether the rebuild draws depends on `ages`, so the level's step does not factor
  through the level (`cut_level` gives only a bound of two). It is not of the form
  `RegimeMargin.step giving use`. To make it a case one would have to prove a simulation: a map
  `St → Way × Nat` (Way trivial or the supply policy) under which `step r false` is a Course step with
  a draw of 1 or 2 that depends on the occurrence; TT's `Course.left` takes the draw from the way
  alone, so the Course would have to be widened to a draw read off the occurrence, or the level
  model would need a lemma that under a cut the draw is exactly 2 once the reader is at its count
  (not stated; `«一元二期之时»` and the others are finite checks). Its end under a cut from every stock
  is itself unproved (header).
- **RuleRebuilding: partly; (c) is already here in its own terms, (d) is not.** `«恒取逾生则尽»`
  (539) is "a respect `F`, closed under the non-ending steps, holds to the last state before `Gone`
  while the level falls by `d` a step"; `steady_ends` (872) and `«隙过生持至尽»` (1792) are its cases.
  The turn analogue, a revision, is a free branch (`Move.rev`, chosen per step index in `run`), never a
  function of the level, and nothing renews "how it goes on" by the level between marks. The level
  step `x.level + r.renewal - take x` with the `Ends` gate is not `RegimeMargin.step` (`(x - H) + g (x - H)`):
  they differ below the take and at level 0 (`Ends` ends at level 0 whatever the renewal). To be a
  case one would need: (i) a policy `St → Move` and a `run` driven by it (no such definition exists;
  `run` takes `Nat → Move`); (ii) a lemma identifying the level map with a Course `left` (a constant
  giving and use = take, with the gate as `need`), or a widening of Course's level law; (iii) the
  respect as a class on `St` (`Held`, or `Steady r q`), as `«同规随类»` already does at one step.
- **ConditionInTime: no.** It has no level and no draw; its objects are dated relations
  (`StepInTime`) and the continuation condition. What bears on the pattern is that a forward relation
  has no cycle (`«后则无环»`) and that an occurrence with no next is exactly a sink
  (`Web.continuationStep_returns_iff`), i.e. "has no next" is a sink of the dated net.
- **ReadOffInTime: its laws are (d) in general form; its model is not a Course.** `readableInTime_iff`
  says a reading is in time exactly where the first step apart precedes the point of no return;
  `too_late_of_own` says that where the reader is among what is kept, no reading is in time. In
  `FourReaders` there is a level under a draw, and after the stop it is the regime
  (`stopped_is_regime`), and the course point of no return is the regime's exact point
  (`recoverable_iff_regime`). But the "turn" (the clearer's stop) is a choice among four supplied
  courses (`Feasible`), not a renewal at a level between marks; nothing in the model turns because a
  gauge read; the habitat is a table checked by `balances`, and the clearing phase is not
  `RegimeMargin.step giving 2` (at level 2 the renewer gives on the level before the draw, so
  `2 → 1`, while `RegimeMargin.step giving 2 2 = 0`). To join TT to it one would prove, for a Course
  with marks: the line under "turn at the first level ≤ high" is one of the feasible courses; the step
  at which the level first lies between the marks is the `FirstApart` of a gauge with need `high + 1`
  against the spared course; and the Course's "never ends" from that step is `Recoverable` with
  `keeps` = never ends. Then TT's in-time condition would be `readableInTime_iff` at that gauge.
- **BeyondCoupling: no.** No level, no time order (whole run). It bears on (a)-(b): `ContinuationClass
  group l` is a class of histories, a selection read off continuations is one invariant under it
  (`ReadOffContinuations`), and `readOffContinuations_alike_iff` / `not_tracks_of_alike` say such a
  selection cannot track what that class does not tell. It is "what E does not tell" for selection,
  not for continuation of a line.

### (5) `Optimum.least_of_room`

Copied in §6. Nothing is renewed in it: it is about a single choice of outcome, with no step.

---

## 8. Where my files already contain what the held attempt proves

- TT `Turning.first_less` (591): a first step from not-less to less, under `[DecidablePred Less]`.
  ReadOffInTime 196 `first_of_decided` is the generic form (decided `P t ∨ Q t`; either `P` up to `n`
  or a first `m ≤ n` with `Q m` and `P` before). `first_less` follows from it with `P j := ¬ Less (c.way s j)`,
  `Q j := Less (c.way s j)`, and `start` excluding `m = 0`.
- TT `goes_on_iff` / `never_ends_iff`: the shape "before `T` the draw is above what is given, from `T` on
  the need is kept; never ends iff the level is right at `T`" is Optimum 2369 `reread_kept_iff`
  (bare level sequence, draw `d t` varying, `r < d t` before `T`, `keeps` from `T`). TT's
  `H₂ + y₂ ≤ c.level s (j + 1)` plays the role of `m ≤ x T`. Not identical (TT ends at `need`, has
  `Short` regimes and ways), but the same law in a level-only form already exists.
- TT `falls` / `falls_le` / `gone` / `below_stays` (varying draw never less than `H`, giving `Short`):
  the second reader wrote "RegimeMargin has no law for a draw that changes from step to step". Optimum
  already has varying-draw laws (`never_rises` 2246, `level_stays_below` 2255, `ends_within` 2289),
  under a different premise (`g t ≤ r < d t` at every step, not `Short g H y`). TT's `below_stays`
  is close to `level_stays_below`; `ends_below_least_use` is close to `ends_within`. A design should
  decide which premise form is the root one rather than add a third.
- TT `Witness.too_late` / `in_time` and the header's "turns in time": ReadOffInTime already has
  `ReadableInTime`, `ReadsInTime`, `too_late_of_alike`, `too_late_of_unreached`,
  `too_late_within_margin`, `too_late_of_own`, and the point of no return `NoReturnAt` on courses.
- TT's "a carrier of the difference that needs a level of the same condition" (`low`) is the setting of
  `too_late_of_own` (the reader's admission among what is kept), stated there generally and proved.
- TT `Course.Lasts`, `lasts_or_ended`: not in my files (the reader points to Lasting.lean).
- RuleRebuilding `«恒取逾生则尽»` already states TT's "used up while nothing in it differs" for a
  closed family under a constant excess draw, on its own model.

---

## 9. Not read or not settled

- Only the header and 545-650 of Optimum were read in full; 2228-2410 were read as statements only;
  the rest of Optimum was not read. `Drain.room_needed` (cited for "where it does not, an optimum need
  not be") was not checked.
- Not read: Admission, Counterfactual, Selection beyond the three definitions cited; RegimeMargin
  beyond the three definitions (`step` 249, `FromNothing` 252, `Short` 255); TimedResponse, Latency,
  Propagation beyond `gap`; ClosedCapture, ReadInTime (the lock's reading step); FlowCenters,
  PersistingChoices, GrammarScope, Lasting, GrammarPath. ReadOffInTime 365-500 (TimedResponse spread
  lemmas) and 1110-1360 (FourReaders first-apart proofs) and BeyondCoupling's witnesses
  `Clearing`/`Diversion` (426-586) were read only at their statements or not at all.
- Nothing was compiled; the empty axiom reports are taken from the headers.
- Not settled: whether the ReaderRebuilding level under a cut is exactly two units a step once the
  reader stands at its count (it would make that model a constant-draw regime); whether
  `Optimum.ends_within`'s premise and RegimeMargin's `Short` can be stated as one; whether
  `«恒取逾生则尽»`'s `Closed` family is a root class (`«类»`) continuing under `«续»` (only one step is
  shown, in `«同规随类»`).
