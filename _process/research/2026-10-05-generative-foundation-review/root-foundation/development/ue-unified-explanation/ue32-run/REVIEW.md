# UE32's run: the reader's findings and what was done with each

4 November 2026. AI-written (a Claude Code session; no person has checked it). One reader other than the author, an independent AI reader, read the result and the changed texts against the run's output, the frozen design and the dry runs, twice: once the first text, then the fixes. It read only; it ran nothing but short reads of the output's figures and, in the second reading, a recount of r by the dimension the embedding chose. About eleven minutes to read.

## First reading

**What the reader read.**
- **In full:** DESIGN.md, UE32's README, `run-embed.out`, the study section, T2's paragraph in 02, its row in 08, all of S-15, the overview's T2 rows in both editions, and the changed lines in the experiments index, the review covers and READING-BUDGETS.
- **In part:** `run-embed.json`, all its verdicts, with figures recomputed from the per-stock records; `dry-runs-embed.json`, each world's medians and ranges; the S3 block of `probe-design.out`.
- **Not read:** the edit script and the study's source text, which it read in their applied form.
- **Searched:** the front pages, both editions, and every tracked Markdown file, for T2's test count and standing.

Apart from findings 3 and 5, every figure it checked matched the output.

**Errors (a reader would believe something false):**

1. **The sciences front's T2 row**, a front page the change missed, said "of three on fish stocks, one passed its state verdict". Taken. It now says there were four, with UE32's verdict and persistence beside it, in as few words as the dossier's hour allows.
2. **MQ's README on the spine** said "of three frozen fish-stock tests, MQ5's passed". Taken the same way.
3. **"Both forecast worse than persistence in 53 of the 65."**
   - Recounted per stock, each state is worse in 53 but both are worse in 46. The author recounted and found the same.
   - Taken in 02, the study and the README: each is worse in 53, both in 46. Where the texts say "both behind persistence in most stocks", 46 of 65 is most.
4. **Why the expected answer missed.** The first text set the run, one archive, against the mixed world's medians over ten archives. It concluded that reading MQ5's S3 share as a third of the stocks age-structured "is what failed". That goes past DESIGN §8, which froze that neither "T2 better" nor "not separated" shows such memory absent. It was not labelled as read after the run, and it left out that S3 flagged 26 of the 65 stocks, within the mixed world's 22 to 39 and above every archive of T2's world (6 to 14).
   - Taken. The text now leads with the design's own term from §1: "T2 better" places the stocks "nearer a world whose state N holds than MQ5's readings do".
   - It says "The output does not show why", and labels what follows as read after the run.
   - The pairing's gap, −0.039, lies within both worlds' archive ranges, below §7's bound of about 0.3. It suggests no minority with memory and cannot show one absent.
   - The flagged count leaves the in-sample excess unexplained by T2's world alone.
   - The run is consistent both with a minority whose memory does not pay out of sample, an outcome the mixed world gave in 6% of its archives, and with an in-sample excess that does not carry out of sample.
   - The author checked the per-archive gaps and counts in `probe-design.out`.
5. **"Beside the dry runs."** F did worse than persistence in 82.9% and 80.3% of the stocks in the drifting and MQ4 worlds, not "about 79%". "Lie nearest" held only on the figures chosen: on the escapement alone and on skill against the training mean, MQ4 was the farthest of the ten worlds. Taken: the paragraph now says no one world reproduces the run's figures.
   - On persistence it lies with the MQ4, drifting and age worlds, with the figures for the three numbers given.
   - On the escapement alone and the training mean it lies inside the ten worlds' spread without pointing to one.
   - Its median r lies within four worlds' ranges, the mixed one's among them.
6. **The reach in 08's row and S-15 left out "not T2's law".** Taken.
7. **08's verdict on what is new.** 08 names "a prediction that could fail and does not" among what would change its verdict that what survives is no discovery. The README called UE32 one, in the design's sense, without saying whether it meets 08's sense. Taken: the study and the README now argue that it does not change the verdict.
   - What UE32 bears out, three numbers holding their own against a longer embedding on about 20 training rows, is in large part what the field's own bound of about √N coordinates foresees.
   - In the dry runs it came also where the giving reads less than T2's state.
   - Both states trailed persistence.
   - Its sharpest part, the embedding at D = 2, within that bound, losing in 16 of 22 stocks, is one reading of one test on assessment outputs. So it moves T2's evidence, not 08's verdict.
8. **The study linked this file before it existed.** Taken: this file.

**Improvements:**

9. **The design's terms.** Taken: 02 now says "where UE32 expected 'not separated'".
10. **The direction of r.** Taken: in 02 and the experiments index, "median log ratio of the embedding's error to the three numbers'", and "the three numbers better in 42".
11. **The D table** counted D = 3 and 4 from D = 1. Taken: N less one number, N plus one, three and five numbers.
12. **The two caveats.**
    - Persistence reads only γ_{t−1}, one of the three numbers, and fits nothing. So the three numbers' loss to it is the cost of a map fitted on about 20 rows, not information they lack.
    - The embedding's loss grows with D in every dry-run world without an age structure or second lag, so it shows what the longer history costs at these lengths, not that it carries nothing.
    - Both taken, in the README and the study.
