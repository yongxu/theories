#!/usr/bin/env python3
"""NL1: write theories/becoming/results/records/what-position-reads.json.
usage (from the checkout root, after apply_text.py): python3 -B make_record.py SECTION_NUMBER RECEIPT_ID"""
import hashlib, json, sys
from datetime import datetime, timezone
from pathlib import Path

sec, receipt = sys.argv[1], sys.argv[2]
P = "experiments/integrated-correction/general-framework/generative-basis/lean/becoming"
SRC = f"{P}/Becoming/RelativePosition.lean"
REC = f"{P}/becoming-checks/{receipt}/verification.json"
STUDY = "_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md"
CH = "theories/becoming/chapters/THE-THEORY-OF-BECOMING.md"
OPEN = "theories/becoming/OPENING.md"

def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()

RP = "Becoming.RelativePosition."
LA = "Becoming.Lasting."
law1 = [RP + n for n in ["Keeps", "keeps_iff_common", "length_pos_of_mem", "regroup"]]
law2 = [RP + n for n in ["keeps_add", "keeps_least"]]
law3 = [RP + n for n in ["spread_le", "keeps_exceeds", "exceeds_iff_spread"]]
law4 = [LA + n for n in ["Member", "flow", "web", "balances", "acting", "dependent", "racers", "drawn_common",
                         "keeps", "drawn_second", "drawn_renewer", "first_greatest", "same_positions_apart"]]
reused = ["Becoming.Race.flow", "Becoming.Race.web", "Becoming.Race.greatest_ends", "Becoming.Race.drawn_renewer",
          "Becoming.Race.drawn_second_le", "Becoming.RelativePosition.riseCount",
          "Becoming.RelativePosition.fallCount", "Becoming.RelativePosition.Least",
          "Becoming.RelativePosition.Greatest", "Becoming.Flow.drawn"]
decls = sorted(set(law1 + law2 + law3 + law4 + reused))
now = datetime.now(timezone.utc).replace(microsecond=0).isoformat()

