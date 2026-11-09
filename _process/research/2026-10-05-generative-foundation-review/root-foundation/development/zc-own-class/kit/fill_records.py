#!/usr/bin/env python3
"""Write ZC's two records with the current hashes (AI-written kit, 9 November 2026).

usage: python3 -B fill_records.py [RECEIPT_TIMESTAMP]

Run from the repository root. Without a receipt timestamp the records are written without a receipt
reference or proof binding (a draft for readers); with one, they are bound to that core run.
"""
import hashlib
import json
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path.cwd()
LEAN = "experiments/integrated-correction/general-framework/generative-basis/lean/becoming"
MODULE = f"{LEAN}/Becoming/OwnClass.lean"
CH07 = "theories/becoming/chapters/07-SIGNIFICANCE.md"
STUDY = "_process/research/2026-10-05-generative-foundation-review/root-foundation/development/zc-own-class"
NOTE = f"{STUDY}/NOTE.md"
REVIEW = f"{STUDY}/COLD-READ.md"
SOURCE = "sources/15-codex-theory-conversations/2026-11-09-route-b-ethics-forms.md"
RECORDS = ROOT / "theories/becoming/results/records"


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def receipt_refs(ts):
    if not ts:
        return [], []
    path = f"{LEAN}/becoming-checks/{ts}/verification.json"
    assert (ROOT / path).exists(), path
    return ([{"path": path, "role": "receipt", "sha256": sha(path)}],
            [{"source": MODULE, "receipt": path, "sha256_pointer": "/source_sha256/Becoming.OwnClass",
              "success_pointer": "/status", "success_value": "passed"}])


def common_refs(decls):
    refs = [{"path": MODULE, "role": "proof", "declarations": sorted(decls), "sha256": sha(MODULE)},
            {"path": CH07, "role": "statement", "sha256": sha(CH07)},
            {"path": NOTE, "role": "provenance", "sha256": sha(NOTE)},
            {"path": SOURCE, "role": "provenance", "sha256": sha(SOURCE)}]
    if (ROOT / REVIEW).exists():
        refs.append({"path": REVIEW, "role": "review", "sha256": sha(REVIEW)})
    return refs


def B(name):
    return f"Becoming.{name}"


