#!/usr/bin/env python3
"""J1's records (AI-written kit, 9 November 2026).

usage (from the repository root):
  python3 -B records.py draft          write route-b-joined (no receipt) and move the declarations of the four
                                       records whose Lean moved (once; refuses if already moved)
  python3 -B records.py j1             rewrite route-b-joined alone (no receipt)
  python3 -B records.py bind TS        bind route-b-joined to the core run TS (receipt and proof bindings)

The four records keep their claims; only where a declaration lives changes, with a history note each.
"""
import hashlib
import json
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path.cwd()
LEAN = "experiments/integrated-correction/general-framework/generative-basis/lean/becoming"
B_ = f"{LEAN}/Becoming"
CH07 = "theories/becoming/chapters/07-SIGNIFICANCE.md"
STUDY = "_process/research/2026-10-05-generative-foundation-review/root-foundation/development/j1-route-b-joined"
NOTE = f"{STUDY}/NOTE.md"
READER = f"{STUDY}/READER.md"
SOURCE = "sources/15-codex-theory-conversations/2026-11-09-route-b-ethics-forms.md"
RECORDS = ROOT / "theories/becoming/results/records"
NOW = datetime.now(timezone.utc).replace(microsecond=0).isoformat()


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def mod(name):
    return f"{B_}/{name}.lean"


def B(name):
    return f"Becoming.{name}"


def load(rid):
    return json.loads((RECORDS / f"{rid}.json").read_text())


def save(rid, d):
    (RECORDS / f"{rid}.json").write_text(json.dumps(d, ensure_ascii=False, indent=2) + "\n")


# ---------------------------------------------------------------- the J1 record

FTD = "FromTheDynamics"
ALT = "FromTheDynamics.Alternating"

