"""OU5 part A: the 219 units classed 丙一, each placed in the family of laws it states.

usage: python3 -B assign.py DATA_DIR   (reads DATA_DIR/units.tsv, writes DATA_DIR/groups.tsv)

Which unit states which law is an AI reconstruction, and every reading says so; the classical text
decides nothing, and Lean checks only the derivation. A family is the laws read from one corpus
statement (G01 to G24; G12 and G24 were dissolved by the design's review).

Dispositions:
  law      the unit states a law of its family, or a case of it, and the law holds;
  false    the unit states a law that is false as read, with a countermodel;
  premise  it states the Z a law takes, or a premise of the model;
  丁       its Z or Y asserts, presupposes or turns on a valuation: back to 丁;
  NE       not expressible in the grammar, with the reason;
  甲       it states a definition.

Rules, one for every unit:
  1. A unit is read under its commentary where it has one; a structural reading against the
     commentary is noted, not placed.
  2. A unit whose clauses read apart is placed by its structural clause; its other clauses
     (丁, NE, 甲) are noted in its reading.
  3. A clause whose law turns on a valuation is 丁 (吉凶, 利害, 善惡 as moral kinds, 福罪, 苦 and 樂 as
     valenced, 勝 between parties, 養, 可 as approval, 好醜貴賤, aversion and seeking). A valuation
     word naming a kind the law does not turn on (善知識, 非善染) is noted. Attainments (斷煩惱, 涅槃)
     are read as states, a line's ending; 染 and 淨 as a mark and its complement.
  4. Not expressible: production and sufficiency (an occurrence not yet there: the grammar's 缘 is
     a necessary relation between places of the net, which has no predicate of presence),
     所緣緣 (the object of a cognition, which the plan leaves out of 缘), qualities and magnitudes
     of bodies, agents' acts, offices and practices, affects, and doctrinal terms with no relation.
  5. A Z that is the presence or absence of a condition (離 X, 依 X) places a unit in G09; a Z that
     is the class taken (看, 由心迴轉) places it in G17.
"""
import csv, sys
from pathlib import Path

D = Path(sys.argv[1])
units = list(csv.DictReader((D / 'units.tsv').open(encoding='utf-8'), delimiter='\t'))
A = {}

def put(group, disp, ids, note):
    for i in ids.split():
        assert i not in A, i
        A[i] = (group, disp, '[AI reading] ' + note)

# Change along a line
put('G01', 'law', 'XCX-02-008', '窮 as ending under a class; 變 as the step a second class continues and the first parts '
    '(«亡而续于他类则异», one unfolding of the definitions); 通 as «通», 久 as its «不穷» half (by definition). On 變 as one '
    'alteration, 變 does not enter 通; on the text\'s own 一闔一闢 (XCS-11-009), 通 is 變 at every place, both ways')
put('G01', 'law', 'XCS-04-004', '聚極則散 (韩, cited in the classifier\'s note): the gathering ends under its class and goes on '
    'altered (遊魂為變): 窮則變')
put('G02', 'law', 'XCS-02-002 XCX-01-003', '剛柔相推: each step passes from one phase to the other; 變 (化) is the alteration '
    'at each such step, by definition')
put('G02', 'law', 'XCX-04-004 XCX-04-005', '日往則月來…: each step leaves the phase class and everything goes on; 明生, 歲成 as '
    '全生成 of the coarse pattern (sufficient, not necessary)')
put('G03', 'law', 'LZ-30-008 LZ-55-009', '壯 as a rise whose line does not come back to a place (不道, after 40章 反者道之動); '
    '早已 as that line not going on for ever in bounded room (no end is exhibited); 王弼\'s 暴 (intensity) not read')
put('G04', 'law', 'LZ-16-003', '復歸其根 as a line in bounded room, merging nothing at its places, coming back to its start: '
    '«及» R x x, not «复» under a class; 芸芸 as every occurrence')
put('G05', 'law', 'XCS-12-012', '乾坤 as the two classes of one distinction; 毀 as the distinction becoming the one, under which '
    'no step is parted (無以見易); 易不可見 as the distinction parting no continuation\'s ends; 息 read so, not as the grammar\'s «息»')
