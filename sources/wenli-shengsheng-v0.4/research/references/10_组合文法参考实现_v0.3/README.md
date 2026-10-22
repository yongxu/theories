# 文理生生组合文法参考实现

本目录把组合文法的有限模型核心做成可执行解释器。它检查表达式的类型，计算给定模型中的真假与可达关系，并拒绝不合法的组合。模型里的对象、事实、转移和规范均由使用者明示；计算成功不代表这些设定已被古文或现实证据证明。

## 文件和运行

| 文件 | 用途 |
|---|---|
| [wenli.py](wenli.py) | 类型检查、递归语义、规范查询和命令行入口。 |
| [examples.json](examples.json) | 储备、改组、风险、身份、量化与规范的26项演示检查。 |
| [tests.py](tests.py) | 50项回归与独立黑盒验收，包括全部512个三状态有向图的闭包及0—4步精确重复。 |
| [casebook](casebook/README.md) | 与07和09逐组对应的12份模型，包含反例及出处、桥梁假设说明。 |
| [validate_casebook.py](validate_casebook.py) | 运行案例集的120项检查，包括命题、关系、规范、集成及错误拒绝。 |
| [verify_lifecycle.py](verify_lifecycle.py) | 将两条存续判据与独立不动点算法作24,576项穷举比较，另查变量与候选模型边界。 |

需要Python 3.9或更新版本，无需安装第三方包。在本目录运行：

```sh
python3 wenli.py examples.json
python3 tests.py
python3 validate_casebook.py
python3 verify_lifecycle.py
```

第一个命令输出每项的实际值、预期值与是否相符；其余命令分别运行接口验收、正文案例和存续判据验证。wenli.py命令行退出码0表示全部检查通过，1表示结果与预期不符，2表示输入不合法。非法UTF-8、重复JSON键、未声明符号等均作为输入错误返回。

## 有限模型怎样声明

```json
{
  "context_id": "example-fixed-scale-and-identity",
  "closed_world": true,
  "states": ["s0", "s1"],
  "sorts": {"Entity": ["a", "b"]},
  "constants": {"a": {"sort": "Entity", "value": "a"}},
  "predicates": {
    "Alive": {
      "sorts": ["Entity"],
      "kind": "descriptive",
      "true_at": {"s0": [["a"]], "s1": []}
    },
    "Safe": {
      "sorts": [],
      "kind": "descriptive",
      "true_at": {"s0": [[]], "s1": []}
    }
  },
  "programs": {"step": [["s0", "s1"]]},
  "formula_defs": {},
  "program_defs": {},
  "norms": {}
}
```

`context_id`是必填的非空字符串，标记本模型固定的研究尺度、对象划分、身份标准和符号解释约定。机器拒绝在`assess`中混合不同语境ID；相同ID是调用者的语义一致性声明，不能证明这种声明准确。

`states`是有限、非空的状态集合。`sorts`把对象域分成不同类型；同一字面值可以出现在不同类型，但不能因此互换。对象域可以为空，全称与存在量化保留其通常的空域语义。

每个谓词都声明参数类型，并给出**每一个状态**的真元组列表。零参数谓词以`[[]]`表示真、`[]`表示假。缺少某个状态的解释会报错；在`closed_world:true`明确承诺下，未列出的合法元组为假。这是输入模型的闭合约定，不是从未观察到现实对象推出它不存在。

原子过程用完整的前后态关系给出；空列表明确表示没有该过程的转移。所有边的端点必须已在`states`声明，重复状态、重复元组与重复边均拒绝。

对象名、类型名、常量名、谓词名、过程名和状态名均为非空字符串。当前核心不直接包含数值运算：例子的储备数值已明确离散成有限状态；数值规则如何导出这些边属于建模步骤。

## 表达式与类型

表达式是JSON语法树，禁止多余键、错误元数、未知操作及未绑定变量。解释器不执行输入字符串，也不把自然古文自动转换为语法树。

### 项

```json
{"const": "a"}
{"var": "x"}
```

