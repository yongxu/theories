"""FC1's landing texts, from the worktree root on a branch merged with main: python3 -I <kit>/fidelity/land_fc1.py SECTION

Writes (or rewrites) the study section, the record fidelity-of-the-classical-statements, and a history note and the
next step on wenli-on-the-spine. Figures come from data/results_main.json and data/results_calib.json."""
import datetime, hashlib, json, re, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[6]
S = sys.argv[1]
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
KIT = RF + '/development/zhonghua/fidelity'
STUDY = RF + '/BECOMING-RENEWAL-READING.md'
RES = 'experiments/wenli-reading-transfer/FIDELITY-RESULTS.md'
DESIGN = 'experiments/wenli-reading-transfer/FIDELITY.md'
CH = 'theories/becoming/chapters/WENLI-AND-BECOMING.md'
RECORDS = ROOT / 'theories/becoming/results/records'
ID = 'fidelity-of-the-classical-statements'
HEAD = 'The fidelity count, run (FC1)'
ANCH = '%s-the-fidelity-count-run-fc1' % S
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
M = json.loads((HERE / 'data/results_main.json').read_text())
C = json.loads((HERE / 'data/results_calib.json').read_text())
cl, cx = M['comparisons']['claude'], C['comparisons']['codex']


def r2(x):
    return '%.2f' % x


def ci(c):
    return '[%s, %s]' % (r2(c[0]), r2(c[1]))


def sha(p):
    return hashlib.sha256((ROOT / p).read_bytes()).hexdigest()


X, XA, OR = cl['X'], cl['X_A'], cl['O_rate']
GX = cx['X']
alpha_en = M['reliability']['table/en/X']['alpha']
alpha_zh_cal = C['reliability']['table/zh/X']['alpha']
study = f'''## {S}. {HEAD}

```text
Result(s): {ID} (new); wenli-on-the-spine (history note, next step)
Delta: the fidelity measure of FIDELITY.md (frozen in dcf2e5175) run on the 中华本 and the canonical chapter:
       for {M['units']} pairs (條, declaration) in {M['tiao']} 條, the referents each wording introduces that the
       Lean statement lacks. The 經 introduce fewer: {r2(X['mean_zh'])} against {r2(X['mean_en'])} per pair, difference
       {r2(X['mean_diff'])}, 95% CI {ci(X['ci95'])} (one coder, Claude, on both sides); agents {r2(XA['mean_zh'])} against
       {XA['mean_en']:.3f}; they leave out fewer of each statement's binders (O-rate {r2(OR['mean_zh'])} against
       {r2(OR['mean_en'])}). The second coder (GPT) agrees in direction on the {C['tiao']} calibration 條 ({r2(GX['mean_zh'])}
       against {r2(GX['mean_en'])}, CI {ci(GX['ci95'])}). F1 and F2 supported; F3 and F4 not measured
Supplied premises / correspondence: codebook v1.1 (two logged clarifications of v1 from the calibration); the Lean
       statements dumped from receipt 20261022T110022.458880Z with one level of unfolding; the registered sort table
Evidence: alignment of 1,399 經 clauses by both coders (exact agreement 1,303, κ 0.952; 96 adjudicated); coding of
          every main segment by Claude and of {M['overlap']['codex_segments']} English main segments and the whole
          calibration set by GPT (gpt-6-astra through cx, blind); α on X {r2(alpha_en)} (English, main),
          {r2(alpha_zh_cal)} (Chinese, calibration); cluster bootstrap, Wilcoxon, McNemar, cluster-robust Poisson
Boundary: no human audit; the main-set 經 coded only by the AI that wrote them (a lower bound); register not separated
          from language (F3 not run); the naive pass and the reading test not run; one pair of texts
```

The design ([FIDELITY.md](../../../../{DESIGN})) registered four predictions. The run's plan was fixed before any main result was read ([ANALYSIS-PLAN.md](development/zhonghua/fidelity/ANALYSIS-PLAN.md)); its two amendments record the scope cut by direction during the run: first the naive pass and the genre-matched segments, so F3 and F4 are not measured; then the second coder, which by then had coded English segments only.

**What was found.** In the main set, with one coder on both sides, the 經 introduce fewer excess referents than the English clauses ({r2(X['mean_zh'])} against {r2(X['mean_en'])}, CI {ci(X['ci95'])}), fewer agents, relata and entities, fewer connective mismatches, and leave out fewer binders, so the lower count is not bought by omission. The difference holds without negated referents, without the 條 that carry readings, and in 17 of 18 篇; counting matches made only through unfolding as excess, it shrinks to {r2(cl['X_U0']['mean_diff'])} (CI {ci(cl['X_U0']['ci95'])}), the 經's names leaning on defined constants. On the calibration set both coders coded everything and agree in direction.

**What limits it.** The AI that wrote the 經 coded every main-set 經; in calibration it found no excess in any 經 where the other coder found a mean of {r2(GX['mean_zh'])}, so the main figure is a lower bound. Agreement between the coders on the Chinese side is low (α {r2(alpha_zh_cal)} in calibration). The 經 are full statements and the English clauses summarize, and the comparison that would separate register from language was not run. No human audit was available. Full statement: [FIDELITY-RESULTS.md](../../../../{RES}).

*Reading* [AI reading, D63]. On this core the classical statements are the more exact reading code of the two compared. This supports the WL chapter's narrower claim that the classical code is a fitting reading layer, not that classical Chinese is the best expression.

**Not done.** The naive pass (F4), the genre-matched comparison (F3), the second coder on the main-set 經, a human audit, and the reading test (DESIGN-H2).
'''
t = (ROOT / STUDY).read_text(encoding='utf-8')
marker = f'## {S}. {HEAD}'
if marker in t:
    a = t.index(marker)
    nxt = re.search(r'\n(?=## \d+\. )', t[a + 1:])
    t = t[:a] + study.strip() + '\n\n' + (t[a + 1 + nxt.start() + 1:] if nxt else '')
