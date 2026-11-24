# 文·合·化：可运行有限原型 v3.0

仅 Python 标准库。运行：

```bash
PYTHONPATH=. python -m unittest discover -s tests -v
PYTHONPATH=. python demo_v3.py
```

## 软件能力与限制

| 模块 | 能力 | 不能声称 |
|---|---|---|
| `core.py` | 有类型超图；沿离散节点界面的粘合；有条件局部重写 | 一般 adhesive-category DPO 实现 |
| `higher.py` | 固定界面的开放图与单态跨度；高阶组合有限实例 | 一般 bicategory 定理已机器验证 |
| `evolving.py` | 外界端口新增撤回重排；持续身份；稳定接缝粘合 | 任意公共接缝可变的完整 double category |
| `modes.py` | 模式决定动作和带类型标签的输出；有理概率转移 | 完整 `PolyTr` / 实际输出物理量校准 |
| `probability.py` | 有理数有限核、顺序与独立并行组合、强可聚合性 | 一般 Markov categories / 相关环境的联合分布 |
| `flow.py` | 有限连续流方程的即时导数与代数守恒检查 | ODE 积分器、存在唯一性或物理测量证据 |
| `process_semantics.py` | 受限开放有向图的可达性 | 一般多端口超图行为语义 |
| `semantics.py` | 旧版确定、随机、资源的有限检查 | 通用因果保真或价值判定 |

`InterfaceTrace` 是位置上的部分单射，**旧端口没有映射不等于原节点一定被删除**。所有模块只在声明的边界上相容。`ModeMachine` 输出以 `(类型标签, 值)` 二元组表达，当前检查标签与数量，不判断物理单位是否合法。

## 如何找反例

- 把共享接缝的某个端口删去：`horizontal_evolution` 拒绝；
- 让两个端口共享一个新持续身份：`InterfaceTrace` 拒绝非单射；
- 让旧类型与新类型不同：身份迹拒绝；
- 将两个拥有不同输出接口的模式归到同一严格接口宏态：`quotient_markov(..., shapes=...)` 拒绝；
- 让某概率行和不为 1：`Kernel.check()` 拒绝；
- 让不同微状态在同一块内去往其他宏态的总概率不同：强可聚合性拒绝。

本项目鼓励从反例向形式化规范倒逼，而非把测试的成功误当成普适真理。

## v4.0 共享界面变化

新增 `wenhehua.seams.SeamContract` 与 `horizontal_changing_seam`。传入**显式的接缝续迹**（可能为空，也可能为真正的部分单射）。旧接缝与新接缝的长度和类型列可以不同，但同一阶段两侧必须可连接；若候选共同见证的两个映射发生非单射碰并，strict 拒绝、forget_conflicts 只有在能够保留所有承诺的外部身份时才允许弱化。

另外 `wenhehua.adapters.junction` 与 `connect_with_adapter` 支持明确声明的超边生成元；它们只进行类型化结构构造，**不验证资源或因果语义**。

```bash
PYTHONPATH=. python -m unittest discover -s tests -v
PYTHONPATH=. python demo_v4.py
```

注意 `forget_conflicts` 不是一般 functor；参见 `test_transient_fusion_and_fission_loses_identity_information`。命题 B.1/B.2 的条件与证明见 `formal/26_共享界变_定义判据与命题.md`。

## v5 谱系关联与有向弱交换（2026-11-24）

- 新增 `wenhehua/lineage.py`：有限类型集、映射、推积、拉回、非必单射的谱系跨度、变界方格和比较映射。
- 新增 `demo_v5.py` 与 `tests/test_lineage.py`。
- v5 的 `Span` token 表示前后关联见证，不是 v4 `Evolution.common` 所声称的持久身份单态见证；不能互换解释。
- 运行 `PYTHONPATH=. python demo_v5.py`。本轮 22 项新增测试，累计 137 项。

## v7.0 依观判守（2026-11-24）

新增 `wenhehua/observational_v7.py`：

- `optimal_observed_lift(chi, mu, q)`：计算最小观察 TV 误差并返回一个精确的有理数局部提升；仅当 `chi.domain` 非空、分布归一且查询总定义时受理。
- `refinement_certificate(chi,mu,q,h)`：检验查询粗化的缺像单调性。
- `common_lift(chi,mu,(q1,...))`：在小规模有限域内寻找**一份**能够同时匹配所有边缘查询的局部分布；默认源集合大小上限为 12。
- `joint_observation`：显式生成联合查询，不把多个边缘的共同符合误认为联合分布相等。
- `composition_error` / `parallel_error`：有限核的串联与**独立张量**误差证书；不可用于未声明相关耦合。
- `observe_kernel` / `stochastic_data_processing`：后处理和总变差收缩检查。

新增 `tests/test_observational_v7.py`、`tests/test_pasting_v7.py`；累计 **232 个测试**通过。

```bash
PYTHONPATH=. python -m unittest discover -s tests -v
PYTHONPATH=. python demo_v7.py
```

注意：`common_lift` 是有限凸可行性小规模有理算法，不是工业级 LP 或一般多查询概率模型；本软件也不自动发现、识别现实中的因果干预关系。所有概念及数学受理域参见 `../formal/46_依观判守_形式规格与定理.md`。
