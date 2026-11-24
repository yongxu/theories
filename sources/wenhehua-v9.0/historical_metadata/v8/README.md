# 文·合·化｜最小生成文法研究 v8.0

**本轮主题：合化同源——双向生成图、高维拼接与弱交换的更深数学统一。**

这是一项将不同数学理论连接成可构造、可检查文法的探索，不声称已经得到现实唯一完整的本体论或新证明的普适高阶范畴定理。

## 阅读

1. `00_一页导读.md`
2. `export/文合化_v8.0_合化同源高阶生成专论.pdf`：本轮重点
3. `formal/53_双向生成与基变换_形式规格.md`：精确的数学角色与命题
4. `examples/54_高阶拼接与基变换_复现.md`：复现正反例
5. `review/55_高阶统一_批判审查.md`：不能随意推广的地方
6. `export/文合化_v8.0_理论全集.pdf`：v1–v8 主体理论整合
7. `export/文合化_v8.0_概念词林.pdf`：v8 新注与历史词库

## 本轮新增文件

- `research/52_合化同源_高阶生成总论.md`
- `formal/53_双向生成与基变换_形式规格.md`
- `examples/54_高阶拼接与基变换_复现.md`
- `review/55_高阶统一_批判审查.md`
- `planning/56_高阶统一下一阶段_形式化路线.md`
- `sources/57_高阶统一_最新文献归属.md`
- `lexicon/12_高维粘合_概念精注.md`（20 条）
- `software/wenhehua/higher_pasting_v8.py`
- `software/tests/test_higher_pasting_v8.py`
- `evidence/tests_v8.0.txt`

## 运行

```bash
cd software
PYTHONPATH=. python -m unittest discover -s tests -q
```

2026-11-24 的最新完整运行：**245 项全部通过（含 v7 的 232 项）**。新增代码的两个严格模型分别是「有边界的二维矩阵拼接」和「有限集合族上的基变换与跨接缝历史比较」；两者都不是一般高阶范畴结构的形式证明。

## 单一 ZIP

最终文件 `WenHeHua_Research_v8.0.zip` 包含本项目全部材料，包括以往版次的 PDF、核心 Markdown、代码、词库、图示、测试日志，和 v0.3–v6.0 历史发布的原始 ZIP。直接位于 `export/` 的三个 v8.0 PDF 为本轮最新阅读版；v7.0 也完整保留。

**归属**：double categories、structured cospans、monic spans of cospans、double computads、doubly weak double categories、intercategories、Beck–Chevalley、polygraphic coherence 的数学理论来自所列前人论文。本项目目前的新增工作是其整合、术语精化、受限证明、可执行反例和验证计划。
