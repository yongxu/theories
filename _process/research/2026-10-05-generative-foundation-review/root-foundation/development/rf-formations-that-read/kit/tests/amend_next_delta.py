"""Name each RF record's test as designed in experiments/formations-that-read.

One clause of `next_delta` changes per record, in English and Chinese, where the
record named its test in words that misstate what a test can refute (plan §10,
corrected with the designs). One history note per record. Nothing else changes.

    python3 amend_next_delta.py SECTION          # dry run: print the changes
    python3 amend_next_delta.py SECTION --apply  # write the records
"""
import json, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[8]
REC = ROOT / 'theories/becoming/results/records'

# record id -> (test, what it can refute, [(old en, new en)], [(old zh, new zh)])
CHANGES = {
    'what-choices-show-of-an-order': ('TR1', 'the correspondence that a chooser picks by strict dominance under one strict order', '择者依一严序以严胜而择之对应',
        [('a frozen test of the reach on choosers', 'a frozen test of the correspondence, that a chooser picks by strict dominance under one strict order (the plan\'s TR1)')],
        [('择者之及之冻结检验', '择者之对应之冻结检验，即择者依一严序以严胜而择（计划之 TR1）')]),
    'acts-alike-from-a-model-or-from-an-order': ('TR1', 'the correspondence that the strict picks accord with one order across frames, which of a model and an order holds being described only', '严择合跨框之一序之对应，模型与序孰成唯述之',
        [('a frozen test separating a model that does not separate from an order that ranks otherwise by informing', 'a frozen informing variant within the plan\'s TR1, whose one verdict is an order across frames; which of a model and an order holds is described, not tested')],
        [('以告分未分之模型与排序相异之序之冻结检验', '计划之 TR1 内告之变体之冻结，其唯一判定为跨框之一序；模型与序孰成，述而不验')]),
    'what-readings-fix-of-the-unread': ('TR2', 'a stated lumping or an implementation', '所述之归并或其实现',
        [('A frozen test of the chain on a trained model with cues varied apart from content', 'A frozen measurement of the chain\'s correspondence on trained models (the plan\'s TR2): cues varied apart from content and the schedule apart from the cue, with identical-input arms; it can refute a stated lumping or an implementation, never the law')],
        [('于已训之模型上分讯与内容而变之链之冻结检验', '于已训之模型上链之对应之冻结量测（计划之 TR2）：分讯于内容而变，分读之时于讯而变，设同入之臂；唯能驳所述之归并或其实现，不驳此律')]),
    'readers-reading-readers': ('TR3', 'the bridge that sequential choosers meet the premise at the histories reached', '依次之择者于所至之历合此前提之桥',
        [('a test predicting when sequential choosers stop reading their own signals', 'a test of where sequential choosers meet the premise, a named probabilistic model\'s timing judged apart (the plan\'s TR3)')],
        [('预测依次之择者何时不复读其私讯之检验', '依次之择者于何处合此前提之检验，具名之概率模型之时机另判（计划之 TR3）')]),
    'a-revision-that-opens-a-correction': ('TR4', 'the bridge that the reading in force is the register\'s rule', '所行之读即簿之规之桥',
        [('a frozen institution simulation with three controls (the plan\'s TR4)', 'a frozen test of whether a language-model institution corrects only through the reading its register states, with the plan\'s controls (the plan\'s TR4)')],
        [('具三对照之冻结制度模拟（计划之 TR4）', '冻结之检验：语言模型之制度是否唯经其簿所陈之读而更正，具计划之对照（计划之 TR4）')]),
    'a-reading-kept-by-its-update': ('TR5', 'the correspondence that an agent acts as a policy from its visible history, and two bridges for a reading it states', '行者为由其可见之历而行之策略之对应，及其所陈之读之二桥',
        [('a frozen test intervening on a formation\'s observations (the plan\'s TR5)', 'a frozen test of whether a language-model agent acts as a policy from its visible history, audited on the worlds possible after each history, and of two bridges for a reading it states (the plan\'s TR5)')],
        [('干预形成之观察之冻结检验（计划之 TR5）', '冻结之检验：语言模型之行者是否为由其可见之历而行之策略，于每一历后可能之诸世审之，及其所陈之读之二桥（计划之 TR5）')]),
    'a-prediction-read-by-what-it-predicts': ('TR6', 'the bridge that a public is a response mapping counts into counts', '公众为以数映数之应之桥',
        [('a frozen test of a published forecast\'s response', 'a frozen test of whether a public responds to a published forecast by the forecast alone (the plan\'s TR6)')],
        [('公预测之应之冻结检验', '公众是否唯依所公之预测而应之冻结检验（计划之 TR6）')]),
    'when-complying-when-read-is-best': ('TR7', 'the reading that a system chooses a maximal plan of stated prospects', '系统于所述之望择一极大之策之读',
        [('a frozen test of whether complying when read follows the value and the rise in being kept (none yet)', 'a frozen test of its reading on stated prospects, the loss and ties included (the plan\'s TR7)')],
        [('读时之从是否随其值与被守之增之冻结检验（尚无）', '其读于所述之望之冻结检验，含损与平局（计划之 TR7）')]),
    'what-holding-for-a-reading-is-worth': ('TR8', 'the bridge that a system chooses as the counts rank', '系统依计之序而择之桥',
        [('a frozen test of whether holding follows the model\'s two excesses', 'a frozen test of whether holding follows the threshold, a rule\'s shortfall plus the amount forgone against each excess (the plan\'s TR8)')],
        [('持是否随模型之二余之冻结检验', '持是否随其阈之冻结检验：规则之所缺加所舍之量对每一余（计划之 TR8）')]),
}


def note(section, test, refutes_en, refutes_zh):
    return {
        'en': f'31 October 2026, board item RF, the tests\' designs (study section {section}): the next step names its test as designed, {test} in experiments/formations-that-read, which can refute at most {refutes_en}, never the law; no statement or declaration changed.',
        'zh': f'2026年10月31日，工作板条目 RF，诸检验之设计（研究第 {section} 节）：下一步所名之检验即 experiments/formations-that-read 之 {test}，至多能驳{refutes_zh}，不驳此律；无一陈述或声明改变。',
    }


def main():
    section, apply = sys.argv[1], '--apply' in sys.argv
    for rid, (test, ren, rzh, en, zh) in CHANGES.items():
        path = REC / f'{rid}.json'
        d = json.loads(path.read_text())
        nd = dict(d['next_delta'])
        for lang, pairs in (('en', en), ('zh', zh)):
            for old, new in pairs:
                if nd[lang].count(old) != 1:
                    raise SystemExit(f'{rid} {lang}: clause not found once: {old}')
                nd[lang] = nd[lang].replace(old, new)
        if len(nd['en']) > 400 or len(nd['zh']) > 180:
            raise SystemExit(f'{rid}: next_delta too long ({len(nd["en"])}/{len(nd["zh"])})')
        print(f'{rid}: en {len(d["next_delta"]["en"])} -> {len(nd["en"])}, zh {len(d["next_delta"]["zh"])} -> {len(nd["zh"])}')
        print('   ', nd['en'])
        print('   ', nd['zh'])
        h = note(section, test, ren, rzh)
        print('    note:', h['en'])
        print('    note:', h['zh'])
        if apply:
            d['next_delta'] = nd
            d['history'].append(note(section, test, ren, rzh))
            path.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print('applied' if apply else 'dry run')


if __name__ == '__main__':
    main()
