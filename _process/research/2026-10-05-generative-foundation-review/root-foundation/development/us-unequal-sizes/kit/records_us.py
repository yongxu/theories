"""US's records: selection-with-returns-to-groupmates extended to groups of any sizes, and
shaping-selected-among-groups' equal-size limit narrowed. References carry each file's hash, proof
bindings name the core receipt. Usage: records_us.py RECEIPT_ID SECTION
Run after the core check has passed on the landing's Lean; then repoint, render and check."""
import hashlib, json, sys
from pathlib import Path

rid, section = sys.argv[1:3]
root = Path(__file__).resolve().parents[7]
R = root / "theories/becoming/results/records"
LEAN = "experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/"
receipt = f"experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-checks/{rid}/verification.json"
NOTE = "_process/research/2026-10-05-generative-foundation-review/root-foundation/development/us-unequal-sizes/NOTE.md"
when = f"{rid[:4]}-{rid[4:6]}-{rid[6:8]}T{rid[9:11]}:{rid[11:13]}:{rid[13:15]}+00:00"
receipt_json = json.loads((root / receipt).read_text(encoding="utf-8"))
assert receipt_json["status"] == "passed", "the receipt did not pass"
SL, RS = "Becoming.SelectionLevels.", "Becoming.RuleShaping."


def sha(path):
    return hashlib.sha256((root / path).read_bytes()).hexdigest()


def lt(text, zh):
    return {"en": text, "zh": zh}


def binding(module):
    assert receipt_json["source_sha256"][f"Becoming.{module}"] == sha(LEAN + module + ".lean"), module
    return {"source": LEAN + module + ".lean", "receipt": receipt, "sha256_pointer": f"/source_sha256/Becoming.{module}",
            "success_pointer": "/status", "success_value": "passed"}


def load(i):
    return json.loads((R / f"{i}.json").read_text(encoding="utf-8"))


def put_ref_decls(d, module, decls):
    for r in d["references"]:
        if r["path"] == LEAN + module + ".lean":
            r["declarations"] = sorted(set(r.get("declarations", [])) | set(decls))
            return
    raise SystemExit(f"no reference to {module}")


def add_plain(d, path, role):
    if not any(r["path"] == path for r in d["references"]):
        d["references"].append({"path": path, "role": role, "sha256": sha(path)})


def rebind(d, module):
    assert any(b["source"] == LEAN + module + ".lean" for b in d["proof_bindings"]), module
    d["proof_bindings"] = [binding(module) if b["source"] == LEAN + module + ".lean" else b for b in d["proof_bindings"]]


def swap(items, old_start, new):
    hits = [k for k, x in enumerate(items) if x["en"].startswith(old_start)]
    assert len(hits) == 1, old_start
    items[hits[0]] = new


history = lambda en, zh: lt(f"4 November 2026, board item US (study section {section}): {en}",
                            f"2026年11月4日，工作板条目 US（研究第 {section} 节）：{zh}")
out = {}

# ---------------------------------------------------------------- selection-with-returns-to-groupmates
d = load("selection-with-returns-to-groupmates")
sized = {**lt("Returns in groups of any sizes: with n a common multiple of the sizes, each group's factor n over its size, and what each unit kept shares reaching every member as q per unit of a reading of its group, selection within goes by s against K, among the means by s against K with n q times the reading's covariation with them, and the whole selects for keeping exactly where K times n times its spread, with q times the reading's discordance with the means, falls short of the same with s and the concordance. Each member gaining q for every unit its group holds, the verdict goes through the covariance of a member's group total with its group's mean, not the spread among groups; what a unit gives its group divided among the members, through the size-weighted spread of the means, K < s + Q ρ.",
              "各组大小任意之所返：取各组大小之公倍数 n、每组之因子为 n 除以其大小，所留每单位所共享者按其组之一读数每单位 q 达于每成员时，组内之选择以 s 对 K，均值之间以 s 对 K 加 n q 乘读数与均值之协变，整体选留恰当 K 乘 n 乘其离散加 q 乘读数与均值之不一致，小于以 s 与一致所成之同式。每成员为其组所持之每单位得 q 时，判定经由成员之组总量与其组均值之协方差，而非组间离散；一单位予其组者均分于成员时，经由按大小加权之均值离散，K < s + Q ρ。"),
         "declarations": [SL + x for x in ["cancel_two", "combination_balance", "kept_balance", "within_shared_by",
                                          "means_shared", "rises_iff_shared_sized", "rises_iff_kept_sized",
                                          "rises_iff_divided_sized"]]}
