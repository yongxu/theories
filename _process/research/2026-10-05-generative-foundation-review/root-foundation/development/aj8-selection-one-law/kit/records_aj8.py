"""AJ8's records: two new, four extended or narrowed. References carry each file's hash, proof
bindings name the core receipt. Usage: records_aj8.py RECEIPT_ID SECTION [--check]
Run after the core check has passed on the landing's Lean; then repoint, render and check."""
import hashlib, json, sys
from pathlib import Path

rid, section = sys.argv[1:3]
dry = "--dry" in sys.argv  # a rehearsal against an older receipt: no hash is asserted
root = Path(__file__).resolve().parents[7]
R = root / "theories/becoming/results/records"
LEAN = "experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/"
receipt = f"experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-checks/{rid}/verification.json"
NOTE = "_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aj8-selection-one-law/NOTE.md"
READING = "_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md"
MAP, LIFE = "theories/becoming/chapters/02-MAP.md", "theories/becoming/chapters/04-LIFE.md"
when = f"{rid[:4]}-{rid[4:6]}-{rid[6:8]}T{rid[9:11]}:{rid[11:13]}:{rid[13:15]}+00:00"
receipt_json = json.loads((root / receipt).read_text(encoding="utf-8"))
assert receipt_json["status"] == "passed", "the receipt did not pass"


def sha(path):
    return hashlib.sha256((root / path).read_bytes()).hexdigest()


def lt(text, zh):
    return {"en": text, "zh": zh}


def binding(module):
    if not dry:
        assert f"Becoming.{module}" in receipt_json["source_sha256"], module
        assert receipt_json["source_sha256"][f"Becoming.{module}"] == sha(LEAN + module + ".lean"), module
    return {"source": LEAN + module + ".lean", "receipt": receipt, "sha256_pointer": f"/source_sha256/Becoming.{module}",
            "success_pointer": "/status", "success_value": "passed"}


def proof(module, decls):
    return {"path": LEAN + module + ".lean", "role": "proof", "sha256": sha(LEAN + module + ".lean"),
            "declarations": sorted(set(decls))}


def plain(path, role):
    return {"path": path, "role": role, "sha256": sha(path)}


def law_decls(laws):
    return [x for law in laws for x in law["declarations"]]


history = lambda en, zh: lt(f"3 November 2026, board item AJ8 (study section {section}): {en}",
                            f"2026年11月3日，工作板条目 AJ8（研究第 {section} 节）：{zh}")
BOUNDS = ["no-ethical-premise", "no-evaluation", "discrete-steps", "formal-not-empirical", "names-provisional",
          "omission-not-refutation"]
RS, SL, DR, DS, DF = "Becoming.RuleShaping.", "Becoming.SelectionLevels.", "Becoming.DrawnReplacement.", \
    "Becoming.DrawnShaping.", "Becoming.Drift.Replacement."

