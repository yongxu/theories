# Brief: OU3a, the old continuation family as instances of the grammar

Repository `/Users/ren/theories`. Lean package: `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/` (pure core: Lean 4.29.1, imports only Init and the package, **every declaration must have an empty axiom report**, no warnings).

## Context

`Becoming.Grammar` (just landed; read all of `Becoming/Grammar.lean`) is the new root: a relational calculus stated for every carrier and relation, names in Chinese. Its centre is continuation relative to a class: `«续» R E := «合» R E` (x continues to y when x is a condition of y under `R`, read as 缘, and x, y are alike under the class `E`); lines `«相续»`, families `«同族»`, positions `«生»`, `«住»`, `«亡»`, alteration `«异»`, renewal `«复生»`, constancy `«有常»`, the core `«核»`, the two-way core `«位核»`, the coarse net `«粗»`. Read `_process/research/2026-10-05-generative-foundation-review/root-foundation/development/one-unfolding-root/PLAN.md` §4 for what the terms mean.

Board rule 9 (`_process/BECOMING-WORKBOARD.md`, "Generalize below, not beside"): the old modules of the continuation family should become instances of the grammar, the grammar being the reason for the special laws. This first step (OU3a) only **connects**: it proves that the old notions are instances of the grammar's notions, and, where clean, derives an old law from a grammar law. It does not change any existing statement.

## Your task

For the module(s) of your assignment:

1. Read the module and the definitions it builds on. Identify its notions of beginning, ending, persisting, continuing, carrying, splitting and merging (or whatever it has of these).
2. Choose the carrier and the relation honestly: typically occurrences are pairs (step, relatum) and 缘 is the relation the module already uses between them (a step along the same relatum, a continuation relation `Web.Continues`, a dependence, a passing). State the class `E` (for example "both active", "same pattern"). Do not invent structure the module does not have.
3. Write a new section at the **end** of the module (after its last declaration, before any final `end`), adding `import Becoming.Grammar` at the top, with:
   - definitions of the 缘 relation and class(es) you use, each with a docstring;
   - **instance theorems**: each old notion is pointwise equivalent (`↔`) to the grammar's notion under your reading, e.g. `Web.Ceases t f ↔ «亡» R E (t, f)` in the right reading, or a one-way implication where only that holds (say which and why);
   - where clean, an old law derived from a grammar law (e.g. a coarsening, a no-self-standing, a fission law), as a new theorem; do not delete or change the old proof;
   - docstrings in English naming the Chinese terms.
   Name new declarations structurally in English inside the module's namespace (e.g. `Web.ceases_iff_wang`), or in Chinese with «» where the name is a grammar term; avoid names of the form `«中文».ascii` (a tool cannot find them; use `«中文之中文»` or English).
4. Build with the scratch builder, never in the package directory itself:
   `python3 -B experiments/integrated-correction/general-framework/generative-basis/lean/becoming/scratch_build.py <YOUR_TREE> Becoming.<Module>` (run from the repository root; `<YOUR_TREE>` holds your edited copy at `Becoming/<Module>.lean`). It compiles against the checkout and audits axioms. Iterate until it passes with empty axiom reports and no warnings. Avoid `simp`, `omega`, `rw` with iffs, `decide` on Prop, and `propext`-carrying lemmas; pattern-match definitions on inductives with full patterns (wildcards over several constructors can bring `propext`).
5. Do not edit any file in the package or anywhere in the repository except inside your output folder. Do not commit.

## Output

In `/Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3-lifting/<your-folder>/`:
- `tree/Becoming/<Module>.lean`: the full edited module(s);
- `NOTES.txt`: the reading you chose (carrier, 缘, classes), every new declaration with one line on what it states, which old laws you derived from grammar laws, what you could not connect and why, and the scratch-build result (pass, axiom reports).

Reply under 400 words with the same content in brief.
