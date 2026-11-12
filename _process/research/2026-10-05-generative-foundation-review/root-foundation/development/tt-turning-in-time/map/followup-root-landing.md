Kept as written; local paths in it point to the session's scratch folder.

AI-written map, 12 November 2026

# Landing a root law in GrammarPath or OwnClass: what it touches, and what those files already state

Scope of this map: `_process/RESULT-WORKFLOW.md`; GATE.md section 5 (the file lives at
`_process/research/2026-10-05-repository-reconciliation/architecture/gt/GATE.md`; there is no
`_process/architecture/gt/GATE.md`); the records under `theories/becoming/results/records` that cite
GrammarPath.lean, OwnClass.lean, FromTheDynamics.lean or RoutesToC.lean (and, for the question, the other
modules of the import closure); `lean/regime/check_regime_reals.py`. Read only: nothing built, run or
rendered. Lean statements below were copied from the package (PKG =
`experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`) to give
the records' cited declarations exactly. Hashes and counts were computed by reading files with Python, not
by any checker.

## 1. Inventory

### 1.1 Declarations the records cite from GrammarPath.lean (bearing on (a)-(d))

All are in `namespace Becoming`, variables `{α : Type u}`. Status: `def` is a definition, `theorem` a
proved theorem; every argument listed is a hypothesis of that theorem.