# ---------------------------------------------------------------- shaping-selected-among-groups
groups_laws = [
    {**lt("In groups of m, each member shaping or not and a group's shared part q for each shaper in it, each member's offspring with c per unit of its shaping is a + c with s per unit of its own shaping and q per unit its group holds: a case of returns kept and shared within the group.",
          "m 人之群，每成员塑或不塑，群中每一塑规者予群 q：每成员之后代加其塑之每单位 c，即 a + c 加其自塑之每单位 s 与其群所持之每单位 q，乃群内自留与共享之所返之一例。"),
     "declarations": [RS + "Grouped", RS + "grouped_returns"]},
    {**lt("The whole selects for shaping exactly where c times the spread of shaping falls short of s times it with m q times the spread among groups: over the rationals, with the assortment ρ, exactly where c < s + m q ρ.",
          "整体选塑规恰当 c 乘塑之离散小于 s 乘之加 m q 乘群间离散：于有理数上，ρ 为同类聚集，恰当 c < s + m q ρ。"),
     "declarations": [RS + "grouped_rises_iff"]},
    {**lt("Groups alike in how many shape, shaping varying, select it exactly where c < s, whatever is shared; where c < s every grouping selects it; groups uniform in shaping and differing select it exactly where c < s + m q.",
          "各群塑者数相同而塑有变异时，选之恰当 c < s，无论同得几何；c < s 时任何分群皆选之；各群于塑上齐一而互异时，选之恰当 c < s + m q。"),
     "declarations": [RS + "grouped_alike_iff", RS + "grouped_kept_rises", RS + "grouped_uniform_iff"]},
    {**lt("Witness: two groups of two, a = s = q = 1 and a cost of two, so that at a step the rule after shaping does not favour the shapers; with the shapers together each leaves four and each other three and the whole selects for shaping, and with each shaper beside an other the counts turn and it selects against.",
          "见证：二群各二人，a = s = q = 1，成本为二，故一步之内塑规后之规则不偏向塑规者；塑规者同群时各留四、他者各留三，整体选塑规；每塑规者与一他者同群时计数相反，整体不选。"),
     "declarations": [RS + "Assorting.one_pos", RS + "Assorting.assortedOffspring", RS + "Assorting.mixedOffspring",
                      RS + "Assorting.assorted_grouped", RS + "Assorting.mixed_grouped", RS + "Assorting.either_verdict"]},
]
groups = {
    "schema_version": 2, "id": "shaping-selected-among-groups",
    "title": lt("The capacity to shape the rule, selected among groups", "塑规之能，于群间被选"),
    "kind": "theorem", "status": "recorded-checked", "family": "F01", "reviewed_at_utc": when,
    "statement": lt("Where a group's shared part is what its shapers give, the whole selects for shaping exactly where the cost falls short of what comes back to the shapers alone with the group's part weighted by assortment: Hamilton's rule with what is kept added; without assortment, the step's direction c < s.",
                    "群之同得为其塑规者所予时，整体选塑规恰当成本小于独返于塑规者者加以同类聚集加权之群份：加入自留者之 Hamilton 法则，其无聚集之情形即一步之方向，c < s。"),
    "laws": groups_laws,
    "hypotheses": [lt("No axiom and no premise beyond each law's own: discrete steps and natural counts; a positive; groups of equal size m listed as given; each member shaping (one) or not (none); in each group the rule after shaping with the shared part q times the group's shapers, the cost counted as extra offspring to the others; the whole read as the whole's spread with the step law's exact transmission.",
                      "不加公理，除各律所带者外不加前提：离散之步与自然数计数；a 为正；等大 m 之群，如所列而给；每成员塑（一）或不塑（无）；每群中塑规后之规则，其同得为 q 乘群之塑规者数，成本计为他者多留之后代；整体以整体之离散读之，步律需传递精确。")],
    "does_not_show": [
        {**lt("How groups form, and assortment changing over generations or with the share: they enter as given at the step.",
              "群如何形成，同类聚集随世代或随份额而变：皆于该步如所给而入。"), "kind": "scope"},
        {**lt("Groups of unequal size, graded capacities to shape, and returns with synergy.",
              "不等大之群、分级之塑规之能、有协同之所返。"), "kind": "scope"},
        {**lt("That a shared part given to those near the shapers leaves the step's direction: through assortment it becomes a return to them.",
              "予塑规者近旁者之同得不改一步之方向：经同类聚集，其成为返于彼等者。"), "kind": "non-implication",
         "witness": RS + "Assorting.either_verdict"},
        {**lt("That shaping is better where it is selected: no evaluation enters, and ranking courses needs C.",
              "被选处塑规更好：不入评价，排序进程须 C。"), "kind": "non-implication"},
    ],
    "standard_boundaries": BOUNDS,
    "validation_scope": lt(f"Machine-checked by the core checker with Lean 4.29.1 (receipt {rid}): Becoming.RuleShaping and Becoming.SelectionLevels, every declaration cited here with an empty axiom report. Built in one session, the texts restating it read against their homes by the author; not reviewed by a person.",
                           f"由核心检查器以 Lean 4.29.1 实查（回执 {rid}）：Becoming.RuleShaping 与 Becoming.SelectionLevels，此处所引声明之公理报告皆空。于一会话中构建，复述之文由作者对照其主节读过；未经人审。"),
    "next_delta": lt("Groups that form by the share; assortment over generations; graded capacities; an independent review by a person.",
                     "随份额而成之群；跨世代之同类聚集；分级之能；人之独立审查。"),
    "correspondence": lt("Hamilton's rule (Hamilton 1964) in the multilevel form of Price (1972), with what comes back to the actor alone added, as in the split of direct and indirect fitness (Frank 1998), here for the capacity to shape a rule. Read on the meta-attractor (theories/meta-attractor), its lever χ, how much of what rule-making gives comes back to the rule-makers, reads in groups as s + m q ρ. EL4b's complete-assortment pairs (PairSelection.assorted_counts) are the case m = 2, ρ = 1 on their own carriers.",
                         "Hamilton 法则（Hamilton 1964）以 Price（1972）之多层形式，加入独返于行动者者，如直接与间接适合度之分（Frank 1998），此处用于塑规之能。读于元吸引子（theories/meta-attractor），其杠杆 χ（立规所予中返于立规者之多少）于群中读作 s + m q ρ。EL4b 之完全同类聚集之对（PairSelection.assorted_counts）为 m = 2、ρ = 1 之情形，在其自身之载体上。"),
    "canonical_source": LEAN + "RuleShaping.lean",
    "history": [history("added: the capacity to shape the rule stated as a case of returns kept and shared within the group, with a witness where the cost exceeds what comes back alone and shaping is selected.",
                        "新增：塑规之能陈述为群内自留与共享之所返之一例，并给一见证，成本超过独返者而塑规被选。")],
    "aliases": ["The capacity to shape the rule, selected among groups", "塑规之能，于群间被选",
                "Hamilton's rule for shaping the rule", RS + "grouped_rises_iff"],
    "dependencies": [
        {"id": "selection-with-returns-to-groupmates", "relation": "formal-reuse",
         "detail": lt("rises_iff_kept and its parts within and among groups; spread_levels, among_none_of_alike, within_none_of_uniform; Founding's two groups of two for the witness.",
                      "rises_iff_kept 及其群内群间之部；spread_levels、among_none_of_alike、within_none_of_uniform；见证用 Founding 之二群各二人。")},
        {"id": "shaping-the-rule-selected-by-what-comes-back", "relation": "formal-reuse",
         "detail": lt("The rule after shaping, shaped, and its two counts.", "塑规后之规则 shaped 及其二计数。")}],
    "related": [{"id": "drawn-shaping-drawn-one-at-a-time",
                 "detail": lt("The other AJ condition read on 04's laws: the critical mass drawn one member at a time.",
                              "以 04 之律读之另一 AJ 条件：逐一而抽之临界量。")}],
    "counterexamples": [{"path": LEAN + "RuleShaping.lean", "detail": lt(
        "A cost above what comes back alone need not leave shaping unselected: with a = s = q = 1 and a cost of two, the shapers together are selected for and apart against (Assorting.either_verdict).",
        "成本高于独返者，塑规不必不被选：a = s = q = 1、成本为二时，塑规者同群则被选，分处则不被选（Assorting.either_verdict）。")}],
}
groups["references"] = [
    proof("RuleShaping", law_decls(groups_laws) + [RS + "shaped"]),
    proof("SelectionLevels", [SL + "rises_iff_kept", SL + "within_kept", SL + "among_kept", SL + "spread_levels",
                              SL + "Founding.keeps", SL + "Founding.assorted", SL + "Founding.mixed"]),
    plain(receipt, "receipt"), plain(NOTE, "integration"), plain(READING, "integration"),
    plain(MAP, "statement"), plain(LIFE, "statement")]
