# AA, the six-family pass: premises, exits, and how the dynamics join

*Brief for the extractors and checkers. AI-written, 11 November 2026.*

## What this is

The atlas of dynamics (`theories/becoming/results/atlas/`) lists 183 dynamics in eight families. Families C (capture of the selection) and D (locks of knowing) have been read in two passes:

- **Step 2:** every exit ends somewhere, and every law lists the premises it takes, from a ledger of premises.
- **Step 2b:** every hypothesis a law's Lean statement binds is mapped to the premise it states.

Read both passes' READMEs first. They are in `_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aa-attractor-atlas/`: `step2b/README.md`, and the step-2 paragraph of `PLAN.md` §13. C and D's entries in `dynamics.json` show the result.

Ren said on 10 November that the dynamics are to be connected, mapped and unified. This pass reads the other six families (A, B, E, F, G, H) to C and D's rule, in one go. Two new fields are proposed with it:

- **`case_of`:** which general law a dynamic's law is a case of, where the Lean derives it.
- **`compose`:** how two dynamics join, where one's state is the other's rule, reading or pool.

Every exit gets the destination its law gives, so that routes cross families.

Each of you holds a **share**: one family, part of one, or two together. The input names your share's dynamics.

## Where to read

Everything is relative to the worktree `/Users/ren/tmp/aa-six/wt`. Read there, write nothing there, and run nothing that writes there. You write only your own output file in `/Users/ren/tmp/aa-six/run/`.

**Your input:** `/Users/ren/tmp/aa-six/run/input-<SHARE>.json`. For each dynamic it gives:

- the entry's fields: `records`, `hypotheses`, `open`, `beyond` and `forbids`;
- its `exits` and `transitions`, numbered `index` from 1 as the family page numbers them;
- its `declarations`, each one of:
  - **`source: "lister"`:** a theorem in the Becoming core. `binders` are every binder of its elaborated statement whose type is a proposition. That covers explicit, implicit and instance binders, before the colon and leading hypotheses after it. Each binder has its `position` among all the statement's binders (data binders counted, from 1) and its `type` as Lean prints it. **This list is Lean's own and complete: do not add to it or drop from it.**
    - `existing_premise_guess` names ledger premises whose Lean names occur in the type. It is a script's guess.
    - `proof_head` is the constant the proof applies after its leading lambdas.
    - `uses_laws_of_other_dynamics` are theorems the proof term names that the atlas lists under another dynamic.
  - **`source: "source text"`:** a declaration outside the core's lister, with `file`, `line` and `statement_text`. If it is a theorem, read its statement in the file and find its binders whose type is a proposition yourself. Count positions the same way, and copy each `type` from the source.
  - **A `kind` other than theorem:** a definition, structure or inductive. It is not a law and gets no premise list.

**Shared files:**