r = {
  "schema_version": 2,
  "id": "what-position-reads",
  "title": {"en": "What position reads", "zh": "位置所读"},
  "kind": "theorem",
  "status": "recorded-checked",
  "family": "F01",
  "reviewed_at_utc": now,
  "statement": {
    "en": "Positions in a family read the amounts exactly up to one amount common to every part. So they bound the total drawn from below, by the spread above the least part, and never from above: the same positions at every step go with a condition that ends and one that lasts.",
    "zh": "一族中的位置读各量，恰读到差一个各部分共有的量为止。所以位置从下以高出最少者的展布界定总共所汲，从不从上界定：每一步相同的位置，可伴随一个终结的条件，也可伴随一个延续的条件。"
  },
  "laws": [
    {"en": "Two profiles of amounts give every part the same position exactly where, for any two parts, what one had under the first with what the other has under the second is what the other had with what the one has: every amount differs by one common amount.",
     "zh": "两组量给每个部分相同的位置，恰在任两部分中，一个在前一组的量加另一个在后一组的量，等于另一个在前一组的量加这一个在后一组的量之处：每个量相差同一个共有的量。",
     "declarations": law1},
    {"en": "Adding one amount to every part keeps every position and adds it to the total once for each part; taking the least part's amount from every part keeps every position and leaves the spread above the least part.",
     "zh": "给每个部分加同一个量，保持每个位置，并按部分数把它加进总量；从每个部分减去最少者的量，保持每个位置，留下高出最少者的展布。",
     "declarations": law2},
    {"en": "With given positions the total is at least the spread; every profile with those positions has its total above a bound exactly where the spread is above it, and some profile with them exceeds every bound.",
     "zh": "位置给定时，总量至少是展布；具这些位置的每一组量，其总量高于一界，恰在展布高于该界之处；且具这些位置的某组量超过任一界。",
     "declarations": law3},
    {"en": "In Lasting the renewer gives two units at every step, as in Race, and the two racers have the race's positions at every step, the same greatest part and the same rise of the first; what is taken stays within what is given and every part is active at every step, while in the race every part is inactive from step two on.",
     "zh": "在 Lasting 中，更新者每步给两个单位，与 Race 相同；两个竞逐者每一步都有竞逐中的位置、相同的最大者、首者相同的上升；所取不超过所给，每个部分每一步都活跃，而在竞逐中每个部分自第二步起不再活跃。",
     "declarations": law4},
  ],
  "hypotheses": [
    {"en": "No axiom. The counting laws use no premise: whole-number amounts, any finite family with a part. Lasting and Race are constructed flows with balance, only active formations giving and activity needing support.",
     "zh": "无公理。计数规律不用前提：自然数的量，任何有一部分的有限族。Lasting 与 Race 是构造的流，具平衡、只有活跃者给予、活跃需要支持。"}
  ],
  "does_not_show": [
    {"en": "That positions read nothing of the total: the spread above the least part bounds it from below, so a spread wider than what is renewed forces more to be drawn whatever the common amount.",
     "zh": "位置对总量毫无所读：高出最少者的展布从下界定总量，所以宽于所更新者的展布，不论共有的量为何，都使所汲多于所更新。", "kind": "non-implication"},
    {"en": "That a race ends or lasts: the end needs the joint-excess law's premises, and reading the two laws together is not stated as one theorem on a flow.",
     "zh": "竞逐终结或延续：终结需要联合超出律的前提，而把两律合读并未陈述为流上的一条定理。", "kind": "non-implication"},
    {"en": "Positions read as ranks, shares or signed amounts.",
     "zh": "以名次、份额或带号的量读的位置。", "kind": "scope"},
    {"en": "That actual competitors' positions are read off what they draw from one shared condition, or how much an actual condition renews.",
     "zh": "实际竞争者的位置读自它们从一个共享条件所汲，或实际条件更新多少。", "kind": "correspondence"},
  ],
  "counterexamples": [],
  "standard_boundaries": ["no-ethical-premise", "no-evaluation", "discrete-steps", "formal-not-empirical",
                          "names-provisional", "omission-not-refutation"],
  "validation_scope": {
    "en": f"Machine-checked by the consolidated Lean 4.29.1 checker (receipt {receipt}): the declarations Becoming.RelativePosition gained have empty axiom reports; the checker verifies core purity. Built and reviewed in one session; author review in study section {sec}; not independently reviewed by a person.",
    "zh": f"Lean 4.29.1 合并检查器实查（回执 {receipt}）：Becoming.RelativePosition 新增声明公理报告为空；检查器并核对核心纯净。在一个会话中构建并审查；作者审查见研究第 {sec} 节；未经人的独立审查。"
  },
  "next_delta": {
    "en": "The two laws read together as one theorem on a flow's takes; positions read as ranks or shares; an independent review.",
    "zh": "两律合读为流之所取上的一条定理；以名次或份额读的位置；独立审查。"
  },
  "correspondence": {
    "en": "Competition read as position, the opening's \"winning\": a standing read against the others, by amount drawn or held, reads the amounts up to a common amount, while whether a shared condition lasts reads the total against what is renewed. With this record the opening's body, in Ren's voice, was brought to its law on his word (version 12): \"position, read against the others, bounds what all draw only from below, so no winning certifies that anything lasts\", in place of \"so winning need not measure anything of what lasts\"; its note [^no-law] states the laws and the readings.",
    "zh": "以位置读的竞争，即开篇的「赢」：相对他者、按所汲或所持读出的地位，读各量只到差一个共有的量为止；而共享条件是否延续，读的是总量与所更新者之比。随本记录，开篇正文（Ren 之语）经其同意改到此律（第十二版）：「位置相对他者而读，只从下界定众所汲，所以没有赢能保证任何东西延续」，取代「所以赢不必衡量所延续的任何东西」；其注 [^no-law] 陈述诸律与读法。"
  },
  "canonical_source": SRC,
  "aliases": ["What position reads", "位置所读", "position reads amounts up to a common amount",
              "Becoming.RelativePosition.keeps_iff_common", "Becoming.Lasting.same_positions_apart"],
  "dependencies": [
    {"id": "relative-position-is-zero-sum", "relation": "formal-reuse",
     "detail": {"en": "Its rise and fall counts, least and greatest parts, and the Race witness; the delta is what positions read of the amounts, exactly, and a witness with the race's positions that lasts.",
                "zh": "其升降计数、最少与最大部分，以及 Race 见证；增量是位置对各量所读之恰当所在，以及一个具竞逐之位置而延续的见证。"}}
  ],
  "related": [
    {"id": "own-count-misses-joint-excess",
     "detail": {"en": "Its joint-excess law reads the total drawn against what is given; this record shows positions read that total only from below.",
                "zh": "其联合超出律以所给读总共所汲；本记录表明位置只从下读此总量。"}},
    {"id": "whole-first-and-bounded-centers",
     "detail": {"en": "Both are cited by the opening's note on what the laws contain.",
                "zh": "二者同为开篇关于诸律所含之注所引。"}}
  ],
  "references": [
    {"path": SRC, "role": "proof", "declarations": decls, "sha256": sha(SRC)},
    {"path": REC, "role": "receipt", "sha256": sha(REC)},
    {"path": STUDY, "role": "integration", "sha256": sha(STUDY)},
    {"path": CH, "role": "statement", "sha256": sha(CH)},
    {"path": OPEN, "role": "provenance", "sha256": sha(OPEN)},
    {"path": "sources/15-codex-theory-conversations/2026-10-22-aim-frontier-not-past-understanding.md", "role": "provenance",
     "sha256": sha("sources/15-codex-theory-conversations/2026-10-22-aim-frontier-not-past-understanding.md")},
  ],
  "proof_bindings": [
    {"source": SRC, "receipt": REC, "sha256_pointer": "/source_sha256/Becoming.RelativePosition",
     "success_pointer": "/status", "success_value": "passed"}
  ],
  "history": [
    {"en": f"22 October 2026, NL1 (asked whether OPENING's note [^no-law] could be pushed further): created; study section {sec}; the note states the laws, and each of the three features, read as a law, is refuted by a constructed flow; on Ren's word the opening's body sentence was brought to the law (version 12).",
     "zh": f"2026年10月22日，NL1（问开篇注 [^no-law] 能否更进一步）：新建；研究第 {sec} 节；该注陈述诸律，三项特征各读作一律，均由构造的流驳倒；依 Ren 之言，开篇正文该句改到此律（第十二版）。"}
  ],
}
out = Path("theories/becoming/results/records/what-position-reads.json")
out.write_text(json.dumps(r, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print("wrote", out)
