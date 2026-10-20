"""R52: add the joint-draw and restraint laws to their two records (content only; receipts bound at landing)."""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[6]
REC = ROOT / "theories/becoming/results/records"
SRC = "experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/JointDraw.lean"
P = "Becoming."


def load(name):
    return json.loads((REC / f"{name}.json").read_text())


def save(name, d):
    (REC / f"{name}.json").write_text(json.dumps(d, indent=2, ensure_ascii=False) + "\n")


def add_proof_ref(d, decls):
    for r in d["references"]:
        if r.get("path") == SRC and r.get("role") == "proof":
            r["declarations"] = sorted(set(r["declarations"]) | set(decls))
            return
    d["references"].append({"path": SRC, "role": "proof", "declarations": sorted(decls)})


# what-a-rise-draws-from-beyond: which dependence breaks when several take at once
d = load("what-a-rise-draws-from-beyond")
joint = [P + x for x in [
    "Flow.Balances.broken_iff", "Flow.Balances.kept_iff", "Web.Broken.of_need_le", "Web.kept_of_need_le",
    "Flow.Balances.broken_drawn", "Flow.Balances.breaks_beyond_drawn", "Flow.Balances.broken_shared",
    "Flow.Balances.kept_of_restrained", "TwoDrawers.broken", "TwoDrawers.shared", "TwoDrawers.restrained_kept"]]
if not any("Becoming.Flow.Balances.broken_shared" in l.get("declarations", []) for l in d["laws"]):
    d["laws"].append({
        "en": "When several formations take at once, the joint draw breaks: in a balanced flow a dependence met at a step breaks exactly where its need with all that is taken exceeds the level with all that is given; on one condition the highest needs break first, whoever takes; every break, the one beyond the slack included, lies on a condition an active formation draws; a break where each drawer's own take is within the slack has every drawer taking strictly less than all that is taken; restraint by the excess, by any drawers, keeps the need met. TwoDrawers: each take within the slack, the joint draw breaks a third formation's dependence and it ends; one drawer restrained keeps it.",
        "zh": "多个构成同时汲取时，打断依存的是共同的汲取：在平衡的流中，某步被满足的依存跨该步被打断，恰当其所需加上所取的全部超过水平加上所给的全部；在同一条件上所需最高者先被打断，不论谁在汲取；每个打断，包括超出余量时其外的那一个，都落在某个活跃构成所汲取的条件上；每个汲取者自身的取量都在余量之内而依存仍被打断时，每个汲取者所取都严格少于所取的全部；任意汲取者按超出之量节制，所需即仍被满足。TwoDrawers：两者的取量各在余量之内，共同的汲取打断第三个构成的依存，它随之结束；其中一个节制则依存被保持。",
        "declarations": joint})
for x in d["does_not_show"]:
    if x["en"].startswith("Which dependence breaks when several formations take at once"):
        x["en"] = "That the selecting formation causes the break beyond the accounting; the break is read at the step's start, as in Becoming.Dependence. Which dependence breaks when several take at once is stated by the joint draw (Becoming.JointDraw), from the amounts each takes and gives, which the flow supplies."
        x["zh"] = "除记账之外选择者导致了打断；打断按该步开始时读出，如 Becoming.Dependence。多个构成同时汲取时哪个依存被打断，由共同的汲取说明（Becoming.JointDraw），依据每个构成所取所给之量，这些由流给出。"
d["next_delta"] = {
    "en": "Offspring numbers tied to what a formation gives, so that the share laws' premise follows from the flow; how much each formation takes when several draw, as a law of the formations rather than a supplied flow; replenishment from outside the whole; an independent review.",
    "zh": "后代数与构成所给予之量相连，使份额之律的前提由流得出；多个构成汲取时各取多少，作为构成之律而非给定的流；来自整体之外的补充；独立审查。"}