groups["proof_bindings"] = [binding("RuleShaping"), binding("SelectionLevels")]

# ---------------------------------------------------------------- drawn-shaping-drawn-one-at-a-time
drawn_laws = [
    {**lt("Among M + 1 members with i shapers, a step replaces an other by a shaper's offspring with weight the shapers' count of the rule read at i, a shaper by an other's with the others' count, and stays with a weight that makes every step weigh alike; the rule read favours the shapers at a count exactly where their weight is at least the others', and with lo ≤ hi their weight does not fall as their count grows.",
          "M + 1 成员中有 i 塑规者，一步以塑规者之后代替一他者，其权为 i 处所读规则中塑规者之计数，以他者之后代替一塑规者，其权为他者之计数，留而不变者之权使每步同权；某计数处所读之规则偏向塑规者恰当其权不小于他者之权，lo ≤ hi 时其权不随其数增而降。"),
     "declarations": [DR + "up", DR + "down", DR + "stay", DR + "whole", DR + "at_", DR + "sub_split", DR + "drawn_carrier",
                      DR + "drawn_other", DR + "favours_iff", DR + "up_mono", DR + "steps"]},
    {**lt("This is the replacement chain with weights read from the count, so its bounds hold: over rounds of M + 1 steps the histories still varied vanish geometrically, and the share fixing the shapers tends to the potential at the start over the potential at the top.",
          "此即权读自计数之替换链，故其诸界成立：每 M + 1 步一轮，尚变之历史几何递减，定于塑规者之份趋于起点之势比顶点之势。"),
     "declarations": [DR + "up_ge", DR + "up_pos", DR + "a_le_whole", DR + "fixation"]},
    {**lt("Noise leaves either lock: from every mixed count the histories losing every shaper weigh at least down^i times every later history, above the critical mass too, and those fixing them at least a^k within reach of the top, below it too.",
          "噪声离开任一锁定：自每一混合计数，失尽塑规者之历史之权至少为 down^i 乘其后每一历史，临界量之上亦然；定于塑规者者于可及顶点处至少为 a^k，临界量之下亦然。"),
     "declarations": [DR + "lost_ge", DR + "fixed_ge"]},
    {**lt("Across the distance: where the rule read at s favours the shapers, from s + n with t to the top, losing every shaper weighs, times the shapers' weights over s + 1 … s + n, at most t times down^n times the whole weight; below the mass, fixing them from j + 1 is bounded the other way.",
          "跨距离：s 处所读之规则偏向塑规者时，自 s + n 起、距顶 t，失尽塑规者之权乘 s + 1 … s + n 处塑规者之权，至多为 t 乘 down^n 乘全权；临界量之下，自 j + 1 定于塑规者者反向为界。"),
     "declarations": [DR + "lost_above", DR + "fixed_below"]},
    {**lt("From one member of either kind among the other, the potential's first step is the product of the shapers' weights over the mixed counts and its last down^M; at an even population the rule read favours the shapers strictly exactly where 2c < hi + lo, risk dominance in counts.",
          "自一员处于他类之中，势之首步为诸混合计数上塑规者之权之积，末步为 down^M；人数均等时所读之规则严格偏向塑规者恰当 2c < hi + lo，即计数中之风险占优。"),
     "declarations": [DR + "one_each", DR + "risk_dominant_iff"]},
    {**lt("Witnesses: five members, a = 1, nothing shared, c = 9, hi = 20, lo = 0: the shapers are risk dominant and the mass lies between the ends, yet the first step, 6,215,625, falls short of the last, 6,250,000; with a = 100, or with 99 to every member alike, the first exceeds the last.",
          "见证：五成员，a = 1，无同得，c = 9，hi = 20，lo = 0：塑规者风险占优，临界量在两端之间，然首步 6,215,625 小于末步 6,250,000；a = 100，或每人同得 99 时，首步大于末步。"),
     "declarations": [DR + "Strong.other_first", DR + "Weak.shapers_first", DR + "Weak.shared_decides"]},
]
drawn = {
    "schema_version": 2, "id": "drawn-shaping-drawn-one-at-a-time",
    "title": lt("The critical mass, drawn one member at a time", "临界量，逐一而抽"),
    "kind": "theorem", "status": "recorded-checked", "family": "F01", "reviewed_at_utc": when,
    "statement": lt("Drawn one member at a time, the stag hunt of shapers and readers drawn from the selected leaves either lock by drift, at a weight falling across the distance from the critical mass; which state a member arising fixes more often is a product of weights that can part from risk dominance.",
                    "逐一而抽时，塑规者与取自被选者之读者之猎鹿局以漂变离开任一锁定，其权随距临界量之远而降；一新成员更常定于何态，为可与风险占优相离之权之积。"),
    "laws": drawn_laws,
    "hypotheses": [lt("No axiom and no premise beyond each law's own: DrawnShaping's model (readers counted as the population counts them, a positive, hi, lo, p and c constants, lo ≤ hi for the chain); offspring drawn one member at a time among M + 1, each member counted among its own readers; a step leaving the count weighed only to make every step weigh alike.",
                      "不加公理，除各律所带者外不加前提：DrawnShaping 之模型（读者如众之计数而计，a 为正，hi、lo、p、c 为常数，链需 lo ≤ hi）；M + 1 成员中逐一而抽后代，每成员计入其自身之读者；不改计数之步加权仅为使每步同权。")],
    "does_not_show": [
        {**lt("That actual rules are drawn one member at a time, or read by readers drawn from those they select: these are premises.",
              "实有之规则逐一而抽，或由取自其所选者之读者读之：此皆前提。"), "kind": "correspondence"},
        {**lt("The long-run state under rare mutation, the one with the larger fixation weight (Fudenberg and Imhof 2006), which is cited; mutation and a time to leave a lock beyond the geometric bound are not stated.",
              "罕有突变下之长期之态，即固定权较大者（Fudenberg 与 Imhof 2006），仅引用；突变与几何界之外离开锁定之时未述。"), "kind": "scope"},
        {**lt("Sampled generations with selection (Wright-Fisher), readers who learn, and counts that accumulate instead of being drawn (ChoiceCountCapture).",
              "带选择之抽样世代（Wright-Fisher）、会学之读者、累积而非抽取之计数（ChoiceCountCapture）。"), "kind": "scope"},
        {**lt("That risk dominance decides which state one member arising fixes more often: the two part under strong selection.",
              "风险占优决定一新成员更常定于何态：强选择下二者相离。"), "kind": "non-implication",
         "witness": DR + "Strong.other_first"},
        {**lt("That the base and the part shared by all leave which state fixes more often alone: they move no critical mass, yet they decide it.",
              "基数与众人同得之部不改何态更常被定：其不移临界量，然决定之。"), "kind": "non-implication",
         "witness": DR + "Weak.shared_decides"},
        {**lt("That leaving a lock by drift is better or worse than keeping it: ranking courses needs C.",
              "以漂变离开锁定优于或劣于守之：排序进程须 C。"), "kind": "non-implication"},
    ],
    "standard_boundaries": BOUNDS,
    "validation_scope": lt(f"Machine-checked by the core checker with Lean 4.29.1 (receipt {rid}): Becoming.DrawnReplacement and Becoming.Drift, every declaration cited here with an empty axiom report. Built in one session, the texts restating it read against their homes by the author; not reviewed by a person.",
                           f"由核心检查器以 Lean 4.29.1 实查（回执 {rid}）：Becoming.DrawnReplacement 与 Becoming.Drift，此处所引声明之公理报告皆空。于一会话中构建，复述之文由作者对照其主节读过；未经人审。"),
    "next_delta": lt("Mutation with drift and the time to leave a lock; sampled generations; drift for counts that accumulate; an independent review by a person.",
                     "带漂变之突变与离开锁定之时；抽样世代；累积计数之漂变；人之独立审查。"),
    "correspondence": lt("The Moran process (Moran 1958) of a two-strategy game in a finite population (Nowak, Sasaki, Taylor and Fudenberg 2004; Taylor, Fudenberg, Sasaki and Nowak 2004), with each member counted among its own readers; one_each is the counting form of their ratio of fixation probabilities, the product of payoff ratios over the mixed counts. Under rare mutation the long-run shares stand as the fixation probabilities (Fudenberg and Imhof 2006). Kandori, Mailath and Rob (1993) and Young (1993) select the risk-dominant state (Harsanyi and Selten 1988), the larger basin, in their limit, which the Moran criterion approaches under weak selection (Nowak and others 2004). That a first step above the last implies 2c < hi + lo follows by pairing the counts k and M + 1 − k (the arithmetic–geometric mean inequality), an argument not checked in Lean. Read on the meta-attractor (theories/meta-attractor), its lock and its second order are one loop without noise only.",
                         "有限群体中二策略博弈之 Moran 过程（Moran 1958；Nowak、Sasaki、Taylor、Fudenberg 2004；Taylor、Fudenberg、Sasaki、Nowak 2004），每成员计入其自身之读者；one_each 为其固定概率之比之计数形式，即诸混合计数上收益比之积。罕有突变下长期份额如固定概率（Fudenberg 与 Imhof 2006）。Kandori、Mailath、Rob（1993）与 Young（1993）于其极限选风险占优之态（Harsanyi 与 Selten 1988），即吸引域较大者，Moran 准则于弱选择下趋之（Nowak 等 2004）。首步大于末步则 2c < hi + lo，由配对计数 k 与 M + 1 − k（算术—几何平均不等式）得之，此论证未经 Lean 检查。读于元吸引子（theories/meta-attractor），其锁定与其第二阶唯无噪声时为一回路。"),
    "canonical_source": LEAN + "DrawnReplacement.lean",
    "history": [history("added: DrawnShaping's stag hunt read as 04's replacement chain with weights read from the count; both exits bounded across the distance from the critical mass; risk dominance in counts and a witness where the Moran criterion parts from it.",
                        "新增：DrawnShaping 之猎鹿局读作 04 之权读自计数之替换链；二出口皆以距临界量之远为界；计数中之风险占优，及 Moran 准则与之相离之见证。")],
    "aliases": ["The critical mass, drawn one member at a time", "临界量，逐一而抽",
                "the stag hunt of drawn shaping with drift", DR + "one_each"],
    "dependencies": [
        {"id": "fixation-with-selection", "relation": "formal-reuse",
         "detail": lt("valueBy, Steps, riseBy, potentialBy, fixationBy, lost_geBy, climbsBy, lostBy_favoured, fixedBy_disfavoured, riseBy_ends, ups_const, downs_const.",
                      "valueBy、Steps、riseBy、potentialBy、fixationBy、lost_geBy、climbsBy、lostBy_favoured、fixedBy_disfavoured、riseBy_ends、ups_const、downs_const。")},
        {"id": "shaping-read-by-readers-drawn-from-the-selected", "relation": "formal-reuse",
         "detail": lt("drawn, drawn_split, drawn_favours_alike: the rule read at each count.", "drawn、drawn_split、drawn_favours_alike：每一计数处所读之规则。")}],
    "related": [{"id": "shaping-selected-among-groups",
                 "detail": lt("The other AJ condition read on 04's laws: shaping as a case of Hamilton's rule.",
                              "以 04 之律读之另一 AJ 条件：塑规作 Hamilton 法则之一例。")},
                {"id": "loss-read-in-time-by-the-others",
                 "detail": lt("After the loss is read the rule read is the drawn rule with lo′ for lo, so this chain applies to it.",
                              "损失既读之后所读之规则即以 lo′ 代 lo 之抽取规则，故此链及之。")}],
    "counterexamples": [{"path": LEAN + "DrawnReplacement.lean", "detail": lt(
        "Risk dominance does not decide which state one member arising fixes more often: with five members, a = 1, c = 9, hi = 20, lo = 0, the shapers are risk dominant and one other still fixes with more weight than one shaper (Strong.other_first); with a = 100 or p = 99 the order turns (Weak.shapers_first, Weak.shared_decides).",
        "风险占优不决定一新成员更常定于何态：五成员、a = 1、c = 9、hi = 20、lo = 0，塑规者风险占优，而一他者仍较一塑规者以更大之权被定（Strong.other_first）；a = 100 或 p = 99 时次序相反（Weak.shapers_first、Weak.shared_decides）。")}],
}
drawn["references"] = [
    proof("DrawnReplacement", law_decls(drawn_laws)),
    proof("Drift", [DF + x for x in ["valueBy", "Steps", "riseBy", "potentialBy", "fixationBy", "lost_geBy", "climbsBy",
                                    "lostBy_favoured", "fixedBy_disfavoured", "riseBy_ends", "ups", "downs"]]),
    proof("DrawnShaping", [DS + "drawn", DS + "drawn_favours_alike"]),
    plain(receipt, "receipt"), plain(NOTE, "integration"), plain(READING, "integration"),
    plain(MAP, "statement"), plain(LIFE, "statement")]
