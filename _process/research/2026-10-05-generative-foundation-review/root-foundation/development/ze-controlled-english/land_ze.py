"""ZE landing texts: the new record fidelity-under-one-discipline, the notes in the FC1 record and in wenli-on-the-spine
(content changed: history notes, hashes of what was reread), and study section N.

    python3 -I -B land_ze.py N        # N: the next study section number on main
"""
import datetime, hashlib, json, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[5]
REC = ROOT / 'theories/becoming/results/records'
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
KIT = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ze-controlled-english'
STUDY_P = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()


def sha(p):
    return hashlib.sha256((ROOT / p).read_bytes()).hexdigest()


def section(n):
    return '''## %d. The controlled English control (ZE)

```text
Result(s): fidelity-under-one-discipline (new); fidelity-of-the-classical-statements (scope and next step: the
       control run; history note); wenli-on-the-spine (scope: the gain is mostly the discipline; history note)
Delta: the control FC1 lacked. An English name table with the 中华本's discipline (449 names: English name,
       sense, what it does not carry, the same anchors; 157 from the glossary) and a controlled English
       rendering of the 經 of all 394 條 clause by clause (1,698 clauses), one source with the Chinese.
       FC1's table pass re-run on the same 672 pairs: under the Claude coder 經 0.095, CE 0.071 excess
       referents per pair, 經 − CE +0.023, 95%% CI [-0.010, +0.055]: the 經's advantage does not survive
       (registered rule); discipline in English recovers 1.03 [0.98, 1.09] of FC1's advantage over E1.
       GPT coder on a stratified 60 pairs: 經 0.61, CE 0.88, -0.27 [-0.50, -0.06], mostly entities;
       the coders' X counts unrelated there (alpha 0.03, -0.01)
Supplied premises / correspondence: codebook v1.1 and FC1's brief unchanged; FC1's Lean table (sha256
       478c555f...) with one level of unfolding; FC1's final alignment; CE is a translation of the 經 with
       the Lean as a key to the reading
Evidence: analysis plan and scorer committed before any coding of CE (9811339e2); 644 + 120 codings, all
          validated against FC1's schema; cluster bootstrap over 條, B = 10,000; 11 Claude agents, 6 GPT runs
Boundary: one AI family wrote both texts and is the primary coder; cross-family check 60 pairs with no
          coder agreement on X; discipline and register not separated; translation, not an independent
          English text; no human audit
```

FC1 could not tell whether the 經 introduce fewer excess referents because they are classical Chinese or because they were written in a name table that states, name by name, the sense taken and the senses excluded, as full statements. The control writes English the same way and measures it the same way: same clauses, same declarations, same codebook, same coder family ([plan](development/ze-controlled-english/ANALYSIS-PLAN.md), [edition](../../../../experiments/wenli-reading-transfer/CONTROLLED-ENGLISH.md), [results](../../../../experiments/wenli-reading-transfer/CONTROLLED-ENGLISH-RESULTS.md)).

**What was found.** Under the planned coder the two disciplined codes are level on every count (excess referents, agents, omitted binders, connective mismatches). The 經 score worse only on relata, on predicate excess and on matches made only through unfolding: their names point at defined constants that the English spells out. The other family's coder finds more excess on both sides and less on the 經 side. But on the same pairs its counts do not track the Claude coder's at all, and SC1 (section 376) showed the two differ by threshold.

*Reading* [AI reading, D63]. The fidelity FC1 measured belongs mostly or wholly to the discipline: a name table with stated exclusions and anchors, used in full statements. Whether classical Chinese adds anything beyond it depends on the coder. The WL claim stands in its narrower form: the disciplined code is a fitting reading layer, and the classical code and a controlled English code are two instances of it.

**Output → input.** FIDELITY-RESULTS and WENLI-AND-BECOMING's testing section point to the result, and the controlled English edition is a candidate code for the H2 reading test. Still open: a controlled English written from the Lean rather than translated from the 經; the separation of discipline from register (F3); adjudication or a human audit of the coders' disagreement on X.
''' % n