G2_LAWS = [
    ({"en": "At an occurrence that conditions something, a class meeting P2 (constancy up to the net's end at its class) and P4 (holding its effects) has its block closed under the net: whatever anything alike to it conditions is alike to it. Conversely, a closed block gives P4, and P2 wherever it is decided of each alike occurrence whether it conditions something.",
      "zh": "在有所缘之事件处，满足 P2（于其类之至网之终有常）与 P4（持其所缘）之类，其块对网封闭：凡与之同类者所缘，皆与之同类。反之，块封闭则得 P4，于每一同类者可判其是否有所缘处并得 P2。"},
     ["«本类常闭则类闭»", "«类闭则本类常闭»", "«本类常闭当且仅当类闭»"]),
    ({"en": "At an occurrence that conditions something, the meet of two classes meeting P2 and P4 meets them, and so does the meet of any family of them with a member; the family is not closed under joins: two such classes can have a least common coarsening that holds an occurrence alike to the member and not its effect.",
      "zh": "在有所缘之事件处，满足 P2 与 P4 之二类之交亦满足之，其任一有成员之族之交亦然；此族对并不封闭：二此类之最小共同粗化可持一与员同类者而不持其所缘。"},
     ["«合为类»", "«本类常闭之交»", "«皆»", "«皆为类»", "«本类常闭之遍交»", "JoinBreaks.J_least", "JoinBreaks.J_fails",
      "JoinBreaks.E_meets", "JoinBreaks.F_meets", "JoinBreaks.E_le_J", "JoinBreaks.F_le_J"]),
    ({"en": "The class holding an occurrence alike with everything downstream of it, and nothing else with anything, is defined from the net and the occurrence alone; wherever some class meets P2 and P4 at the occurrence it does too, or wherever it is decided of each occurrence downstream whether it conditions something, or wherever everything within the occurrence's closure has the occurrence within its own, as at an element returning along the net; every class meeting them contains it.",
      "zh": "持一事件与其下游一切同类、他者皆不相类之类，唯由网与此事件定义；凡有类于此事件满足 P2 与 P4，此类亦满足之，且凡满足之类皆含之；其下游每一者是否有所缘可判处，或其闭包内每一者之闭包皆含此事件处，此类即满足之。"},
     ["«后类»", "«后类为类»", "«后类之本»", "«本类常闭则后皆同»", "«本类常闭则含后类»", "«后类本类常闭»", "«后类最细»", "«判则后类本类常闭»", "«及之首步»", "«返则后类本类常闭»", "ReturnsAlong.downstreamClass_regular"]),
    ({"en": "Under every class meeting P2 and P4 at an occurrence, its line reaches exactly what a line under the one reaches; given P2, P4 is equivalent to that. With each center under a class of its own meeting P2 and P4, the per-center condition along the net is the condition at the one, and along a net with no cycle it holds only where every center is one and the same occurrence.",
      "zh": "凡于一事件满足 P2 与 P4 之类，其线所及恰为一之线所及；有 P2 时，P4 等价于此。各中心皆在其自满足 P2 与 P4 之类下时，各中心之沿网之条件即一之条件；于无环之网，唯诸中心为同一事件时成立。"},
     ["«本类常闭则所及即一之所及»", "«本类常则闭当且仅当所及即一之所及»", "«各本类常闭则续无外即一之续无外»", "«各本类常闭续无外则同一中心»"]),
    ({"en": "The identity meets P2 at every occurrence and fails P4 wherever the occurrence conditions something other than itself. P2 alone is not closed under meets, and where the occurrence conditions nothing the meet of two classes meeting P2 and P4 can fail P2.",
      "zh": "同一处处满足 P2，凡事件有异于自身之所缘处不满足 P4。单有 P2 对交不封闭；事件无所缘处，满足 P2 与 P4 之二类之交可不满足 P2。"},
     ["«静之本类至终有常»", "«静不闭»", "MeetBreaks.E_constant", "MeetBreaks.F_constant", "MeetBreaks.meet_not_constant",
      "MeetBreaks.meet_not_constant_at", "MeetBreaks.not_held", "MeetBreaks.idle_both", "MeetBreaks.idle_meet_not_constant"]),
]

G2_EXTRA = ["JoinBreaks.Occ", "JoinBreaks.step", "JoinBreaks.labelE", "JoinBreaks.labelF", "JoinBreaks.labelJ",
            "JoinBreaks.E", "JoinBreaks.F", "JoinBreaks.J", "JoinBreaks.E_class", "JoinBreaks.F_class", "JoinBreaks.J_class",
            "JoinBreaks.m_goes", "JoinBreaks.decided", "MeetBreaks.Occ", "MeetBreaks.step", "MeetBreaks.labelE",
            "MeetBreaks.labelF", "MeetBreaks.E", "MeetBreaks.F", "MeetBreaks.E_class", "MeetBreaks.F_class"]