add_proof_ref(d, joint)
h = {"en": "20 October 2026: R52 added the joint draw, which dependence breaks when several formations take at once (Becoming.JointDraw), section 8.1 item 10.",
     "zh": "2026年10月20日：R52 新增共同的汲取，即多个构成同时汲取时哪个依存被打断（Becoming.JointDraw），第 8.1 节第 10 项。"}
if h not in d["history"]:
    d["history"].append(h)
save("what-a-rise-draws-from-beyond", d)

# ranking-under-readings: restraint over any number of drawers under the whole-run reading
d = load("ranking-under-readings")
rest = [P + x for x in [
    "Flow.Balances.level_succ_le", "Flow.Balances.level_le_of_restrained", "Flow.Balances.eases_of_restrained",
    "Ranking.restraint_extends_iff", "Ranking.restraint_ranks_over_drawers", "TwoDrawers.restraint_ranks"]]
if not any("Becoming.Ranking.restraint_extends_iff" in l.get("declarations", []) for l in d["laws"]):
    d["laws"].append({
        "en": "Restraint over any number of drawers, under the whole-run reading: two balanced flows from levels at least as high at the start, the restrained one taking no more from each condition and giving no less at every step, hold every condition at least as high at every step, and with dependences, needs and draws no greater the restrained course eases the other; so where activity needs support in the overdrawing course and follows support in the restrained one, the restrained course extends the other exactly when it includes an event the other withholds, and every comparison satisfying C ranks it higher. No count of formations enters; TwoDrawers is an instance with two drawers and a third formation depending.",
        "zh": "整段读法下对任意多个汲取者的节制：两个平衡的流，起点水平不低，节制的一方每步从每个条件所取不多、所给不少，则每步每个条件的水平不低；依存、所需与汲取不更多时，节制的继续缓和另一个；所以在过度汲取的继续中活动需要支持、在节制的继续中活动随支持而有时，节制的继续扩展另一个，恰当它记入另一个扣下的某个事件，每个满足 C 的比较都把它排得更高。其中不出现构成的数目；TwoDrawers 是两个汲取者加一个依存的第三构成的实例。",
        "declarations": rest})
for x in d["does_not_show"]:
    if x["en"].startswith("The comparisons of absence with presence, sharing with winning and stopping with overdraw"):
        x["en"] = "The comparisons of absence with presence and sharing with winning are proved in the support-gated family (two parts: the focal and the sustaining formation), as instances of the laws of comparison and easing. Restraint is proved for any number of drawers under the whole-run reading (Becoming.JointDraw); under the stepwise reading only in the two-part family, and ThirdParty shows that taking no more does not suffice there."
        x["zh"] = "在场与不在场、共享与以消耗取胜的比较，在支持门控定律族（二元：焦点形成与维持者）中作为比较之律与缓和之律的实例证明。节制在整段读法下对任意多个汲取者证明（Becoming.JointDraw）；在逐步读法下只在二元族中证明，ThirdParty 表明在那里所取不多并不足够。"
d["next_delta"] = {
    "en": "A restraint theorem under the stepwise reading beyond the two-part family, with a premise beyond taking no more, since ThirdParty shows that alone does not suffice (amounts so that taking nothing does not undermine, for example); the same comparison under the relation-level reading; whether the priority of basic conditions yields “better without malignant growth” stepwise.",
    "zh": "逐步读法下二元族之外的节制定理，需要所取不多之外的前提，因为 ThirdParty 表明单此不足（例如带数量使不取者不侵蚀）；形式化关系层读法下的同一比较；检验基本条件优先能否在逐步读法下给出“没有恶性增殖更好”。"}
add_proof_ref(d, rest)
h = {"en": "20 October 2026: R52 proved restraint for any number of drawers under the whole-run reading (Becoming.JointDraw), section 8.1 item 11.",
     "zh": "2026-10-20：R52 在整段读法下对任意多个汲取者证明节制（Becoming.JointDraw），第 8.1 节第 11 项。"}
if h not in d["history"]:
    d["history"].append(h)
save("ranking-under-readings", d)
