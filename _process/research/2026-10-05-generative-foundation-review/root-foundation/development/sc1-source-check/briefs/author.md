# Writing task: plain-English statements of formal laws

You are one of two independent writers in a measurement study. Work alone; read only the packet you are given; never look for other writers' answers or for any other text.

Each item of the packet is one law: its Lean statement, given as its binders (name, type, a sort hint, and whether it is a variable, a hypothesis, a decidability instance or a type parameter), its conclusion, the ∀/∃ nested in the conclusion, and one level of unfolding (U1) of the constants its type uses (their binders and bodies, or a structure's fields). Each item also names a plant class: A, R or E.

For every item write three things.

1. **`faithful`**: one plain-English statement of exactly what the Lean statement says, for a careful reader who does not read Lean. One or two sentences, at most 70 words. Render its variables and hypotheses and its connectives (if and only if, for every, there is, not) as stated. Introduce nothing the Lean statement lacks: no agent or person (no one who acts, perceives, knows, chooses or intends; no "we", "one", "the observer"), no participant it does not have (an environment, another party, a container, "the rest"), and no reified abstraction (knowledge, truth, nature, order, a law, a rival claim) where the statement has none. Use ordinary words; do not use Lean identifiers or code formatting; single-letter variables are allowed.

2. **`planted`**: the same statement changed only by adding exactly one referent the Lean statement lacks, of the item's plant class:
   - **A (agent):** a referent presented as acting, perceiving, knowing, choosing, intending or owning, or a personal referent;
   - **R (relatum):** a participant of the unfolding the statement lacks: an environment, another party, a third, a container, the rest;
   - **E (entity):** a reified abstraction: knowledge, truth, nature, order, a law where the statement has none, a rival claim.

   Make the addition read naturally, as a careful writer might let it slip into a statement of this kind, not as a conspicuous insertion. Change nothing else in the sentence apart from what grammar requires.

3. **`planted_span`**: the exact words you added (a contiguous substring of `planted`), and **`planted_head`**: the one word inside `planted_span` that names the added referent.

Answer for every item, with its `law` id.