G5_LAWS = [
    ({"en": "Read on a flow as a net along affecting, with a formation's class \"within its coupling closure or not\", P4 holds exactly where everything the formation affects lies within its coupling closure, and with coupling by threshold only, exactly where whatever it affects can affect it back at some remove.",
      "zh": "以流为沿影响之网读之，形成者之类取「在其耦合闭包内与否」，则 P4 恰当其所影响者皆在其耦合闭包内时成立；仅按阈值耦合时，恰当其所影响者皆能辗转影响回它。"},
     ["«内外»", "«内外为类»", "«内外之所缘同于»", "Flow.CouplingClass", "Flow.couplingClass_class", "Flow.couplingClass_held_iff",
      "Flow.couplingClass_held_iff_back"]),
    ({"en": "Everything downstream of the formation lies on its line under this class exactly where everything within its reach lies within its coupling closure: wherever its acts return, for every coupling by level, and with coupling by threshold only, exactly there.",
      "zh": "此类下，形成者下游一切在其线上，恰当其所及皆在其耦合闭包内：凡其行为返回处，对每一按水平之耦合皆然；仅按阈值耦合时，恰在彼处。"},
     ["«内外之后皆续当且仅当后皆在内»", "Flow.couplingClass_reach_iff", "Flow.ReachReturns.couplingClass_reach",
      "Flow.couplingClass_reach_iff_returns"]),
    ({"en": "The line stays within the formation's reach and its coupling closure, and with coupling by threshold only it reaches exactly the formation's loop. On the root, with the class of what can reach an occurrence, the line reaches exactly its loop, only itself along a net with no cycle.",
      "zh": "其线不出形成者之所及与其耦合闭包；仅按阈值耦合时，恰及其环。于根上，以能及于一事件者之类，其线恰及其环；于无环之网，唯及自身。"},
     ["«内外之线不出»", "Flow.couplingClass_line_within", "Flow.couplingClass_line_iff_loop", "«返之线»", "«返之所及即环»",
      "«返之后皆续当且仅当皆返»", "«无环则返之所及唯己»"]),
    ({"en": "At a formation that affects something, P2 and P4 together, so read, ask that its coupling closure be closed under affecting, more than return: in a net where two occurrences condition each other and a third conditions the first and something reaching neither, the reach holds at the first and P2 fails there.",
      "zh": "于有所影响之形成者，如此读之，P2 与 P4 合而要求其耦合闭包对影响封闭，多于返回：于二事件相缘、第三者缘其一并缘一不及二者之物之网，此及于其一成立而 P2 于彼不成立。"},
     ["Flow.couplingClass_closed", "ReturnsNotRegular.reach_without_regularity", "ReturnsNotRegular.returns"]),
]

G5_EXTRA = ["ReturnsNotRegular.Occ", "ReturnsNotRegular.step", "ReturnsNotRegular.back", "ReturnsNotRegular.within_f",
            "ReturnsNotRegular.k_back", "ReturnsNotRegular.g_back", "ReturnsNotRegular.h_not_back"]


def laws(spec):
    return [dict(text, declarations=[B(d) for d in decls]) for text, decls in spec]


