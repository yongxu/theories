"""Write OG's record from the draft: references with the Lean file's hash, the proof binding to a
core receipt, and the landing's history and validation fields. Usage: fill_record.py RECEIPT_ID SECTION"""
import hashlib, json, sys
from pathlib import Path
rid, section = sys.argv[1], sys.argv[2]
root = Path(__file__).resolve().parents[7]
kit = Path(__file__).resolve().parent
lean = "experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReaderRebuilding.lean"
receipt = f"experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-checks/{rid}/verification.json"
d = json.loads((kit / "record.draft.json").read_text(encoding="utf-8"))
sha = hashlib.sha256((root / lean).read_bytes()).hexdigest()
decls = sorted({x for law in d["laws"] for x in law["declarations"]} | {"Becoming.ReaderRebuilding.«一元三期之时»"})
d["family"] = "F01"
d["reviewed_at_utc"] = "2026-11-01T00:00:00+00:00" if rid == "PENDING" else f"{rid[:4]}-{rid[4:6]}-{rid[6:8]}T{rid[9:11]}:{rid[11:13]}:{rid[13:15]}+00:00"
d["aliases"] = ["Becoming.ReaderRebuilding.«以储买时当且仅当取于储»", "a reader rebuilt from the level it reads", "取于储者以储买时"]
d["dependencies"] = [{"id": "rooms-tested-by-a-window", "relation": "interpretive",
    "detail": {"en": "The rooms tell regulation from equilibrium with a given heater; this family asks where a reader is rebuilt from.",
               "zh": "诸室以给定之热器分调节与平衡；此族问读者由何重建。"}}]
d["related"] = []
d["counterexamples"] = [{"path": lean, "detail": {
    "en": "The reader rebuilt from the supply, and the one never rebuilt, are the nets where the condition fails: each ends at its span under a cut from every level, so its stock buys nothing («断则取于供者尽», «不复建者尽», «取于供者之时»); the given reader never ends.",
    "zh": "取于供之读者与不复建之读者是条件不成立之网：供断时自任一位至其寿而尽，其储不买时（«断则取于供者尽»、«不复建者尽»、«取于供者之时»）；给定之读者永不尽。"}}]
d["references"] = [{"path": lean, "role": "proof", "sha256": sha, "declarations": decls}]

if rid != "PENDING":
    rsha = hashlib.sha256((root / receipt).read_bytes()).hexdigest()
    d["references"].append({"path": receipt, "role": "receipt", "sha256": rsha})
d["proof_bindings"] = [{"source": lean, "receipt": receipt, "sha256_pointer": "/source_sha256/Becoming.ReaderRebuilding",
                        "success_pointer": "/status", "success_value": "passed"}]
d["validation_scope"] = {
 "en": f"Checked by the core checker with Lean 4.29.1 from the prelude: Becoming.ReaderRebuilding, an instance of the ring, at receipt {rid}, 48 declarations (32 theorems), each axiom report empty. Its design had one independent AI reading and a re-check with runs of the rule; its Lean one independent AI reading; every finding was taken.",
 "zh": f"由核心检查器以 Lean 4.29.1 从前奏检查：Becoming.ReaderRebuilding，环之实例，回执 {rid}，48 个声明（32 条定理），公理报告均为空。其设计经一次独立 AI 审读与一次以规则运行复核，其 Lean 经一次独立 AI 审读，所见皆采纳。"}
d["history"] = [{"en": f"1 November 2026, board item OG (an organism on the root, plan §十三 item 9): added, study §{section}. A family of four readers by the rebuild's source; the stock buys time under a cut exactly where the rebuild draws on the level.",
                 "zh": f"2026年11月1日，工作板条目 OG（根上之生物体，计划 §十三 第 9 项）：新增，研究 §{section}。按重建之源分四种读者；恰当重建取于储，供断时储为读者买时。"}]
out = root / "theories/becoming/results/records/the-stock-buys-time-where-the-rebuild-draws-on-it.json"
out.write_text(json.dumps(d, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print(out, sha[:12])