常量必须先声明，变量必须由外围量词绑定。等号两边必须同类型。为了避免隐含捕获，同一量词作用域内禁止重新绑定相同变量名；改用另一个变量名即可。

### 命题 Formula

| 操作 | 完整构式 | 含义 |
|---|---|---|
| true、false | `{"op":"true"}`；`{"op":"false"}` | 真与假。 |
| atom | `{"op":"atom","name":"Alive","args":[{"const":"a"}]}` | 应用一个已声明的描述谓词。 |
| eq | `{"op":"eq","left":Term,"right":Term}` | 同类型项的相等。 |
| not | `{"op":"not","arg":Formula}` | 命题否定。 |
| and、or | `{"op":"and","args":[Formula...]}`；or同形 | 合取、析取；空列分别为真、假。 |
| implies | `{"op":"implies","left":Formula,"right":Formula}` | 当前状态上的实质蕴涵，不自动表示因果或转移。 |
| forall、exists | `{"op":"forall","var":"x","sort":"Entity","body":Formula}`；exists同形 | 在指定有限类型域中量化。 |
| diamond、box | `{"op":"diamond","program":Program,"body":Formula}`；box同形 | 某个可达后态成立；所有可达后态成立。 |
| fref | `{"op":"fref","name":"F"}` | 使用一个已声明、闭合的命题定义。 |

`Term`、`Formula`、`Program`及省略号是上表的语法占位说明，实际JSON中必须填入相应完整对象。

### 过程 Program

设过程的意义为状态关系。两个关系顺接时，前一个过程的后态必须是后一个过程的前态。

| 操作 | 完整构式 | 关系语义 |
|---|---|---|
| atomic | `{"op":"atomic","name":"step"}` | 取已声明的原子关系。 |
| skip | `{"op":"skip"}` | 所有状态上的恒等关系。 |
| test | `{"op":"test","condition":Formula}` | 只保留条件为真的状态上的恒等边，不改变状态。 |
| seq | `{"op":"seq","args":[Program...]}` | 按所列顺序作关系复合；空列为skip。 |
| choice | `{"op":"choice","args":[Program...]}` | 关系并集；空列为空关系，不是随机采样。 |
| sync | `{"op":"sync","args":[Program,Program...]}` | 至少两项的关系交集，要求同一前后态同时获准；不表示一般并行调度。 |
| star | `{"op":"star","body":Program}` | 自反传递闭包，表示零次或任意有限次重复。 |
| repeat | `{"op":"repeat","count":3,"body":Program}` | 恰好3次重复；count必须是非负整数，布尔值不当整数。 |
| pref | `{"op":"pref","name":"P"}` | 使用一个已声明、闭合的过程定义。 |

过程测试可以引用外层量词变量，变量解释在整段模态求值中保持。例如“存在某个x，x当前活跃，而且执行step后仍活跃”可写为：

```json
{
  "op": "exists", "var": "x", "sort": "Entity",
  "body": {
    "op": "diamond",
    "program": {
      "op": "seq",
      "args": [
        {"op":"test","condition":{"op":"atom","name":"Alive","args":[{"var":"x"}]}},
        {"op":"atomic","name":"step"}
      ]
    },
    "body": {"op":"atom","name":"Alive","args":[{"var":"x"}]}
  }
}
```

这只保证模型中的同一域元素在两端满足谓词；现实身份标准、采样间隙及身份关系的证据仍由模型解释负责。

## 命名定义与可组合宏

`formula_defs`、`program_defs`分别把名字绑定到完整的命题或过程表达式。它们可以相互引用，但合并的依赖图必须无环；所有定义都在模型构造时检查，未被查询引用的错误定义也不能保留。

这些定义必须闭合，不能悄悄捕获调用位置的变量。定义内部可以有自己的量词。核心没有带参数的文本替换宏：需要参数的“生、存、通、久”等模板，须先显式实例化成这套JSON构式，再以闭合定义命名。闭合定义为表达式缩写，不是新增公理。

