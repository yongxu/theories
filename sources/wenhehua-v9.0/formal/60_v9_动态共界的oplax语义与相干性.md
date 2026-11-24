# v9 数学审查：动态图式、拼合与历史的余松比较

## 0. 结论与归属

v5–v8 的有限共界历史模型可以精确放进一个已有、相干律完整的标准构造：

\[
\operatorname{Span}(Q):\operatorname{Span}(\mathcal C^J)
\longrightarrow\operatorname{Span}(\mathcal C),\qquad
Q=\operatorname{colim}_J.
\]

这里 \(J\) 是固定有限图式，\(\mathcal C\) 有拉回与 \(J\)-型余极限。\(Q\) 一般不保拉回，因而 \(\operatorname{Span}(Q)\) 是 **normal oplax double functor（正规余松双函子）**，通常不是强双函子。其组合比较

\[
\kappa_{W,V}:Q(W\times_DV)\longrightarrow QW\times_{QD}QV
\]

正是旧模型的 \(\chi\)，不是仅仅同形的类比。所有有限时间分组的相干性由拉回的泛性质证明，不再依靠抽查三阶段或四阶段。

**文献归属：**任意函子在跨度构造上诱导上述正规余松双函子的事实，见 Michael Shulman, *Framed bicategories and monoidal fibrations*, TAC 20 (2008), 650–738，现行修订版 Example 6.3；亦见 Dawson–Paré–Pronk, *The span construction*, TAC 24 (2010), 302–377，§2.1。下文给出独立的专门化定义、逐项证明、旧代码对应与反例。不可把这项标准事实登记为本项目新发现。

**本轮实际增益：**识别旧模型的确切标准对象，补齐任意阶段比较的证明，建立与 Beck–Chevalley 的明确桥梁，并扩展到一般有限图式。它不自动给出全体文合化语法的忠实模型，也不等于已经构造完整 intercategory。

## 1. 底层与图式

固定有限类型集合 \(T\)，可取 \(\mathcal C=\mathsf{FinSet}/T\)。对象是有限带类型集合，态射是保持类型的全函数。它有拉回与有限余极限，均由带类型集合的标准构造得到。无类型情形取 \(T=\{*\}\)。

更一般地，以下定理只要求 \(\mathcal C\) 有拉回与相关余极限。有限有向图、固定有限 incidence schema 下的有限图式模型也适用：其有限极限与余极限逐分量计算。代码实现的有限集合范围和这个数学推广必须分开标注。

令 \(J\) 为有限小范畴，\(\mathcal D=\mathcal C^J\)。对象 \(D\) 是图式；态射 \(\eta:D\Rightarrow E\) 是自然变换。\(\mathcal D\) 的拉回逐对象计算。记

\[
Q(D)=\operatorname{colim}_JD,\quad
\iota^D_j:D(j)\to Q(D).
\]

对自然变换 \(\eta:D\Rightarrow E\)，\(Q\eta\) 是唯一满足

\[
(Q\eta)\iota^D_j=\iota^E_j\eta_j
\]

的态射。因为余极限注入族联合检测由余极限出发的态射，\(Q\) 保恒等与组合，故是函子。

**二块一缝专门化。**令 \(J\) 有三个对象 \(L,S,R\) 和两条非恒等箭头 \(S\to L,S\to R\)。一个图式就是

\[
D_L\xleftarrow{}D_S\xrightarrow{}D_R,
\quad QD=D_L\amalg_{D_S}D_R.
\]

这个形状在范畴论中是 span 形状。其余极限是 pushout；不能因为使用 pushout 就把原图式叫作 cospan。

## 2. 历史是图式范畴中的跨度

从 \(D_0\) 到 \(D_1\) 的历史是一个跨度

\[
H=(D_0\xleftarrow{\ell}W\xrightarrow{r}D_1)
\]

其中 \(W\in\mathcal D\)，两腿是自然变换。不要求它们单射。\(W\) 的元素是对应事件或来源见证；其数学地位不保证某个物理个体不变。

若 \(H=(D_0\leftarrow W\to D_1)\)、\(K=(D_1\leftarrow V\to D_2)\)，其时间合成的顶点为 \(W\times_{D_1}V\)，外腿由投影接原外腿。单位为 \(D\leftarrow D\to D\)。同端点的历史态射 \(h:H\to H'\) 是 \(h:W\to W'\)，满足两外腿的三角形交换。

