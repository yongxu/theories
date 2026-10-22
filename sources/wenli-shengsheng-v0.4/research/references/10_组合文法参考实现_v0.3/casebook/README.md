# 组合推导的可执行案例

本目录把07的五状态教学模型与09的七组推导落实为12个独立JSON案例。每个文件都能直接交给相邻的`wenli.py`执行；其`notes`列出模型输入、桥梁假设与原典线索。

原文、义项与现代机制的联系见[完整推导与反例](../../09_组合文法完整推导与反例_v0.3.md)。这些案例检验给定解释下的形式推论；不自动完成古文释义或验证真实世界。

| 文件组 | 对应正文 | 检查重点 |
|---|---|---|
| `01_negation_observation.json`及`01_negation_possible_unseen.json` | 09第二节 | 固定Time域中的窗口变换；未观测不等于未发生；空真、测试与真实tick；T为0也检查K。 |
| `02_qiong_bian_tong_jiu.json`及`02_supply_failure.json` | 09第三节 | 七状态改革成本与供给；改革可行但未发生；固定新规则下的永续与供给下降反例。 |
| `03_relational_concepts.json` | 09第四节 | 概念相待与互补定义；相似不推出因果；相生环不自动对称。 |
| `04_harmony_difference.json` | 09第五节 | 和且不同的见证；不同不保证和、和不要求不同的两个反例。 |
| `05_birth_end_lineage.json` | 09第六节 | 生灭宏是Program；sync要求同一前后边；谱系不推出严格同一。 |
| `06_follow_structure.json`及`06_blocked_structure.json` | 09第七节 | 结构允许的顺接路径、角色类型、通道堵塞的反例。 |
| `07_norms_and_feasibility.json` | 09第八节 | 持续性、伤害后果、规范评价分别输入；规范表由明示的V给定。 |
| `08_five_state_tutorial.json`及`08_five_state_failure.json` | 07第十节 | 完整五状态推导；改革可行但后续不再稳定的反例。 |

每组使用独立`context_id`；同组的候选或反模型保留相同ID，因为比较问题、尺度及身份准则保持相同，只改变所列解释。ID相同本身不能证明这些声明诚实或充分。

所有模型按封闭解释运行：未列元组在已给出的完整表中为假；缺失整张表或缺状态解释会报错。每个tick都在其文档模型中表示固定正时间步，测试与空动作不计实际时间。

在本目录上一级运行全部案例与额外拒绝检查：

```text
python3 validate_casebook.py
```

可选保存详细结果：

```text
python3 validate_casebook.py --report casebook/validation_results.json
```

运行单一案例：

```text
python3 wenli.py casebook/05_birth_end_lineage.json
```

验证器除了执行各JSON的公式、过程关系和规范查询，还直接检查候选模型合评、不同context的拒绝、角色错误、Formula／Program混用、TextClaim／Judgement越级，以及规范判断与实际可行性的联合结果。

规范案例的V表由公开的示范标准填写：本次只接受可行且全部后果不伤害指定人的行动。验证器检查表与该标准在示范决策状态的一致性，并调用`judge`与`decision`；解释器不会从持续性推出V，也不证明V是普遍伦理。输出准入不等于已经执行或总体最优。

路径损伤成本在09中另声明为两条零成本边的和。核心不解释数值成本，验证器只作这一附加的简单算术核对；核心关系求值与成本增补分开。