## 空后继与持续性的区别

没有后继时，`box(a,p)`为真，因为没有反例后态；`diamond(a,true)`为假。因此，`box`单独不表示过程能实际继续。

示例中的`LiveNext`是：

```text
〈tick〉true ∧ [tick]K
```

它同时要求至少一个后继，以及所有后继均在持续域K中。`AllRunSafe`是：

```text
[tick*](K ∧ 〈tick〉true)
```

这要求每个可达状态安全且没有死端。如果有限模型中的`tick`确实代表一个正时长步骤，则它保证任意有限次运行都能继续，并允许无限路径。`test`和`skip`本身不代表时间前进；不能仅凭`star`中的零步路径宣称实际延续。

## 规范查询与行动准入

规范独立于描述命题，用完整的判断表给出：

```json
{
  "N": {
    "actions": ["wait", "reform"],
    "judgments": {
      "s0": {"wait":"permitted", "reform":"forbidden"},
      "s1": {"wait":"undetermined", "reform":"required"}
    }
  }
}
```

它可作为模型的`norms`字段。结果仅有`required`、`permitted`、`forbidden`、`undetermined`，必须对每个状态和所列行动显式给出；缺项不会默认为允许或未决。

`Model.judge(norm,state,action)`返回规范表判断。`Model.decision(norm,state,action,program)`再结合该程序是否有后继，返回：

| 情形 | eligible |
|---|---|
| 不可行，或规范禁止 | false |
| 可行，且规范允许或要求 | true |
| 可行，规范尚未决 | null |

行动名与程序由调用者绑定，此函数不会凭名称推定两者相同。`eligible`仅表示给定规范下的准入，不是总体道德最优。规范判断、文本主张和因果有效性标签不能作为Formula的隐式输入；描述性谓词若被命名为“因果”，名称本身也不会增加因果识别能力。

## 不确定性与API

| 接口 | 结果 |
|---|---|
| `Model(data)` | 全模型校验，不合格时抛`GrammarError`。 |
| `check_formula(ast)` | 合法时返回`Formula`，不计算真假。 |
| `check_program(ast)` | 合法时返回`Program`，不证明过程发生。 |
| `holds(ast,state)` | 给定模型和状态中的布尔真值。 |
| `relation(ast)` | 程序的有限前后态关系。 |
| `successors(ast,state)` | 指定状态的后继集合。 |
| `judge(norm,state,action)` | 给定规范表的判断。 |
| `decision(norm,state,action,program)` | 规范与可行性共同约束的准入。 |
| `assess(models,ast,state)` | 明示候选模型组中的true、false或unknown。 |

`assess`要求非空的候选模型列表，且context_id、状态域、对象域、常量解释、谓词签名、原子过程名字、闭合定义和规范行动签名一致。谓词真值扩展、过程边可以变化；规范表判断也可变化，因为Formula不能引用它。所有候选中为真则返回`true`，全为假则返回`false`，真假混合则返回`unknown`。空候选集报错，不产生“任何事都确定”的结论。

这是一组显式模型上的判断，不能保证候选组已经穷尽真实世界的可能性。任意自然语言、连续时间、概率推断、经验因果识别、带参数宏编译和开放域定理证明均不在这个执行核心内。

## 命令行数据包

命令行输入以`model`为必需字段，另外可给`title`、`notes`以及三类查询：

```json
{
  "model": {},
  "queries": [
    {"name":"命题检查","state":"s0","formula":{"op":"true"},"expected":true}
  ],
  "relations": [
    {"name":"关系检查","program":{"op":"skip"},"expected":[["s0","s0"]]}
  ],
  "norm_queries": [
    {"name":"规范检查","norm":"N","state":"s0","action":"wait","expected":"permitted"}
  ]
}
```

上例的空`model`只是结构位置说明，运行时须填入完整模型；可直接使用本目录的`examples.json`。JSON中的重复键会被拒绝，避免一个构造悄悄覆盖另一个构造。