13. **T2's own world beside the D ≥ 2 median.** Taken: +0.11 under T2's law, with the mixed and age worlds.
14. **The overview row's "which".** It attached to the persistence clause. Taken: the reach now follows the verdict, and persistence comes last. The Chinese row is ordered the same way. The reader found the Chinese saying nothing the English does not.
15. **READING-BUDGETS.**
    - Its list of the dossiers' stated times still opened with sciences' 140 to 190. Taken: 140 to 195 since UE32's run, with the slowest reading.
    - The overview row's account of what was added did not record UE32's 47 words and 110 Chinese characters. Taken.
16. **"Of four … one passed, and in another …"** could lead a reader to count UE32 as not passing. Taken in the overview row (EN, ZH): one passed, one failed its state verdict, one missed its bound, and in the fourth the three numbers forecast better than the field's fitted embedding.

**What the dossier's hour allowed.** The front's T2 row and S-15 are on the sciences hour, which states 45 to 65 minutes. With the first fixes it measured 6,520 words, 65.2 minutes. To stay within it:
- 08's UE32 clause puts its figures in a closing parenthesis, which S-15 does not quote; S-15 quotes the rest, with persistence, the loss with D and the reach.
- The front's row gives the verdict with persistence beside it, and leaves the loss with D and the reach to S-15 and the homes.

The hour now measures 6,500 words, 65.0 minutes at the slower rate. The whole measures 190.3 minutes, so its stated time is now 140 to 195, on the dossier and both review covers.

## Second reading

**What the reader read.**
- **In full:** the diff of the fixes in the texts: the study section, READING-BUDGETS, this file, the experiments index, MQ's README, UE32's README, the overview's T2 rows in both editions, 02, 08, both review covers and the sciences dossier.
- **Not read:** the scripts, the study's source text and the board's drafts.
- **Checked:** the figures against `run-embed.json`, with a recount by the dimension F chose, against `dry-runs-embed.json` and against `probe-design.out`.

Every finding of the first reading but those below it found taken as this file says. Every statement of the verdict carries the persistence caveat (the coordinator's first condition), and the Chinese row says nothing the English does not but item 8. The budget figures follow from the counts. The two words of S-15's addition the reader could not place are the quote's prefix, `Quote [path]:`, which the measure does not count.

**Errors:**

1. **The README's persistence bullet** set the run beside "the worlds where the giving reads less than T2's state". DESIGN §7 counts the level world among those, and its figures, worse than persistence in 42.5% of the stocks with skill +0.19, are far from the run's. The bullet's "There" also pointed at the worlds before the run's own figures. Taken: it now names the MQ4, drifting and age worlds, as the study does, gives the run's figures and then theirs, and sets the level world's beside T2's and the mixed one's. The study's comparison names the level world too.
2. **The argument on 08's verdict sat under the frozen heading** "What it means, as the design froze it (DESIGN §8)". It was made after the run, and §8 says nothing of 08. The study's paragraph on it carried no label. Taken: in the README it has its own heading, marked read after the run, not frozen, and the study's label says the same.
3. **"Within four worlds' ranges"** (first reading, item 5, and the README's median-r bullet). The run's +0.163 lies within six worlds' ranges: T2's noisy world's (up to +0.24) and the level world's (up to +0.27) as well. The author checked the ten worlds' ranges in `dry-runs-embed.json`. Taken: the README lists the six with their maxima.

**On 08's verdict.** The reader found the argument sound and, if anything, understated. Its recount by the dimension F chose:
- over the 48 stocks where F chose D ≤ 2, the median r is +0.035, the three numbers better in 29 and F in 19, p = 0.19: on those stocks alone the test would say "not separated";
- so the verdict rests on the 17 where F held 6 or 8 coordinates;
- at D = 2 alone, 16 of 22, p = 0.052.

The author recounted from `run-embed.json` and found the same, and over the 17 stocks at D ≥ 3, 13 to 4, p = 0.049. Taken, in the README and the study, labelled read after the run: not failing was foreseen, since the design expected "not separated" (§1); what went past the expectation rests on the stocks where F went past the field's own bound of about √N coordinates; the D = 2 stocks fall short of 0.05 on their own. The landed clause says it in a sentence.

**Improvements:**

4. **"An outcome the mixed world gave in 6%".** The 6% is the share of "T2 better" verdicts, not a measure of memory failing to pay its way. Taken: "as in the mixed world's archives that said 'T2 better' (6%)".
5. **"The same growth wherever no age structure or second lag held".** The mixed world does not show it (+0.16 at D = 3, +0.01 at D = 4). The reader proposed "in the six worlds with neither in any stock". The dry runs have five such worlds: T2's, its noisy one, the level, the drifting and MQ4's; each shows the growth. Taken with five, in the README and the study.
6. **08's closing parenthesis** followed the reach and read as attached to it. Taken: "(better in 42 of 65 stocks, …)". S-15 does not quote it.
7. **S-15 no longer says that the expected answer was "not separated".** Not taken. S-15 is on the sciences hour, which measures 6,500 words, 65.0 minutes at the slower rate, the edge of what it states. The expectation stands in the closing parenthesis of 08's row, which S-15 quotes up to it, and in the README and the study, to which the dossier links.
8. **The Chinese row's "这显示……充分性"** is stronger than the English "a sign of". Taken: "这是……的一个迹象".
9. **The sciences front's "beat the field's embedding"** may be read as the field's standard embedding. Taken by a trade within the hour: "UE32: T2's numbers beat the field's fitted embedding", where it said "in UE32 T2's numbers beat the field's embedding".