LAWS = [
    ({"en": "At the formations whose acts return, along affecting, each one's least class, itself with everything "
            "downstream of it, meets P2 and P4 there; with each standpoint's line under that class, the per-center "
            "condition holds exactly where the flow is mutually dependent, given one returning formation. The "
            "equivalence uses no P2: under that class a line reaches its member's whole closure, with no premise.",
      "zh": "于其举回返之形成处，沿影响，各者之最细类（己与其下游一切）于彼满足 P2 与 P4；各立场之线皆在此类下时，各中心之条件恰于流相互依赖处成立，"
            "须有一回返之形成。此等价不用 P2：此类下之线及其成员之全闭包，无须前提。"},
     {FTD: ["Flow.returning_downstream_iff_mutuallyDependent"],
      "OwnClass": ["«各后类续无外即一之续无外»", "«返则后类本类常闭»", "ReturnsAlong.downstreamClass_regular"]}),
    ({"en": "For any coupling by level, what lies beyond a returning standpoint's coupling closure has no "
            "significance from it, and the significance is a rival. Pooled over every returning formation of a finite "
            "flow with reach decided, nothing lies beyond: the bound on selection read off continuation has content "
            "only for a pool that leaves some returning formation out.",
      "zh": "对任一按水平之耦合，回返之立场之耦合闭包外者，从它无意义，此意义为对手。于有限而可判所及之流，合诸回返之形成为池，则无外者：读自延续之选择之界，唯于池漏某回返之形成时有内容。"},
     {FTD: ["Flow.returning_beyond_coupling"],
      "BeyondCoupling": ["Flow.reachReturns_ownClosure_rival", "Flow.returning_pool_covers"]}),
    ({"en": "Where the shown relation with every own-widening met added has no cycle, every strict order according "
            "with the choices and increasing in its own continuation on the pairs met ranks a course above another "
            "exactly where the first reaches the second in that relation. An extension between listed level paths met together is one step, "
            "so such orders give C there; C for an order increasing everywhere is the every-pair case.",
      "zh": "加入所遇之己扩大后之所示关系无环处，凡与诸择相合、于所遇之对随己之延续而增之严序，排一程于另一程之上，恰当前者于此关系中及于后者。同遇之二列出水平路径间之延展为其一步，"
            "故凡此序于彼给出 C；于每对皆随己之延续而增之序之 C，为每对之情形。"},
     {FTD: ["ChoiceOccasions.selfConcerned_above_iff_reach", "Web.extension_reached_of_met"],
      "PremiseWitnesses": ["Web.extension_ownWidens", "Web.extension_ranked_of_increasingInOwnOn",
                           "Web.extension_ranked_of_increasingInOwn"]}),
    ({"en": "Where only ending was at stake on the occasions met, the pair the met-pair C ranks is a course that does "
            "not end above one that ends, and every order putting keeping above ending is increasing in its own "
            "continuation on the pairs met: self-concern there is a corollary of keeping above ending, which also "
            "ranks keeping above an ending course it does not widen.",
      "zh": "所遇之时唯终结攸关处，同遇之 C 所排之对，乃不终结之程居终结之程之上；凡置存于终之上之序，于所遇之对皆随己之延续而增：彼处之自我关切为存居终上之推论；存居终上亦排存于其所不扩大之终程之上。"},
     {FTD: ["Web.extension_met_keeps_above_ending"],
      "PersistingChoices": ["ChoiceOccasions.increasingInOwnOn_of_keeping",
                            "ChoiceOccasions.selfConcerned_consistent_of_kept"]}),
    ({"en": "C between listed level paths never ranks the course taken where a line persists: no finite listing "
            "holds the web's actual levels. With every course met and ending read as the empty predicate, the "
            "persistence laws' premises hold on a World meeting them, and no strict order according with the choices "
            "is increasing in its own continuation on every pair.",
      "zh": "列出水平路径间之 C 从不排系存续处所取之程：网之实际水平无有限列表可列。诸程皆遇、终结读作空谓词时，存续诸律之前提于满足之之世界皆成立，"
            "而无与诸择相合之严序于每对皆随己之延续而增。"},
     {"PersistingChoices": ["Flow.persists_not_listsAdmitted", "PersistingChoices.Crossed.not_selfConcerned"],
      FTD: [f"{ALT}.crossed_noCycle", f"{ALT}.crossed_stake", f"{ALT}.crossed_joined"]}),
    ({"en": "A joint witness: two formations standing in turn, each taking its own standing and giving the other its "
            "standing. The flow balances and is mutually dependent, so every formation returns and the scope's "
            "condition holds; a line of descent persists through the two and never overdraws; the web's levels are "
            "never listed; its chooser keeps, consistent with keeping above ending and self-concern "
            "on the occasion met.",
      "zh": "合见之例：二形成轮流而立，各取己之所立并予他者以其所立。流平衡且相互依赖，故每一形成皆回返，范围之条件成立；一传承之系经此二者而存续，从不过取；"
            "其水平从不被列；择于存与终者择存，合于存居终上，并合于所遇之时之自我关切。"},
     {FTD: [f"{ALT}.stands", f"{ALT}.unit", f"{ALT}.flow", f"{ALT}.web", f"{ALT}.generations", f"{ALT}.balances",
            f"{ALT}.acting", f"{ALT}.dependent", f"{ALT}.descended", f"{ALT}.member_stands", f"{ALT}.recurs", f"{ALT}.persists", f"{ALT}.gated",
            f"{ALT}.coupled", f"{ALT}.mutuallyDependent", f"{ALT}.returns", f"{ALT}.choices", f"{ALT}.noCycle",
            f"{ALT}.stake", f"{ALT}.realized", f"{ALT}.joined"]}),
    ({"en": "The general laws the four pieces shared, now below them: returning along a relation, at the frame; the "
            "condition held de se where every element is a center and where one center returns; the one-center law "
            "with each center under a class of its own; a generation coupled to an overdrawn family leaving none; a "
            "reach's first step; self-concern on some pairs, beside self-concern.",
      "zh": "四部分共用之通律，今居其下：沿一关系回返，于框架；每元素皆为中心处与一中心回返处之自指条件；各中心各在己类下之一中心律；系于过取之族之一代无后；"
            "及之首步；于某些对之自我关切，与自我关切并列。"},
     {"Frame": ["ReturnsAlong", "ReturnsAlong.whole"],
      "Weightings": ["ownClosure_unrestricted_iff_of_onto", "ownClosure_unrestricted_iff_of_returning",
                     "Weighting.IncreasingInOwnOn"],
      "GrammarScope": ["«各续无外则同一中心»"],
      "GroupEnding": ["GroupEnding.Flow.coupled_generation_childless"],
      "Grammar": ["«及之首步»"]}),
]
EXTRA = {FTD: [f"{ALT}.unit_self", f"{ALT}.unit_other", f"{ALT}.family_eq", f"{ALT}.balances_at",
               f"{ALT}.descends_at", f"{ALT}.both", f"{ALT}.mem_both", f"{ALT}.dependsOn_self", f"{ALT}.exchanges",
               f"{ALT}.decided", f"{ALT}.keep", f"{ALT}.drain", f"{ALT}.own", f"{ALT}.drain_ne_keep", f"{ALT}.order",
               f"{ALT}.kept"],
         "Significance": ["ReadsOnlyDynamics.not_entails"]}


