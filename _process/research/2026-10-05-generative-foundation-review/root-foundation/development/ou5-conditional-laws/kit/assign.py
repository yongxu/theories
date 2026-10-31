"""OU5 part A: the 219 units classed 丙一, each assigned to the group whose law it states.

usage: python3 -B assign.py DATA_DIR   (reads DATA_DIR/units.tsv, writes DATA_DIR/groups.tsv)

Which unit states which law is an AI reconstruction; the classical text decides nothing, and Lean
checks only the derivation. Dispositions: law (the unit states the group's law or a case of it),
premise (it states the premise Z the law takes, or a premise of its model), 丁 (its Z or Y is an
evaluation: back to 丁), NE (not expressible in the grammar), 甲 (it states a definition).
"""
import csv, sys
from pathlib import Path

D = Path(sys.argv[1])
units = list(csv.DictReader((D / 'units.tsv').open(encoding='utf-8'), delimiter='\t'))
A = {}

def put(group, disp, ids, note):
    for i in ids.split():
        assert i not in A, i
        A[i] = (group, disp, note)

# Change along a line
put('G01', 'law', 'XCX-02-008', '窮 as ending under a class, 變 as alteration («异»), 通 as «通», 久 as «不穷»')
put('G01', 'law', 'XCS-04-004', '韩注 聚極則散: the gathering ends under its class and goes on altered (遊魂為變)')
put('G02', 'law', 'XCS-02-002 XCX-01-003', '剛柔相推: each step passes from one phase to the other; 變化 the alteration at each step')
put('G02', 'law', 'XCX-04-004 XCX-04-005', '日往則月來…: each step leaves the phase class; 明生, 歲成 as 全生成 of the coarse pattern')
put('G02', 'law', 'XCS-06-004 XCS-06-005', '靜 and 動 in turn read as 相推; 專直翕闢, qualities of the motion, not read')
put('G03', 'law', 'LZ-30-008 LZ-55-009', '壯 as a rise that does not return (不道, after 40章 反者道之動); 早已 as ending within its room')
put('G03', 'law', 'LZ-23-002', '王弼 暴疾美興不長: wind and rain as a rise that does not return, ending within its room')
put('G04', 'law', 'LZ-16-003', '復歸其根 as every line returning to its start («复»); 芸芸 as every occurrence')
put('G05', 'law', 'XCS-12-012', '乾坤 as the two classes of one distinction, 易 as alteration under it')
put('G06', 'law', 'XCS-10-006', '感 as a predecessor reaching it under the class; 遂通 as «通»; 寂然不動 as no step of its own')
put('G07', 'law', 'XCS-01-003', '韩注 動止得其常體則剛柔之分著: a constant class lies within its core')
# Conditions and dependence
put('G08', 'premise', 'JSZ-C-015 JSZ-C-016 JSZ-C-005', 'necessity: what occurs has a condition (無緣不起)')
put('G08', 'premise', 'ZL-07-127', 'necessity; an unarisen 法 is no occurrence of the net, so its meeting conditions has no reading')
put('G08', 'premise', 'JSZ-P-01-003 JSZ-C-069 JSZ-C-044 ZL-07-133 ZL-07-170', 'production: with its conditions the occurrence follows')
put('G08', 'premise', 'QXL-JS-212 QXL-JS-214', 'two kinds of condition (因, 緣), both needed; 214 read only for the ending of a line (斷煩惱)')
put('G08', 'premise', 'XCX-04-050 XCX-04-051', 'production from two joined conditions; 化醇, 化生 read only as arising')
put('G09', 'law', 'QXL-JS-119 QXL-JS-085 QXL-JS-082 QXL-JS-281 QXL-JS-293 QXL-JS-304 QXL-JS-166 QXL-JS-078 QXL-JS-414',
    '離 X 則無 Y: no condition of the kind, no result; the dependence the text states elsewhere is Z')
put('G09', 'law', 'QXL-JS-123 QXL-JS-159 QXL-JS-197 ZL-24-041', 'a chain of dependences («依之传»); 心生則法生 (123) is a production premise')
put('G09', 'law', 'ZL-17-040 ZL-17-042 ZL-17-045', '離種無相續: no first condition, no line from it (opponent\'s view in 中论 17)')
put('G09', 'law', 'LZ-39-002 CWS-P3-002 CWS-P3-003 CWS-P3-008', 'without the condition the occurrence does not come (or a line never ends); 立種姓 definitional')
put('G09', 'premise', 'QXL-JS-074 QXL-JS-081 QXL-JS-084 QXL-JS-086 QXL-JS-100 QXL-JS-122 QXL-JS-156 QXL-JS-175 QXL-JS-176 QXL-JS-180',
    '依 X 故有 Y: the dependence itself, the Z of «依则离无»')