witness = {**lt("Witness in groups of three and one: two keepers and two others, the keepers together or one in each group, the same spread over the whole and the same size-weighted spread of the means; each member gaining two for every unit its group keeps at a cost of one, the whole selects for keeping with the keepers together and against it with one in each; with what is shared divided, the two listings give one verdict whatever the returns.",
                "三与一之组中之见证：二保留者与二他者，保留者同组或各组一人，整体之离散相同，按大小加权之均值离散亦同；每成员为其组所留之每单位得二、保留者付一时，保留者同组则整体选留，各组一人则不选；所共享者均分时，二种列法不论回报若何皆得同一判定。"),
           "declarations": [SL + "Sized." + x for x in ["big", "small", "big_common", "bigOffspring", "smallOffspring",
                                                       "big_returns", "small_returns", "either_verdict",
                                                       "divided_one_verdict"]]}
if not any(SL + "rises_iff_shared_sized" in law["declarations"] for law in d["laws"]):
    d["laws"] += [sized, witness]
put_ref_decls(d, "SelectionLevels", sized["declarations"] + witness["declarations"])
rebind(d, "SelectionLevels")
add_plain(d, receipt, "receipt"); add_plain(d, NOTE, "integration")
st = d["statement"]
if "groups of any sizes" not in st["en"]:
    st["en"] += " In groups of any sizes the verdict goes through a reading of the group: its total, each member gaining b for every unit its group holds, so that with unequal sizes the spread among groups does not decide it; or its mean, what a unit gives divided among the members, so that it does."
    st["zh"] += "各组大小任意时，判定经由组之一读数：其总量，每成员为其组所持之每单位得 b，则大小不等时组间离散不决定之；或其均值，一单位所予均分于成员，则决定之。"
h = d["hypotheses"][0]
assert "; groups of equal size;" in h["en"] and "；各组大小相等；" in h["zh"]
h["en"] = h["en"].replace("; groups of equal size;", "; groups of equal size for the spread among groups, of any sizes, with a common multiple of the sizes, for a reading of the group;")
h["zh"] = h["zh"].replace("；各组大小相等；", "；经组间离散者各组大小相等，经组之读数者各组大小任意，取诸大小之公倍数；")
swap(d["does_not_show"], "Returns with synergy (depending on the product",
     {**lt("Returns with synergy (depending on the product of own and groupmates' amounts) are not stated, nor which sharing actual groups have: a member gaining for every unit its group holds, or a share of what is given divided, is a premise, and other readings of the group are stated only through the general law.",
           "有协同的回报（依赖自身与组员之量的乘积）未陈述；实有之组如何共享亦未陈述：成员为其组所持之每单位而得，或所予者之均分，皆为前提，组之其他读数仅经一般之律陈述。"), "kind": "scope"})
d["counterexamples"].append({"path": LEAN + "SelectionLevels.lean", "detail": lt(
    "With unequal sizes the spread among groups does not decide the verdict where each member gains for every unit its group holds: the same spread over the whole and among the size-weighted means, and either verdict (Sized.either_verdict).",
    "大小不等而每成员为其组所持之每单位而得时，组间离散不决定判定：整体与按大小加权之均值之离散皆同，而判定两可（Sized.either_verdict）。")})
