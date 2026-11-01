# The invariance-kernel patch, as applied

`invariance-kernel-on-sj-claim-afc9dc196.patch` (this folder) corrects "viability kernel" to "invariance kernel" where the kernel is `Viability.Kernel P guard s := ∀ t, Reach P s t → guard t`: every course stays in the guard, Aubin's invariance kernel; the viability kernel asks only that some course stays. It was cut against `sj-claim` at afc9dc196 and rides SJ's landing (board item VK, part 1). SJ applied it as 900e43847, on top of afc9dc196 and 60119dba2, with three amendments in SJ's kit. The patch file is kept as it was cut.

1. **Lasting.lean:40**, the never-reaching bullet, in the form agreed with the coordinator: "This is the invariance kernel of the target's complement (`avoids_iff_kernel`). Here each configuration has one course, so in Aubin's terms this is also the viability kernel." It states a correspondence and claims no Lean; the repository defines only the invariance sense.
2. **README.zh.md:36**, SJ's CommonResponse row in the Lean package: 生存核 → 不变核, twice. The patch had missed this row.
3. **make_record_sj.py**, the statement (line 53) and law 1 (line 61): two English strings the patch had left at "viability kernel", split across string pieces, now "invariance". Regenerating the record from the maker also brings the Chinese history line with 不变核 and the current reference hashes of CommonResponse.lean and Viability.lean.

Part 2 (SPINE.md, the collective dossier's title, MarketInstances' two docstrings) lands after SJ, on branch vk-docs.
