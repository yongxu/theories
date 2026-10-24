#!/usr/bin/env python3
"""OU6: bring the three grammar records to the corrected Lean (run from the checkout root).

Changes only the laws whose declarations OU6 renamed, redefined or added, and appends one history entry to
each record. Writes JSON with the records' own layout (indent 2, UTF-8)."""
import json
from pathlib import Path

REC = Path('theories/becoming/results/records')
NOTE = {
    'en': '25 October 2026, board item OU6 (corrections to the grammar from the review of its sources, '
          'study section {N}): {what} The claim is narrowed where a name or a reading said more than the Lean, and the '
          'new theorems are added; no other law changes.',
    'zh': '2026年10月25日，工作板条目 OU6（据对文法与其来源之审所作之更正，研究第 {N} 节）：{what}'
          '凡名或读法说过了 Lean 者，论断收窄；新定理增入；其余之律不变。',
}


def law(r, key):
    for i, l in enumerate(r['laws']):
        if any(key in d for d in l.get('declarations', [])):
            return i
    raise SystemExit(f'{r["id"]}: no law cites {key}')


LEAN = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/'


def rebind(r, renames, added, module):
    """Rename and add declarations in the record's aliases and in the declaration list of its reference to the
    module's file, keeping each list sorted, and check that every law's declaration is an alias."""
    def fix(names):
        out = [renames.get(d, d) for d in names if renames.get(d, d) is not None]
        return sorted(set(out) | set(added))
    r['aliases'] = fix(r['aliases'])
    refs = [ref for ref in r['references'] if ref['path'] == LEAN + module]
    assert len(refs) == 1, module
    refs[0]['declarations'] = fix(refs[0]['declarations'])
    for ref in r['references']:
        if ref is not refs[0] and 'declarations' in ref:
            assert not set(ref['declarations']) & set(renames), ref['path']
    cited = {d for l in r['laws'] for d in l.get('declarations', [])}
    assert cited <= set(r['aliases']), cited - set(r['aliases'])
    gone = {k for k in renames}
    assert not gone & set(r['aliases']), gone & set(r['aliases'])


def scope(r, en_old, en_new, zh_old, zh_new):
    """Bring the validation scope to the passing receipt's counts and say how the corrections were reviewed."""
    v = r['validation_scope']
    assert v['en'].count(en_old) == 1 and v['zh'].count(zh_old) == 1, r['id']
    v['en'] = v['en'].replace(en_old, en_new).rstrip() + ' The OU6 corrections were reviewed against the Lean by GPT astra and Opus reviewers.'
    v['zh'] = v['zh'].replace(zh_old, zh_new).rstrip() + 'OU6 之更正经 GPT astra 与 Opus 审查者对照 Lean 审查。'