这给出跨度双范畴 \(\operatorname{Span}(\mathcal D)\)：对象是 \(D\)，竖箭头是自然变换，横箭头是跨度，方块是三个竖向映射构成的交换图。横向跨度组合由拉回给出，结合与单位律一般通过典范同构成立；竖向方块组合是普通映射组合。只保留竖边恒等的方块就得到对应的跨度双范畴的水平 bicategory。

**坐标提醒。**标准 Span 文献把跨度放在横向。因此旧 Python 名称 `vertical`（时间合成）在这个标准模型中是跨度的横合。`horizontal`（空间粘合）成为函子 \(Q\) 对跨度的作用，不是另一个未经证明的二元箭头复合。可以整体转置坐标，但不能混用这两种“横纵”来宣布完成了更强的双范畴。

## 3. 定理 S1：拼合诱导正规余松双函子

### 精确陈述

设 \(\mathcal A,\mathcal B\) 有选定拉回，\(F:\mathcal A\to\mathcal B\) 是任意函子。逐项施加 \(F\) 给出正规余松双函子

\[
\operatorname{Span}(F):\operatorname{Span}(\mathcal A)
\to\operatorname{Span}(\mathcal B).
\]

对可接跨度顶点 \(W,V\) 及中间对象 \(D\)，组合比较是唯一态射

\[
\kappa^F_{W,V}:F(W\times_DV)\to FW\times_{FD}FV
\]

满足

\[
\pi_1\kappa^F_{W,V}=F\pi_1,
\qquad \pi_2\kappa^F_{W,V}=F\pi_2.
\]

单位比较为恒等。它保普通映射及方块的竖向复合；相干公理不要求 \(\kappa\) 可逆。

### 证明 1：比较存在且保持外边界

在 \(W\times_DV\) 上有 \(r_W\pi_1=\ell_V\pi_2\)。函子性给出

\[
F(r_W)F(\pi_1)=F(\ell_V)F(\pi_2),
\]

故 \((F\pi_1,F\pi_2)\) 是目标拉回的锥，唯一地诱导 \(\kappa\)。接任一外腿后，两边均等于原外腿复合投影的像，所以它确实是跨度之间的方块，而非无边界限制的集合函数。

### 证明 2：自然性