put('G06', 'law', 'XCS-10-006', '感 as a predecessor reaching it under the class; 遂通 as «通»; 寂然不動 as no predecessor')
put('G07', 'law', 'XCS-01-003', '動靜有常 as the class constant; 剛柔斷 as the class lying within its core; the corpus gives no '
    'commentary for this unit')
# Conditions and dependence
put('G08', 'premise', 'JSZ-C-015 JSZ-C-016 JSZ-C-005', 'necessity: what occurs has a condition (無緣不起), a premise of the model')
put('—', 'NE', 'ZL-07-127', 'an unarisen 法 meeting its conditions: an occurrence not yet there is no place of the net (the net of '
    'the possible, plan §4.1, is not built)')
put('—', 'NE', 'JSZ-P-01-003 JSZ-C-069 ZL-07-133 ZL-07-170', 'production: with its conditions the occurrence arises; sufficiency '
    'speaks of an occurrence not yet there, and the grammar has no predicate of presence')
put('—', 'NE', 'XCX-04-050 XCX-04-051', 'production from two joined conditions (化醇, 化生): sufficiency, as production')
put('—', 'NE', 'QXL-JS-212', 'joint sufficiency of 因 and 緣 (具足乃得成辦): production; its necessity half is G08\'s premise for two relations')
put('—', 'NE', 'JSZ-C-044', '法與自心為緣: 法 as the object of mind, the 所緣 sense the plan leaves out of 缘 (PLAN.md §4.1)')
put('—', 'NE', 'QXL-JS-086', '境界緣: the object as condition (所緣緣), the sense the plan leaves out of 缘 (PLAN.md §4.1)')
put('G09', 'law', 'QXL-JS-119 QXL-JS-085 QXL-JS-082 QXL-JS-281 QXL-JS-293 QXL-JS-304 QXL-JS-078',
    '離 X 則無 Y: nothing of the kind X, none of Y; the dependence the text states elsewhere (依 X 故有 Y) is Z')
put('G09', 'law', 'QXL-JS-012', '唯依妄念而有差別, 若離妄念則無一切境界之相: the dependence and the law in one unit (rule 5)')
put('G09', 'law', 'QXL-JS-414', '法身現 read as depending on the mind without 垢; with 垢, no 法身現')
put('G09', 'law', 'QXL-JS-166', '依心體而動, 心體滅則眾生斷絕: a dependence and its law, temporal (the dependence within the region)')
put('G09', 'law', 'QXL-JS-123', '心滅則種種法滅: a temporal dependence, the dependence within the region; 心生則種種法生 is production (rule 4)')
put('G09', 'law', 'QXL-JS-159', 'a chain of dependent endings (因滅則緣滅…), temporal, the dependence within the region')
put('G09', 'law', 'QXL-JS-197', 'a chain of dependent endings (無明滅 → 心無起 → 境界滅): «依之传» with «所依无则依者无»; 涅槃 read as the line\'s end')
put('G09', 'law', 'QXL-JS-058', '無明滅則相續滅: the line depends on 無明 (rule 5); 智性不壞 is the 戊 aspect, not read')
put('G09', 'law', 'QXL-JS-167', '癡滅故心相隨滅: a dependence and its law; 以體不滅心得相續 is grounded in a substance (體), which '
    'the plan registers as not a class (PLAN.md 起信论), so that clause is not expressible')
put('G09', 'law', 'QXL-JS-214', 'without the condition (meeting the teacher), no ending of 煩惱 even with the 因: a dependence on a '
    'second kind of condition; 善知識 names the kind, the law does not turn on its being good')
put('G09', 'law', 'ZL-24-041', '若不依俗諦不得第一義…不得涅槃: a chain of dependences, «依之传»; 涅槃 read as a state')
put('G09', 'law', 'ZL-17-040 ZL-17-042 ZL-17-045', '離種無相續: no first condition, no line from it (opponent\'s view in 中论 17)')
put('G09', 'law', 'CWS-P3-002 CWS-P3-003', 'without the undefiled seeds the ending (害) of the obstructions never comes: a dependence; '
    '立 … 種姓 names a kind (甲 part)')