def write(rid, r):
    (REC / f'{rid}.json').write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def main(n):
    # continuation relative to a class
    rid = 'continuation-relative-to-a-class'
    r = json.loads((REC / f'{rid}.json').read_text(encoding='utf-8'))
    i = law(r, '«位同则四相同»')
    r['laws'][i]['declarations'] = ['Becoming.«位同则生亡同»' if d == 'Becoming.«位同则四相同»' else d for d in r['laws'][i]['declarations']]
    i = law(r, '«火因于薪»')
    r['laws'][i]['en'] = ('Holding, mutual need and leaning-on through constancy apply only to lines that do not end; through '
                          'the core they apply to all: a class suffices for another\'s regularity where what is alike under '
                          'both is alike under the other\'s core. The constancy forms imply the core forms, mutual need '
                          'through constancy is symmetric and nothing needs itself, a class is constant exactly where it lies in its core, and the '
                          'core is monotone in the class. In the flame of three moments and its ash, "flame or not" and "the same '
                          'fuel left" need each other through the core, and every class that with "flame or not" tells its '
                          'four occurrences apart '
                          'suffices for its regularity, so the witness singles out neither fuel nor a direction; in two flames '
                          'side by side the fuel left suffices for the regularity of "flame or not" while the joint class relates two '
                          'distinct occurrences (the two flames at one moment), and sameness of flame does not suffice.')
    r['laws'][i]['zh'] = ('以有常言之自持、相须、因于，只适用于不终了之线；以核言之，则适用于一切：两类俱同者在其一之核下亦同，'
                          '则另一类足以定此类之理。以有常者蕴涵以核者；相须对称，无物自相须；一个类恰在含于其核时有常；核随类单调。'
                          '三刻之火及其灰中，“火与否”与“余薪同”以核相须，凡与“火与否”合而能分开此四事之类皆足以定火之理，故此见证既不挑出薪，'
                          '也不定方向；两火并燃之中，余薪同足以定“火与否”之理，而二类之合关联两个不同之事（同刻之两火）；同火则不足。')
    r['laws'][i]['declarations'] = [d for d in r['laws'][i]['declarations'] if d != 'Becoming.«火因于薪»'] + [
        'Becoming.TwoFlames', 'Becoming.TwoFlames.step', 'Becoming.TwoFlames.alike', 'Becoming.TwoFlames.sameFuel',
        'Becoming.TwoFlames.sameFlame', 'Becoming.«火薪相须»', 'Becoming.«火之见证不择类»', 'Becoming.«两火以薪定理»',
        'Becoming.«两火同火不足以定理»']
    i = law(r, '«生生不息»')
    r['laws'][i] = {
        'en': 'Renewing into: an occurrence conditions a beginning whose line reaches another. Ceasing, defined positively '
              'and inductively along renewing into: an occurrence ceases where everything it renews into ceases, the least '
              'property so closed. Renewal without end, the greatest family each member of which renews into a member, '
              'does not cease (生生不息). Ceasing concerns what an occurrence renews into, not its line: one that does not '
              'itself renew ceases, so one on whose line nothing renews ceases; under the one everything ceases.',
        'zh': '复生至：一事为一始之缘，而此始之线达于另一事。息，正面而沿复生至以归纳定义：一事所复生至者皆息，则此事息；息是如此封闭之'
              '最小之性。生生是每一员皆复生至族中一员之最大之族，在此族中者不息（生生不息）。息所论是一事所复生至者，不是其线：自身不复生之事息，故其线上无物复生之事息；在“一”之下皆息。',
        'declarations': ['Becoming.«复生至»', 'Becoming.«息»', 'Becoming.«生生不息»', 'Becoming.«自不复生则息»',
                         'Becoming.«不复生则息»',
                         'Becoming.«一之下皆息»']}
    r['history'].append({k: v.format(N=n, what=(
        'the theorem on the two-way core renamed «位同则生亡同», since it shows only that beginning and ending carry over; '
        'the flame witness restated as mutual need through the core («火薪相须»), with the theorem that it picks no class '
        'and a two-flame model in which the fuel left is singled out against sameness of flame; ceasing defined '
        'positively, inductively, on renewing into («复生至»): what does not itself renew ceases («自不复生则息»), and the '
        'old reading implies the new («不复生则息»); the law on ending under a coarser class narrowed to what its theorem '
        'shows (not ending), and the law on the two-way core stated for a class, with abiding carried over too '
        '(«位同则住同»).' if k == 'en' else
        '双向之核之定理改名为 «位同则生亡同»，因其只示生与亡相传；火之见证改述为以核相须（«火薪相须»），并证此见证不择类，'
        '又立两火之模型，其中余薪同相对于同火而被挑出；息改为正面、以归纳在复生至上定义（«复生至»）：自身不复生者息（«自不复生则息»），'
        '旧读蕴含之（«不复生则息»）；粗类下之亡一律收窄为其定理所示（不亡），双向之核一律对一个类而说，住亦相传（«位同则住同»）。')) for k, v in NOTE.items()})
    i = law(r, '«亡于细者不必亡于粗»')
    for k, a, b in [('en', 'something can end under the finer class while it abides under the coarser.',
                     'something can end under the finer class and not end under the coarser.'),
                    ('zh', '可有一事在细类下亡而在粗类下住。', '可有一事在细类下亡而在粗类下不亡。')]:
        assert r['laws'][i][k].count(a) == 1, a
        r['laws'][i][k] = r['laws'][i][k].replace(a, b)
    i = law(r, '«位同则生亡同»')
    for k, a, b in [('en', 'Read both ways, constant under 缘 and under its converse, the core fixes positions: what shares it '
                           'shares beginning and ending.',
                     'Read both ways, constant under 缘 and under its converse, the core carries beginning, abiding and '
                     'ending: for a class, what the two-way core relates shares beginning, abiding and ending (altering, a '
                     'relation between two occurrences with a finer class, is not a mark of one occurrence).'),
                    ('zh', '双向读之（对缘及其逆皆有常），核定位：同位者，生与亡皆同。',
                     '双向读之（对缘及其逆皆有常），对一个类，双向之核所关联者生同、住同、亡同（异是两事之间带较细之类之关系，不是一事之相）。')]:
        assert r['laws'][i][k].count(a) == 1, a
        r['laws'][i][k] = r['laws'][i][k].replace(a, b)
    r['laws'][i]['declarations'].append('Becoming.«位同则住同»')
    scope(r, 'Becoming.Grammar, 64 theorems in 106 declarations', 'Becoming.Grammar, 68 theorems in 116 declarations',
          'Becoming.Grammar，106 个声明中 64 条定理', 'Becoming.Grammar，116 个声明中 68 条定理')
    rebind(r, {'Becoming.«位同则四相同»': 'Becoming.«位同则生亡同»', 'Becoming.«火因于薪»': None},
           ['Becoming.TwoFlames', 'Becoming.TwoFlames.step', 'Becoming.TwoFlames.alike', 'Becoming.TwoFlames.sameFuel',
            'Becoming.TwoFlames.sameFlame', 'Becoming.«位同则住同»', 'Becoming.«自不复生则息»', 'Becoming.«火薪相须»', 'Becoming.«火之见证不择类»', 'Becoming.«两火以薪定理»', 'Becoming.«两火同火不足以定理»',
            'Becoming.«复生至»', 'Becoming.«不复生则息»'], 'Grammar.lean')
    write(rid, r)

    # classical definitions in the grammar
    rid = 'classical-definitions-in-the-grammar'
    r = json.loads((REC / f'{rid}.json').read_text(encoding='utf-8'))
    i = law(r, '«同于为类»')
    r['laws'][i]['en'] = r['laws'][i]['en'].replace('it is a class exactly where each belongs to one and one only',
                                                    'it is a class where each belongs to one and one only (shown sufficient; necessity is not shown)')
    assert '恰在各属唯一时为类' in r['laws'][i]['zh']
    r['laws'][i]['zh'] = r['laws'][i]['zh'].replace('恰在各属唯一时为类', '在各属唯一时为类（只证其为充分，未证必要）')
    i = law(r, '«有常则通»')
    r['laws'][i]['en'] = ('复, read from the 老子 (「復命曰常」), is a line returning to where it was; what returns abides. 通, '
                          'read from the 系辞 (「往來不窮謂之通」) with 往來 read as a relation and its converse, is going and '
                          'coming without end: the line from an occurrence never ends along 缘, nor along its converse. Under a '
                          'constant class a line with a past never ends going; an occurrence that abides passes through where '
                          'the class is constant both ways; constancy one way is not enough (counting up from zero); under the '
                          'one, day and night go and come without end.')
    r['laws'][i]['zh'] = ('老子之复（「復命曰常」）是线之返其所始；复者住。系辞之通（「往來不窮謂之通」），'
                          '以往来为一关系与其逆：往与来皆不穷，即自一事起之线沿缘不终，沿其逆亦不终。有常之类下，有前之线往而不穷；'
                          '类于缘与其逆两向皆有常时，住者通；一向有常不足（自零计数）；在“一”之下，昼夜往来不穷。')
    r['laws'][i]['declarations'] = [d for d in r['laws'][i]['declarations'] if d != 'Becoming.«有常则通»'] + [
        'Becoming.«有常则往不穷»', 'Becoming.«两向有常则通»', 'Becoming.«有常而不通»', 'Becoming.«昼夜往来不穷»']
    r['history'].append({k: v.format(N=n, what=(
        '通 defined with its 往來, going along 缘 and coming along its converse, so that constancy one way no longer '
        'gives it («有常则通» renamed «有常则往不穷», for what it shows); the statement and the sentence on 同 narrowed to '
        'the sufficiency the theorem shows.' if k == 'en' else
        '通依其往来而定义，往沿缘、来沿其逆，故一向有常不再得通（«有常则通» 依其所示改名为 «有常则往不穷»）；陈述与同之一句收窄为定理所示之充分。')) for k, v in NOTE.items()})
    for k, a, b in [('en', '同 is a class only where belonging is single',
                     '同 is a class where each belongs to one and one only (shown sufficient; necessity is not shown)'),
                    ('zh', '同只在所属唯一时为类', '同在各属唯一时为类（只证其为充分）')]:
        assert r['statement'][k].count(a) == 1, a
        r['statement'][k] = r['statement'][k].replace(a, b)
    scope(r, 'Becoming.GrammarReadings, 9 theorems in 14 declarations', 'Becoming.GrammarReadings, 12 theorems in 17 declarations',
          'Becoming.GrammarReadings，14 个声明中 9 条定理', 'Becoming.GrammarReadings，17 个声明中 12 条定理')
    rebind(r, {'Becoming.«有常则通»': 'Becoming.«有常则往不穷»'},
           ['Becoming.«两向有常则通»', 'Becoming.«有常而不通»', 'Becoming.«昼夜往来不穷»'], 'GrammarReadings.lean')
    write(rid, r)

    # generation and degeneration at two grains
    rid = 'generation-and-degeneration-at-two-grains'
    r = json.loads((REC / f'{rid}.json').read_text(encoding='utf-8'))
    i = law(r, '«全生有终之定当且仅当排中»')
    r['laws'][i]['en'] = ('The strong forms read the whole coarse line: 全生成 (the line never ends, and from every point it '
                          'reaches a carrying renewal lies ahead), 全守 (it never ends, and from some point no carrying renewal '
                          'lies ahead, renewals before that point allowed) and 有终 (some point it reaches ends, which is not '
                          'degeneration) exclude each other and, with excluded middle, cover every point; coverage by the '
                          'some-branch regions is not proved. Placing every point of every model in one of the strong forms is '
                          'exactly excluded middle, and so is telling a line that never ends from one that ends; 全生成 holds '
                          'along its line and an end reaches back along it.')
    r['laws'][i]['zh'] = ('强形读整条粗线：全生成（线不穷，且自其所及之每一点，前有传）、全守（不穷，且自某点起前无传，此前之传不论）'
                          '与有终（其所及之某点终，此非退化）彼此排斥，以排中律则覆盖每一点；某支诸域之覆盖未证。把每一模型之每一点'
                          '都置于强形之一，恰是排中律；分开不穷之线与有终之线，亦恰是排中律；全生成沿其线而存，有终沿其线而回溯。')
    r['laws'][i]['declarations'] = ['Becoming.«不穷有终之定当且仅当排中»' if d == 'Becoming.«全生有终之定当且仅当排中»' else d
                                    for d in r['laws'][i]['declarations']] + ['Becoming.«全三域之定当且仅当排中»']
    i = law(r, '«阶全生成»')
    r['laws'][i]['en'] = r['laws'][i]['en'].replace('A chain of classes reads generation at every order',
                                                    'A sequence of classes, no order between them assumed, reads generation at every order')
    assert '一串类在每一阶读生成' in r['laws'][i]['zh']
    r['laws'][i]['zh'] = r['laws'][i]['zh'].replace('一串类在每一阶读生成', '一串类（不设其间之序）在每一阶读生成')
    r['laws'].append({
        'en': 'Read along renewing into under the one, renewal without end is going on along some branch, and ceasing is '
              'ending on every branch.',
        'zh': '在“一”之下沿复生至而读，生生即某一支上之延，息即诸支皆尽。',
        'declarations': ['Becoming.«生生即延»', 'Becoming.«息即尽»']})
    r['history'].append({k: v.format(N=n, what=(
        'the excluded-middle theorem renamed «不穷有终之定当且仅当排中», since it is about a line that never ends against '
        'one that ends, and the theorem for the three regions added («全三域之定当且仅当排中»); the higher orders said '
        'to assume no order between the classes; renewal without end and ceasing joined to 延 and 尽; the every-branch '
        'forms restated as strong forms with their quantifiers, as DEFECTS-FOUND asked from chapter 02.' if k == 'en' else
        '排中之定理改名为 «不穷有终之定当且仅当排中»，因其所论是不穷之线与有终之线；增三域之定理（«全三域之定当且仅当排中»）；'
        '阶之诸类不设其间之序；生生与息接于延与尽；诸支皆然之形依缺陷录（第二章）改述为强形，并写出其量词。')) for k, v in NOTE.items()})
    scope(r, 'Becoming.GrammarMap, 36 theorems in 55 declarations', 'Becoming.GrammarMap, 39 theorems in 58 declarations',
          'Becoming.GrammarMap，55 个声明中 36 条定理', 'Becoming.GrammarMap，58 个声明中 39 条定理')
    rebind(r, {'Becoming.«全生有终之定当且仅当排中»': 'Becoming.«不穷有终之定当且仅当排中»'},
           ['Becoming.«全三域之定当且仅当排中»', 'Becoming.«生生即延»', 'Becoming.«息即尽»'], 'GrammarMap.lean')
    write(rid, r)
    print('records updated')


if __name__ == '__main__':
    import sys
    main(sys.argv[1])
