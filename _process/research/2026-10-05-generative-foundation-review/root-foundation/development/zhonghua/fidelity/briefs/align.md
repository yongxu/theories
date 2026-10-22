# Coding task: which clause states which Lean declaration

You are one of two independent coders in a measurement study. Work alone; do not look for other files or for anyone else's answers.

Each item is a 條 (an article) of a book written in plain classical Chinese that states a formal theory. Its 經 (statement) is given split into numbered clauses. Its proof line cites a list of Lean declarations; each comes with a short form of its Lean statement (kind, binders `name : type`, and the conclusion after ⊢).

For each clause, give the set of declarations whose content the clause states:
- A clause states a declaration when it asserts that declaration's conclusion under (some of) its hypotheses, or defines what that declaration defines.
- A clause may state several declarations (one sentence covering two laws), or none (a clause that only introduces a word, or states something no listed declaration states).
- A declaration may be stated by one clause, by several, or by none.
- A mechanical proposal is given (from shared vocabulary). It is often too broad. Correct it freely.
- Judge by content, not by shared words. Use only the declaration names given for that 條.

Return JSON only, in the given schema: for every 條 in the packet, every clause number, with its list of declaration names (possibly empty).