def main():
    n = int(sys.argv[1])
    anchor = '#%d-the-controlled-english-control-ze' % n
    refs = [('experiments/wenli-reading-transfer/CONTROLLED-ENGLISH-RESULTS.md', 'statement'),
            ('experiments/wenli-reading-transfer/CONTROLLED-ENGLISH.md', 'statement'),
            (KIT + '/ANALYSIS-PLAN.md', 'integration'),
            (KIT + '/names-en.tsv', 'integration'),
            (KIT + '/controlled-english.jsonl', 'integration'),
            (KIT + '/ze_score.py', 'integration'),
            (KIT + '/data/results.json', 'integration'),
            ('experiments/wenli-reading-transfer/FIDELITY-RESULTS.md', 'statement'),
            (STUDY_P, 'review')]
    STUDY.write_text(STUDY.read_text(encoding='utf-8').rstrip('\n') + '\n\n' + section(n), encoding='utf-8')
    rec = {
        'schema_version': 2, 'id': 'fidelity-under-one-discipline',
        'title': {'en': 'The fidelity count under one discipline: the classical statements against a controlled English code',
                  'zh': '同一纪律下之忠实之测：中华本之经对受控英文之码'},
        'kind': 'assessment', 'status': 'reviewed-scoped', 'family': 'F01', 'reviewed_at_utc': NOW,
        'statement': {
            'en': "Under the Claude coder, English written as full statements in the 中华本's name-table discipline introduces no more referents the Lean lacks than the 經 (經 − CE +0.023, CI [-0.010, +0.055]); the GPT coder on 60 pairs leaves a residual for the 經 (-0.27); LLM-coded, provisional.",
            'zh': '在 FC1 之 270 條、672 对上，以中华本之纪律（每名之所取、所不带、同样之锚）写成之完整英文陈述，依 Claude 编码者，所引入之 Lean 所无之所指不多于经（差 +0.023）；GPT 编码者于 60 对上仍见经略少（−0.27），而二者于此不一致；大模型编码，暂定。'},
        'hypotheses': [{
            'en': "FC1's codebook v1.1 and brief, table pass; FC1's Lean table with one level of unfolding and its final alignment of 經 clauses to declarations; the controlled English key gives each English name's sense and anchors, as the Chinese key does; CE is a translation of the 經 with the Lean as a key to the reading.",
            'zh': 'FC1 之编码本 v1.1 与说明，名表一遍；FC1 之 Lean 表，展开一层，及经之子句与声明之终对齐；受控英文之键给每一英文名之所取与锚，同中文之键；受控英文是经之译文，以 Lean 为读法之钥。'}],
        'does_not_show': [
            {'en': 'That classical Chinese adds nothing beyond the discipline: the GPT coder leaves a residual for the 經, and the two coders do not agree on X where both coded.',
             'zh': '古汉语于纪律之外无所加：GPT 编码者仍见经略少，二编码者于共编之处在 X 上不一致。', 'kind': 'scope'},
            {'en': 'That discipline rather than register does it: CE matches the 經 in both, and the genre-matched comparison (F3) was not run.',
             'zh': '是纪律而非体裁：受控英文于二者皆同于经，体裁对照（F3）未运行。', 'kind': 'scope'},
            {'en': 'That an English text written directly from the Lean in the same table would score the same: CE was translated from the 經.',
             'zh': '直接依 Lean 以同一名表写成之英文得分相同：受控英文译自经。', 'kind': 'scope'},
            {'en': 'Anything about readers (H2) or about which code is best.',
             'zh': '任何关于读者（H2）或何码最好之事。', 'kind': 'non-implication'}],
        'counterexamples': [],
        'standard_boundaries': ['no-ethical-premise', 'formal-not-empirical', 'names-provisional', 'omission-not-refutation'],
        'validation_scope': {
            'en': 'Name table checked (449 distinct names, 881 anchors resolved in the newest core receipt, a not-carried field on every row); edition checked clause by clause against the 經; analysis plan and scorer committed before any CE coding (9811339e2); 644 CE codings by 7 Opus subagents, 120 by GPT (gpt-6-astra through cx, blind, separate language packets), all validated against the schema; cluster bootstrap over 條, B = 10,000; no human audit.',
            'zh': '名表经检（449 个不同之名，881 个锚在最新核心回执中可解，每行有所不带）；译本逐句对经检；分析计划与计分程序于编受控英文之前提交（9811339e2）；受控英文 644 份由 7 个 Opus 子代理编，GPT 编 120 份（经 cx 之 gpt-6-astra，盲，分语言），皆对模式校验；按條之聚类自助，B = 10,000；无人工复核。'},
        'next_delta': {
            'en': 'A controlled English written from the Lean in the same table; the separation of discipline from register (F3); adjudication or a human audit of the coders\' disagreement on X; the H2 reading test with the classical and the controlled English codes.',
            'zh': '依 Lean 以同一名表直接写成之受控英文；纪律与体裁之分（F3）；二编码者于 X 之分歧之裁定或人工复核；以古典之码与受控英文之码作 H2 阅读试验。'},
        'correspondence': {
            'en': "Board item ZE, the control named in FC1's limits. Reading (the AI's, D63): the fidelity FC1 measured belongs mostly or wholly to the discipline of the name table and full statements; the classical code and a controlled English code are two instances of one fitting reading layer.",
            'zh': '看板项 ZE，即 FC1 限度中所称之对照。读法（AI 的，D63）：FC1 所测之忠实大部或全部属于名表之纪律与完整之陈述；古典之码与受控英文之码是同一贴切读法层之二例。'},
        'canonical_source': 'experiments/wenli-reading-transfer/CONTROLLED-ENGLISH-RESULTS.md',
        'aliases': ['ZE', 'controlled English edition', 'English name table', '受控英文本'],
        'dependencies': [{'id': 'fidelity-of-the-classical-statements', 'relation': 'interpretive',
                          'detail': {'en': "Runs the control named in the fidelity count's limits, on its pairs and codings.",
                                     'zh': '在忠实之测之对与编码上，运行其限度中所称之对照。'}},
                         {'id': 'fidelity-coders-on-own-and-other-texts', 'relation': 'interpretive',
                          'detail': {'en': "Its finding that the coders differ by threshold bears on the cross-family disagreement here.",
                                     'zh': '其「二编码者之别在阈值」之所见，关乎此处之跨家族分歧。'}}],
        'related': [],
        'references': [{'path': p, 'role': r, 'sha256': sha(p)} for p, r in refs],
        'proof_bindings': [],
        'progress': [{'en': 'The control built and measured.', 'zh': '对照建成并测之。', 'source': STUDY_P + anchor}],
        'history': [{'en': '23 October 2026: added (ZE); study section %d.' % n, 'zh': '2026年10月23日：新增（ZE）；研究第 %d 节。' % n}]}
    (REC / 'fidelity-under-one-discipline.json').write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

    def edit(rid, fn, note_en, note_zh, reread):
        p = REC / (rid + '.json')
        r = json.loads(p.read_text(encoding='utf-8'))
        fn(r)
        r['reviewed_at_utc'] = NOW
        r['history'].append({'en': note_en, 'zh': note_zh})
        for x in r['references']:
            if x['path'] in reread:
                x['sha256'] = sha(x['path'])
        p.write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

    def fc1(r):
        for d in r['does_not_show']:
            if d['en'].startswith('That the gain belongs to classical Chinese'):
                d['en'] = ("That the gain belongs to classical Chinese rather than to the name table's discipline: the control run afterwards (ZE, record fidelity-under-one-discipline) finds it does not survive against a controlled English under the same discipline for the Claude coder, and a residual for the GPT coder on 60 pairs.")
                d['zh'] = '所得属于古汉语而非名表之纪律：其后之对照（ZE，记录 fidelity-under-one-discipline）见：依 Claude 编码者，对同样纪律下之受控英文本，所得不复存在；GPT 编码者于 60 对上仍见少许。'
        r['next_delta'] = {
            'en': "The second coder on the main-set 經 and a human audit; F3, F4 and the reading test; the authoring model's own-text test on the 經 under the name table (on English statements it found no author-specific deficit: fidelity-coders-on-own-and-other-texts). The controlled English control is run (fidelity-under-one-discipline).",
            'zh': '主集之经之第二编码者与人工复核；F3、F4 与阅读试验；并在名表下之经上检验作者模型于己文之检出（在英文陈述上未见作者特有之短缺：fidelity-coders-on-own-and-other-texts）。受控英文之对照已运行（fidelity-under-one-discipline）。'}

    edit('fidelity-of-the-classical-statements', fc1,
         '23 October 2026: the controlled English control run (ZE, record fidelity-under-one-discipline, study section %d); the scope item on language and discipline and the next step updated.' % n,
         '2026年10月23日：受控英文之对照已运行（ZE，记录 fidelity-under-one-discipline，研究第 %d 节）；语言与纪律之范围项与下一步随之更新。' % n,
         {'experiments/wenli-reading-transfer/FIDELITY-RESULTS.md', 'theories/becoming/chapters/WENLI-AND-BECOMING.md', STUDY_P})

    def wl(r):
        for d in r['does_not_show']:
            if d['en'].startswith('That 文理生生 or classical Chinese is the best expression'):
                d['en'] += " The fidelity count's control (fidelity-under-one-discipline) finds its measured gain mostly or wholly in the name table's discipline, not the language."
                d['zh'] += '忠实之测之对照（fidelity-under-one-discipline）见其所测之得大部或全部在名表之纪律，不在语言。'

    edit('wenli-on-the-spine', wl,
         '23 October 2026, ZE: the controlled English control run; the chapter\'s testing section, head and open item 6 state its result.',
         '2026年10月23日，ZE：受控英文之对照已运行；本章「怎样检验」、章首与未立者第 6 项写其结果。',
         {'theories/becoming/chapters/WENLI-AND-BECOMING.md', 'experiments/wenli-reading-transfer/FIDELITY-RESULTS.md',
          'experiments/wenli-reading-transfer/README.md',
          '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/zhonghua/wenli/chapter-rest.fragment',
          '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/zhonghua/wenli/centre.fragment',
          '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/zhonghua/wenli/head.fragment',
          STUDY_P})
    print('section', n, 'record fidelity-under-one-discipline, two records noted')


if __name__ == '__main__':
    main()