drawn["proof_bindings"] = [binding("DrawnReplacement"), binding("Drift"), binding("DrawnShaping")]


# ---------------------------------------------------------------- the four existing records
def load(i):
    return json.loads((R / f"{i}.json").read_text(encoding="utf-8"))


def put_ref_decls(d, module, decls):
    for r in d["references"]:
        if r["path"] == LEAN + module + ".lean":
            r["declarations"] = sorted(set(r.get("declarations", [])) | set(decls))
            return
    d["references"].insert(0, proof(module, decls))


def add_receipt(d):
    if not any(r["path"] == receipt for r in d["references"]):
        d["references"].append(plain(receipt, "receipt"))
    if not any(r["path"] == NOTE for r in d["references"]):
        d["references"].append(plain(NOTE, "integration"))


def rebind(d, module):
    d["proof_bindings"] = [binding(module) if b["source"] == LEAN + module + ".lean" else b for b in d["proof_bindings"]]


def swap(items, old_start, new):
    hits = [k for k, x in enumerate(items) if x["en"].startswith(old_start)]
    assert len(hits) == 1, old_start
    items[hits[0]] = new


def relate(d, i, en, zh):
    if not any(x["id"] == i for x in d["related"]):
        d["related"].append({"id": i, "detail": lt(en, zh)})