def j1_record():
    by_file = {}
    for _, decls in LAWS:
        for m, names in decls.items():
            by_file.setdefault(m, set()).update(names)
    for m, names in EXTRA.items():
        by_file.setdefault(m, set()).update(names)
    refs = [{"path": mod(m), "role": "proof", "declarations": sorted(B(n) for n in names), "sha256": sha(mod(m))}
            for m, names in sorted(by_file.items(), key=lambda kv: (kv[0] != FTD, kv[0]))]
    refs += [{"path": CH07, "role": "statement", "sha256": sha(CH07)},
             {"path": NOTE, "role": "integration", "sha256": sha(NOTE)},
             {"path": SOURCE, "role": "provenance", "sha256": sha(SOURCE)}]
    if (ROOT / READER).exists():
        refs.append({"path": READER, "role": "review", "sha256": sha(READER)})
    laws = [dict(text, declarations=[B(n) for names in decls.values() for n in names]) for text, decls in LAWS]
    return {
        "schema_version": 2,
        "id": "route-b-joined",
        "title": {"en": "Route (b) joined", "zh": "路线 (b) 合观"},
        "kind": "theorem",
        "status": "recorded-checked",
        "family": "F07",
        "reviewed_at_utc": NOW,
        "statement": {
            "en": "At the formations whose acts return along affecting, given one, each under its least class, the "
                  "de se condition is exactly mutual dependence; nothing beyond their coupling closures counts "
                  "from them; orders a persisting line's choices allow give C only along what they show, never the "
                  "course taken.",
            "zh": "于沿影响其举回返之形成处（有其一时），各在其最细类下，自指之延续条件恰为相互依赖；其耦合闭包外者从它们无意义；存续之系之择所容之序，唯沿其所示给出 C，从不及所取之程。"},
        "laws": laws,
        "hypotheses": [
            {"en": "No axiom. Read off one flow and one web, as in the four pieces: the relation is affecting, the "
                   "standpoints the formations whose acts return, each one's class its least class; that significance "
                   "is own closure is itself a reading.",
             "zh": "不加公理。如四部分，由一流一网读出：关系为影响，立场为其举回返之形成，各者之类为其最细类；意义为自身闭包，本身即一读法。"},
            {"en": "The scope: one returning formation, which finitely many formations with reach decided give wherever "
                   "there is a formation. The pool's covering: finitely many formations listed and reach decided.",
             "zh": "范围：一回返之形成；有限多形成且所及可判时，凡有形成处即有之。池之覆盖：有限多形成列出，所及可判。"},
            {"en": "C: the condition held de se, an own marking of what lies within a center's closure, decided "
                   "admission, two listed level paths, one extending the other, the two met together at some occasion; "
                   "for the exact condition, no cycle in the shown relation with every own-widening met added.",
             "zh": "C：自指之条件，标记中心闭包内者为己，可判之纳入，二列出之水平路径，一延展另一，二者于某时同遇；精确条件另须加入所遇之己扩大后之所示关系无环。"},
            {"en": "Keeping above ending as self-concern: on the occasions met a course adds to its own continuation "
                   "beyond one it widens only where it does not end and the other does (the stake).",
             "zh": "以存居终上为自我关切：所遇之时，一程于其所扩大者之外增己之延续，唯当其不终而他者终（攸关之设）。"},
            {"en": "The persistence laws: balance, only active formations giving, activity needing support, descent, a "
                   "family's renewal gated on it, every member depending on it at a need of at least m, and the line "
                   "persisting; an ending choice realized as an overdraw.",
             "zh": "存续诸律：平衡，唯活动者给予，活动须支撑，传承，族之更新以族为门，每成员以至少 m 之需依于族，系存续；终结之择实现为过取。"}],
        "does_not_show": [
            {"en": "That significance is own closure, or the relation, the standpoints or the class: each is a reading "
                   "the dynamics do not fix.",
             "zh": "意义为自身闭包，或关系、立场、类：皆为动力不定之读法。", "kind": "non-implication"},
            {"en": "That any order is held rather than consistent with the choices, or any order between degrees of "
                   "keeping.",
             "zh": "任何序为所持而非仅与诸择相合，或存之程度之间之任何序。", "kind": "non-implication"},
            {"en": "Self-concern on every pair under these premises, every course being met.",
             "zh": "在此等前提下、诸程皆遇时，于每对之自我关切。", "kind": "converse",
             "witness": B(f"{ALT}.crossed_joined")},
            {"en": "That the four pieces' centers are one object: no theorem identifies them.",
             "zh": "四部分之中心为同一对象：无定理认同之。", "kind": "scope"},
            {"en": "Anything in time: every relation is read across all steps, and own closure ignores the step.",
             "zh": "任何关于时间者：每一关系皆跨诸步读之，自身闭包不计步。", "kind": "scope"},
            {"en": "That mutual dependence is benign: it counts taking as well as giving, so it includes mutual drain.",
             "zh": "相互依赖为良善：其计取亦计予，故含相互耗取。", "kind": "non-implication"},
            {"en": "A selection whose pool is read off the course, or one that removes its own readers.",
             "zh": "池读自所行之程之选择，或去其自身读者之选择。", "kind": "scope"},
            {"en": "That the flow forms the chooser: in the joint witness the chooser is supplied, tied to the flow only "
                   "by the realization premise.",
             "zh": "流形成择者：合见之例中择者为所给，唯以实现之前提系于流。", "kind": "correspondence"}],
        "counterexamples": [],
        "standard_boundaries": ["no-ethical-premise", "significance-related-not-asserted", "names-provisional",
                                "formal-not-empirical", "discrete-steps"],
        "validation_scope": {
            "en": "Pure core, axiom report empty; a leaf composing the four pieces and the general laws moved below "
                  "them. Near-definitional by necessity: no statement reading only the dynamics entails the condition "
                  "(what the dynamics leave open). Each law is a short composition; the witnesses are checked on their "
                  "models. Written by an AI; a reader of another model read the statements cold against this record; "
                  "no human audit.",
            "zh": "纯核心，公理报告为空；叶模块，合四部分及移至其下之通律。近于定义乃势所必然：唯读动力之陈述皆不蕴含条件（动力所留开者）。各律皆短组合；诸例于其模型上查验。"
                  "AI 所写；另一模型之读者冷读对照本记录；无人类审计。"},
        "next_delta": {
            "en": "Which readings or scopes persist, with the pool a selection reads taken off the course, where the "
                  "meta-attractor can be stated; and the condition read in time, along dated mutual dependence.",
            "zh": "何种读法或范围存续，选择所读之池取自所行之程，元吸引子于彼可陈；及按时间读之条件，沿带时之相互依赖。"},
        "correspondence": {
            "en": "Reading (the AI's): persisting's filter, keeping above ending, is the self-preservation half of "
                  "instrumental convergence wherever a reward channel or an operator's assent is among what a line "
                  "depends on; with the bound, the drain beyond what couples in, it is the pair AJ's plan names for "
                  "convergence. One dynamics, named by where its closure reaches: what tells an ethics from self-keeping "
                  "is the scope, whether the closure a center's concern is drawn along reaches beyond what returns to "
                  "it, not the order.",
            "zh": "解读（AI 的）：存续之筛，存居终上，凡奖励通道或操作者之认可在系之所依中，即工具性趋同之自保一半；与界（耦合入者外之耗取）合，即 AJ 计划为趋同所名之一对。"
                  "一个动力，依其闭包所及而命名：分伦理与自保者，是范围（中心之关切所沿之闭包是否及于回返于己者之外），非序。"},
        "canonical_source": mod(FTD),
        "aliases": ["route (b) joined", "路线 (b) 合观", B("Flow.returning_downstream_iff_mutuallyDependent"),
                    B("ChoiceOccasions.selfConcerned_above_iff_reach"), B(f"{ALT}.joined")],
        "dependencies": [
            {"id": "standpoints-read-off-a-flow", "relation": "formal-reuse",
             "detail": {"en": "Flow.Returning and Flow.returning_unrestricted_iff_mutuallyDependent.",
                        "zh": "Flow.Returning 与 Flow.returning_unrestricted_iff_mutuallyDependent。"}},
            {"id": "what-the-net-fixes-of-ones-own-class", "relation": "formal-reuse",
             "detail": {"en": "«后类», «后类之所及即一之所及», «返则后类本类常闭» and ReturnsAlong.downstreamClass_regular.",
                        "zh": "«后类»、«后类之所及即一之所及»、«返则后类本类常闭» 与 ReturnsAlong.downstreamClass_regular。"}},
            {"id": "route-b-universal-form-closed", "relation": "formal-reuse",
             "detail": {"en": "Flow.reachReturns_ownClosure_rival at the returning standpoints.",
                        "zh": "Flow.reachReturns_ownClosure_rival，于回返之立场。"}},
            {"id": "selection-read-off-continuations", "relation": "formal-reuse",
             "detail": {"en": "Flow.returning_pool_covers.", "zh": "Flow.returning_pool_covers。"}},
            {"id": "what-persisting-shows-of-an-order", "relation": "formal-reuse",
             "detail": {"en": "ShownOrder's laws on the enlarged occasions, keeping_above_ending, the persistence laws, "
                              "Flow.persists_not_listsAdmitted and the crossed choices.",
                        "zh": "扩大之时上之所示之序诸律、keeping_above_ending、存续诸律、Flow.persists_not_listsAdmitted 与交错之择。"}},
            {"id": "self-concern-and-c-under-the-condition", "relation": "formal-reuse",
             "detail": {"en": "The C theorem between listed level paths, now the case of every pair of the met-pair C.",
                        "zh": "列出水平路径间之 C 定理，今为同遇之 C 之每对情形。"}},
            {"id": "what-the-dynamics-leave-open", "relation": "interpretive",
             "detail": {"en": "Why the join is near-definitional: no statement reading only the dynamics entails the "
                              "condition (ReadsOnlyDynamics.not_entails).",
                        "zh": "合观何以近于定义：唯读动力之陈述皆不蕴含条件（ReadsOnlyDynamics.not_entails）。"}}],
        "related": [
            {"id": "mutual-dependence-gives-the-condition-de-se",
             "detail": {"en": "The condition held de se at every center under mutual dependence; here at the returning "
                              "standpoints under their least class.",
                        "zh": "相互依赖下每一中心之自指条件；此处于回返之立场、在其最细类下。"}},
            {"id": "covering-by-the-returning-formations",
             "detail": {"en": "The covering the pool's law rests on.", "zh": "池之律所依之覆盖。"}}],
        "references": refs,
        "proof_bindings": [],
        "history": [{
            "en": "9 November 2026, board item J1 (route (b)'s join, after G1, G3, G2 and the bound landed): added. "
                  "Three AI readings of the join, eight adversarial checkers and a critic settled what composes; this "
                  "record states it once, with a joint witness where none had existed, and the general laws the "
                  "pieces shared moved below them (board rule 9).",
            "zh": "2026年11月9日，看板项 J1（路线 (b) 之合观，于 G1、G3、G2 与界落地之后）：新增。三份 AI 合观读法、八个对抗查验者与一评者定其可组合者；"
                  "本记录合而陈之，立一前所未有之合见之例，并将诸部分共用之通律移至其下（看板规则 9）。"}],
    }


