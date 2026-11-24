# v9.0 最终运行证据与复现

## 实际结果

2026-11-24 的最终完整运行发现并执行 **313 个 unittest 测试方法，313 个通过，退出码 0**。unittest 报告运行时间 1.311 秒；外层进程墙钟时间约 1.704 秒。时间仅描述本次环境，不是性能基准。

语法内核演示与语义演示也分别成功运行，退出码均为 0，标准输出均通过 JSON 解析。

**计数分开：313 是单元测试方法数。语义演示另计算 6 个模型实例，每例验证四阶段的 5 种有序二叉括号，共 30 次括号实例检查。不能把这 30 次再加到单元测试数上。** 演示执行有限实例；一般相干性由研究正文的证明承担。

## 证据文件

| 文件 | 内容 |
|---|---|
| `tests_v9.0.txt` | 最终完整命令、工作目录、选定环境、退出码、实际测试数及完整 stdout/stderr |
| `v9_test_results.txt` | 与上一文件完全相同的副本 |
| `v9_test_results.json` | 最终测试结果与环境的机器可读摘要 |
| `v9_demo_kernel.json` | 原始项、结构证书、有向重写、三维构造演示的合法 JSON |
| `v9_demo_semantics.json` | 6 个有限模型的比较映射、BC 实例与 30 次括号实例检查 |
| `v9_demo_runs.json` | 两次演示的命令、时间、退出码、stderr 及输出文件名 |
| `v9_test_discovery_default.txt`、`.json` | 首次默认发现未进入测试目录而运行 0 个测试的完整记录 |

本轮没有增加或修改测试、模型或正式研究文稿，只生成最终运行证据。

## 实测环境

| 项目 | 实际值 |
|---|---|
| Python | 3.12.14 |
| Python executable | `/opt/codex/runtimes/codex-primary-runtime/dependencies/python/bin/python3` |
| NetworkX | 3.7 |
| Platform | Linux-6.18.57-x86_64-with-glibc2.41 |
| 附加依赖目录 | `/workspace/scratch/4d585e40cdc3/tmp/test_dependencies` |
| 运行目录 | `/workspace/scratch/4d585e40cdc3/WenHeHua_Research_v9.0/software` |

NetworkX 的版本和实际模块路径由同一环境中的 Python 直接导入读取，详见结果 JSON。

## 依赖范围

v9 新增的 `generative_v9.py`、`higher_cells_v9.py` 与 `diagrammatic_v9.py` 使用 Python 标准库。两个 v9 演示脚本同样没有新增第三方依赖。

继承的完整测试套件包含图同构验证，需要 NetworkX；项目的 `software/requirements-test.txt` 声明 `networkx>=3.0`，本次实际使用 3.7。因此应说“新内核使用标准库”，不能说“完整历史套件不需要第三方依赖”。临时依赖目录属于本次执行环境，不是研究包中的可移植路径。

## 本次准确命令

在上述 `software` 目录运行：

```bash
PYTHONPATH=/workspace/scratch/4d585e40cdc3/tmp/test_dependencies python3 -m unittest discover -s tests -v
PYTHONPATH=/workspace/scratch/4d585e40cdc3/tmp/test_dependencies python3 demo_v9_kernel.py
PYTHONPATH=/workspace/scratch/4d585e40cdc3/tmp/test_dependencies python3 demo_v9_semantics.py
```

本次实际子进程用实测环境表中列出的 Python 完整路径启动；环境变量与以上等价。

默认 `python3 -m unittest discover -v` 在本次 Python 环境没有递归进入缺少 `__init__.py` 的 `tests` 目录，运行 0 个测试并返回退出码 5。随后明确指定 `-s tests`，完整发现 313 个测试。这个运行命令修正没有改动项目代码；保留首次发现记录是为了避免把“0 个测试且未执行”误报为通过。

## 在另一台机器复现

从解压后的研究包进入 `software` 目录，使用兼容 Python。本次精确依赖版本可这样安装并运行：

```bash
python3 -m pip install networkx==3.7
python3 -m unittest discover -s tests -v
python3 demo_v9_kernel.py
python3 demo_v9_semantics.py
```

若依照项目声明而不固定本次依赖版本，可将安装命令改为 `python3 -m pip install -r requirements-test.txt`。这种环境与本次精确版本有所不同，应另行保留自己的运行结果。

## 证明边界

313 个测试覆盖实现中的构造、语义、反例、拒绝路径与历史回归；30 次演示括号检查覆盖选定有限实例。二者均不构成 Lean/Coq 等证明助理核验，不替代任意图式、任意阶段数及高阶商结构的数学证明。