put('G09', 'law', 'CWS-P3-008', 'without the undefiled seeds the noble path never arises: a dependence')
put('G09', 'law', 'CWS-P6+P7+P8-043', '若無此識, 彼事不成: the event depends on the consciousness (rule 2); 由善惡業下上身分 turns '
    'on a valuation (丁 part, as CWS-P2-007)')
put('G09', 'premise', 'QXL-JS-074 QXL-JS-081 QXL-JS-084 QXL-JS-100 QXL-JS-122 QXL-JS-156 QXL-JS-175 QXL-JS-176 QXL-JS-180',
    '依 X 故有 Y: the dependence itself, the Z of «所依无则依者无»')
put('G09', 'premise', 'QXL-JS-252', '以依業識生滅相示: the dependence itself (rule 5)')
put('G09', 'premise', 'ZL-17-049 ZL-10-009 CWS-P3-004', 'a dependence stated as the model\'s premise')
put('—', 'NE', 'ZL-17-013', 'volition to action (因思起身口業), an agent\'s act, as XZ-ZM-143')
put('—', 'NE', 'LZ-39-001', 'qualities (清寧靈盈) and an office (侯王貞) kept by 得一; under 王弼 物各得此一以成, a production of '
    'qualities; the shape (each kept by its relation to the one) would be G09\'s if they were relations')
put('—', 'NE', 'LZ-39-002', 'qualities lost (裂發歇竭) without 清寧靈盈, an office (侯王); 貴高 a valuation (丁 part)')
put('G10', 'law', 'QXL-JS-178 QXL-JS-179', '熏習 loops: conditions of each other, so co-present (俱有)')
put('—', '丁', 'QXL-JS-195', 'Z is 厭求 (aversion and seeking), an attitude, as QXL-JS-194, -206, -215, -216')
put('—', 'NE', 'CWS-P3-074', 'Z, 能熏所熏 俱生俱滅, is arising and ceasing together, simultaneity, which «俱有» (mutual reach) does '
    'not state; Y, 熏習義成, is the sense of a doctrinal term')
put('G10', 'law', 'CWS-P3-077', '能熏生種, 種起現行, 如俱有因: the conditions of the 熏習 loop, co-present')
put('G10', 'law', 'ZL-01-065', '穀作芽、芽作穀: mutual conditions are one cluster (中论 reductio)')
put('G11', 'law', 'CWS-P6+P7+P8-019', '三法無間轉: the joint class constant, so the joint line never ends')
put('G11', 'false', 'CWS-P6+P7+P8-020', '不爾便無恒相持用 states the converse (not constant, no lasting holding): false as read '
    '(a class not constant under which a line never ends)')
put('G11', 'law', 'CWS-P6+P7+P8-049', '壽煖識不相離: the three held together, neither alone («相须»)')
put('—', 'NE', 'ZL-10-043', 'Z, 人功現有, is human effort (an agent\'s work); Y, 火不異可燃, is a non-difference «相须» does not state')
# The four marks and continuation
put('G13', 'law', 'ZL-21-115 ZL-21-120 ZL-17-101', '生滅故不常，相續故不斷: begins and ends under identity (不常), abides under '
    'the one (不斷: does not end under the one)')
put('G13', 'false', 'ZL-21-113', '若無常即墮斷邊: read with 無常 as not abiding under identity and 斷 as ending under the one, '
    'false as read («四相俱时»: ends under identity, abides under the one); 若常即墮常邊 is a tautology')
put('G13', 'false', 'ZL-17-051', '若離業有果報則有斷常: a result with no deed among its conditions gives neither 斷 (the deed may '
    'go on) nor 常 (the result abides under no class): false as read')
put('G13', 'law', 'ZL-21-031', '成中常有壞則無住: at one class, what ends there does not abide there («住亡不并»); across two '
    'grains both can hold («四相俱时»), the reading the classifier notes')
put('G13', 'law', 'CWS-P1-031 CWS-P9-016 CWS-P1-007', '似我、似常一: continuing under a coarse class (一類相續) is not continuing '
    'under identity («非一非异»), which only seems (似) one')
