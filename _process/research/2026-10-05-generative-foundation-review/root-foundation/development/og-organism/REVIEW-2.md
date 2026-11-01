# OG's scratch Lean: an independent reading (1 November 2026)

An AI reader (one agent, read-only) read the scratch module at 5e593d3ab against its design. Every proof was sound as written, with the axiom report empty; the findings concern what the statements say. [AI review, unverified except where taken.] All eight are taken in the rebuilt module, `Becoming.ReaderRebuilding` (32 theorems in 48 declarations, axioms empty), and in DESIGN §8.

| # | severity | finding | taken as |
|---|---|---|---|
| 1 | medium | the window law is L0 at another state: with the supply on, the read lifts the level to at least one whatever it was | L0 stated from every level; `drawn` and its theorem removed; "a window tests nothing in this rule" said |
| 2 | medium | the family law holds at span one, so the turnover does not separate the members | said in the law's docstring, the header and DESIGN §8; the guess narrowed to the rebuild's source |
| 3 | medium | `BuysTime` gives only a lower bound of two units a step and an end from an empty stock | L1 called "a lower bound that grows with the stock"; ending from every stock, monotonicity and rates listed as not proved |
| 4 | medium | the one-unit step law is only decided | a sentence of its own: a conjecture the decided cases check |
| 5 | medium | an empty reader with stock is rebuilt; L2 is closure of one state; the module name says the reader rebuilds itself | said in the header and §8; the module renamed `Becoming.ReaderRebuilding` |
| 6 | medium | «自供者» reads as "supplies itself", the opposite; «一读者» names no unit; «绝而不复» unscoped; level and 储 both used | «取于供者…»; «一元二期之时», «一元三期之时»; «取于储者绝而不复»; the header says the Chinese names call the level its stock (储) |
| 7 | low | the design's six members and its amounts exceed the Lean's four members | listed as not modelled in the header and §8 |
| 8 | low | the step order matches; `m` plays no part under a cut; the flat stretch is h(0) = … = h(s) = s | said in the header and §8 |