# selection-with-returns-to-groupmates
d = load("selection-with-returns-to-groupmates")
kept = {**lt("Returns kept: where each unit a member keeps costs it K, brings s back to it alone and gives q to every member of its group, its own included, selection within goes by s against K, among groups by s + m q, and the whole selects for keeping exactly where K times its spread falls short of s times it with m q times the spread among groups.",
             "有所自留之所返：成员所留之每单位使其付 K、独返其 s、予其群每人（己亦在内）q 时，群内之选择以 s 对 K，群间以 s + m q，整体选留恰当 K 乘其离散小于 s 乘之加 m q 乘群间离散。"),
        "declarations": [SL + "within_kept", SL + "among_kept", SL + "rises_iff_kept"]}
if not any(SL + "rises_iff_kept" in law["declarations"] for law in d["laws"]):
    d["laws"].insert(len(d["laws"]) - 1, kept)
put_ref_decls(d, "SelectionLevels", kept["declarations"])
add_receipt(d); rebind(d, "SelectionLevels")
relate(d, "shaping-selected-among-groups", "The capacity to shape a rule, a group's shared part what its shapers give, is a case of returns kept.",
       "塑规之能（群之同得为其塑规者所予）为有所自留之所返之一例。")
d["validation_scope"] = lt(f"Machine-checked by the consolidated Lean 4.29.1 checker (receipts 20261022T122330.896153Z and, for the kept form and the returns derived from it, {rid}): every declaration of Becoming.SelectionLevels has an empty axiom report; the checker verifies core purity. Built and reviewed in one session each, with no separate reviewer; not independently reviewed by a person.",
                           f"Lean 4.29.1 合并检查器实查（回执 20261022T122330.896153Z，及有所自留之形式与由之导出之所返，回执 {rid}）：Becoming.SelectionLevels 每一声明之公理报告皆空；检查器核验核心之纯。各于一会话中构建与审读，无另一审者；未经人之独立审查。")