put('G13', 'law', 'ZL-01-079 ZL-01-086', '來、出 as continuation under identity, which needs self-conditioning («非一非异»)')
put('G13', 'law', 'ZL-02-010', '去時, neither gone nor not yet: abiding (a predecessor and a successor) on a line of going')
put('G13', 'law', 'ZL-01-047', '若滅今不應有穀: what ends under a class starts no line under it («断则无相续»)')
put('G13', 'law', 'ZL-02-091', '因去法滅故有住, 無去則無住: abiding needs continuation («住因于续»)')
put('G14', 'law', 'CWS-P4-019 CWS-P5-017 CWS-P5-021 CWS-P5-022', '瀑流: the stream\'s class constant, the stream never breaks; '
    'waves are alterations on it')
put('G14', 'law', 'CWS-P1-024 CWS-P1-018 CWS-P6+P7+P8-015 CWS-P6+P7+P8-048', '一類相續、無間無轉: a constant class, a line that never breaks')
put('G14', 'law', 'CWS-P6+P7+P8-003', '一類、能遍、相續執受: a constant class, a line that never breaks; 非善、染 classifies the mind '
    'as neither, a valuation the law does not turn on')
put('G14', 'law', 'CWS-P1-030', '身心相續 輪迴: a line under a constant class (rule 2); 厭患苦故求趣涅槃 is an attitude (丁 part)')
put('G14', 'law', 'QXL-JS-168 QXL-JS-241', '熏習 keeps the arising unbroken: a constant class')
put('—', 'NE', 'LZ-33-005', 'agentive under 王弼 (以明自察，量力而行) (rule 1); read structurally against the commentary it '
    'would be G14\'s law')
put('G14', 'law', 'ZL-17-076 ZL-17-086', '不失法 as a class constant under 缘 carrying the deed (opponent\'s view, 中论 17)')
put('G15', 'law', 'QXL-JS-326', '無後際 transfers to what lies in one core class with it, 相應 read as the core (the technical '
    '相應, association, read as never told apart)')
put('G15', 'false', 'QXL-JS-324', '無前際 carried by 故 read as dependence: false as read («依于无始而有始之例»); the text has no '
    '相應, and JS-318 says the 染法 (無明 among them, JS-176) never 相應 with 如來藏; its conclusion is a premise of the model')
put('G15', 'law', 'QXL-JS-238 CWS-P4-062', 'a line without beginning that ends (無始而有斷; 阿羅漢位方究竟捨)')
put('—', 'NE', 'LZ-63-004', 'great and small (大事, 細): magnitude, which the grammar has no term for')
put('—', 'NE', 'LZ-23-002', 'wind and rain lasting less than a morning or a day: magnitudes of intensity and duration (暴, 驟, 朝, 日)')
put('G16', 'law', 'ZL-07-235 ZL-21-022 ZL-21-058 ZL-21-069', '自相、離壞有成、無成無壞、性不空: own condition, so abiding under '
    'every class and beginning or ending under none (或無 in 21-058 not read)')
put('G16', 'law', 'ZL-07-162 ZL-07-163', '縷自有定相不應從麻出: «缕之无定性» read back, premise 不自缘')
put('G16', 'law', 'ZL-24-185 JSZ-C-067 ZL-17-162', 'conditioned and not its own condition, so no own position')
put('G16', 'law', 'JSZ-C-064', '生與無生互成互奪: one occurrence begins under one class and not another («定性之判»)')
put('G16', 'law', 'ZL-01-040', '離劫初穀有今穀則應有生: what has no condition begins under every class')
put('G16', 'false', 'ZL-01-099', '若無因而有萬物，是則為常: what has no condition abides under no class, and it can end (the lone '
    'occurrence): false as read with 常 as abiding under every class or as never ending')
put('G16', 'false', 'ZL-02-070', '若決定有去、有去者，應有初發: own position read as own condition gives no beginning under any class '
    '(«自缘则常»): false as read; it is the premise of a reductio (moved from G15)')
put('—', 'NE', 'LZ-07-002', '王弼 reads 自生 as 與物爭, a social stance (rule 1); read structurally against the commentary, 不自生 '
    'as not its own condition, it would be false (the short line\'s end)')
# Marks and classes
put('G17', 'law', 'JSZ-P-07-007 JSZ-P-07-008 JSZ-P-07-009', '看 as the class taken: what it tells apart shows, what holds '
    'everywhere under it hides')