nd = d["next_delta"]
assert "the returns' among-group part for groups of unequal size; " in nd["en"] and "大小不等之组中回报的组间部分；" in nd["zh"]
nd["en"] = nd["en"].replace("the returns' among-group part for groups of unequal size; ", "")
nd["zh"] = nd["zh"].replace("大小不等之组中回报的组间部分；", "")
d["validation_scope"] = lt(f"Machine-checked by the consolidated Lean 4.29.1 checker (receipts 20261022T122330.896153Z; for the kept form and the returns derived from it, 20261103T102739.294112Z; for groups of any sizes, {rid}): every declaration of Becoming.SelectionLevels has an empty axiom report; the checker verifies core purity. Built and reviewed in one session each, the restatements of groups of any sizes read by one AI reader other than the author; not independently reviewed by a person.",
                           f"Lean 4.29.1 合并检查器实查（回执 20261022T122330.896153Z；有所自留之形式与由之导出之所返，回执 20261103T102739.294112Z；各组大小任意者，回执 {rid}）：Becoming.SelectionLevels 每一声明之公理报告皆空；检查器核验核心之纯。各于一会话中构建与审读，各组大小任意之重述经作者以外之一 AI 读者审读；未经人之独立审查。")
d["history"].append(history("the returns stated in groups of any sizes through a reading of the group (rises_iff_shared_sized), with the kept and divided readings and a witness either way; the open item on the among-group part for unequal sizes answered.",
                            "所返于各组大小任意时经组之读数陈述（rises_iff_shared_sized），附有所自留与均分二读数及两可之见证；大小不等时组间部分之未决项已答。"))
d["reviewed_at_utc"] = when
out["selection-with-returns-to-groupmates"] = d

# ---------------------------------------------------------------- shaping-selected-among-groups
d = load("shaping-selected-among-groups")
law = {**lt("In groups of any sizes, each member gaining q for each shaper in its group, the whole selects for shaping exactly where c times n times the spread of shaping, with q times the discordance of a member's group's shapers with its group's share of them, falls short of s times n times the spread with q times their concordance; with unequal sizes not a function of the spread among groups.",
            "群之大小任意，每成员为其群每一塑规者得 q 时，整体选塑规恰当 c 乘 n 乘塑之离散加 q 乘成员之群塑规者数与其群塑规份额之不一致，小于 s 乘 n 乘离散加 q 乘其一致；大小不等时非群间离散之函数。"),
       "declarations": [RS + "grouped_rises_iff_sized"]}
if not any(RS + "grouped_rises_iff_sized" in x["declarations"] for x in d["laws"]):
    d["laws"].insert(2, law)
put_ref_decls(d, "RuleShaping", law["declarations"])
put_ref_decls(d, "SelectionLevels", [SL + "rises_iff_kept_sized", SL + "Sized.either_verdict"])
rebind(d, "RuleShaping"); rebind(d, "SelectionLevels")
add_plain(d, receipt, "receipt"); add_plain(d, NOTE, "integration")
swap(d["does_not_show"], "Groups of unequal size, graded capacities to shape",
     {**lt("The verdict through the spread among groups for groups of unequal size, which holds only where what is shared is divided among the members; graded capacities to shape, and returns with synergy.",
           "不等大之群中经群间离散之判定，仅于所共享者均分于成员时成立；分级之塑规之能、有协同之所返。"), "kind": "scope"})
h = d["hypotheses"][0]
assert "groups of equal size m listed as given" in h["en"] and "等大 m 之群，如所列而给" in h["zh"]
h["en"] = h["en"].replace("groups of equal size m listed as given", "groups listed as given, of equal size m for the spread among groups and of any sizes, with a common multiple n of the sizes, for the covariance form")
h["zh"] = h["zh"].replace("等大 m 之群，如所列而给", "群如所列而给，经群间离散者等大 m，经协方差之形者大小任意，取诸大小之公倍数 n")
d["history"].append(history("shaping in groups of any sizes stated (grouped_rises_iff_sized), the case of returns kept in groups of any sizes; the equal-size limit narrowed to the spread form.",
                            "群之大小任意时之塑规陈述（grouped_rises_iff_sized），乃各组大小任意之自留所返之一例；等大之限收窄至离散之形。"))
d["reviewed_at_utc"] = when
out["shaping-selected-among-groups"] = d

for i, rec in out.items():
    (R / f"{i}.json").write_text(json.dumps(rec, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print("wrote", i)
