"""SC1: write the record fidelity-coders-on-own-and-other-texts (run from the repository root)."""
import json, hashlib
from datetime import datetime, timezone

K = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/sc1-source-check/'
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'


def h(p):
    return hashlib.sha256(open(p, 'rb').read()).hexdigest()


refs = [('experiments/source-check/RESULTS.md', 'statement'), (K + 'DESIGN.md', 'integration'),
        (K + 'kit.py', 'integration'), (K + 'results.json', 'integration'),
        ('experiments/wenli-reading-transfer/FIDELITY-RESULTS.md', 'statement'), (STUDY, 'review')]
r = {
    "schema_version": 2, "id": "fidelity-coders-on-own-and-other-texts",
    "title": {"en": "Fidelity coders on their own and the other's texts", "zh": "忠实之测之编码者：于己文与他文"},
    "kind": "assessment", "status": "reviewed-scoped", "family": "F01",
    "reviewed_at_utc": datetime.now(timezone.utc).replace(microsecond=0).isoformat(),
    "statement": {
        "en": "On 240 English statements written and blind-coded by Claude and GPT, neither coder under-detects referents planted in its own text (interaction +0.02, CI [-0.05, +0.08]); GPT lists more excess in faithful texts (+0.16, CI [+0.08, +0.24]); LLM-coded, provisional.",
        "zh": "Claude 与 GPT 各写各盲编 240 句英文陈述：二编码者于己文之植入皆不少检（交互 +0.02）；GPT 于忠实之句列多余所指更多（+0.16）；大模型编码，暂定。"},
    "hypotheses": [{
        "en": "FC1's codebook v1.1, table pass with no key; FC1's Lean table (sha256 478c555f…) with one level of unfolding; plants made knowingly by each author in its own words as the ground truth for detection; a plant detected where an excess referent's span carries its new words.",
        "zh": "FC1 编码本 v1.1，名表一遍而无键；FC1 之 Lean 表（sha256 478c555f…），展开一层；各作者以己语有意植入者为检出之真值；多余所指之文段含植入之新词则为检出。"}],
    "does_not_show": [
        {"en": "That the authoring model has no blind spot for its own controlled classical code: the texts are English under no name table, and the 經 case is untested.",
         "zh": "作者模型于其受控之古典之码无盲点：所测为无名表之英文，经之情形未测。", "kind": "scope"},
        {"en": "That the GPT coder over-reads rather than the Claude coder under-detecting unplanted excess: the faithful texts carry no ground truth; about half of GPT's unplanted count is numerals the codebook matches, described after the fact.",
         "zh": "是 GPT 编码者过读而非 Claude 编码者漏检未植入之多余：忠实之句无真值；GPT 未植入之计数约半为编码本所配之数词，系事后描述。", "kind": "non-implication"},
        {"en": "Each coder's self effect apart: two families identify only their sum, and a knowing plant is not an unnoticed slip.",
         "zh": "各编码者之自效应各自几何：二家只能识其和；有意之植入亦非不觉之滑入。", "kind": "scope"}],
    "counterexamples": [],
    "standard_boundaries": ["no-ethical-premise", "formal-not-empirical", "names-provisional", "omission-not-refutation"],
    "validation_scope": {
        "en": "Design, decision rule and analysis code committed before any text was written; 480 of 480 codings (Claude: 6 Opus subagents; GPT: 12 gpt-6-astra runs through cx, blind, inline packets); cluster bootstrap over laws, B = 10,000; no human audit.",
        "zh": "设计、判定规则与分析代码于写任何文本之前提交；480 份编码俱全（Claude：6 个 Opus 子代理；GPT：经 cx 之 12 次 gpt-6-astra 运行，盲，内联包）；按定律之聚类自助，B = 10,000；无人工复核。"},
    "next_delta": {
        "en": "The same crossing on the 經 under the name table; adjudication or a human audit of unplanted excess; a third model family to separate the two self effects.",
        "zh": "在名表下之经上作同样之交叉；未植入之多余之裁定或人工复核；第三家模型以分二自效应。"},
    "correspondence": {
        "en": "Board item SC1, testing the open observation recorded in FC1's results. Reading (the AI's): the calibration discrepancy is better accounted for by a difference of coding threshold than by a blind spot; the tie to Becoming.Web.SelectsThrough is not supported as an author effect.",
        "zh": "看板项 SC1，检验 FC1 结果中所记之开放观察。读法（AI 的）：校准之差以编码阈值之别解释优于以盲点解释；与 Becoming.Web.SelectsThrough 之联系作为作者效应不获支持。"},
    "canonical_source": "experiments/source-check/RESULTS.md",
    "aliases": ["SC1", "source check", "self-detection of excess referents", "作者盲点之测"],
    "dependencies": [{"id": "fidelity-of-the-classical-statements", "relation": "interpretive",
                      "detail": {"en": "Tests the calibration observation recorded with the fidelity count.",
                                 "zh": "检验忠实之测所记之校准观察。"}}],
    "related": [],
    "references": [{"path": p, "role": role, "sha256": h(p)} for p, role in refs],
    "proof_bindings": [],
    "progress": [{"en": "The crossed test run on English statements.", "zh": "交叉之测在英文陈述上运行。",
                  "source": STUDY + "#376-coders-on-their-own-and-the-others-texts-sc1"}],
    "history": [{"en": "23 October 2026: added (SC1); study section 376.", "zh": "2026年10月23日：新增（SC1）；研究第 376 节。"}],
}
open('theories/becoming/results/records/fidelity-coders-on-own-and-other-texts.json', 'w', encoding='utf-8').write(
    json.dumps(r, ensure_ascii=False, indent=2) + '\n')
print('written')