put('G17', 'law', 'JSZ-P-07-014 JSZ-P-07-015 JSZ-P-07-016', 'under one class all is one kind (純); under several each is pure and mixed')
put('G17', 'law', 'JSZ-P-07-032', '由心迴轉: gold and lion show or hide, one or many, as the class taken changes; the turning '
    'mind is not read; 善成 names the gate')
put('G17', 'law', 'QXL-JS-406 QXL-JS-313', '分齊、差別 relative to a class taken; under the one nothing is told apart')
put('G17', 'law', 'LZ-28-006', '樸散則為器: under a class finer than the one, things are told apart; 王弼\'s generative reading '
    '(殊類生) is lost; 聖人用之…大制不割 is 丁 (part)')
put('G18', 'law', 'QXL-JS-256 QXL-JS-260', 'a mark gives its complement a mark; to know a mark is to have its non')
put('G18', 'law', 'QXL-JS-028', '離妄心實無可空: where nothing falls outside, no mark («离非无相»)')
put('G18', 'law', 'LZ-01-001', '可道非常道: what has a mark does not hold everywhere («遍而无相» read back; 王弼 指事造形，非其常也)')
put('G19', 'law', 'ZL-19-002 ZL-19-003 ZL-19-004', 'past and future as the two ends of one relation: together globally, not pointwise')
# Knowing and measuring
put('G20', 'premise', 'XZ-ZM-034', '同類同情者意物也同: the class is constant under perceiving (有常), a premise of the model')
put('G20', 'premise', 'XZ-ZM-016', '名定而實辨: a fixed naming class tells realities apart; Z is the fixing of names, not the ruler '
    '(unlike XZ-ZM-026, whose Z is a ruler arising); 慎率民而一焉 is 丁 (part)')
put('G21', 'premise', 'XZ-ZM-043', '征知 through the senses: knowing along the sense\'s coupling and then the mind\'s, «而» of the two, '
    'a premise of 荀子\'s model')
put('G21', 'law', 'XZ-ZM-044', '征知 only where the senses register the kind: what the coupling does not put in the core is '
    'separated at some stage, the converse of «可分则不在核», which holds under the premise that not being separated is constant')
put('G22', 'law', 'XZ-ZM-164 XZ-ZM-165', '衡正 as a map keeping "heavier than" within "hangs lower than" («保之像»); whether '
    '衡不正 reverses or only fails to keep is unsettled (no commentary in the corpus)')
put('G23', 'law', 'ZZ-YSZ-016', '无厚入有間: a point within what has two parts does not fill it («尺与端或尽或不尽»)')
put('—', 'NE', 'LZ-36-001 LZ-36-002 LZ-36-003 LZ-36-004', '王弼 因物之性，令其自戮: a strategy, an agent\'s plan (rule 1); read '
    'structurally against the commentary (every end preceded by a rise, 亡 → 有前) it would be false')
# Definitions
put('—', '甲', 'CWS-P2-006 CWS-P3-078', 'the definition of continuation: 等流, 自類相生 = continuation under the class of one\'s kind (01 §2)')
put('—', '甲', 'CWS-P3-039 CWS-P3-040', 'defines two kinds of condition (因緣 as producing directly, 增上緣 as contributing): two relations, given apart')
put('—', '甲', 'CWS-P5-006', 'defines 攝藏 by holding the seeds')
# Evaluations
put('—', '丁', 'LZ-18-001 LZ-18-002 LZ-18-003 LZ-18-004', 'names virtues and counterfeits; the claim values a social order (decline). The marking reading («知相则有其非») loses it')
put('—', '丁', 'LZ-11-004', '利 and 用: what serves, valued')
put('—', '丁', 'LZ-22-001', '王弼 reads each pair as the sage not displaying himself (rule 1), so 敝則新 is not read structurally; '
    'read so against the commentary, "what is worn renews" would be false («亡而息之例»)')
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
put('—', 'NE', 'XCS-06-004 XCS-06-005', '是以大生、廣生: 生 as to produce (the classifier\'s note), production (rule 4); 專直、翕闢 are '
    'qualities of the motion')
put('—', 'NE', 'XZ-ZM-026', 'Z is a ruler arising, an agent; Y a naming practice')
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
