# v0.4 相对表达核心

先读 [最小文法相对结果.md](最小文法相对结果.md)。本目录证明 G1 的22种命题／过程构式可归约到13种候选构式，并给出限定局部片段的可达性下界；不宣称最小不可约基。

```text
python3 normalizer.py --check
```

只需 Python 标准库。发布版依赖 `../core/wenli.py`；工作副本回退读取旧10号解释器。`--check` 重算并核对保存的 [results.json](results.json)，不重写文件；不加参数会重算并更新结果。

库接口为 `Normalizer(model_data).formula(ast)` 与 `.program(ast)`。先按G1验证输入，返回只含G0构式、绑定已改名、引用已展开的JSON树。类型错误抛 `GrammarError`；实现的构造预算或递归深度限制抛 `NormalizationLimit`。

[lower_bound_review.md](lower_bound_review.md) 保存独立核对的双链证明。主验证还包括10组具体双链见证。一般结论来自证明，有限实例用于核验实现与反例构造。