def main():
    ts = sys.argv[1] if len(sys.argv) > 1 else None
    now = datetime.now(timezone.utc).replace(microsecond=0).isoformat()
    receipt, binding = receipt_refs(ts)
    review_note = ("Read cold for overclaim by one other model before landing (the study's cold read)."
                   if (ROOT / REVIEW).exists() else "")
    scope_g2 = {"en": (f"Machine-checked by the consolidated Lean 4.29.1 checker (receipt {ts}): " if ts else
                       "Built in scratch with the checker's own steps, every axiom report empty; the core run binds it at landing: ")
                + "Becoming.OwnClass, every declaration with an empty axiom report. " + review_note,
                "zh": (f"Lean 4.29.1 合并检查器实查（回执 {ts}）：" if ts else "以检查器之步骤于草稿中构建，公理报告皆空；落地时由核心运行绑定：")
                + "Becoming.OwnClass，公理报告皆空。" + ("落地前经另一模型冷读，查其言过其实处。" if review_note else "")}
    g2_decls = sorted({d for _, ds in G2_LAWS for d in ds} | set(G2_EXTRA))
    g5_decls = sorted({d for _, ds in G5_LAWS for d in ds} | set(G5_EXTRA))
    g2 = {
        "schema_version": 2,
        "id": "what-the-net-fixes-of-ones-own-class",
        "title": {"en": "What the net fixes of one's own class", "zh": "网于己之类所定者"},
        "kind": "theorem",
        "status": "recorded-checked",
        "family": "F01",
        "reviewed_at_utc": now,
        "statement": {"en": "Where a class meets the path's regularity and holds one's effects, the net fixes the least such class, oneself with everything downstream, and every such class reaches what the one reaches; at an occurrence that acts, these classes are closed under meets, not joins.",
                      "zh": "凡一类满足此路之理且持己之所缘，网即定其最细者，即己连同下游一切；凡此类皆所及即一之所及；于有所缘之事件，此诸类对交封闭，对并不封闭。"},
        "laws": laws(G2_LAWS),
        "hypotheses": [
            {"en": "No axiom and no premise beyond each law's own, for every carrier, relation and class: the meet law at an occurrence that conditions something; the converse of the closure form where it is decided of each alike occurrence whether it conditions something; the witnesses' nets supplied, with equality on their carriers.",
             "zh": "不加公理，除各律所带者外不加前提，对一切载体、关系与类：交律于有所缘之事件；闭合之形之逆于每一同类者可判其是否有所缘处；见证之网为所给，设载体上之相等。"}],
        "does_not_show": [
            {"en": "Which class is one's own, or that acting presupposes a class holding its effects: that is 07's crux, argued and not settled.", "zh": "何类为己之类，或行动预设一持其所缘之类：此为 07 之关键，有论而未定。", "kind": "non-implication"},
            {"en": "That an actual self's class meets the path's regularity, or holds its effects.", "zh": "实际之自之类满足此路之理，或持其所缘。", "kind": "correspondence"},
            {"en": "That the classes meeting the regularity alone have a least member other than the moment: the identity meets it everywhere, and that family is not closed under meets.", "zh": "单满足此理之诸类有异于一刹那之最细者：同一处处满足之，且此族对交不封闭。", "kind": "scope", "witness": "Becoming.MeetBreaks.meet_not_constant_at"},
            {"en": "That the classes meeting both are closed under joins.", "zh": "满足二者之诸类对并封闭。", "kind": "converse", "witness": "Becoming.JoinBreaks.J_fails"},
            {"en": "That the meet law holds where the occurrence conditions nothing.", "zh": "事件无所缘处交律成立。", "kind": "scope", "witness": "Becoming.MeetBreaks.idle_meet_not_constant"},
            {"en": "Any order of courses: holding one's effects ranks nothing.", "zh": "任何进程之序：持己之所缘不排任何序。", "kind": "non-implication"},
            {"en": "Which occurrences are centers.", "zh": "何事件为中心。", "kind": "scope"}],
        "counterexamples": [],
        "standard_boundaries": ["no-ethical-premise", "no-evaluation", "decidability", "formal-not-empirical", "names-provisional"],
        "validation_scope": scope_g2,
        "next_delta": {"en": "The crux, now the whole of the de se question on the path: whether acting presupposes a class holding one's effects, put to philosophers; and, with centers read off a flow, the per-center condition restated on them.",
                       "zh": "关键，今即此路上 de se 问题之全部：行动是否预设一持己之所缘之类，交哲学家；并以由流读出之中心，重述各中心之条件。"},
        "correspondence": {"en": "Read de se: where one's own class meets the path's two conditions, the net fixes the least such class, oneself with everything one's acts condition at any remove, the widest self of 07's table, and what every such class reaches, that same downstream; which of them is one's own it does not fix, and nothing the line reaches turns on it. So, granted the regularity, the de se question on the path has nothing left but whether one's class holds one's effects; at an occurrence that conditions something other than itself, the identity, a self of one moment, meets the regularity and not that. The reading is the AI's.",
                           "zh": "以 de se 读之：己之类满足此路二条件处，网定其最细者，即己连同己之行为辗转所缘之一切，07 表中最宽之自，并定凡此类之所及，即同一下游；何者为己之类，网不定之，而线之所及不系于此。故许此理，此路上 de se 问题只余己之类是否持己之所缘；于有异于自身之所缘之事件处，同一，一刹那之自，满足此理而不满足彼。读法为 AI 之。"},
        "canonical_source": MODULE,
        "aliases": ["What the net fixes of one's own class", "网于己之类所定者", B("«后类»"), B("«后类最细»"), B("«本类常闭当且仅当类闭»"),
                    B("«本类常闭之交»"), B("«本类常闭则所及即一之所及»")],
        "dependencies": [
            {"id": "constancy-read-at-a-members-class", "relation": "formal-reuse",
             "detail": {"en": "«本类至终有常», «所缘同于», «本类常闭则所缘同类», «本类常闭则后皆续» and «后皆续则所缘同于».", "zh": "«本类至终有常»、«所缘同于»、«本类常闭则所缘同类»、«本类常闭则后皆续» 与 «后皆续则所缘同于»。"}},
            {"id": "the-continuation-condition-on-the-root", "relation": "formal-reuse",
             "detail": {"en": "«续无外» and «续无外则同一中心».", "zh": "«续无外» 与 «续无外则同一中心»。"}},
            {"id": "standpoints-read-off-a-flow", "relation": "formal-reuse",
             "detail": {"en": "ReturnsAlong, at whose elements the least class meets P2 and P4 with no decision.", "zh": "ReturnsAlong，于其元素处最细之类无须判定即满足 P2 与 P4。"}}],
        "related": [
            {"id": "the-class-of-being-joined", "detail": {"en": "The class of being joined reaches what the one reaches; so does every class meeting P2 and P4.", "zh": "相连之类所及即一之所及；凡满足 P2 与 P4 之类亦然。"}},
            {"id": "what-a-line-holds-and-a-regularity-takes-in", "detail": {"en": "Its path's P2 and P4 are what this record asks of the class.", "zh": "其路之 P2 与 P4 即本记录对类之所问。"}},
            {"id": "reach-past-ones-own-end", "detail": {"en": "Which class a center's own line runs under, left open there, is answered here as far as P2 and P4 are granted.", "zh": "彼处所留之中心之线在何类下，此处于 P2 与 P4 所许之限内答之。"}},
            {"id": "the-own-class-read-on-a-flow", "detail": {"en": "The same question with the class read on a flow.", "zh": "同一问题，类于流上读之。"}}],
        "references": common_refs([B(d) for d in g2_decls]) + receipt,
        "proof_bindings": binding,
        "history": [{"en": "9 November 2026: added (ZC, route (b)'s piece G2), deciding an AI conjecture, unchecked, that the classes meeting P2 and P4 are closed under joins and not meets; the opposite holds, and P2 alone is not closed under meets.",
                     "zh": "2026年11月9日：新增（ZC，路线 (b) 之 G2），判定一未经核查之 AI 猜想（满足 P2 与 P4 之诸类对并封闭而对交不封闭）；所成者相反，且单有 P2 对交不封闭。"}],
    }
    scope_g5 = dict(scope_g2)
    g5 = {
        "schema_version": 2,
        "id": "the-own-class-read-on-a-flow",
        "title": {"en": "The own class read on a flow", "zh": "于流上读己之类"},
        "kind": "theorem",
        "status": "recorded-checked",
        "family": "F07",
        "reviewed_at_utc": now,
        "statement": {"en": "With a formation's class read as its coupling closure, the path's reach holds exactly where everything within its reach lies in that closure; with coupling by threshold only, exactly where its acts return, and its line is then its loop.",
                      "zh": "以形成者之耦合闭包读其类，此路之及恰当其所及皆在此闭包内时成立；仅按阈值耦合时，恰在其行为返回处，其线即其环。"},
        "laws": laws(G5_LAWS),
        "hypotheses": [
            {"en": "No axiom and no premise beyond each law's own: reach, influence and coupling closures read off one flow and one web, as in where a formation's acts return; coupling by threshold only where stated; the root witness's net supplied, with no flow built whose affecting is that net.",
             "zh": "不加公理，除各律所带者外不加前提：所及、影响与耦合之闭包由一流一网读出，如形成者之行为何处返回；按阈值耦合处已明言；根上见证之网为所给，未建以此网为影响之流。"}],
        "does_not_show": [
            {"en": "That a formation's own class is its coupling closure: that is one reading, beside the class of what follows it.", "zh": "形成者之己之类即其耦合闭包：此为一读法，与其下游之类并列。", "kind": "non-implication"},
            {"en": "That the path's regularity holds under this class wherever acts return.", "zh": "凡行为返回处，此类下此路之理成立。", "kind": "converse", "witness": "Becoming.ReturnsNotRegular.reach_without_regularity"},
            {"en": "That actual formations' acts return, or that their coupling is by threshold only.", "zh": "实际形成者之行为返回，或其耦合唯按阈值。", "kind": "correspondence"},
            {"en": "Anything substantive about the dynamics beyond the closures' definitions: the laws are near-definitional.", "zh": "闭包定义之外关于动力之实质内容：诸律近乎定义。", "kind": "scope"}],
        "counterexamples": [],
        "standard_boundaries": ["no-ethical-premise", "no-evaluation", "discrete-steps", "formal-not-empirical", "names-provisional"],
        "validation_scope": scope_g5,
        "next_delta": {"en": "With centers read off a flow, whether the formations that hold standpoints are those whose acts return, so that this reading and route (b)'s scope coincide on them.",
                       "zh": "以由流读出之中心，问持立场之形成者是否即行为返回者，使此读法与路线 (b) 之范围于彼相合。"},
        "correspondence": {"en": "Read with the class of what a formation can represent, the path stays within its coupling closure; with coupling by threshold only it reaches no further than route (b)'s outer bound, the influence closure: its line is its loop, within what can affect it, and the reach the path asks is that its acts return. Along dated occurrences the line is the occurrence alone. The path's wider reach needs a class that holds what does not come back. The reading is the AI's.",
                           "zh": "以形成者所能表征者之类读之，此路不出其耦合闭包；仅按阈值耦合时，所及不出路线 (b) 之外界，即影响闭包：其线为其环，在能影响它者之内，此路所问之及即其行为返回。沿有日期之事件，其线唯此事件。此路较宽之及须一持不返回者之类。读法为 AI 之。"},
        "canonical_source": MODULE,
        "aliases": ["The own class read on a flow", "于流上读己之类", B("Flow.CouplingClass"), B("Flow.couplingClass_reach_iff_returns"),
                    B("Flow.couplingClass_line_iff_loop"), B("«返之所及即环»")],
        "dependencies": [
            {"id": "where-a-formations-acts-return", "relation": "formal-reuse",
             "detail": {"en": "Flow.ReachReturns, Flow.InOneLoop, Flow.withinReach_iff_influence and ReachReturns.represented.", "zh": "Flow.ReachReturns、Flow.InOneLoop、Flow.withinReach_iff_influence 与 ReachReturns.represented。"}},
            {"id": "what-the-net-fixes-of-ones-own-class", "relation": "formal-reuse",
             "detail": {"en": "«本类常闭则类闭», for what P2 and P4 ask under this class.", "zh": "«本类常闭则类闭»，用于此类下 P2 与 P4 之所问。"}}],
        "related": [
            {"id": "constancy-read-at-a-members-class", "detail": {"en": "Its reach law, read with this class.", "zh": "其及之律，以此类读之。"}}],
        "references": common_refs([B(d) for d in g5_decls]) + receipt,
        "proof_bindings": binding,
        "history": [{"en": "9 November 2026: added (ZC, route (b)'s piece G5): the class read on a flow; near-definitional, as expected.",
                     "zh": "2026年11月9日：新增（ZC，路线 (b) 之 G5）：类于流上读之；近乎定义，如所料。"}],
    }
    for record in (g2, g5):
        if not ts:
            record.pop("proof_bindings")
        path = RECORDS / f"{record['id']}.json"
        path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print("wrote", path.relative_to(ROOT))


if __name__ == "__main__":
    main()
