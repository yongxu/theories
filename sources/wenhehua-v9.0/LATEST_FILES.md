# v9.0 最新文件导航

## 三份最新 PDF

- `export/文合化_v9.0_严格高阶生成专论.pdf`：本轮研究、证明、反例、审查和路线。
- `export/文合化_v9.0_理论全集.pdf`：本轮在前，完整继承 v8 理论汇编。
- `export/文合化_v9.0_概念词林.pdf`：本轮严格词谱与历次词库。

## 按问题阅读

| 问题 | 文件 |
|---|---|
| 核心结构是什么？ | `research/58_v9_严格高阶生成框架.md` |
| 二维自由性质与保守升维如何证明？ | `formal/59_v9_自由双范畴与相对三维生成.md` |
| 动态接缝、余松比较、BC 如何连接？ | `formal/60_v9_动态共界的oplax语义与相干性.md` |
| 生成语法怎样进入历史语义？ | `formal/67_v9_生成历史的语法语义接口.md` |
| 并排与任意有限阶如何接入？ | `formal/66_v9_并排组合与任意有限阶.md` |
| 如何分清观察误差与历史区别？ | `formal/61_v9_基变换与观察保真.md` |
| 反例怎样构造、输出是什么？ | `examples/62_v9_构造与反例.md` |
| 哪些已证明、已实现、仍开放？ | `review/63_v9_证明状态与交叉审查.md` |
| 下一阶段具体怎么验收？ | `planning/64_v9_形式化与应用路线.md` |
| 原始文献和归属在哪里？ | `sources/65_v9_原始文献与归属.md` |
| 词汇怎样精确使用？ | `lexicon/13_v9_严格生成词谱.md` |

## 程序与证据

- 三个新模块：`software/wenhehua/generative_v9.py`、`higher_cells_v9.py`、`diagrammatic_v9.py`。
- 演示入口：`software/demo_v9_kernel.py`、`software/demo_v9_semantics.py`。
- 完整测试日志：`evidence/tests_v9.0.txt`；摘要 `evidence/v9_test_results.json`。
- 原始演示输出：`evidence/v9_demo_kernel.json`、`evidence/v9_demo_semantics.json`。
- 复现说明：`evidence/v9_reproduction.md`。
- PDF 校对：`evidence/QA_REPORT_v9.0.md`。
- 三幅精确图示：`figures/v9_*.pdf`、同名 `.svg`、`.png`。
- 完整性检查：`manifest.json`、`SHA256SUMS.txt`、`verify_release_v9.py`。

历史来源包的替换前根文件与旧模块保留在 `historical_metadata/v8/`。历史结论以本轮证明状态表中的明确范围为准。