# ---------------------------------------------------------------- the four records whose Lean moved

def move_decls(d, names, src, dst):
    """Move the named declarations from the reference to src to the one to dst (created if missing)."""
    refs = d["references"]
    s = next(r for r in refs if r["path"] == mod(src))
    for n in names:
        assert n in s["declarations"], (d["id"], n)
        s["declarations"].remove(n)
    t = next((r for r in refs if r["path"] == mod(dst)), None)
    if t is None:
        t = {"path": mod(dst), "role": "proof", "declarations": [], "sha256": sha(mod(dst))}
        refs.insert(refs.index(s) + 1, t)
    t["declarations"] = sorted(set(t["declarations"]) | set(names))
    if not s["declarations"]:
        refs.remove(s)


def replace_in_laws(d, old, new):
    for law in d.get("laws", []):
        law["declarations"] = [x for n in law["declarations"] for x in (new if n == old else [n])]


def note(d, en, zh):
    d.setdefault("history", []).append({"en": en, "zh": zh})
    d["reviewed_at_utc"] = NOW


def draft():
    save("route-b-joined", j1_record())

    d = load("mutual-dependence-gives-the-condition-de-se")
    names = [B("Clearing.not_unrestricted_ownClosure"), B("Flow.mutuallyDependent_iff_unrestricted"),
             B("Flow.unrestricted_of_mutuallyDependent")]
    move_decls(d, names, "PersistingChoices", "FlowCenters")
    d["canonical_source"] = mod("FlowCenters")
    for c in d.get("counterexamples", []):
        if c["path"] == mod("PersistingChoices"):
            c["path"] = mod("FlowCenters")
    for b in d.get("proof_bindings", []):
        if b["source"] == mod("PersistingChoices"):
            b["source"] = mod("FlowCenters")
            b["sha256_pointer"] = "/source_sha256/Becoming.FlowCenters"
    note(d, "9 November 2026, J1 (route (b)'s join, board rule 9): the three declarations moved, with their names "
            "and statements, from PersistingChoices to FlowCenters, beside the standpoints a flow gives; "
            "Flow.mutuallyDependent_iff_unrestricted is now the case of ownClosure_unrestricted_iff_of_onto. "
            "The claim is unchanged.",
         "2026年11月9日，J1（路线 (b) 之合观，看板规则 9）：三声明连同其名与陈述自 PersistingChoices 移至 FlowCenters，与流所给之立场并列；"
         "Flow.mutuallyDependent_iff_unrestricted 今为 ownClosure_unrestricted_iff_of_onto 之情形。所陈未变。")
    save(d["id"], d)

    d = load("standpoints-read-off-a-flow")
    names = [B("ReturnsAlong"), B("ReturnsAlong.loop"), B("returnsAlong_of_whole"), B("ReturnsAlong.whole")]
    move_decls(d, names, "FlowCenters", "Frame")
    note(d, "9 November 2026, J1 (route (b)'s join, board rule 9): ReturnsAlong and its three laws moved, with their "
            "names and statements, from FlowCenters to the frame, stated for elements of any type, and Centers' "
            "Flow.ReachReturns is now defined as its case along affecting; ownClosure_unrestricted_atReturning_iff "
            "and Flow.mutuallyFed_iff_unrestricted are cases of two laws in Weightings, and the backward half of "
            "Flow.returning_unrestricted_iff_mutuallyDependent is Flow.unrestricted_of_mutuallyDependent. The claim "
            "is unchanged.",
         "2026年11月9日，J1（路线 (b) 之合观，看板规则 9）：ReturnsAlong 及其三律连同名与陈述自 FlowCenters 移至框架，对任意类型之元素陈述，"
         "Centers 之 Flow.ReachReturns 今定义为其沿影响之情形；ownClosure_unrestricted_atReturning_iff 与 Flow.mutuallyFed_iff_unrestricted "
         "为 Weightings 中二律之情形，Flow.returning_unrestricted_iff_mutuallyDependent 之逆半为 Flow.unrestricted_of_mutuallyDependent。所陈未变。")
    save(d["id"], d)

    d = load("what-the-net-fixes-of-ones-own-class")
    move_decls(d, [B("«及之首步»")], "OwnClass", "Grammar")
    s = next(r for r in d["references"] if r["path"] == mod("OwnClass"))
    s["declarations"].remove(B("«各本类常闭续无外则同一中心»"))
    s["declarations"] = sorted(set(s["declarations"]) | {B("«各后类续无外即一之续无外»")})
    gs = {"path": mod("GrammarScope"), "role": "proof", "declarations": [B("«各续无外则同一中心»")],
          "sha256": sha(mod("GrammarScope"))}
    d["references"].insert(d["references"].index(s) + 1, gs)
    replace_in_laws(d, B("«各本类常闭续无外则同一中心»"),
                    [B("«各后类续无外即一之续无外»"), B("«各续无外则同一中心»")])
    note(d, "9 November 2026, J1 (route (b)'s join, board rule 9): «及之首步» moved to the grammar beside «及»; "
            "«各本类常闭续无外则同一中心» went, since the one-center law holds with each center under any class "
            "of its own, asking none of its premises «类», P2 or P4 («各续无外则同一中心», GrammarScope), and "
            "«各后类续无外即一之续无外» states the least class's per-center form with no premise; "
            "«返则后类本类常闭» takes its hypothesis as ReturnsAlong. Statement and claim unchanged; the 07 sentence "
            "citing the corollary now cites the general law.",
         "2026年11月9日，J1（路线 (b) 之合观，看板规则 9）：«及之首步» 移至文法，与 «及» 并列；«各本类常闭续无外则同一中心» 去之，因一中心律于各中心"
         "在其任一己类下皆成立，不须其前提 «类»、P2 或 P4（«各续无外则同一中心»，GrammarScope），而 «各后类续无外即一之续无外» 陈最细类之各中心形式，无须前提；"
         "«返则后类本类常闭» 之假设今写作 ReturnsAlong。陈述与所陈未变；07 引此推论之句今引通律。")
    save(d["id"], d)

    d = load("what-persisting-shows-of-an-order")
    move_decls(d, [B("Weighting.IncreasingInOwnOn"), B("Weighting.increasingInOwnOn_of_increasingInOwn"),
                   B("Weighting.increasingInOwnOn_every_iff")], "PersistingChoices", "Weightings")
    s = next(r for r in d["references"] if r["path"] == mod("PersistingChoices"))
    s["declarations"].remove(B("ChoiceOccasions.reach_first_step"))
    s["declarations"] = sorted(set(s["declarations"]) | {B("ChoiceOccasions.increasingInOwnOn_of_keeping")})
    g = {"path": mod("Grammar"), "role": "proof", "declarations": [B("«及之首步»")], "sha256": sha(mod("Grammar"))}
    d["references"].append(g)
    replace_in_laws(d, B("ChoiceOccasions.reach_first_step"), [B("«及之首步»")])
    replace_in_laws(d, B("ChoiceOccasions.selfConcerned_consistent_of_kept"),
                    [B("ChoiceOccasions.increasingInOwnOn_of_keeping"),
                     B("ChoiceOccasions.selfConcerned_consistent_of_kept")])
    note(d, "9 November 2026, J1 (route (b)'s join, board rule 9): Weighting.IncreasingInOwnOn and its two laws moved "
            "to Weightings beside IncreasingInOwn; ChoiceOccasions.reach_first_step went for the grammar's «及之首步»; "
            "the ending step of Flow.persists_never_overdraws is GroupEnding.Flow.coupled_generation_childless; and "
            "ChoiceOccasions.selfConcerned_consistent_of_kept is now derived from keeping_above_ending through "
            "ChoiceOccasions.increasingInOwnOn_of_keeping (under the stake, keeping above ending is self-concern on "
            "the pairs met). The claim is unchanged.",
         "2026年11月9日，J1（路线 (b) 之合观，看板规则 9）：Weighting.IncreasingInOwnOn 及其二律移至 Weightings，与 IncreasingInOwn 并列；"
         "ChoiceOccasions.reach_first_step 去之，用文法之 «及之首步»；Flow.persists_never_overdraws 之终结一步为 GroupEnding.Flow.coupled_generation_childless；"
         "ChoiceOccasions.selfConcerned_consistent_of_kept 今经 ChoiceOccasions.increasingInOwnOn_of_keeping 由 keeping_above_ending 推出（攸关之设下，存居终上即所遇之对之自我关切）。所陈未变。")
    save(d["id"], d)