| # | Line | Kind | Exact statement | What it states |
|---|---|---|---|---|
| G1 | GrammarPath 159 | def | `def «所缘同于» (R E : «际» α) (m : α) : Prop := ∀ v, R m v → E m v` | E holds m's effects: everything m conditions is E-alike to m. |
| G2 | GrammarPath 222 | def | `def «至终有常» (R E : «际» α) : Prop := ∀ u u', E u u' → ∀ v, R u v → (∃ v', R u' v' ∧ E v v') ∨ ∀ w, ¬ R u' w` | Constancy up to the net's end: whatever an alike occurrence conditions, this one conditions something alike to it, unless this one conditions nothing at all. It is exactly "alike stays alike, except that one may end where the net ends". |
| G3 | GrammarPath 226 | theorem | `theorem «有常则至终有常» {R E : «际» α} (constant : «有常» R E) : «至终有常» R E` | Constancy implies constancy up to the net's end. |
| G4 | GrammarPath 235 | def | `def «本类至终有常» (R E : «际» α) (m : α) : Prop := ∀ u u', E m u → E m u' → ∀ v, R u v → (∃ v', R u' v' ∧ E v v') ∨ ∀ w, ¬ R u' w` | G2 asked only of the occurrences alike to m (m's class). |
| G5 | GrammarPath 239 | theorem | `theorem «至终有常则本类至终有常» {R E : «际» α} (hE : «类» E) (constant : «至终有常» R E) (m : α) : «本类至终有常» R E m` | For a class E, G2 gives G4 at every m. |
| G6 | GrammarPath 246 | theorem | `theorem «至终有常之逐类» {R E : «际» α} (hE : «类» E) : «至终有常» R E ↔ ∀ m, «本类至终有常» R E m` | For a class, G2 is G4 at every member. |
| G7 | GrammarPath 253 | theorem | `theorem «亡而网续则不至终有常» {R E : «际» α} {x y : α} (hxy : «续» R E x y) (ends : «亡» R E y) (goes : ∃ w, R y w) : ¬ «至终有常» R E` | If a step under E reaches y, y has no E-alike next (ends under E) but y still conditions something, then E is not constant up to the net's end. Any E, class or not. The up-to-the-end form of Grammar's `«有亡之续则不有常»`. |
| G8 | GrammarPath 264 | theorem | `theorem «亡而网续则本类不至终有常» {R E : «际» α} {m x y : α} (mx : E m x) (my : E m y) (hxy : «续» R E x y) (ends : «亡» R E y) (goes : ∃ w, R y w) : ¬ «本类至终有常» R E m` | G7 at m's class, with x and y alike to m. |
| G9 | GrammarPath 164 | theorem | `theorem «后皆同类则后皆续» {R E : «际» α} (hE : «类» E) {c t : α} (all : ∀ s, «及» R c s → E c s) (down : «及» R c t) : «相续» R E c t` | If everything downstream of c is alike to c, each downstream t is on a line under E from c. No regularity assumed. |
| G10 | GrammarPath 175 | theorem | `theorem «后皆续当且仅当后皆同类» {R E : «际» α} (hE : «类» E) {m : α} : (∀ t, «及» R m t → «所及» R E m t) ↔ (∀ t, «及» R m t → E m t)` | Everything downstream lies on m's line exactly when everything downstream is alike to m. |
| G11 | GrammarPath 214 | theorem | `theorem «亡而网续则后不皆续» {R E : «际» α} (hE : «类» E) {m y : α} (line : «相续» R E m y) (ends : «亡» R E y) (goes : ∃ w, R y w) : ¬ ∀ t, «及» R m t → «所及» R E m t` | A line from m that ends at y while y still conditions something means not everything downstream is on the line. |
| G12 | GrammarPath 355 | theorem | `theorem «本类出类随行» {R E : «际» α} (hE : «类» E) {m c u : α} (atClass : «本类至终有常» R E m) (alike : E c m) (effect : R m u) (outside : ¬ E m u) (goes : ∃ w, R c w) : ∃ x, R c x ∧ E u x ∧ ¬ E c x` | Under G4 at m: if m conditions u outside its class and c (alike to m) conditions anything, c conditions something alike to u and outside c's class. |
| G13 | GrammarPath 367 | theorem | `theorem «出类随行» {R E : «际» α} (hE : «类» E) (constant : «至终有常» R E) {m c u : α} (alike : E c m) (effect : R m u) (outside : ¬ E m u) (goes : ∃ w, R c w) : ∃ x, R c x ∧ E u x ∧ ¬ E c x` | G12 under global G2. |
| G14 | GrammarPath 376 / 387 | theorem | `«本类出类随线»` / `«出类随线»`: as G12/G13 with `(line : «所及» R E m c)` in place of `(alike : E c m)` | What leaves the class follows every stage of the line that conditions anything. |
| G15 | GrammarPath 396 | theorem | `theorem «出类不随则本类不至终有常» {R E : «际» α} (hE : «类» E) {m c u : α} (alike : E c m) (effect : R m u) (outside : ¬ E m u) (goes : ∃ w, R c w) (clean : ∀ x, R c x → ¬ E u x) : ¬ «本类至终有常» R E m` | Contrapositive of G12: an alike c that goes on but conditions nothing alike to m's outside effect breaks G4. |
| G16 | GrammarPath 406 | theorem | `«出类不随则不至终有常»`, same premises, conclusion `¬ «至终有常» R E` | G15 for the global condition. |
| G17 | GrammarPath 414 | theorem | `theorem «本类常则闭当且仅当后皆同类» {R E : «际» α} (hE : «类» E) {m : α} (atClass : «本类至终有常» R E m) : «所缘同于» R E m ↔ ∀ t, «及» R m t → E m t` | Under G4, holding m's effects is everything downstream being alike. |
| G18 | GrammarPath 992-1009 (namespace CleanStep) | theorems on a witness | `theorem not_constant_at : ¬ «本类至终有常» step own .m`; `theorem not_constant_to_end : ¬ «至终有常» step own`; `theorem ends_where_net_ends {y : Occ} (line : «相续» step own .m y) (ends : «亡» step own y) : ∀ w, ¬ step y w` | A concrete net where every line under the class ends only where the net ends, yet G4 fails: G4 asks more than "a line ends only where the net does". |
| G19 | GrammarPath 1077 (namespace FiniteWake) | theorem on a witness | `theorem not_constant : ¬ «有常» step own` | In FiniteWake, the class is not constant (j alike to m, conditions nothing); the record pairs it with `FiniteWake.constant_to_end`: constant up to the end but not constant. |

The records also cite witness families FinerOutside, FinerWake, UnevenOutside, Inconstant, Unclosed,
FiniteFamilies, FiniteSharedCondition (constancy at a class under divisions of what lies outside; premises
not droppable). I did not copy each witness statement; they bear on how "outside" is divided, not on
(c)-(d).

### 1.2 Declarations the records cite from OwnClass.lean

| # | Line | Kind | Exact statement | What it states |
|---|---|---|---|---|
| O1 | OwnClass 99 | theorem | `«本类常闭则类闭» {R E : «际» α} (hE : «类» E) {m : α} (atClass : «本类至终有常» R E m) (goes : ∃ w, R m w) (held : «所缘同于» R E m) : «闭» R (E m)` | G4 + holding effects at an m that conditions something closes m's block under R. |
| O2 | OwnClass 105 | theorem | `theorem «类闭则本类常闭» {R E : «际» α} (hE : «类» E) {m : α} (closed : «闭» R (E m)) (decided : ∀ u, E m u → (∃ w, R u w) ∨ ∀ w, ¬ R u w) : «本类至终有常» R E m ∧ «所缘同于» R E m` | Converse, given it is decided of each alike occurrence whether it conditions something. |
| O3 | OwnClass 116 | theorem | `theorem «本类常闭当且仅当类闭» {R E : «际» α} (hE : «类» E) {m : α} (goes : ∃ w, R m w) (decided : ∀ u, E m u → (∃ w, R u w) ∨ ∀ w, ¬ R u w) : «本类至终有常» R E m ∧ «所缘同于» R E m ↔ «闭» R (E m)` | P2 and P4 at m are block-closure, under the two premises. |
| O4 | OwnClass 170 | def | `def «后类» (R : «际» α) (m : α) : «际» α := fun x y => x = y ∨ («所闭» R m x ∧ «所闭» R m y)` | The class of m with everything downstream of it. |
| O5 | OwnClass 238 | theorem | `theorem «返则后类本类常闭» {R : «际» α} {m : α} (returns : ReturnsAlong R m) : «本类至终有常» R («后类» R m) m ∧ «所缘同于» R («后类» R m) m` | Where m's closure returns to m (Frame.lean 161: `ReturnsAlong rel c := ∀ g, WithinClosure rel c g → WithinClosure rel g c`), O4 meets G4 and holds m's effects, with no decision premise. |
| O6 | OwnClass 269 | theorem | `theorem «本类常闭则所及即一之所及» {R E : «际» α} (hE : «类» E) {m : α} (atClass : «本类至终有常» R E m) (held : «所缘同于» R E m) (t : α) : «所及» R E m t ↔ «所及» R «一» m t` | Under P2 and P4 at m, m's line under E reaches exactly what a line under the one (all-alike) class reaches. |

Others cited (not copied): meets of P2+P4 classes (`«本类常闭之交»`, `«本类常闭之遍交»`), joins break
(`JoinBreaks.*`), the identity is the least P2 class and fails P4 (`«静之本类至终有常»`, `«静最细»`,
`«静不闭»`), `MeetBreaks.*`, and the flow readings `Flow.CouplingClass`, `Flow.couplingClass_held_iff(_back)`,
`Flow.couplingClass_reach_iff(_returns)`, `Flow.couplingClass_line_iff_loop`.

### 1.3 FromTheDynamics.lean and RoutesToC.lean (as their records cite them)

These bear on the ethics' order premise C, not on (a)-(d) directly. Record `route-b-joined` cites
`Flow.returning_downstream_iff_mutuallyDependent`, `«各后类续无外即一之续无外»`, `«返则后类本类常闭»` (O5),
`Flow.returning_beyond_coupling`, `Flow.persists_not_listsAdmitted`, `FromTheDynamics.Alternating.*` (a joint
witness of two formations standing in turn; "a line of descent persists ... never overdraws"). Record
`what-would-give-c` cites `Becoming.Weighting.*` (listing frame, widening, Pareto among self-concerned
profiles) and `Weighting.increasing_on_downstream_of_regularity`, which takes P2 + P4 at a center as its
regularity premise. I did not copy their statements. Nothing in them states a level running down or a
turn before the end.

### 1.4 Context outside my files, needed to place the held attempt (copied, not mapped further)

- Grammar 340: `def «有常» (R E : «际» α) : Prop := «则» («而» («逆» E) R) («而» R («逆» E))`.
- Grammar 370: `theorem «有亡之续则不有常» {R E : «际» α} {x y : α} (hxy : «续» R E x y) (hy : «亡» R E y) : ¬ «有常» R E`.
- Grammar 375: `def «核» (R E : «际» α) : «际» α := fun u u' => ∃ S : «际» α, «则» S E ∧ «则» S («逆» S) ∧ «有常» R S ∧ S u u'`; Grammar 380 `«根»`: the core lies in E, is constant and symmetric, and is the greatest such.
- Grammar 523: `theorem «亡于核下不变» {R E : «际» α} (hE : «类» E) {y y' : α} (hk : «核» R E y y') (hy : «亡» R E y) : «亡» R E y'` (ending under E is not told apart by E's core).
- GrammarLaws 2568: `def «同行» (R E : «际» α) : Prop := «则» («而» («而» («逆» R) E) R) E`; 2592 `«有常则可续» … : ∀ u u' v, E u u' → R u v → ∃ v', R u' v'`; 2600 `«同行可续则有常»`; 2612 `«局定后则有常当且仅当同行可续»` (with successor fixed where E leads, 有常 ↔ 同行 ∧ availability: "the exact gap between the two: availability"); 2677 `«同行之迭» {R E : «际» α} (alike : «同行» R E) : ∀ (n : Nat) {x x' y y' : α}, E x x' → «迭» R n x y → «迭» R n x' y' → E y y'`.

## 2. Where the held attempt restates what already exists

Attempt: `tmp/r7/the-loop/lean/Becoming/TurningInTime.lean`.

- `alike_steps` (attempt 137) is `«同行之迭»` (GrammarLaws 2677), the same statement up to binder names.
- `not_constant` (attempt 131: `E u u'`, `R u v`, `∀ v', ¬ R u' v'` gives `¬ «有常» R E`) is a one-line
  contrapositive of `«有常则可续»` (GrammarLaws 2592), and the same content as `«有亡之续则不有常»` read
  at a bare end. More to the point for this design: the root already has the weaker condition that
  *permits* exactly this situation, `«至终有常»` (G2): an alike pair with one going on and one with no next at
  all satisfies G2's right disjunct. "Stays the same in a respect up to its end" (pattern (c)) is G2 / G4.
- `core_step` (attempt 109) is `«有常之逐点»` applied to `(«根» R E).2.1`; `core_apart` (126) is its
  bare-R contrapositive. The E-relative form is `«亡于核下不变»` (Grammar 523).
- G7/G8 (`«亡而网续则(本类)不至终有常»`) state the "ends while the net goes on breaks constancy up to the end"
  law; the attempt's section on the grammar does not cite them.
- O5 and G4 give, at a returning formation, a class meeting the up-to-the-end condition with no extra premise,
  the natural place where "a line stays alike up to its end" is already a theorem rather than a hypothesis.

## 3. Answers to the question

### 3.1 Which records' hashes drift and must be re-pointed

Mechanism (RESULT-WORKFLOW "Hashes", lines 49-61): Lean sources and receipts need exact bytes. A record
references a Lean file with a `sha256` (the reviewed bytes) and carries a `proof_binding` whose receipt
must hold the file's current sha256 at `/source_sha256/<Module>`. A re-point that changes nothing the record
says is made with `tools/research/repoint.py` (`--paths`, and `--receipt <run>/verification.json --lean <file>`
for bindings), logged once per landing in `_process/architecture/rebinds.jsonl`; a changed declaration list
takes a history note.

On the current tree every reference hash and every binding for the closure modules matches (checked by
hashing the files and reading each binding's receipt): nothing drifts today.

A law added to **GrammarPath.lean** changes only that file's bytes (modules above only recompile; their
bytes, and so their records, do not drift). Drift:
- Reference hash and proof binding (bound to `becoming-checks/20261106T132906.779148Z/verification.json`):
  `constancy-read-at-a-members-class`, `what-a-line-holds-and-a-regularity-takes-in`,
  `what-leaves-a-class-follows-its-line` (3 records).
- The live receipt file `becoming-verification.json`, rewritten by every core run, is cited by exact bytes
  (`aa798fc3…`, today's file) in 10 records: `confined-rise-within-a-whole`, `drift-offspring-sampled`,
  `fixation-by-drift`, `fixation-with-selection`, `groups-formed-by-descent`,
  `selection-with-returns-to-groupmates`, `selection-within-and-among-groups-of-any-sizes`,
  `selection-within-and-among-groups`, `shaping-read-by-readers-drawn-from-the-selected`,
  `shaping-the-rule-selected-by-what-comes-back`. Every landing with a core run re-points these 10 (the
  rebinds log shows one such line per core run on 9-10 November).

A law added to **OwnClass.lean**: reference and binding (bound to `20261109T164551.067705Z`):
`the-own-class-read-on-a-flow`, `what-the-net-fixes-of-ones-own-class`, `route-b-joined` (3 records), plus
the same 10.

Not drifting unless their own files change: GrammarCases (`reach-through-a-shared-condition`,
`the-class-of-being-joined`, `the-source-texts-test-systems`), RoutesToC (`what-would-give-c`),
PremiseWitnesses (`premises-met-and-failed`, `route-b-joined`, `self-concern-and-c-under-the-condition`),
FromTheDynamics (`route-b-joined`), PremisesTogether (`premises-met-and-failed`). The root `Becoming.lean`
is bound by no record (`effective-capacity-and-eventual-reachability` matches only `RelationalBecoming.lean`);
adding a new module changes the root's bytes but no record.

If the new law is added to a record's declaration list, or a record is re-said as its case, that record
takes a history note (not a bare re-point). Removing or renaming any declaration a record lists fails
the declaration-presence check: the three GrammarPath records list 77, 56 and 18 GrammarPath declarations.
Generated views (`results/LEAN-DECLARATIONS.md`, `lean-declarations/*.md`, `LEAN-INDEX.md`,
`data/lean-index.json`, `map/cards.json`) re-render; they are not hand-edited. The shared-laws generator
(`tools/research/shared_laws.py`) runs after any Lean change (RESULT-WORKFLOW "Shared laws under each law";
GATE §3.1 "Before the gate"). A changed home section or record statement puts the lines that restate it in
the gate's `restated` list for a reader other than the author.

### 3.2 Core-run steps added

GATE §5: a core run costs about 4|U|+2 Lean steps, U the changed modules and everything above them; the
measurement (`gt/measurements/map-lean-speed.md` lines 14-25) names the four per module (compile, `#print
axioms` audit, `#check @` signatures, prelude-only recompile) plus EnvironmentAudit and Controls. The current
receipt (`20261110T172100.128611Z`, 404 modules, 1,615 step keys) has exactly these four keys for each of the
modules below, and the two package steps.

Importer closures computed from the `import` lines of PKG:
- **GrammarPath.lean changed**: U = GrammarPath, GrammarCases, OwnClass, RoutesToC, PremiseWitnesses,
  FromTheDynamics, PremisesTogether, Becoming (root) = 8 modules, so about 4·8+2 = **34 steps**.
- **OwnClass.lean changed**: U = OwnClass, FromTheDynamics, Becoming = 3, so about **14 steps**.
- **A new leaf module imported only by the root**: U = new module + root = 2, about 10 steps.
- For comparison, **RegimeMargin.lean changed**: U = RegimeMargin, DrawHistory, ReadOffInTime, RoomRuns,
  RunTurns, Becoming = 6, about 26 steps.
Each is far from the near-full run of the 25 lowest modules. Per GATE §5 rule 1, liftings go in one batch per
landing; rule 2 (board rule 9): a lift that keeps the model law's name and statement needs no edit above.
The receipt holds no per-step seconds for these modules (the last run reused all but `version.log`), so time
per step is not stated here.

### 3.3 Does a RegimeMargin edit require rerunning the RegimeReals periphery check?

Not by any check that runs at landing; whether it should is the record owner's call. Settled facts:
- `gate.py receipt_check` (tools/research/gate.py 897-925) reads only `lean/becoming/*-verification.json`
  (the core receipt and fallible-inquiry's). `lean/regime/regime-reals-verification.json` is in another
  directory and is never read. No other tool in `tools/research` or the Makefile names `check_regime_reals`
  or the regime receipt (git grep finds them only in process studies and the rebinds log).
- The RegimeReals receipt (`20261031T134231.224593Z`, passed, 66 modules in its compile order) is **already
  stale**: its `source_sha256` differs from the current bytes for 43 core modules, RegimeMargin included. The
  CY landings of 10 November edited RegimeMargin (two core runs) and did not rerun it.
- Record `regime-in-any-amounts` binds RegimeReals.lean to that 31 October receipt. The binding checks only
  RegimeReals.lean's own bytes, which are unchanged, so it stays valid however RegimeMargin moves; its
  RegimeMargin binding is to a core run (`20261110T010039.815631Z`) and drifts with RegimeMargin like the 10
  other RegimeMargin records (`coupled-regimes`, `coupled-webs`, `margin-of-a-regime`,
  `regime-point-under-adjusting-giving`, `rest-by-balance`, `rest-on-coupled-webs`,
  `threshold-in-the-state-plane`, `thresholds-beyond-a-band`, `webs-with-a-recent-giving`,
  `where-a-run-of-a-regime-comes-to-rest`; 11 records with `regime-in-any-amounts`).
- If rerun: `check_regime_reals.py` needs Lean 4.30.0-rc2, Mathlib at `ea11ccc0…` in
  `SYSTEMS_MATHLIB_PROJECT` (default `~/repos/生生不息`), and every closure module but RegimeReals to match
  *some* passed receipt under `lean/` by sha256 (a fresh core run's retained `verification.json` serves). It
  keys steps by the Mathlib revision too, so most core steps would rerun under that toolchain, not be reused
  from the core cache. Its own runner is not `lean_step` (it calls `subprocess.run` itself), so GATE §5.1's
  rule applies: a change to what its steps run needs a fresh run before reuse.
- What would actually break: if a RegimeMargin edit changed or removed a name or statement RegimeReals uses,
  RegimeReals would stop compiling and nothing at landing would notice. An edit that only adds a law, or keeps
  every name and statement (rule 9), leaves RegimeReals' proof valid in substance, though its receipt keeps
  naming older bytes.

## 4. Cautions

- A new definition of "stays alike up to its end" duplicates `«至终有常»` (G2) / `«本类至终有常»` (G4).
  A new "alike pair, one goes on, one has none, so not constant" duplicates `«有常则可续»` /
  `«有亡之续则不有常»`, and in the up-to-the-end form G7/G8. A new "lumping keeps n steps" duplicates
  `«同行之迭»`.
- Pattern (b) needs care: an alike pair with one going on and the other having no next at all breaks
  `«有常»` but **not** `«至终有常»`. What breaks `«至终有常»` is an end *under E* while the occurrence still
  conditions something (G7). A design stating (b) with "has none" must say which: no next at all, or no
  E-alike next.
- `«亡»` is relative to E (`«亡» R E x := ¬ «有后» R E x`, no E-alike successor); the attempt's `ends : ∀ v', ¬ R u' v'`
  is a bare end. They are different premises.
- Name collisions: `not_constant` exists as `Becoming.FiniteWake.not_constant` (GrammarPath 1077) and
  `not_constant_at` in several witness namespaces; `Course` exists as a structure in LineageDrawdown.lean 261.
  A top-level `Becoming.not_constant` or `Becoming.Course` is free today, but a namespaced placement could clash.
- Docstrings that claim more than the statement: `«至终有常»`'s docstring says "so a line under the class ends
  only at an occurrence that conditions nothing", a reading; the definition is the pointwise disjunction, and the
  CleanStep witness (G18) shows that "lines end only where the net ends" does not give G4.
  `«本类常闭当且仅当类闭»` needs both `goes` and `decided`; a summary dropping `decided` overstates it (O5
  removes it only under `ReturnsAlong`).
- Adding a law to GrammarPath re-points 13 records (3 + 10); to OwnClass also 13 (3 + 10). Editing an existing
  statement in GrammarPath reaches three records' claims and needs their history notes; adding only does not.
- The RegimeReals receipt is stale against 43 modules already; a reader seeing a "passed" receipt there should
  not take it to bind current core bytes.

## 5. Not read or not settled

- I did not copy the statements of the witness families (FinerOutside, FinerWake, UnevenOutside, Inconstant,
  Unclosed, FiniteFamilies, FiniteSharedCondition, JoinBreaks, MeetBreaks) or of FromTheDynamics' and RoutesToC's
  declarations; Section 1.3 names them from the records only.
- Whether `repoint.py`'s drift handling for the 10 live-receipt records is automatic in the gate or done by hand at
  each landing: the rebinds log shows it done once per core run; I did not read repoint.py beyond its header.
- Exact step counts depend on the runner's plan; 4|U|+2 is GATE §5's estimate, matched against the receipt's keys,
  not a count from a run.
- Whether RegimeReals currently compiles against today's RegimeMargin: not checked (no Lean run allowed).
- The records' Markdown sources (chapters 02, 07, 08) drift where a landing rewrites lines they cite; that depends
  on what the train edits in prose and is not mapped here.