d["history"].append(history("the returns stated as the case s = 0 of returns kept, within_returns, among_returns and rises_iff_returns derived from rises_iff_kept and its parts; the law with something kept added.",
                            "所返陈述为有所自留之所返于 s = 0 之情形，within_returns、among_returns、rises_iff_returns 由 rises_iff_kept 及其部导出；增有所自留之律。"))
d["reviewed_at_utc"] = when
out = {"selection-with-returns-to-groupmates": d}

# fixation-with-selection
d = load("fixation-with-selection")
by_count = [
    {**lt("With weights read from the count, up u(i), down d(i) and a weight of staying making every step weigh T, the histories compose as before; the potential's steps are the downs below a count times the ups above it, harmonic for the steps, and the constant case is the one above.",
          "权读自计数，上 u(i)、下 d(i)，留之权使每步同权 T，历史如前相合；势之步为计数之下诸下权乘其上诸上权，于步为调和，常权之情形即上述者。"),
     "declarations": [DF + x for x in ["valueBy", "Steps", "valueBy_mixed", "valueBy_one_kind", "valueBy_stays", "valueBy_add",
                                      "valueBy_mul", "valueBy_le", "valueBy_congr", "valueBy_const", "valueBy_comp", "downs",
                                      "ups", "riseBy", "potentialBy", "riseBy_step", "potentialBy_harmonic", "valueBy_potential",
                                      "steps_const", "rise_closed"]]},
    {**lt("Every bound holds with those weights where each up is at least a positive c: the varied histories vanish over rounds and the fixing share tends to the potential's ratio, the first kind lost with weight at least the downs' product. Where the ups are at least the downs above s, losing the first kind from s + n weighs, times the ups crossed, at most the distance to the top times the downs crossed times the whole.",
          "上权皆不小于正数 c 时诸界于此等权成立：尚变之历史逐轮递减，定之之份趋于势之比，第一类以至少诸下权之积之权失之。s 之上上权皆不小于下权时，自 s + n 失第一类之权乘所越之上权，至多为距顶之数乘所越之下权乘全权。"),
     "declarations": [DF + x for x in ["valueBy_partition", "fixedBy_below", "potentialBy_within", "fixationBy_bounds", "climbsBy",
                                      "varied_stepBy", "varied_vanishesBy", "fixationBy", "lost_geBy", "riseBy_shift",
                                      "potentialBy_tail", "potentialBy_head", "lostBy_bounds", "lostBy_favoured",
                                      "fixedBy_disfavoured", "riseBy_ends"]]},
]
if not any(DF + "fixationBy" in law["declarations"] for law in d["laws"]):
    d["laws"][-1:-1] = by_count
