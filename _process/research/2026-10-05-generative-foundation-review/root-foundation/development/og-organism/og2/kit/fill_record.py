"""Write OG2's record from the draft: references with the Lean file's hash, the proof binding to a core
receipt, and the landing's history and validation fields. Usage: fill_record.py RECEIPT_ID SECTION THEOREMS DECLARATIONS"""
import hashlib, json, sys
from pathlib import Path
rid, section, thms, decls_n = sys.argv[1:5]
kit = Path(__file__).resolve().parent
root = Path(__file__).resolve().parents[8]
lean = "experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/RuleRebuilding.lean"
receipt = f"experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-checks/{rid}/verification.json"
d = json.loads((kit / "record.draft.json").read_text(encoding="utf-8"))
sha = hashlib.sha256((root / lean).read_bytes()).hexdigest()
W = "Becoming.RuleRebuilding."
decls = sorted({x for law in d["laws"] for x in law["declarations"]} | {W + "«带不定改后»", W + "«弃而储增»", W + "«及任之前持尽之例»"})
d["reviewed_at_utc"] = f"{rid[:4]}-{rid[4:6]}-{rid[6:8]}T{rid[9:11]}:{rid[11:13]}:{rid[13:15]}+00:00"
d["aliases"] = [W + "«稳者恒持当且仅当在带»", "an entry rule on a shared stock, passed through members who also keep it", "规取于其所限之众"]
d["dependencies"] = [
    {"id": "own-count-misses-joint-excess", "relation": "interpretive",
     "detail": {"en": "Joint excess on a gated renewal is the form of this model's end, taken here as its own clause; no law of it is used.",
                "zh": "门控更新上的共过是此模型之终的形式，此处作为其自身之条款；未用其律。"}},
    {"id": "the-stock-buys-time-where-the-rebuild-draws-on-it", "relation": "interpretive",
     "detail": {"en": "The organism's model of the same plan item: there a stock buys a reader time; here a level is spent by those who keep it.",
                "zh": "同一计划条目之生物体模型：彼处储为读者买时；此处位由守之者所耗。"}}]
d["related"] = []
d["counterexamples"] = [{"path": lean, "detail": {
    "en": "Where a hypothesis fails: at s ≤ l holders drain however large the quota («不及任则持尽»); from no holder the rule does not return («无持者不复»); outside the steady state's test the level ends with the rule held to the last state, and states with gaps can end where the steady state goes on («稳存而隙不存»); revisions outside a region can end the level, inside the band too («带不定改后»).",
    "zh": "假设不成立处：s ≤ l 时无论额多大持者皆尽（«不及任则持尽»）；自无持者规则不复（«无持者不复»）；稳态之试不成立时位终而规持至最后一态，有隙状态可终于稳态存续之处（«稳存而隙不存»）；域外之修订可终其位，带内亦然（«带不定改后»）。"}}]
d["references"] = [{"path": lean, "role": "proof", "sha256": sha, "declarations": decls}]
rsha = hashlib.sha256((root / receipt).read_bytes()).hexdigest()
d["references"].append({"path": receipt, "role": "receipt", "sha256": rsha})
d["proof_bindings"] = [{"source": lean, "receipt": receipt, "sha256_pointer": "/source_sha256/Becoming.RuleRebuilding",
                        "success_pointer": "/status", "success_value": "passed"}]
d["validation_scope"] = {
 "en": f"Checked by the core checker with Lean 4.29.1 from the prelude: Becoming.RuleRebuilding, an instance of the ring, at receipt {rid}, {decls_n} declarations ({thms} theorems), each axiom report empty. The Lean step agreed with the simulation on 699,840 cases. Its design had two independent AI readings and a re-check with runs of the rule; its Lean one independent AI reading, every finding taken.",
 "zh": f"由核心检查器以 Lean 4.29.1 从前奏检查：Becoming.RuleRebuilding，环之实例，回执 {rid}，{decls_n} 个声明（{thms} 条定理），公理报告均为空。Lean 之步与模拟于 699,840 例相合。其设计经两次独立 AI 审读与一次以规则运行复核，其 Lean 经一次独立 AI 审读，所见皆采纳。"}
d["history"] = [{"en": f"2 November 2026, board item OG2 (one kind of institution on the root, plan §十三 item 9): added, study §{section}. A family of nets by where a rule of entry is taught from; the steady state's band, a region under revision, passing, two tests, gaps.",
                 "zh": f"2026年11月2日，工作板条目 OG2（根上之一种制度，计划 §十三 第 9 项）：新增，研究 §{section}。按进入之规由何传授分网族；稳态之带、修订下之域、传授、二试、有隙状态。"}]
out = root / "theories/becoming/results/records/a-rule-rebuilt-from-the-members-it-limits.json"
out.write_text(json.dumps(d, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print(out, sha[:12])
