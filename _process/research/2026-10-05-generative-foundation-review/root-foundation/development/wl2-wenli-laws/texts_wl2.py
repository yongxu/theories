"""WL2's texts in Chinese: the edits to the chapter WENLI-AND-BECOMING's fragments (head, centre) and the round of
exact edits to the 中华本 (work/round8-edits.json, by the book's 條 ids). Used by apply_text_wl2.py."""


def head_pairs(N, SL):
    return [
        ('所以「文理」二字，在本表中是一个关系：守值之理中最粗者，所并恰是文同之状（几条已检之律之合，不是一条定理）；理自文读出，只在此义。',
         '所以「文理」二字，在本表中是一个关系：守值之理中最粗者，所并恰是文同之状（`Becoming.Law.coarsest_iff`，一条定理）；理自文读出，只在此义。'),
        ('- 本章不新增 Lean。所需的 Lean 项列在第一部分末（「本节未立者」）与「文理生生的形式部分与八卦」一节中，须先在工作板上认领。',
         f'- 本章初成时不新增 Lean。它列为未立的三项 Lean，已由其后的看板项 WL2 证出，引在正文相应之处（第一部分 §四 律 6、§六、§七与总表；'
         f'[研究第 {N} 节]({SL})）：守值之理中最粗者恰并文同之状，作一条定理；缘感无异与待者自身之文；名之文与通意。嵌入文理生生的 G1，'
         '仍是「文理生生的形式部分与八卦」一节所说的可以认领的后续项目。'),
    ]


