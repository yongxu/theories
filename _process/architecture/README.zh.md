<a id="repository-architecture-repair--仓库架构修正"></a>
# 仓库架构修正

> **中文版（2026-10-17）。** 正典文本是[英文版](README.md)；本版由重构时从双语原文拆出，不与英文同步维护，两者有出入时以英文为准。

当前概览由成果与授权记录生成，不再由各会话反复追加竞争的状态段落。稳定工具与旧命令兼容；完成范围、原反例、原证明与实际工作位置保持。检索区分工作源码和冻结证据，依赖区分正式复用、应用、解释及关联。

<a id="preservation-and-reconciliation"></a>

<a id="validation-and-remaining-scope"></a>

<a id="directory-renames-9-october-2026--目录改名"></a>
## 目录改名

| 旧路径 | 现路径 |
|---|---|
| `theories/shengsheng-buxi-generative-existence/` | [`theories/becoming/`](../../theories/becoming/README.md) |
| `theories/shengsheng-buxi-generative-existence/unified-2026-10-05/` | [`theories/becoming/chapters/`](../../theories/becoming/history/THE-THEORY-OF-BECOMING.md) |

```sh
python3 -B _process/architecture/check_rename.py
```

两处目录改名，使路径说出所放之物；移动本身不改任何文件内容。现行引用按五条有序规则改写，规则只匹配路径位置上的完整路径成分。指令记录只改 Markdown 链接目标，引用 Ren 原话的行不动。证据保留原字节与旧路径，按上表读。回执逐一列出改写文件改名前后的哈希，以及沿用的已审哈希：只有文件原本与之相符、且新字节恰为旧字节的替换时才沿用。因此各登记的新鲜程度与改名前相同。检查器从基准提交重新推出每个改写文件并核对哈希。