put_ref_decls(d, "Drift", law_decls(by_count))
swap(d["does_not_show"], "That the common factor of the one-birth-one-death chain drops is read",
     {**lt("Weights that depend on more than the count, such as on time or the history, and mutation with drift.",
           "依于计数之外者（如时间或历史）之权，及带漂变之突变。"), "kind": "scope"})
d["next_delta"] = lt("Selection in sampled generations; mutation with drift; the time to fixation; an independent review.",
                     "抽样世代中之选择；带漂变之突变；至固定之时；独立审查。")
add_receipt(d); rebind(d, "Drift")
relate(d, "drawn-shaping-drawn-one-at-a-time", "A rule read at each count drawn one member at a time: the stag hunt of drawn shaping on this chain.",
       "于每一计数处读之规则逐一而抽：抽取塑规之猎鹿局于此链上。")
d["validation_scope"] = lt(f"Machine-checked by the consolidated Lean 4.29.1 checker (receipts 20261022T145016.701975Z and, for weights read from the count and the constant case derived from them, {rid}): every declaration of Becoming.Drift has an empty axiom report; the checker verifies core purity. Built and reviewed in one session each, with no separate reviewer; not independently reviewed by a person.",
                           f"Lean 4.29.1 合并检查器实查（回执 20261022T145016.701975Z，及权读自计数与由之导出之常权情形，回执 {rid}）：Becoming.Drift 每一声明之公理报告皆空；检查器核验核心之纯。各于一会话中构建与审读，无另一审者；未经人之独立审查。")
d["history"].append(history("the chain stated with weights read from the count and a weight of staying, every bound proved there and the constant case derived from it; bounds across a stretch where one kind's weight is at least the other's added.",
                            "链以权读自计数与留之权陈述，诸界皆于彼处证之，常权之情形由之导出；增一类之权不小于他类之一段上之界。"))
d["reviewed_at_utc"] = when
out["fixation-with-selection"] = d

# shaping-the-rule-selected-by-what-comes-back
d = load("shaping-the-rule-selected-by-what-comes-back")
first = d["laws"][0]
assert first["en"].endswith("exactly where s ≤ c, whatever p."), first["en"][-60:]
first["en"] = first["en"][:-len("whatever p.")] + "whatever p comes to every member alike."
assert first["zh"].endswith("与 p 无关。"), first["zh"][-20:]
first["zh"] = first["zh"][:-len("与 p 无关。")] + "与众人同得之 p 无关。"
swap(d["does_not_show"], "A gain made by the shapers and divided among all",
     {**lt("That the direction holds where the shared part goes to those near the shapers: listed in groups it is a return to them through assortment, and the whole selects for shaping exactly where c < s + m q ρ (shaping-selected-among-groups).",
           "同得部分归于塑规者近旁者时方向仍如此：分群而列，经同类聚集其为返于彼等者，整体选塑规恰当 c < s + m q ρ（shaping-selected-among-groups）。"), "kind": "non-implication"})