def centre_pairs(N, SL):
    return [
        # §一's closing reading
        ('理自文读出只在一义：法经一象示之，守象之值之最粗之理所并者恰为文同之状（一·二十一）。识是一个待者经其感读它自身之所历，也在展开之中（§六）。',
         '理自文读出只在一义：法经一象示之，守象之值之最粗之理所并者恰为文同之状（一·二十一，`Becoming.Law.coarsest_iff`）。识是一个待者经其感读它自身之所历，'
         '也在展开之中：感读作值时，它所择者恰依它自身之文之往（§六）。'),
        # 理者，成物之文也
        ('守象之值、为理而又并凡文同之状者，是正名（`Becoming.Law.identifiesAlike_of_law`）。所以守象之值、为理、又并凡文同之状的类，所并者恰是文同之状，它是守值之理中最粗的。'
         '一族尽其状时，这样的类是有的：以自每状起之文前 N＋N－1 步之往名此状（N 为族之员数），即是正名，且载一法（`Becoming.Law.name_identifiesAlike`、'
         '`Becoming.Law.name_carries`）。这是几条已检之律合起来的结论，没有一条定理单独陈述「理所并者恰是文同者」。',
         '守象之值、为理而又并凡文同之状者，是正名（`Becoming.Law.identifiesAlike_of_law`）。一条定理说出全部（`Becoming.Law.coarsest_iff`）：守象之值而为理之类，凡守值而为法所守之关系所连之二状皆并之、凡文同之二状皆并之、所并恰是文同之状、'
         '为正名，四者是一。文同本身是守值而为法所守之关系中最粗者，不加前提（`Becoming.Law.sameFuture_coarsest`）。所以守值之理中最粗者，所并恰是文同之状。'
         '作为类，一族尽其状时有之：以自每状起之文前 N＋N－1 步之往名此状（N 为族之员数），这些名守值、为理、恰并文同之状；守值之理粗于每一守值之理'
         '（其值与象之值同一 universe），恰当它恰并文同之状（`Becoming.Law.coarsest_class`）。不给一族时，以文同取商可以有，但商并文同之状须 `Quot.sound`，'
         '核心不用，所以只立其关系。'),
        # §四 律 6
        ('   - 所以，守 o 之值、为理、又并凡经 o 文同之状的类，所并者恰是经 o 文同之状，是守值之理中最粗的，并且它是正名。这是上二律与 '
         '`Becoming.Law.kernel_bisimulation`、`Becoming.Law.alike_iff_sameFuture` 合起来的结论，没有一条定理单独陈述它。一族尽其状时，这样的类是有的：'
         '以自每状起之文前 N＋N－1 步之往名此状（N 为族之员数；`Becoming.Law.name_identifiesAlike`、`Becoming.Law.name_carries`）。',
         '   - `Becoming.Law.coarsest_iff`（若：π 守 o 之值，且 `GoAlike (Law.process next) π`，即 `Becoming.Law.KeepsAndCarries`）：以下四者是一：'
         '凡守 o 之值而为法所守（`Becoming.Law.KeepsRelation`）之关系所连之二状，π 皆并之；凡经 o 文同之二状，π 皆并之；π 所并恰是经 o 文同之状；'
         'π 为正名。\n'
         '   - `Becoming.Law.sameFuture_coarsest`（无设）：经 o 文同守 o 之值、为法所守，且含每一守 o 之值而为法所守之关系。所以守 o 之值之理中最粗者，'
         '所并恰是经 o 文同之状，且为正名；恰并经 o 文同之状之类，粗于每一守 o 之值而为理之类（`Becoming.Law.coarser_of_exact`）。\n'
         '   - `Becoming.Law.coarsest_class`（若：一族尽其状）：以自每状起之文前 N＋N－1 步之往名此状（N 为族之员数），这些名守 o 之值、为理、所并恰是经 o '
         '文同之状；守 o 之值而为理之类，粗于每一守值为理、其值与 o 之值同一 universe 之类，恰当它恰并经 o 文同之状。不给一族时，核心不立这样的类：'
         '以文同取商可以有，商并文同之状须 `Quot.sound`；最粗者作为关系仍在。'),
        # §六 识
        ('它所择，只依其所历在这个类中之所在。可以读作：它所读的，是它自身之所历经其感逐步所显者，即它的文；文的状与法读自文（§一）。但缘感无异是一个关系，不是一个象。'
         '脊柱还没有一条定理把文之诸律接到缘感无异上，这是一个须在看板认领的 Lean 项。',
         '它所择，只依其所历在这个类中之所在。缘感无异一般是一个关系，不是一个象：容是一辞，以积感入之所待可以无穷。下面的律说它在何处是一个象，'
         '那时它所读的就是它自身之所历经其感逐步所显者，即它的文；文的状与法读自文（§一）。\n'
         '- **待者自身之文**（感读作值之处）：\n'
         '  - `Becoming.Web.ValuesThrough`（定义）：value 给出感入 g 者之值，是说每一步，两组积之值相同，恰当二者同容或同不容 g、以积感入 g 之所待其积亦同。'
         '待者自身之文（`Becoming.Web.courseThrough`）是每步感入它者经 value 之值。\n'
         '  - `Becoming.Web.listed_values`（若：g 之容已定然否，以积感入 g 之所待列尽）：容与否连同所列诸积，就给出这样的值。\n'
         '  - `Becoming.Web.alikeThroughUpTo_iff_prefix`：两段历缘 g 之感至 t 无异，恰当 g 自身之文在二历下至 t 之往相同。\n'
         '  - `Becoming.Web.selectsThrough_iff_prefix`：一择缘 g 之感至 t，恰当它依 g 自身之文至 t 之往而择（有一辞读往，此择恰依之）；'
         '`Becoming.Web.selects_alike_iff_prefix`：二历被每一缘 g 之感至 t 之择同样地择，恰当其往相同。所以缘感而择，就是读自身之文之往。\n'
         '  - `Becoming.Web.alike_of_bounded`（若：g 自身之文在二历下各不过 N、N′ 状）：二历缘 g 之感在 N＋N′－1 步之前每步无异，则至每一步都无异；'
         '凡缘其感之择，于每一步都同样地择这二历（`Becoming.Web.selects_alike_of_bounded`）。这是有界则往定其行（九·三十三，'
         '`Becoming.Identification.bounded_agree`）用在待者自身之文上。二文合读不过 P 状时，P 步之前无异即足（`Becoming.Web.alike_of_joint_bounded`，'
         '`Becoming.IdentificationRuns.joint_agree`）。\n'
         '  - `Becoming.Web.bounded_exact`（构造之例，一待者一所待，以积感入，以积读之）：对每一 M、M′，有二历，其文各不过 M＋1、M′＋1 状，于 M＋M′ 之前每步缘感无异，'
         '于 M＋M′ 步有异。所以界 N＋N′－1 确切。\n'
         '  - `Becoming.Web.states_by_reading`（同一构造之例）：连步数之积也给出感入者之值；积恒为零之历，以积读之，其文一状，连步数读之，其文之状多于每一界。'
         '文之状比较异步之值，感只比较同一步之二历，所以文之状随读而定。\n'
         '  - 讀（AI，D45、D63）：识所读的，是它自身之文之往。它自身之文之状有穷时，凡它所能分开的二历，于 N＋N′－1 步之内都已分开；二历缘其感于前 T 步无异、其后有异，'
         '则它在二历下的文之状数之和大于 T＋1。这条律只在一种读之下说话，读越粗，所说越多。'),
        # §七 读出一切词之串
        ('  - 讀（AI，D63）：一部书是以名为值之文，其名经码配义项（§一）；这条律说一个读者何时能从这样的文读回每一名之义项。文之律（§一）与这条律之间，脊柱还没有定理相接。',
         '  - 讀（AI，D63）：一部书是以名为值之文，其名经码配义项（§一）；这条律说一个读者何时能从这样的文读回每一名之义项。\n'
         '- **名之文：**\n'
         '  - `Becoming.SharedCodes.course_states_iff`：一码之下，凡义之文，其名之文二步同，恰当义之文二步同，恰当此码辨诸义（不二义同名，'
         '`Becoming.SharedCodes.TellsApart`）。二义同名，则先取其一、后皆取其二之义之文（`Becoming.Learning.holdFrom`），其名之文并了义之文所分之首二步。\n'
         '  - `Becoming.SharedCodes.course_read`（若：同上条之三若；以通意读出每一串）：于每一词之文，通意逐步把名读为义，义之文就是名之文经此读所得；'
         '名之文二步同，则义之文二步同。\n'
         '  - `Becoming.SharedCodes.code_read_every`（若：同上，词就是义，名由一码给出）：以通意读回每一串之码，必辨诸义，所以名之文与义之文同状。\n'
         '  - 讀（AI，D63）：读回每一名之义项的读者，从名之文读出的状，并于义之文之状之中；码辨诸义时，二者恰同，文之律（§一）对名之文所说的状，就是对义之文所说的状。'
         '有异名同义者，名之文之状可多于义之文之状。'),
        # 总表
        ('| 理者，成物之文也 | `Law.sameFuture_of_law`、`Law.identifiesAlike_of_law`、`Law.alike_iff_sameFuture`、`Law.name_identifiesAlike` | '
         '守值、为理、并凡文同之状的类，所并恰是文同之状，且为正名；一族尽其状时有之（几条律合起来，非一条定理） |',
         '| 理者，成物之文也 | `Law.coarsest_iff`、`Law.sameFuture_coarsest`、`Law.coarser_of_exact`、`Law.coarsest_class` | '
         '守值、为理之类，粗于每一守值而为法所守之关系，恰当它恰并文同之状，恰当它为正名（一条定理）；文同是这样的关系中最粗者；作为类，一族尽其状时有之 |'),
        ('| 观／证 | `Web.SelectsThrough`、`Web.selects_alike_iff`、`Web.Excludes.not_of_alike` | 知者之感以内 |',
         '| 观／证 | `Web.SelectsThrough`、`Web.selects_alike_iff`、`Web.Excludes.not_of_alike`、`Web.selectsThrough_iff_prefix`、`Web.alike_of_bounded`、'
         '`Web.bounded_exact` | 知者之感以内；感读作值之处（容已定、以积感入者列尽时有之），所据即自身之文之往，自身之文有界则所分者 N＋N′－1 步内分尽 |'),
        ('| 字合为模 | `Generative.trace_append_iff`、`goAlike_image_iff`、`CodeAcquisition.acquired_every_expression`、`CrossSituational.reads_every_iff` |',
         '| 文²：一部书是以名为值之文，名经码配义项 | `CrossSituational.reads_every_iff`、`SharedCodes.course_read`、`SharedCodes.course_states_iff`、'
         '`SharedCodes.code_read_every` | 读出每一串之处：义之文是名之文经通意之读；码辨诸义时二文同状 | 二义同名之码，名之文并义之文所分之步；'
         '读不出每一串之处 |\n'
         '| 字合为模 | `Generative.trace_append_iff`、`goAlike_image_iff`、`CodeAcquisition.acquired_every_expression`、`CrossSituational.reads_every_iff` |'),
        # 本节未立者 5
        ('5. **「同理恰在文同」作为一条定理。** 它是 `Becoming.Law.sameFuture_of_law`、`Becoming.Law.identifiesAlike_of_law`、`Becoming.Law.kernel_bisimulation`、'
         '`Becoming.Law.alike_iff_sameFuture` 合起来的结论；一族尽其状时这样的类之有，另由 `Becoming.Law.name_identifiesAlike` 给出。文之律与 '
         '`Becoming.CrossSituational`、`Becoming.Web.AlikeThroughUpTo` 之间也没有定理相接。这几项都是须在看板认领的 Lean 项，本节没有认领。',
         '5. **恰并文同之类，于任一法皆有。** 一族尽其状时有之（`Becoming.Law.coarsest_class`）；一般以文同取商，商并文同之状须 `Quot.sound`，核心不用，'
         '只立其关系（`Becoming.Law.sameFuture_coarsest`）。缘感无异之为象亦然：一般而言要以此关系取商，核心只在容已定、以积感入者列尽之处给出其值'
         f'（`Becoming.Web.listed_values`）。原列于此的三项 Lean，已由看板项 WL2 证出，见 §四 律 6、§六、§七（[研究第 {N} 节]({SL})）。'),
    ]