put('G09', 'premise', 'ZL-17-013 ZL-17-049 ZL-10-009 LZ-39-001 CWS-P3-004', 'a dependence or production stated as the model\'s premise')
put('G10', 'law', 'QXL-JS-178 QXL-JS-179 QXL-JS-195', '熏習 loops: conditions of each other, so co-present (俱有)')
put('G10', 'law', 'CWS-P3-074 CWS-P3-077', '能熏所熏 俱生俱滅 as co-presence of mutual conditions')
put('G10', 'law', 'ZL-01-065', '穀作芽、芽作穀: mutual conditions are one cluster (中论 reductio)')
put('G11', 'law', 'CWS-P6+P7+P8-019 CWS-P6+P7+P8-020', '三法無間轉: the joint class constant, so the joint line never ends; 不爾 the countermodel')
put('G11', 'law', 'CWS-P6+P7+P8-049 CWS-P6+P7+P8-043', '壽煖識不相離: where the holding withdraws, the mate ends (冷觸)')
put('G11', 'law', 'ZL-10-043', '火、可燃 as needing each other (opponent\'s view, 中论 10); «火薪相须»')
# Continuation across classes
put('G12', 'law', 'QXL-JS-058 QXL-JS-167', 'the defiled line (fine class) ends with its condition; 智性, 心體 (coarse) goes on')
put('G12', 'law', 'ZL-02-091', '去法滅故有住: going ends under the class of going, the goer abides under its coarser class')
put('G13', 'law', 'ZL-21-115 ZL-21-120 ZL-17-101', '生滅故不常，相續故不斷: begins and ends under identity, abides under the one')
put('G13', 'law', 'ZL-21-113', 'the two 邊 are the two failures of Z: own condition (常), no result (斷)')
put('G13', 'law', 'ZL-21-031', '成中常有壞則無住: what ends under a class does not abide under it («住亡不并»)')
put('G13', 'law', 'CWS-P1-031 CWS-P9-016 CWS-P1-007', '似我、似常一: abiding under a coarse class (一類相續) taken for identity')
put('G13', 'law', 'ZL-01-079 ZL-01-086', '來、出 as continuation under identity, which needs self-conditioning («非一非异»)')
put('G13', 'law', 'ZL-02-010', '去時, neither gone nor not yet: the abiding place between, on a line of going')
put('G13', 'law', 'ZL-01-047', '若滅今不應有穀: what ends under a class starts no line under it («断则无相续»)')
put('G14', 'law', 'CWS-P4-019 CWS-P5-017 CWS-P5-021 CWS-P5-022', '瀑流: the stream\'s class constant, the stream never breaks; waves are alterations on it')
put('G14', 'law', 'CWS-P1-024 CWS-P1-018 CWS-P6+P7+P8-003 CWS-P6+P7+P8-015 CWS-P6+P7+P8-048', '一類相續、無間無轉: a constant class, a line that never breaks')
put('G14', 'law', 'CWS-P1-030', 'split: 身心相續 輪迴 read here; 厭患苦故求趣涅槃 is an evaluation (丁)')
put('G14', 'law', 'QXL-JS-168 QXL-JS-241', '熏習 keeps the arising unbroken: a constant class')
put('G14', 'law', 'LZ-33-005', '不失其所 as staying within a constant class of positions; 久 as «不穷»')
put('G14', 'law', 'ZL-17-076 ZL-17-086', '不失法 as a class constant under 缘 carrying the deed (opponent\'s view, 中论 17)')
put('G15', 'law', 'QXL-JS-326', '無後際 transfers to what lies in one core class with it (相應)')
put('G15', 'law', 'QXL-JS-324', '無前際 transfers only along the two-way core, not along dependence or the one-way core')
put('G15', 'law', 'QXL-JS-238 CWS-P4-062', 'a line without beginning that ends (無始而有斷; 阿羅漢位方究竟捨)')
put('G15', 'law', 'ZL-02-070 LZ-63-004', 'a first beginning where going back always ends (初發; 必作於細)')
put('G16', 'law', 'ZL-07-235 ZL-21-022 ZL-21-058 ZL-21-069', '自相、離壞有成、無成無壞、性不空: own condition, so abiding under every class')
put('G16', 'law', 'ZL-07-162 ZL-07-163', '縷自有定相不應從麻出: «缕之无定性» read back, premise 不自缘')
put('G16', 'law', 'ZL-24-185 JSZ-C-067 ZL-17-162', 'conditioned and not its own condition, so no own position')
put('G16', 'law', 'JSZ-C-064', '生與無生互成互奪: one occurrence begins under one class and not another («定性之判»)')
put('G16', 'law', 'ZL-01-099 ZL-17-051 ZL-01-040', 'the two horns: no condition, so beginning under every class (斷); own condition, so 常')
put('G16', 'law', 'LZ-07-002', 'false under the reading 不自生 = not its own condition (countermodel); 王弼 自生 = 與物爭 is social')
# Marks and classes
put('G17', 'law', 'JSZ-P-07-007 JSZ-P-07-008 JSZ-P-07-009', '看 as the class taken: what it tells apart shows, what holds everywhere under it hides')
put('G17', 'law', 'JSZ-P-07-014 JSZ-P-07-015 JSZ-P-07-016 JSZ-P-07-032', 'under one class all is one kind (純); under several each is pure and mixed')
put('G17', 'law', 'QXL-JS-012 QXL-JS-406 QXL-JS-313 QXL-JS-252', '差別、分齊 are relative to a class taken; under the one nothing is told apart')
put('G17', 'law', 'LZ-28-006', '樸散則為器: under a class finer than the one, things are told apart')
put('G18', 'law', 'QXL-JS-256 QXL-JS-260', 'a mark gives its complement a mark; to know a mark is to have its non')
put('G18', 'law', 'QXL-JS-028', '離妄心實無可空: where nothing falls outside, no mark («离非无相»)')
put('G18', 'law', 'LZ-01-001', '可道非常道: what has a mark does not hold everywhere («遍而无相» read back)')
put('G19', 'law', 'ZL-19-002 ZL-19-003 ZL-19-004', 'past and future as the two ends of one reach: together globally, not pointwise')
# Knowing and measuring
put('G20', 'premise', 'XZ-ZM-034', '同類同情者意物也同: the class is constant under perceiving (有常), a premise of the model')
put('G20', 'premise', 'XZ-ZM-016', '名定而實辨: a naming class constant across speakers, read with 034')
put('G21', 'law', 'XZ-ZM-043 XZ-ZM-044', '征知 needs the coupling to separate the class: separated at a stage, not in the core')
put('G22', 'law', 'XZ-ZM-164 XZ-ZM-165', '衡正 as a map keeping "heavier than" within "hangs lower than" («保之像»)')
put('G23', 'law', 'ZZ-YSZ-016', '无厚入有間: a point within what has two parts does not fill it («尺与端或尽或不尽»)')
put('G24', 'law', 'LZ-36-001 LZ-36-002 LZ-36-003 LZ-36-004', 'read as G03\'s converse (every end preceded by a rise): false; as a strategy, not expressible')
# Definitions
put('—', '甲', 'CWS-P2-006 CWS-P3-078', 'the definition of continuation: 等流, 自類相生 = continuation under the class of one\'s kind (01 §2)')
put('—', '甲', 'CWS-P3-039 CWS-P3-040', 'defines two kinds of condition (因緣 as producing directly, 增上緣 as contributing): two relations, given apart')
put('—', '甲', 'CWS-P5-006', 'defines 攝藏 by holding the seeds')
# Evaluations
put('—', '丁', 'LZ-18-001 LZ-18-002 LZ-18-003 LZ-18-004', 'names virtues and counterfeits; the claim values a social order (decline). The marking reading («知相则有其非») loses it')
put('—', '丁', 'LZ-11-004', '利 and 用: what serves, valued')
put('—', '丁', 'LZ-22-001', '王弼 reads each pair as the sage not displaying himself; 得, 惑 conclude with valuations')
put('—', '丁', 'LZ-38-006', 'a ranking of 道 德 仁 義 禮 by loss')
put('—', '丁', 'XZ-ZM-144 XZ-ZM-152', '可 as approval: acting follows what is approved')
put('—', '丁', 'XZ-ZM-179 XZ-ZM-180 XZ-ZM-181 XZ-ZM-182', '重物、輕理、危、憂恐: valuing and danger')
put('—', '丁', 'XZ-ZM-191 XZ-ZM-192', '養: what nourishes, valued')
put('—', '丁', 'QXL-JS-079 QXL-JS-181', 'Y is 苦 (suffering, valenced); the dependence 果不離因 is G09\'s')
put('—', '丁', 'QXL-JS-194 QXL-JS-206 QXL-JS-215 QXL-JS-216', 'Y is an attitude: 厭生死苦, 樂求涅槃, 信, 善根')
put('—', '丁', 'QXL-JS-217', 'Z is 修善根 (wholesome, valued)')
put('—', '丁', 'QXL-JS-258 QXL-JS-259', '非常樂我淨, 淨功德: valued qualities')
put('—', '丁', 'ZL-17-002 ZL-17-024 ZL-17-026 ZL-17-028 ZL-17-056', '惡、福、罪、名利、貴處: merit and demerit (opponent\'s view, 中论 17)')
put('—', '丁', 'ZL-17-090', '隨重而受報: deeds ordered by gravity')
put('—', '丁', 'ZL-17-135', '好醜貴賤 果報; 愛能潤生 alone would be a dependence (G09)')
put('—', '丁', 'CWS-P2-007', '異熟 from valenced deeds only (有漏善惡): the valuation is what the law turns on')
# Not expressible
put('—', 'NE', 'LZ-05-004 LZ-15-004 LZ-15-005', 'qualities and rates (虛, 濁清, 徐) the grammar has no terms for')
put('—', 'NE', 'LZ-30-003 LZ-32-003', 'armies, land, rain, people: specific kinds; 自均 an amount')
put('—', 'NE', 'LZ-36-006 LZ-43-001 LZ-45-006 LZ-76-004 LZ-78-001 LZ-78-002', '勝 relates qualities of bodies (柔剛, 躁寒) or opposed parties; read as a contest, its Y ranks outcomes')
put('—', 'NE', 'LZ-75-001 LZ-75-002 LZ-75-003', 'social mechanisms between ruler and people')
put('—', 'NE', 'LZ-76-001 LZ-76-002 LZ-76-003', 'qualities of bodies (柔脆, 枯槁, 堅強); read as "what goes on has a next step" it is a definition and loses the text')
put('—', 'NE', 'LZ-77-004 LZ-77-005', 'amounts (有餘, 不足): laws of the World model with natural-number amounts, not of the grammar')
put('—', 'NE', 'XCX-05-004', '陰陽合德、剛柔有體: no relational reading the commentary fixes')
put('—', 'NE', 'XZ-ZM-026', 'a ruler\'s naming practice')
put('—', 'NE', 'XZ-ZM-143', 'desire and belief moving to seeking: an agent\'s psychology')
put('—', 'NE', 'XZ-ZM-183', 'affect and perception (憂恐, 不知其味)')
put('—', 'NE', 'QXL-JS-048', 'an attainment of a knower (得無念 → 知四相)')
put('—', 'NE', 'QXL-JS-196', 'the effect of long practice (久遠熏習力): amounts of time and repetition')
put('—', 'NE', 'ZL-17-077', 'a dialectical consequence (破業之過) inside the opponent\'s system')
put('—', 'NE', 'CWS-P6+P7+P8-072', 'nourishment and growth (段食、增長): amounts')
put('—', 'NE', 'CWS-P6+P7+P8-073', '偏勝: a comparison of degree')

missing = [u['id'] for u in units if u['id'] not in A]
extra = [i for i in A if i not in {u['id'] for u in units}]
assert not missing and not extra, (missing, extra)
with (D / 'groups.tsv').open('w', encoding='utf-8', newline='') as f:
    w = csv.writer(f, delimiter='\t', lineterminator='\n')
    w.writerow(['id', 'source', 'confidence', 'group', 'disposition', 'reading'])
    for u in units:
        g, d, n = A[u['id']]
        w.writerow([u['id'], u['source'], u['confidence'], g, d, n])
from collections import Counter
print(len(units), Counter(v[1] for v in A.values()))
print(sorted(Counter(v[0] for v in A.values()).items()))
