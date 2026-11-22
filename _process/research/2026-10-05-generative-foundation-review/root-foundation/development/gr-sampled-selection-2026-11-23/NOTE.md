# Row GR: a selection through couplings, read at a coarser step

AI-written (Claude Fable, a Claude Code desktop session that holds board row GR), 23 November 2026.

## What was asked, and on whose word

On 23 November at 00:02 WIB Ren wrote to this session "let's first merge back, then finish them on latest main", under three lines of its own report of what it had not done ([his words](../../../../../../sources/15-codex-theory-conversations/2026-11-23-first-merge-back-then-finish-them.md)). He did not say what "them" covers. That Lean is among them is the session's reading.

The evening before, three searches by this session (by word over the modules' opening accounts, by name over whole files, and over the print of what proof terms use) had found no theorem joining the modules on parts, wholes and coarser steps to the modules on the lock or on selection through couplings ([the record of that evening](../../../../../../sources/15-codex-theory-conversations/2026-11-22-is-the-theory-precisely-this.md)). The row asks one thing of that: what `Becoming.Sampling` asks of the laws of one step (what holds across a coarse step where it holds across the fine steps inside, what does not come back, what is relative to the step), asked of selection through couplings on a web.

## What landed

One module, `Becoming.SampledSelection`, a leaf that imports `Becoming.Sampling` and `Becoming.Selection` and edits neither. Its opening account says what each theorem states. In short:

- A selection through a formation's couplings on the web read at strictly increasing times, taken back along the reading, is a selection through its couplings on the web. This closes by unfolding and one use of the order of the reading times.
- The coupling closure read at the coarser steps lies within the coupling closure. With the reading strict and starting at step 0, exchange is not lost, and the closure is smaller only through a requirement that holds at no step read.
- Withholding a part commutes with the reading, where each relatum is listed once at every fine step. This lemma is what the module adds to the two it joins.
- So every selection through the couplings read at the coarser steps, of a formation within the closure read there, selects the sampled levels with and without a part beyond that closure alike. It is `Flow.unselected_beyond_coupling` at the sampled flow and web, with its premises carried over. For a part beyond the coupling closure itself the same already followed from the fine law; what is added is the parts within the coupling closure and beyond the closure read at the coarser steps.
- A built case, `Missed`, of such a part: a selection through the selector's couplings separates the levels with and without it, and none read at the even steps does, though the sampled levels differ and a selection there under a wider coupling separates them.

## What it does not show

The selector's requirement in `Missed` is put at a step the reading skips. The case shows that this can be; it does not show that any actual reading skips what a selector requires. Nothing here is about the lock, the pace of a rule or a turn in time. It places nothing between the two ways of the direction page.

## The tests, and what three readers changed

The tests are in [TESTS.md.txt](TESTS.md.txt): the first 6,280 bytes are the text as first frozen (sha256 `fc03b9f7092692dc6a7dd56c346040deefaa96e127bc6070f800cd43aa280ef9`), and what the readers changed stands below it under "After" headings.

One scratch build of a first draft ran at 00:13 WIB, before the tests were first written at 00:14; the tests say so and took nothing from it.

1. **Before any build that counts**, a reader who took no part attacked the tests (177 thousand tokens). It showed that the row's second part, the lock's two-level course read at stretches, was `RuleCapture.locked_stays` and `turn_locked` re-indexed along a stretch that is not read (`Locked` for a stretch's reading unfolds to plain `Locked` at the configuration that many unread steps on), and that its built case was the mirror of `RuleCapture.Alternating` with `Reversed`. That part was withdrawn unbuilt; its draft is kept as [SampledPace.lean.txt](withdrawn/SampledPace.lean.txt). What is kept from it as a sentence: the lock's laws are stated over every schedule and every stretch, so reading at stretches adds no lock the package lacks. The same reader showed that the first part's first built case was void (its two histories were equal at the steps read) and that its tests could be met by their letter; they were replaced.
2. **After the sixth build**, a second reader (163 thousand tokens) found that the rebuilt case met its clause by the letter only: read at the even steps its selector had no coupling at all, so every selection through its couplings was constant. The case was rebuilt with two conditions, the selector coupled by level to the second, and a clause added that such selections are not constant. It also found one sentence of the account that said "fewer" for more.
3. **After the seventh build**, a third reader (101 thousand tokens) found that in that case the second condition was inert, so the blindness law did no work a direct check could not, and that one heading said "no selection at the coarser steps" where a theorem in the same namespace gives one. The case was changed so that the selector gives to the second condition and its level moves through the flow, and the heading and four sentences were mended. The fourth reader read the case as it then stood.

4. **Before the core run**, at the coordinating session's asking, a fourth reader (167 thousand tokens) read the case as it stood after build 9 and the mended sentences: no finding that changes the Lean; all eight statements of the case checked by hand; three sentences of the account changed (the case's blindness can also be checked directly, so it shows the premises met together and not that the law is needed; `coarse_reads` is one selection and two constant histories; the selector in the case gives across the step at which its own requirement is unmet). Its judgment, argued both ways: a small real join resting on the general lemmas, the case a witness.

Readers' tokens: 608 thousand against a cap of 600 thousand, over by 8 thousand on the fourth read; told to the coordinating session. Scratch builds: 9 of a cap of 14; their logs are in [build/](build/).

## What would still count against it

That the module is `Strobe.converse_fails` with a requirement in place of activity and one instance of an older law. The second reader argued both sides and held that the blindness law says something neither parent module has, small, and that the built case had not shown it doing work; the case was changed twice since. A reader who judges the final case the same way would be right to say the row is a dictionary with one lemma.

## The count from the print of proof terms

Not what the row moved. By the print made in this landing (core run `20261122T175942.715137Z`), with the families as this session chose them on 22 November: one theorem's proof term names both a theorem of the modules on parts, wholes and coarser steps and one of the modules on selection through couplings, `Flow.sample_unselected_beyond_coupling`, which uses `Flow.BalancesOn.sample`, `Flow.WithheldLevels.sample` and `Flow.unselected_beyond_coupling`; through chains, two theorems of this module (the second is `Missed.coarse_blind`). Between those modules and the modules on the lock: none, as before. The print follows no definition.

## After: what else is filed here (added 23 November, about 03:55 WIB, when everything was gathered onto one head)

At Ren's word to the coordinating session that night ("I want to merge everything and create a unified head"), what this row still held only in scratch or in a session's context was filed here, as text:

- [readers/](readers/): the four readers' final reports, word for word.
- [kit/](kit/): the scripts of the landing (the record's writer, the steps after the core run, the two wait scripts, the landed clause).
- [of-22-november/](of-22-november/): the two scripts behind the searches of 22 November that this row started from (`uses.py` over the print of proof terms, `samefile.py` by name over whole files), the two scripts that built the file of his words of that evening, and the two documents by another AI system that he pasted that evening, which are not his and which his words file describes; until now they were in a session's transcript only. They are another AI system's text, kept as the context his words of that evening point to ("read this"); no claim of either was checked, and nothing in the repository rests on a claim in them.
- [SENTENCE-FOR-AGENTS.md.txt](SENTENCE-FOR-AGENTS.md.txt): one sentence put to him for AGENTS.md, not landed there, with what stands behind it and what does not.

The two sentences in the root and the checker that this row left loosely worded were mended in row FM's landing (`c0b9584f4`). The direction page tells this row in row DJ's words (`0096b0e3a`), checked by this session against the record.