swap(d["does_not_show"], "Graded capacities, a return growing",
     {**lt("Graded capacities, returns growing with the domains captured or passing between them, real-valued shares; readers drawn from the selected are in shaping-read-by-readers-drawn-from-the-selected, drawing in drawn-shaping-drawn-one-at-a-time.",
           "分级之能、随所捕获之领域而增或于领域间相传之所返、实数份额；取自被选者之读者见 shaping-read-by-readers-drawn-from-the-selected，逐一而抽见 drawn-shaping-drawn-one-at-a-time。"), "kind": "scope"})
assert "a gain made by the shapers and divided among all; " in d["next_delta"]["en"]
d["next_delta"]["en"] = d["next_delta"]["en"].replace("a gain made by the shapers and divided among all; ", "")
assert "塑规者所得而由众人分享之益；" in d["next_delta"]["zh"]
d["next_delta"]["zh"] = d["next_delta"]["zh"].replace("塑规者所得而由众人分享之益；", "")
relate(d, "shaping-selected-among-groups", "This rule in groups whose shapers give the group's shared part: the direction at a step is its case without assortment.",
       "此规则于群中，群之同得为其塑规者所予：一步之方向为其无同类聚集之情形。")
relate(d, "drawn-shaping-drawn-one-at-a-time", "With hi = lo = s, this rule drawn one member at a time: its lock is left by drift.",
       "hi = lo = s 时此规则逐一而抽：其锁定为漂变所离。")
add_receipt(d); rebind(d, "RuleShaping")
d["history"].append(history("the step's direction scoped to a shared part coming to every member alike, the gain divided among the shapers' groups now stated in shaping-selected-among-groups, and noise in drawn-shaping-drawn-one-at-a-time; the laws are otherwise unchanged.",
                            "一步之方向限于众人同得之同得部分；塑规者所得而分于其群者今述于 shaping-selected-among-groups，噪声述于 drawn-shaping-drawn-one-at-a-time；诸律余皆不变。"))
d["reviewed_at_utc"] = when
out["shaping-the-rule-selected-by-what-comes-back"] = d

# shaping-read-by-readers-drawn-from-the-selected
d = load("shaping-read-by-readers-drawn-from-the-selected")
swap(d["does_not_show"], "Courses with noise, or convergence to either boundary state",
     {**lt("That the lock holds under noise: drawn one member at a time either lock is left by drift, and the state a member arising fixes more often can part from risk dominance (drawn-shaping-drawn-one-at-a-time).",
           "噪声下锁定仍守：逐一而抽时任一锁定为漂变所离，一新成员更常定于何态可与风险占优相离（drawn-shaping-drawn-one-at-a-time）。"), "kind": "non-implication"})
c = d["correspondence"]
a_en = "under noise the risk-dominant state is selected in the long run (Kandori, Mailath and Rob 1993; Young 1993)"
assert a_en in c["en"]
c["en"] = c["en"].replace(a_en, "in the limit of rare mutation against a deterministic dynamic the risk-dominant state is selected (Kandori, Mailath and Rob 1993; Young 1993), and drawn one member at a time the Moran criterion parts from it under strong selection (drawn-shaping-drawn-one-at-a-time)")
a_zh = [z for z in ["有噪声时，长期选风险占优之状态（Kandori、Mailath、Rob 1993；Young 1993）"] if z in c["zh"]]
assert len(a_zh) == 1, "the Chinese correspondence's noise clause changed; read it and set it here"
c["zh"] = c["zh"].replace(a_zh[0], "于罕有突变对确定性动态之极限中选风险占优之态（Kandori、Mailath、Rob 1993；Young 1993），逐一而抽时 Moran 准则于强选择下与之相离（drawn-shaping-drawn-one-at-a-time）")
assert "noise and the long-run state; " in d["next_delta"]["en"]
d["next_delta"]["en"] = d["next_delta"]["en"].replace("noise and the long-run state; ", "mutation with drift and the time to leave the lock; ")
relate(d, "drawn-shaping-drawn-one-at-a-time", "This model drawn one member at a time: both locks left by drift, bounded across the distance from the critical mass.",
       "此模型逐一而抽：二锁定皆为漂变所离，以距临界量之远为界。")
add_receipt(d)
d["history"].append(history("the noise boundary narrowed: drawn one member at a time either lock is left by drift (drawn-shaping-drawn-one-at-a-time), and the long-run state under noise is not the risk-dominant one in general; the laws are unchanged.",
                            "噪声之界收窄：逐一而抽时任一锁定为漂变所离（drawn-shaping-drawn-one-at-a-time），噪声下之长期之态一般非风险占优者；诸律不变。"))
d["reviewed_at_utc"] = when
out["shaping-read-by-readers-drawn-from-the-selected"] = d

out["shaping-selected-among-groups"] = groups
out["drawn-shaping-drawn-one-at-a-time"] = drawn
for i, rec in out.items():
    (R / f"{i}.json").write_text(json.dumps(rec, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print("wrote", i)
