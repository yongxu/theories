#!/usr/bin/env python3
"""DF2, the lander's part (DF2-PLAN.md, "The rest"): run once from the checkout root after the records are drafted.

Statements for the two schema-1 records without one, from 01's home section (their laws wait for the schema-2
migration); each gets one DF2 history note, with DF_N for the study section filled at landing. The decision entry
D69 for the grammar's three readings (triage row 16), in both editions of the register, and 01's labels pointed to
it; 01 §2's reading says what its witness shows (sameness in belonging need not be transitive)."""
import json
from pathlib import Path

ROOT = Path.cwd()
REC = ROOT / 'theories/becoming/results/records'
DC = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation'
CH01 = ROOT / 'theories/becoming/chapters/01-ROOT.md'


def sub(p, old, new):
    t = p.read_text(encoding='utf-8')
    assert t.count(old) == 1, (p.name, old[:60], t.count(old))
    p.write_text(t.replace(old, new), encoding='utf-8')
NOTE = '27 October 2026, board item DF2 (study section DF_N): '
NOTE_ZH = '2026年10月27日，工作板条目 DF2（研究第 DF_N 节）：'


def statement(name, en, zh, note_en, note_zh):
    p = REC / f'{name}.json'
    d = json.loads(p.read_text(encoding='utf-8'))
    assert 'statement' not in d, name
    d = {**{k: d[k] for k in list(d)[:list(d).index('title') + 1]}, 'statement': {'en': en, 'zh': zh},
         **{k: d[k] for k in list(d)[list(d).index('title') + 1:]}}
    d['history'].append({'en': NOTE + note_en, 'zh': NOTE_ZH + note_zh})
    p.write_text(json.dumps(d, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')


statement('least-footprint-where-idleness-decided',
          'Where idleness is decided at every step and relatum, the least footprint touches exactly what is not idle '
          'and lies in every containing footprint; with equality of relata decided, a least footprint exists exactly '
          'where idleness is decided.',
          '每步每个关系项的闲置可判定时，最小足迹恰触及非闲置者，且在每个包含足迹之内；关系项相等可判定时，最小足迹恰在闲置可判定时存在。',
          "A statement, as 01's home section states the result (Footprinted.least_touch_iff, least_le, "
          'least_exists_iff); its laws wait for the schema-2 migration.',
          '陈述，按 01 的归属一节所述（Footprinted.least_touch_iff、least_le、least_exists_iff）；其规律待迁移到第 2 版格式。')
statement('normal-forms-need-decided-apartness',
          'With joining symmetric, two arrangements of a finite stretch are connected by commuting unjoined neighbours '
          'exactly where they order joined pairs alike; a complete invariant on the stretch exists exactly where '
          'apartness of distinct exchanges is decided, the normal form giving one.',
          '相连对称时，有限段的两个安排经相邻不相连交换互达，恰当它们对相连之对给出同样先后；段上的完整不变量恰在不同交换的不相连可判定时存在，正规形给出一个。',
          "A statement, as 01's home section states the result (rearranges_iff, complete_iff, normalForm_iff); its laws "
          'wait for the schema-2 migration.',
          '陈述，按 01 的归属一节所述（rearranges_iff、complete_iff、normalForm_iff）；其规律待迁移到第 2 版格式。')

C = '../../../../theories/becoming/chapters/01-ROOT.md'
D69 = f"""
<a id="d69-the-grammars-readings"></a>
### The grammar's readings

Where: 01 §2, §8.6 and §8.7 ([§2]({C}#class-and-continuation), [§8.6]({C}#instances), [§8.7]({C}#test-systems)); their losses are registered in the one-unfolding root's plan, §4.1 and §5.2 ([PLAN](development/one-unfolding-root/PLAN.md)). Decided in the one account of D45; registered by board item DF2, the chapter having labelled the first two with D45, the rule for every reading, and the third as new.

**Decision.** Adopted with exact scope, in three readings.
1. **The class is plural.** The 墨经's four samenesses, 重, 體, 合 and 類, are each a class once the whole, place or respect it relies on is fixed; 類同, alike in some respect, need not be transitive until its respect is fixed (`«同于不必传递»`, a witness).
2. **The fire passed on.** 「指窮於爲薪，火傳也」 reads the pattern passed on while its carrier ceases: the step ends under the carrier's class and not under the pattern's, an alteration (`Web.passing_fire`). The World model's counting, amounts, recurrence and renaming laws are not its instances; only their premises are connected.
3. **Consent and penalties.** An institution kept by its members' consent and one held by penalties, the source's pair of observationally equivalent mechanisms, are the thermostat witness read socially: in one core class of "in being or not" while the penalties stand, told apart once their removal is in the net. That is the witness's net with its occurrences renamed, not a new law.

**Reasons.** Each reading claims no more than the law or witness it names: the class law with its witness that sameness in belonging need not be transitive, the alteration law, and the thermostat witness renamed.

**What would change it.** A reading found to claim more than its law, or to conflict with another reading of the account.
"""
D69_ZH = f"""
<a id="d69-文法之读法--the-grammars-readings"></a>
### D69. 文法之读法

所在：01 §2、§8.6 与 §8.7（[§2]({C}#class-and-continuation)、[§8.6]({C}#instances)、[§8.7]({C}#test-systems)）；其所失登记于一元之根之计划 §4.1 与 §5.2（[PLAN](development/one-unfolding-root/PLAN.md)）。依 D45 之一个说明决定；由看板项目 DF2 登记，因该章把前二者标为 D45（适用于每一读法之规则），把第三者标为新。

**决定。** 依所述范围采用，分三读。一、**类是多的。** 墨经之四同，重、體、合、類，各在其所依之整体、位置或方面固定时为一类；類同，有以同，在其方面固定之前未必传递（`«同于不必传递»`，见证）。二、**火传。** 「指窮於爲薪，火傳也」读作其承载者终止而样式传下：此步在承载者之类下终止，而不在样式之类下终止，是异（`Web.passing_fire`）。世界模型之计数、量、复现与改名之律不是其实例，只有其前提相连。三、**认同与惩罚。** 由成员认同而维持之制度与由惩罚而维持之制度，即来源中观察上等价之一对机制，是恒温器之见证在社会上之读法：惩罚尚在时同在“在或不在”之一个核类中，其撤除入网后即被区分。这是该见证之网改名其出现，不是新律。

**理由。** 每一读所说不多于其所名之律或见证：类之律及其“同于之同未必传递”之见证、异之律、改名之恒温器见证。

**会改变它的。** 发现某一读所说多于其律，或与本说明之另一读法冲突。
"""
for name, text in (('DELEGATED-CHOICES.md', D69), ('DELEGATED-CHOICES.zh.md', D69_ZH)):
    p = DC / name
    s = p.read_text(encoding='utf-8')
    assert 'd69-' not in s, name
    p.write_text(s.rstrip('\n') + '\n' + text, encoding='utf-8')

sub(CH01, '**Reading** [AI reading, D45]. The class is plural.', '**Reading** [AI reading, D69]. The class is plural.')
sub(CH01, 'is not transitive until its respect is fixed (`«同于不必传递»`;', 'need not be transitive until its respect is fixed (`«同于不必传递»`, a witness;')
sub(CH01, '**Reading** [AI reading, D45]. The fire passed on reads', '**Reading** [AI reading, D69]. The fire passed on reads')
sub(CH01, '**Reading** [AI reading, new]. An institution kept by', '**Reading** [AI reading, D69]. An institution kept by')
print('DF2 rest applied')