def bind(ts):
    receipt = f"{LEAN}/becoming-checks/{ts}/verification.json"
    assert (ROOT / receipt).exists(), receipt
    data = json.loads((ROOT / receipt).read_text())
    assert data.get("status") == "passed"
    d = load("route-b-joined")
    d["references"] = [r for r in d["references"] if r.get("role") != "receipt"]
    d["references"].append({"path": receipt, "role": "receipt", "sha256": sha(receipt)})
    d["proof_bindings"] = []
    for r in d["references"]:
        if r["path"].endswith(".lean"):
            m = "Becoming." + Path(r["path"]).stem
            assert data["source_sha256"][m] == sha(r["path"]), m
            r["sha256"] = sha(r["path"])
            d["proof_bindings"].append({"source": r["path"], "receipt": receipt,
                                        "sha256_pointer": f"/source_sha256/{m}",
                                        "success_pointer": "/status", "success_value": "passed"})
    for r in d["references"]:
        if not r["path"].endswith(".lean") and r.get("role") != "receipt":
            r["sha256"] = sha(r["path"])
    if (ROOT / READER).exists() and not any(r["path"] == READER for r in d["references"]):
        d["references"].append({"path": READER, "role": "review", "sha256": sha(READER)})
    d["reviewed_at_utc"] = NOW
    save("route-b-joined", d)


if __name__ == "__main__":
    if sys.argv[1] == "draft":
        draft()
    elif sys.argv[1] == "j1":
        save("route-b-joined", j1_record())
    elif sys.argv[1] == "bind":
        bind(sys.argv[2])
    else:
        raise SystemExit(__doc__)