else:
    t = t.rstrip('\n') + '\n\n' + study.strip() + '\n'
(ROOT / STUDY).write_text(t, encoding='utf-8')

old = RECORDS / f'{ID}.json'
first = json.loads(old.read_text())['history'][0] if old.exists() else None
record = {
    'schema_version': 2, 'id': ID,
    'title': {'en': 'The fidelity count: the classical statements against the English chapter',
              'zh': '忠实之测：中华本之经对英文本之句'},
    'kind': 'assessment', 'status': 'reviewed-scoped', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': (f'Over {M["tiao"]} 條, the 中华本\'s 經 introduce fewer referents the Lean statement lacks than the canonical '
               f'chapter\'s English clauses ({r2(X["mean_zh"])} against {r2(X["mean_en"])} per pair, CI {ci(X["ci95"])}) '
               f'and fewer agents, and leave out fewer binders; LLM-coded, provisional.'),
        'zh': (f'在 {M["tiao"]} 條上，中华本之经引入 Lean 陈述所没有之所指少于英文本之句（每对 {r2(X["mean_zh"])} 对 '
               f'{r2(X["mean_en"])}），施动者亦少，所漏变元亦少；大模型编码，暂定。')},
    'hypotheses': [{
        'en': ('Codebook v1.1 (FIDELITY.md §3 with two logged clarifications from calibration); the Lean statements of '
               'receipt 20261022T110022.458880Z with one level of unfolding; the alignment of 經 clauses to declarations '
               'by two coders and an adjudicator; one coder (Claude) on both sides of the main set.'),
        'zh': ('编码本 v1.1（FIDELITY.md §3，加校准中记录之两条澄清）；回执 20261022T110022.458880Z 之 Lean 陈述，展开一层；'
               '经之子句与声明之对齐由二编码者与一裁定者定；主集两边皆由一编码者（Claude）编。')}],
    'does_not_show': [
        {'en': 'That classical Chinese is the best expression of the core: one English text is compared, in another register.',
         'zh': '古汉语是核心最好之表达：只比较了一个英文本，且体裁不同。', 'kind': 'non-implication'},
        {'en': 'That the result survives a human audit or a second coder on the main-set 經: neither was run, and the coder of the main-set 經 wrote them.',
         'zh': '结果经得起人工复核或主集之经之第二编码者：二者皆未运行，且主集之经之编码者即其作者。', 'kind': 'scope'},
        {'en': 'Anything about readers (H2): the reading test is not run.', 'zh': '任何关于读者之事（H2）：阅读试验未运行。',
         'kind': 'non-implication'}],
    'counterexamples': [],
    'standard_boundaries': ['no-ethical-premise', 'formal-not-empirical', 'names-provisional', 'omission-not-refutation'],
    'validation_scope': {
        'en': (f'Alignment by two coders (κ 0.952); coding of {M["units"]} pairs by Claude, and of the calibration set and '
               f'{M["overlap"]["codex_segments"]} English segments by GPT (blind, separate languages); α on X '
               f'{r2(alpha_en)} English, {r2(alpha_zh_cal)} Chinese (calibration); cluster bootstrap over 條, Wilcoxon, '
               f'McNemar, cluster-robust Poisson; plan and amendments fixed before any main result was read.'),
        'zh': (f'对齐由二编码者为之（κ 0.952）；{M["units"]} 对由 Claude 编码，校准集与 {M["overlap"]["codex_segments"]} 段英文由 GPT '
               f'编码（盲，分语言）；X 之 α 英文 {r2(alpha_en)}，中文 {r2(alpha_zh_cal)}（校准）；按條之聚类自助法、Wilcoxon、McNemar、'
               f'聚类稳健之 Poisson；计划与修订皆定于读主结果之前。')},
    'next_delta': {
        'en': 'The second coder on the main-set 經, a human audit, the genre-matched comparison (F3), the naive pass (F4), and the reading test (DESIGN-H2).',
        'zh': '主集之经之第二编码者、人工复核、体裁对照（F3）、naive 一遍（F4），与阅读试验（DESIGN-H2）。'},
    'correspondence': {
        'en': ('Board item FC1, on Ren\'s request to run the fidelity count; the scope was cut by his direction during '
               'the run (provenance, not warrant). Reading (the AI\'s, D63): the classical statements are the more exact '
               'reading code of the two compared, not the best expression.'),
        'zh': '看板项 FC1，按 Ren 运行忠实之测之要求；范围在运行中按其指示收缩（来历，不是根据）。读法（AI 的，D63）：所比二者中，古典之经是较精确之读码，不是最好之表达。'},
    'canonical_source': RES,
    'aliases': ['the fidelity count', '忠实之测', 'FC1', 'excess referents'],
    'dependencies': [{'id': 'wenli-on-the-spine', 'relation': 'interpretive',
                      'detail': {'en': 'Tests the WL chapter\'s claim that the classical code is a fitting reading layer.',
                                 'zh': '检验 WL 一章「古典之码是贴切之读法层」之说。'}}],
    'related': [],
    'references': [{'path': p, 'role': role, 'sha256': sha(p)} for p, role in [
        (RES, 'statement'), (DESIGN, 'statement'), (f'{KIT}/ANALYSIS-PLAN.md', 'integration'),
        (f'{KIT}/CODEBOOK-REVISIONS.md', 'integration'), (f'{KIT}/data/results_main.json', 'integration'),
        (f'{KIT}/data/results_calib.json', 'integration'), (f'{KIT}/score.py', 'integration'), (CH, 'statement'),
        (STUDY, 'review')]],
    'proof_bindings': [],
    'progress': [{'en': 'The fidelity count run on the reduced scope.', 'zh': '忠实之测在收缩之范围上运行。',
                  'source': f'{STUDY}#{ANCH}'}],
    'history': [first or {'en': f'22 October 2026: added (FC1); study section {S}.',
                          'zh': f'2026年10月22日：新增（FC1）；研究第 {S} 节。'}]}
old.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n')

wp = RECORDS / 'wenli-on-the-spine.json'
w = json.loads(wp.read_text())
note = {'en': f'22 October 2026 (FC1, study section {S}): the fidelity count run; see {ID}.',
        'zh': f'2026年10月22日（FC1，研究第 {S} 节）：忠实之测已运行；见 {ID}。'}
w['history'] = [h for h in w['history'] if not h['en'].startswith('22 October 2026 (FC1')] + [note]
for k, a, b in (('en', 'The H2 reading test and the fidelity count (experiments/wenli-reading-transfer); ',
                 'The H2 reading test (experiments/wenli-reading-transfer; the fidelity count is run, ' + ID + '); '),
                ('zh', 'H2 阅读试验与忠实之测（experiments/wenli-reading-transfer）；',
                 'H2 阅读试验（忠实之测已运行，' + ID + '）；')):
    if a in w['next_delta'][k]:
        w['next_delta'][k] = w['next_delta'][k].replace(a, b)
for r in w['references']:
    if r['path'] == CH:
        r['sha256'] = sha(CH)
wp.write_text(json.dumps(w, ensure_ascii=False, indent=2) + '\n')
print('FC1 landing texts: study section', S, 'record', ID)