def round8(N):
    why = f'WL2 (study section {N}): the open Lean items of WENLI-AND-BECOMING proved'
    return [
        {'id': '七·十二',
         'find': '这是四条已检之律之合（又 `Becoming.Law.alike_iff_sameFuture`、`Becoming.identifiesAlike_iff`），不是一条定理。',
         'replace': '这是一条定理：守象之值而为理之类，凡守值而为法所守之关系所连之二状皆并之、凡文同之二状皆并之、所并恰是文同之状、为正名，四者一也'
                    '（`Becoming.Law.coarsest_iff`）；文同自身是守值而为法所守之关系中最粗者，无设（`Becoming.Law.sameFuture_coarsest`）；一族尽其状时，'
                    '以前段之名（⟦十·十五⟧）为类，即守值之理中最粗者（`Becoming.Law.coarsest_class`）。不给一族时，以文同取商可以有，商并文同之状须 '
                    '`Quot.sound`，核心不用，故只立其关系。',
         'why': why + ': the coarsest value-keeping class as one law'},
        {'id': '七·十二',
         'find': '`Becoming.Law.identifiesAlike_of_law`、`Becoming.carries_law_alike_iff`',
         'replace': '`Becoming.Law.identifiesAlike_of_law`、`Becoming.Law.KeepsAndCarries`、`Becoming.Law.sameFuture_coarsest`、`Becoming.Law.coarsest_iff`、'
                    '`Becoming.Law.coarsest_class`、`Becoming.carries_law_alike_iff`',
         'why': why},
        {'id': '十一·九',
         'find': '以积感入者增，缘感之择仍缘感。',
         'replace': '以积感入者增，缘感之择仍缘感。感读作值时，二历缘其感至某步无异，恰当其自身之文至此步之往同；缘其感之择，恰是依此往之择；其自身之文于二历下'
                    '各不过 N、N′ 状，则二历缘其感于 N＋N′－1 步之前无异者，永无异。',
         'why': why + ': a formation\'s own course'},
        {'id': '十一·九',
         'find': '讀（AI，D25）：AI 训练中给奖励者是择者',
         'replace': '感读作值（`Becoming.Web.ValuesThrough`：每步二组积之值同，恰当其同容或同不容此待者、以积感入之所待其积亦同；容已定然否、以积感入之所待列尽时，'
                    '容否与所列诸积即是，`Becoming.Web.listed_values`），待者自身之文是每步感入它者之值（`Becoming.Web.courseThrough`，⟦WEN-1⟧）：二历缘其感至某步'
                    '无异，恰当其自身之文至此步之往同（`Becoming.Web.alikeThroughUpTo_iff_prefix`）；一择缘其感，恰当它依此往而择'
                    '（`Becoming.Web.selectsThrough_iff_prefix`）。所以缘感而择，就是读自身之文之往。自身之文于二历下各不过 N、N′ 状，则二历缘其感于 N＋N′－1 '
                    '步之前每步无异，即永无异（`Becoming.Web.alike_of_bounded`，⟦九·二十五⟧），此界确切（`Becoming.Web.bounded_exact`，构造之例，一待者一所待）；'
                    '二文合读不过 P 状，则 P 步之前无异即足（`Becoming.Web.alike_of_joint_bounded`）。文之状比较异步之值，感只比较同步之二历，故文之状随读而定：'
                    '一待者一所待之例中，积恒为零之历，以积读之其文一状，连步数读之其文之状多于每一界（`Becoming.Web.states_by_reading`）。缘感无异一般是关系，'
                    '不是象：容是一辞，以积感入之所待可以无穷。讀（AI，D25）：AI 训练中给奖励者是择者',
         'why': why + ': a formation\'s own course'},
        {'id': '十一·九',
         'find': '`Becoming.Clearing.selected_by_dweller`；记录',
         'replace': '`Becoming.Clearing.selected_by_dweller`、`Becoming.Web.ValuesThrough`、`Becoming.Web.listed_values`、`Becoming.Web.courseThrough`、'
                    '`Becoming.Web.alikeThroughUpTo_iff_prefix`、`Becoming.Web.selectsThrough_iff_prefix`、`Becoming.Web.alike_of_bounded`、'
                    '`Becoming.Web.bounded_exact`、`Becoming.Web.alike_of_joint_bounded`、`Becoming.Web.states_by_reading`；记录',
         'why': why},
        {'id': '十一·九',
         'find': '[testing-within-couplings](../results/records/testing-within-couplings.md)。',
         'replace': '[testing-within-couplings](../results/records/testing-within-couplings.md)、'
                    '[a-formations-own-course](../results/records/a-formations-own-course.md)。',
         'why': why},
        {'id': '九·一',
         'find': '只随其感所作之类而定；感之外之差',
         'replace': '只随其感所作之类而定；感读作值时，此类恰是其自身之文之往（⟦十一·九⟧），所以识所读者是它自身之文；感之外之差',
         'why': why + ': 识 reads the prefix of its own course'},
        {'id': '十·十一',
         'find': '对照（相合，mojing-tong-yi-hou-dui）',
         'replace': '一部书是以名为值之文（⟦WEN-1⟧）。分组能复原每一串编码之词、以通意读出每一串之义项时，通意逐步把名之文读为义之文：名之文二步同，则义之文二步同'
                    '（`Becoming.SharedCodes.course_read`）。经一码，凡义之文，其名之文与义之文同状，恰当此码辨诸义（`Becoming.SharedCodes.course_states_iff`）；'
                    '以通意读回每一串之码，必辨诸义（`Becoming.SharedCodes.code_read_every`）。对照（相合，mojing-tong-yi-hou-dui）',
         'why': why + ': the course of names'},
        {'id': '十·十一',
         'find': '`Becoming.CrossSituational.Omitted.wrong_unique`；记录',
         'replace': '`Becoming.CrossSituational.Omitted.wrong_unique`、`Becoming.SharedCodes.course_read`、`Becoming.SharedCodes.course_states_iff`、'
                    '`Becoming.SharedCodes.code_read_every`；记录',
         'why': why},
        {'id': '十·十一',
         'find': '[encounter-selection-and-revision](../results/records/encounter-selection-and-revision.md)。',
         'replace': '[encounter-selection-and-revision](../results/records/encounter-selection-and-revision.md)、'
                    '[a-code-formed-between-formations](../results/records/a-code-formed-between-formations.md)。',
         'why': why},
    ]