设 \(a:W\to W'\)、\(b:V\to V'\)、\(d:D\to D'\) 与两条中间腿相容。它们诱导 \(a\times_db\)。则

\[
\kappa^F_{W',V'}F(a\times_db)
=(Fa\times_{Fd}Fb)\kappa^F_{W,V}.
\]

将等式两侧分别接目标两投影：第一分量同为 \(Fa\,F\pi_1\)，第二分量同为 \(Fb\,F\pi_2\)。拉回的两投影联合单性给出相等。连同外端点映射，这就是双函子组合比较对一般方块的自然性。

### 证明 3：结合相干

简写跨度合成为 \(W\star V\)，典范结合子为

\[
a:(W\star V)\star U\xrightarrow{\cong}W\star(V\star U).
\]

从 \(F((W\star V)\star U)\) 到 \(FW\star(FV\star FU)\) 有两条公理要求相等的路径：

\[
a'\,(\kappa_{W,V}\star1)\,\kappa_{W\star V,U}
=(1\star\kappa_{V,U})\,\kappa_{W,V\star U}\,F(a).
\]

把终点视为三重拉回，两条路径接向 \(FW,FV,FU\) 的投影，都等于原三重拉回相应投影经 \(F\) 的像。三重拉回的投影族联合单，故相等。这是全称证明，不依赖元素有限或枚举。

### 证明 4：单位相干

\(F\) 把 \(D\xleftarrow{1}D\xrightarrow{1}D\) 逐项送到 \(FD\xleftarrow{1}FD\xrightarrow{1}FD\)，单位比较可取严格恒等，因此称 normal。这里并未声称任意选取的拉回单位子都是字面恒等。实际单位子 \(l,r\) 是典范同构，满足

\[
l_{FW}\kappa_{I,W}=F(l_W),\qquad
r_{FW}\kappa_{W,I}=F(r_W),
\]

因为两边向 \(FW\) 的投影均相同。以上定义与证明完成所需余松双函子公理。

### 推论 S1a：何时强保持时间合成

对某一可接对，\(\kappa_{W,V}\) 是同构，当且仅当 \(F\) 把对应拉回方块送为拉回方块。若 \(F\) 保所有拉回，则它是强双函子。反之，若所有跨度对的比较都可逆，则 \(F\) 保所有拉回：给定任意 \(X\xrightarrow f Z\xleftarrow gY\)，取两个跨度 \(X\xleftarrow{1}X\xrightarrow fZ\) 和 \(Z\xleftarrow gY\xrightarrow{1}Y\)，它们的组合比较恰为该拉回的比较。

“保真”在这里精确指这个拉回组合结构的保留；不等于 \(F\) 忠实，不等于模型在物理经验上充分。

## 4. 定理 S2：任意有限阶段的唯一比较与全部分组相干

给定可接的 \(n\) 个跨度顶点 \(W_1,\ldots,W_n\)，中间对象 \(D_1,\ldots,D_{n-1}\)。令

\[
P_n=W_1\times_{D_1}\cdots\times_{D_{n-1}}W_n
\]

表示平坦的有限拉回链极限，\(\pi_i:P_n\to W_i\)。存在唯一

\[
\kappa_n:F(P_n)\to
FW_1\times_{FD_1}\cdots\times_{FD_{n-1}}FW_n
\]

使第 \(i\) 个投影为 \(F\pi_i\)。\(n=1\) 时为恒等；零阶段取指定起点的单位跨度，其比较也为恒等；这里不要求范畴存在一个可代替所有起点的终对象。

**全分组相干证明。**任意二叉括号法、任意连续区段的分组、任意加入或去掉单位历史，都可通过二元 \(\kappa\)、源与目标的典范结合/单位同构生成一个从相应 \(F(P_n)\) 到目标平坦极限的态射。对该构造树归纳，每条最终投影必为 \(F\pi_i\)。因此所有这些态射都等于唯一的 \(\kappa_n\)。这覆盖每个有限 \(n\)，不是“已有若干低阶测试所以推测全部成立”。

注意代码的一段历史仍使用单元组标签，其与原见证的比较需要显式去掉单元组包装。数学上的一段比较取恒等，程序标签上的相等则按这个典范同构处理。

这项证明只覆盖此跨度比较的时间分组相干，不自动覆盖任意几何三维拼图、任意重写临界分支或任意 intercategory 公理。

## 5. 定理 S3：与 v5–v8 的逐项精确对应

以下已核对基线 `software/wenhehua/lineage.py` 和 `higher_comparison_v6.py` 的实际字段与算法。

| 旧构造 | 标准数学对象 | 精确条件 |
|---|---|---|
| `TSet`, `TMap` | \(\mathsf{FinSet}/T\) 的对象、态射 | 全函数且保类型 |
| `SeamState` | \(\mathcal C^J\) 对象 \(D\) | 三对象二箭头的图式 |
| `SeamStep` 的 left/seam/right witnesses | 图式 \(W\) | 两个 witness seam 映射 |
| `SeamStep` 的 old/new legs | 自然变换 \(W\Rightarrow D_0,D_1\) | 代码的四个交换方块检查恰好是自然性 |
| `vertical(first,second)` | \(\operatorname{Span}(\mathcal C^J)\) 的跨度复合 | 三分量逐项拉回 |
| `horizontal(step)` | \(\operatorname{Span}(Q)(H)\) | old、witness、new 分别取 pushout |
| `interchanger` | \(\kappa^Q_{W,V}\) | 从两个局部投影的商类诱导唯一映射 |
| `n_interchanger` | \(\kappa_n\) 的左嵌套命名实现 | 需用典范重括号同构比较其他命名 |

在二块一缝形状，\(Q(W\times_DV)\) 展开为

\[
(W_L\times_{D_L}V_L)
\amalg_{W_S\times_{D_S}V_S}
(W_R\times_{D_R}V_R),
\]

目标展开为

\[
(W_L\amalg_{W_S}W_R)
\times_{D_L\amalg_{D_S}D_R}
(V_L\amalg_{V_S}V_R).
\]

这与 v5 的 \(\chi\) 源、靶完全一致。源中的局部配对 \((w,v)\) 映为 \(([w],[v])\)。这就是旧代码对左右局部见证分别构造、再检查 seam 上一致的映射；泛性质给出全局唯一性。

**限定语。**旧代码没有所有跨度映射及范畴操作的 API，因此“精确对应”针对其数学数据与已实现操作；不能说旧软件已实现整个双范畴。命名编码、可变字典等工程问题也不能被数学定理消除。

## 6. 两种独立失真：漏掉与合并

### 6.1 非满射：局部没有，全局出现

中间状态 \(D_L,D_S,D_R\) 均为单点，接缝把左右点粘为一。第一历史只有左 witness，第二历史只有右 witness，两阶段 seam witnesses 均空。局部两阶段拉回在左右两边都空，所以源空；每阶段各自先粘合后，中点已相同，产生一个全局配对。

\[
\chi:\varnothing\to\{p\}.
\]

这就是旧 `example_interchange(full=False)`。它说明全局可接不保证局部同一分量的历史可接。

### 6.2 非单射：局部两个，全局合并

下例是本轮提出并独立交叉核验的对称反例。中间图式

\[
D_L=\{a\},\quad D_R=\{b\},\quad D_S=\{s_1,s_2\},
\]

两条 seam 映射都把 \(s_1,s_2\) 送到相应唯一侧点。第一 witness 图式

\[
W_L=\{u_1,u_2\},\;W_R=\{v\},\;W_S=\{x_1,x_2\},
\]

其中 \(x_i\mapsto u_i,v\)，且 \(x_i\mapsto s_i\)。第二 witness 图式

\[
V_L=\{p\},\;V_R=\{q_1,q_2\},\;V_S=\{y_1,y_2\},
\]

其中 \(y_i\mapsto p,q_i\)，且 \(y_i\mapsto s_i\)。两外端点图式可取各分量均单点的图式。

\(QW,QV,QD\) 都是单点，故目标拉回单点。逐项拉回的左点为 \((u_1,p),(u_2,p)\)，右点为 \((v,q_1),(v,q_2)\)，seam 只有 \((x_1,y_1),(x_2,y_2)\)，各连接相同下标的一对侧点，所以源的 pushout 有两个连通类。

\[
\chi:\{c_1,c_2\}\to\{c\}.
\]

因此一般 \(\chi\) 既不保证单射，也不保证满射。“全局总是比局部多出混合历史”并不是一般定理；它还可能合并可区分的局部历史。v8 只在特定窄模型中给出的 inclusion 不能外推到一般动态图式。

### 6.3 群作用的极简反例：保留相对关系

取 \(J=BC_2\)，即一对象、两个箭头 \(1,s\) 且 \(s^2=1\) 的有限范畴。\(\mathsf{FinSet}^J\) 的图式是有限 \(C_2\)-集合，\(Q\) 是取轨道集合。令 \(D\) 是平凡作用的单点，\(W=V=\{0,1\}\) 上 \(s\) 交换两个点。

\(W\times_DV=\{00,01,10,11\}\) 上是对角作用，有两个轨道 \(\{00,11\}\) 与 \(\{01,10\}\)。因此

\[
Q(W\times_DV)=\{\text{同向},\text{反向}\},\qquad
QW\times_{QD}QV=\{*\}.
\]

\(\chi\) 为二对一映射。联合系统保有的相对关系，在分别取轨道之后已无法复原。这直接把群作用、组合与观察信息联系起来；它是有限数学模型，不是对现实系统的额外物理断言。

对 \(n\ge1\) 个这样的二点 witness，局部 \(n\) 重拉回的轨道数为 \(2^{n-1}\)，逐个取轨道后的全局历史只有一个；所有分组仍满足 S2 的相干律。相干不保证可逆，也不保证不丢信息。

### 6.4 一个安全的 exact 片段

若 \(J\) 是离散有限索引，\(\mathcal C=\mathsf{FinSet}/T\)，则 \(Q\) 是带索引标签的不交并。任何自然变换保持索引，故

\[
\coprod_j(W_j\times_{D_j}V_j)
\cong(\coprod_jW_j)\times_{\coprod_jD_j}(\coprod_jV_j).
\]

右侧的相等要求索引相同，逐分量配对给出双射。因此这种无粘合识别的拼并保时间合成。非离散图式能否 exact，应检查相关拉回是否被 \(Q\) 保存，不可仅凭“边界合法”推断。

## 7. 定理 S4：把 Beck–Chevalley 真正接上

考虑源中拉回方块 \(P=W\times_DV\)，将 \(F\) 施加到四个顶点与箭头，得到交换方块

\[
\begin{array}{ccc}
FP&\xrightarrow{Fq}&FV\\
\scriptstyle Fp\downarrow&&\downarrow\scriptstyle Fs\\
FW&\xrightarrow{Fr}&FD.
\end{array}
\]

其拉回比较正是 \(\kappa:FP\to FW\times_{FD}FV\)。现在取 \(\mathcal B=\mathsf{Set}\) 或有限集合，设 \(E=(E_w)_{w\in FW}\) 是 \(FW\) 上的 family。对于主模型 \(\mathsf{FinSet}/T\)，先取底层集合即可：忘却函子创建拉回及有限余极限，而且带类型映射是同构当且仅当底层函数是双射，所以本判据也准确检测原带类型比较的可逆性。记 \(f^*\) 为 family 重索引，\(\Sigma_f\) 为沿纤维的不交并。存在自然 BC 映射

\[
\beta_E:\Sigma_{Fq}(Fp)^*E
\longrightarrow(Fs)^*\Sigma_{Fr}E.
\]

在 \(v\in FV\) 的纤维上，它是

\[
\coprod_{u\in FP:\,Fq(u)=v}E_{Fp(u)}
\longrightarrow
\coprod_{w\in FW:\,Fr(w)=Fs(v)}E_w,
\quad(u,e)\longmapsto(Fp(u),e).
\]

这个箭头定义良好恰因方块交换。它的方向在可逆时可倒转，和文献常见的 BC 同构写法一致。

**命题。**以下三件事等价：

1. \(\kappa\) 双射；
2. 上面经 \(F\) 得到的方块仍是拉回；
3. 对每个 family \(E\)，\(\beta_E\) 是自然同构。

**证明。**1 与 2 是拉回比较的基本特征。若 1，则每个相容 \((w,v)\) 有唯一 \(u\)，纤维映射的逆为 \((w,e)\mapsto(\kappa^{-1}(w,v),e)\)，得 3。若 3，取所有 \(E_w\) 都是单点的常值 family，则各 \(v\)-纤维映射就是 \(\kappa\) 的纤维映射；皆双射即 \(\kappa\) 双射。

因此 BC 不再是旁边的另一则类比。必须使用这个**具体由共界历史拉回经拼合所得的交换方块**，才得到与旧 \(\chi\) 的严格等价。随意另选一个 BC 方块并不能自动代表旧模型。

## 8. 定理 S5：多层解释的比较如何连接

设 \(F:\mathcal A\to\mathcal B\)、\(G:\mathcal B\to\mathcal E\)，三个范畴都有拉回。则在典范拉回识别下，

\[
\kappa^{GF}_{W,V}
=\kappa^G_{FW,FV}\circ G(\kappa^F_{W,V}).
\]

两边接向 \(GFW,GFV\) 的投影均为 \(GF\pi_1,GF\pi_2\)，故由唯一性相等。于是“先装配，再做领域解释”产生的比较可以因式分解为两层各自的比较。若领域解释 \(G\) 保所需拉回，它不新增这一类组合偏差。这里仍不能推断概率、因果、成本等语义也自动保真；它们需要另外指定的函子和结构。

## 9. 有限可变形状扩张：已证明的对象级方案，未宣称已实现

可定义 \(\mathsf{Diag}_{fin}(\mathcal C)\)：

- 对象为 \((J,D)\)，其中 \(J\) 是有限范畴，\(D:J\to\mathcal C\)。
- 态射 \((\phi,\eta):(J,D)\to(K,E)\) 由函子 \(\phi:J\to K\) 与自然变换 \(\eta:D\Rightarrow E\phi\) 构成。
- 组合为 \((\psi,\theta)(\phi,\eta)=(\psi\phi,(\theta\phi)\eta)\)。

**拉回存在。**给定两态射 \((J,D)\to(K,E)\leftarrow(L,H)\)，先在有限范畴中作严格拉回 \(P=J\times_KL\)。对对象 \((j,l)\)（两者映到相同 \(k\)），设

\[
M(j,l)=D(j)\times_{E(k)}H(l).
\]

对 \(P\) 中箭头，两个原图式的箭头由自然性给出相容对，故唯一诱导 \(M\) 的箭头；唯一性保证函子律。\((P,M)\) 连同显然的两投影给出总范畴中的拉回。验证泛性质：任意共同锥先由形状拉回得到唯一形状函子，再逐对象由 \(\mathcal C\) 的拉回得到唯一自然变换。这两次唯一性给出总范畴中的唯一性。

若 \(\mathcal C\) 有有限余极限，则 \(Q(J,D)=\operatorname{colim}_JD\) 仍是函子：态射 \((\phi,\eta)\) 的像由 cocone \(D(j)\xrightarrow{\eta_j}E(\phi j)\to\operatorname{colim}_KE\) 唯一诱导。于是 S1–S2 同样给出

\[
\operatorname{Span}(Q):
\operatorname{Span}(\mathsf{Diag}_{fin}(\mathcal C))
\longrightarrow\operatorname{Span}(\mathcal C).
\]

这个方案允许 witness 形状向旧、新形状分别映射。缺失对象可以表示无对应，非单射形状映射可以表示形状记录的合并。但语义仍是“对应”，不自动是合法的物理拆装。

**技术范围。**有限范畴不等于有向有限图的自由路径范畴：有环的自由路径范畴可能无限。一般有限网络可采用有限 incidence 范畴编码；若采用无限自由路径图式，需要另外证明所需余极限存在。固定 \(J\) 模型嵌入为形状映射都为恒等的子结构；它不在总范畴中自动是全子结构。这里不赋予相同 colimit 的不同形状同一性。

## 10. 如何接严格生成核，以及不能做什么

一个自由严格双范畴的语法只可通过保持它的方程的解释进入目标。最安全的严格模型是 \(\mathsf{Sq}(\mathcal C)\)：两类一箭头均为 \(\mathcal C\) 的态射，方块为交换方块，两个组合都是普通复合；严格交换律直接成立。它通常不忠实：固定四条边至多一个方块，不能保存不同历史证据。

\(\operatorname{Span}(Q)\) 是独立的语义装配模块，源和靶是跨度的弱双范畴，比较一般不可逆。不能把它直接称为任意自由 double computad 的严格解释，也不能先在语法中把“局部先合时间”与“全局先粘空间”判成同一二维胞腔，再加入一个三胞腔 \(\chi\) 声称恢复失去的区分。

有三条诚实的接口：

1. exact 语法解释只选取比较可逆且相干的子片段，并明确解释为严格、伪或经严格化后的函子；
2. 宽语法保留装配与时间合成的表达树，\(\chi\) 作为有向显式比较，解释到本文已证明的余松语义；
3. 若希望装配本身成为另一个内部组合方向，再构造并验证 intercategory 或其他多重结构。本文定理是其可复用组件，不能替代其全部公理。

### 一个闭合的历史路径语法接口

取有向图 \(G\)：顶点是选定的图式状态，每条生成边 \(h:D\to E\) 赋一个明确的图式历史跨度 \(\llbracket h\rrbracket=(D\leftarrow W_h\to E)\)。自由路径范畴 \(P(G)\) 给出时间语法；其箭头是有限可接词，空词是单位，串接严格结合。

对词 \(w=h_1\cdots h_n\)，定义局部解释 \(L(w)\) 为所有 witness 的平坦拉回链，空词解释为单位跨度。串接词与先分别求值再拉回之间存在由极限泛性质得到的典范同构，因此 \(L\) 是这个时间语法到跨度 bicategory 的伪函子。另定义：

\[
\operatorname{Late}(w)=Q(L(w)),\qquad
\operatorname{Early}(w)=Q(W_{h_1})\times_{QD_1}\cdots\times_{QD_{n-1}}Q(W_{h_n}).
\]

二者外边界相同。S2 给出的 \(\kappa_w\) 是从 Late 到 Early 的实际跨度映射。时间括号相干由 S2 给出；任意连续分块之间的宏细化相干由形式卷 67 §D3 进一步证明，后者使用到最终块的投影。Late 一般只是余松的组合解释，Early 是先解释原子再组合的伪函子解释；不能把 Late 也称为严格或伪函子而忽略非可逆 \(\kappa\)。

当前 `n_comparison` 与 `bracketed_comparison` 对已赋值的非空有限历史序列实现平坦及二叉括号求值；空词单位由 `didentity` 单独构造。一般宏管理及全部分块细化尚未封装为程序 API。这一接口也不替任意额外双向方胞生成元自动选择领域语义。

### 与既有相邻文献的区别

- Cicala 2018 的 monic spans of cospans 在 topos 等假设下满足交换律；本文一般非 monic、变 seam 历史不是该定理的直接对象，反例不反驳该定理。
- Baez–Courser 2020 的 structured-cospan 双范畴有清楚的界面映射、开放系统、交换方块；它也不自动把所有 lineage spans 当作同一类方块。
- Grandis–Paré 2015 的 intercategory 正是允许某些非可逆交换比较的标准三维结构，但要用它仍须逐项给出其单元、三种箭头/面、三维胞腔和相干数据。

## 11. 来源与检索锚点

仅列核实到原始出版物的资料。原文段落中的数学结果归原作者；上面展开的应用证明和反例计算是本次重构。

1. Michael Shulman. *Framed bicategories and monoidal fibrations*. Theory and Applications of Categories 20 (2008), 650–738. 现行修订版 Example 6.3 明述任意有拉回范畴之间的函子诱导 normal oplax double functor，保拉回时 strong。摘要页注明 2015-07-29 修订，旧预印本编号可能不同。<https://www.tac.mta.ca/tac/volumes/20/18/20-18abs.html>；论文 <https://www.tac.mta.ca/tac/volumes/20/18/20-18.pdf>。
2. Robert Dawson, Robert Paré, Dorette Pronk. *The span construction*. Theory and Applications of Categories 24 (2010), 302–377. §2.1 给出任意函子 \(F\) 的跨度比较方向 \(F(T\otimes_BS)\to FT\otimes_{FB}FS\)，称 oplax morphism of bicategories。<https://tac.mta.ca/tac/volumes/24/13/24-13abs.html>；论文 <https://www.tac.mta.ca/tac/volumes/24/13/24-13.pdf>。
3. Daniel Cicala. *Spans of cospans*. TAC 33 (2018), 131–147. <https://www.tac.mta.ca/tac/volumes/33/6/33-06abs.html>。
4. John C. Baez, Kenny Courser. *Structured cospans*. TAC 35 (2020), 1771–1822. <https://www.tac.mta.ca/tac/volumes/35/48/35-48abs.html>。
5. Marco Grandis, Robert Paré. *Intercategories*. TAC 30 (2015), 1215–1255. <https://tac.mta.ca/tac/volumes/30/38/30-38abs.html>。

## 12. 尚存 proof obligations 与诚实边界

- S1–S5 的数学证明已完整给出；它们不是 Lean/Coq 机器验证证明。
- 一般有限图式的实现应检查所有图式交换关系；只把有限有向图箭头当随意关系而不检查函子律，不能等同任意有限范畴图式。
- 对固定 incidence schema，可专门化为没有非恒等可复合箭头的有限图式；这个子类可避免显式复合表而保持数学正确。
- 任意生成核与这些语义之间的实际函子/余松解释仍须明确签名赋值及所保关系。
- 全部三维重写相干、higher critical pairs、终止性、合流性、忠实性、以及现实领域经验保真不由本定理推出。
- 审查发现 v8 的 pushout 字符串命名会发生分隔符碰撞，`TMap` 的内部 Mapping 也并非深度不可变。v9 已将旧模块的商类命名改为结构化 JSON，并复制冻结映射；新模块使用结构化元组标签。两类缺陷都有具体回归检查。历史输出保留原编码，跨版本比较应使用所载映射或显式同构。