- `/Users/ren/tmp/aa-six/run/dynamics-index.json`: all 183 dynamics, with id, family, name and mechanism. These are the possible destinations.
- `/Users/ren/tmp/aa-six/run/cd-exits-in-words.json`: the exits of C and D that end in a state in words.
- **The ledger:** `theories/becoming/results/atlas/entries/premises.json`, 362 premises. It holds the seeds (`k3-*`, `card-*`) and C and D's premises; see its `kind`, `lean` and `home` fields.
- **The records:** `theories/becoming/results/records/<id>.json`, with `laws`, `hypotheses` (1-indexed), `does_not_show` and `statement`. Their rendered `.md` gives the headings that anchors point to.
- **The Lean:**
  - the core is `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`, where `Becoming.X.y` lives in `Becoming/X.lean` (or a file the module's name gives);
  - the periphery is at the `file` the input names.

  Read a declaration's binders, and the definitions they use, in the source. That reading settles what a law takes, not a record's sentence.
- **The situation's note on joining:** `_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aa-attractor-atlas/slice/notes.json`, key `writer_schema_note`. Its second half says what a field for composition must hold.

## What to write

Write **one file**, `/Users/ren/tmp/aa-six/run/extract-<SHARE>.jsonl`, one JSON object per line. Append a line for each dynamic as you finish it, with a short Python append, so that nothing is lost if you are stopped. Then append one line per new premise, and one per incoming route if you found any. Check that every line parses before you return.

### A dynamic's line

```json
{"kind": "dynamic", "id": "…",
 "laws": [{"law": "Becoming.X.y",
           "binders": [{"position": 4, "name": "hU", "premises": ["x-unread"], "note": ""}],
           "also_takes": [{"premise": "card-natural-number-amounts", "as": "commitment", "note": "…"}],
           "case_of": [{"law": "Becoming.General.law", "how": "…"}]}],
 "exits": [{"index": 1, "to": "dynamic-id" | {"en": "…"} | null, "to_law": "Becoming.…" | null, "drops": ["…"], "why": "…"}],
 "transitions": [{"index": 1, "between": {"from": "…" | {"en": "…"}, "to": "…" | {"en": "…"}} | null, "why": "…"}],
 "compose": [ … see below … ],
 "readings": ["…"],
 "not_read": ["…"]}
```

`laws` covers every theorem among the dynamic's declarations, lister and source text alike, in the declarations' order. `exits` and `transitions` cover every one the input lists. Nothing is skipped; anything you could not read goes in `not_read`, with the reason.

### Premises: the rules of step 2 and 2b

1. **A binder maps to the premise whose proposition it states, as the law states it.** A conjunction maps to each of its parts. Never map to a premise that is only related: `Locked` is not `Keeps`.
2. **One proposition, passed unchanged from law to law, is one premise.** That means the same definition with its parameters in the same roles. One name with two senses is two premises: ReadsShare on the rule and ReadsShare on a reading are two. Reuse a ledger premise wherever the binder states its proposition.
3. **Bounds and conditions are premises too.** Bounds on parameters (`2 ≤ T`, `lo ≤ hi`) count, and so do start and state conditions (`h ∈ hs`, `x.internal = y.internal`). One proposition in one module and one role is one premise. The same symbols in another module or role are another premise.
4. **`also_takes`** lists premises a law takes other than through a binder. Each has `as`, one of:
   - `definition`: the statement is made through it;
   - `commitment`: a commitment of the representation. List one only where the statement depends on it in a way 08's premise card names, such as natural-number amounts for a law counting a least unit. `card-discrete-steps` is listed on no law.
   - `form`: held by the law's form.

   Keep it short. Most laws have none.
5. **A law with no hypothesis binder** and nothing in `also_takes` takes nothing. That is fine.

### A new premise's line

```json
{"kind": "premise", "id": "…", "name": {"en": "…"}, "statement": {"en": "…"}, "kind_of": "hypothesis of a law",
 "lean": ["Becoming.…"], "holds_in": [], "fails_in": [], "home": "theories/becoming/results/records/<record>.md#<anchor>",
 "seeded_from": ["Lean"]}
```

- **`id`:**
  - Where the premise is a named Lean definition or structure (`Becoming.Requirement.Frontier`, `Becoming.ClosedCapture.Unread`), the id is its full name after `Becoming.`, lower-cased, with dots made hyphens: `requirement-frontier`, `closedcapture-unread`. Other shares mint the same id for the same definition, and the ids then merge.
  - A field of a structure (`L.Balances`, where `L : Becoming.Withholding.Law`) is named the same way through its structure: `withholding-law-balances`.
  - A bound or a condition with no definition of its own is `<module>-<short>`, the law's module as above with a short name of your own (`regimemargin-lo-le-hi`).
  - Ids are lower-case ASCII matching `[a-z][a-z0-9-]+`, and none may equal an existing ledger id unless it is that premise.
- **`statement`:** the proposition in words, exact, written generally (as every law that binds it states it, not as one law's instance). Use the law's symbols where words alone would be vague.
- **`kind_of`:** one of:
  - `commitment of the representation`
  - `local hypothesis`
  - `World premise`
  - `dynamics and correspondence`
  - `ethics or practice`
  - `hypothesis of a law`

  Most are the last.
- **`lean`:** the defining declaration, or else the laws that bind it. Every name must be declared.
- **`holds_in` and `fails_in`:** declarations or record ids you have read that show the premise holding or failing. Otherwise `[]`.
- **`home`:** a section of a record of a dynamic that lists the law. The anchor must be a heading of that `.md` as GitHub slugs it, such as `#conditions--条件` or `#laws--规律`. Check it in the file.

### Exits

- **`to`:**
  - **A dynamic's id** (any family; see the index) only where a law places the course there. Either the law's conclusion is that dynamic's defining condition, or it meets that dynamic's hypotheses. Name that law in `to_law`.
  - **Otherwise, a text `{"en": …}`:** the state the course reaches, as the exit's law states it, in that law's own terms, and no more.
  - **A witness exit:** say what the constructed example exhibits.
  - **`null` only where reading failed;** say why. The entry's present `to` may be wrong; confirm or correct it.
- **`drops`:** the premises whose failure or release the exit uses. They are premises that the dynamic's laws take and that no longer hold once the course leaves, as the exit's law shows. Use `[]` where the exit stays within the premises, such as a parameter crossing a bound.
- **An exit with `standing_without_law`** (no law) gets neither `to_law` nor `drops`. Its `to` is a text, or a dynamic only where the source it cites says so.
- **`why`** names the Lean file and line, or the record field, that you read.

### Transitions

`between` gives the two sides, `from` and `to`, each a dynamic's id or a text. Use it only where the record or the Lean says what lies on each side. Otherwise use `null`, with the reason in `why`.

### `case_of`: what a law is a case of

On a law, `case_of` lists the general laws it is a case of. **Only where the Lean derives it:**

- **The general law M must appear in the law's proof.** The lister's `proof_head` or `uses_laws_of_other_dynamics` show it; for a law in the periphery, its proof text does. Read the proof in the source.
- **The law's conclusion is M's conclusion,** with some of M's roles given this dynamic's values, and M's hypotheses discharged by the law's own or by facts proved in place. A proof that uses M as one lemma among others, toward a conclusion that is not M's, is **not** a case of M.
- **M is more general than the law:** it is stated for every value of the roles the law fixes.
- **M sits under another dynamic of the atlas** (any family), or under none. If under none, say so in `how`: it may be a general law the atlas lacks. M under the same dynamic is an inner step, not a `case_of`.
- **`how`** is one sentence: which of M's roles this law fixes, and to what.

The script's candidates come only from the proof term's direct constants, so a candidate is not a finding, and a case it misses can still be found by reading the proof. Expect few: across the six families, about 130 laws name another dynamic's law in their proofs at all.

### `compose`: how two dynamics join

A composition is where one dynamic's state is read as another dynamic's **rule**, **reading** or **pool**. These are the higher orders: learning, prediction, evaluation, capture of the selection, the meta-attractor. Write one **only where the Lean or a record says it**:

- **`"standing": "proved"`:** a Lean law whose statement relates both dynamics' roles. Name it in `joint_law`.
- **`"standing": "stated"`:** a record or chapter section says it, with no joint law. `joint_law` is `null`, and `source` is the path#anchor where it is said.

A composition you see but cannot anchor goes in `readings` as a sentence. It stays in the pass's evidence and is not written into the atlas.

```json
{"from": {"dynamic": "…", "law": "Becoming.…" | null, "role": "its share of the favoured kind"},
 "to": {"dynamic": "…", "law": "Becoming.…" | null, "role": "rule" | "reading" | "pool"},
 "map": "how the first's state is read as the second's role",
 "order_kept": "kept" | "not kept" | "not checked" | "not needed",
 "premises": ["ids the join takes or carries"],
 "joint_law": "Becoming.…" | null,
 "exits_kept": "which exits of each side remain exits of the joined course" | null,
 "standing": "proved" | "stated",
 "source": "path#anchor",
 "why": "…"}
```

`order_kept` says whether the map preserves the order the second law needs. For example, a monotone reading is needed where the second law takes ReadsShare. Write each composition once, on the line of whichever of its two dynamics is in your share. If both are, use the `from` side.

### Incoming routes

An exit of another share, or one of C and D's exits in words (`cd-exits-in-words.json`), may end in one of your dynamics. That holds when its law's conclusion is your dynamic's defining condition, or meets its hypotheses. If you find one, append:

```json
{"kind": "incoming", "from_dynamic": "…", "index": 2, "to": "your-dynamic", "to_law": "Becoming.…", "why": "…"}
```

## How to say things

- **Exact.** Say what the Lean proves: a sufficient condition is not an exact one, and a witness gives no condition.
- **Nothing ranks courses here.** Where a dynamic or premise touches comparing courses:
  - say "widening", which on a finite list every additive weighting that counts each listed thing above zero ranks higher;
  - say "C, a requirement an order may meet";
  - never write "better", "the continuation condition and C named, not asserted", or an ordering field.
- **Plain English,** one sense per word, in the atlas's own terms. The family pages under `theories/becoming/results/atlas/families/` show the register. The text is AI-written.

## What to return

A short summary:
- the counts: dynamics, laws, binders mapped, premises reused, premises new, exits by destination (a dynamic or a text), transitions with `between`, `case_of`, compositions and readings;
- what you could not settle.

## The checker

You are set to **refute** the extractor of your share. Read this brief, the input and the extractor's file `/Users/ren/tmp/aa-six/run/extract-<SHARE>.jsonl`, and check them against the Lean and the records. Write `/Users/ren/tmp/aa-six/run/check-<SHARE>.json`:

```json
{"corrections": [{"dynamic": "…", "part": "binder" | "also_takes" | "case_of" | "exit" | "transition" | "compose" | "premise",
                  "law": "…", "position": 4, "index": 2, "id": "…",
                  "value": <the replacement, in the extractor's shape, or null to remove it>, "why": "…"}],
 "missed": [{"dynamic": "…", "part": "…", "value": <the item in the extractor's shape>, "why": "…"}],
 "merges": [{"id": "new-id", "into": "existing-or-new-id", "why": "…"}],
 "checked": "what you read in full and what you sampled"}
```

A correction names its item:
- a binder, by `law` and `position`;
- `also_takes` and `case_of`, by `law`, with `value` the whole replacement list;
- an exit or transition, by `index`, with `value` the whole item;
- a composition, by its position in the dynamic's `compose` list (from 1), in `index`;
- a premise, by `id`, with `value` the whole premise line.

Read in full:
- every exit, transition, `case_of` and composition;
- every new premise;
- every binder mapped to a new premise, and every binder where the extractor departed from the script's guess.

Sample the rest, and say which you sampled. Mark as wrong:
- a binder mapped to a premise that is only related, or a conjunction mapped to one part;
- a reused premise that is not the same proposition, or a new premise duplicating one in the ledger or another new one;
- a statement that says more or less than the Lean, an undeclared `lean` name, or a `home` anchor that is not a heading;
- a destination dynamic that no named law places the course in, or a text destination saying more than the law concludes;
- a drop the exit does not release;
- a `case_of` whose law is not in the proof, whose conclusion is not the general law's, or whose general law sits under the same dynamic;
- a composition with no joint law and no source that says it, or with a role the source does not give.

Add in `missed` what the extractor skipped.
