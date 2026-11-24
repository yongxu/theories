#!/usr/bin/env python3
"""Generate reproducible bilingual architecture diagrams for the Theory of Becoming.

Outputs:
  - theories/becoming/results/architecture.svg
  - theories/becoming/results/architecture.zh.svg

Visual and technical invariants (aligned with tools/research/spine.py & build_site.py):
  - Python standard library only, 100% deterministic output.
  - Editorial palette: paper #fcfcfb, primary ink #1c1917, muted #57534e,
    faint #a8a29e, border #d6d3d1, sand #f5f3ef, crimson #8c2f1e.
  - Generic system sans fonts only; zero <script>, zero external URLs,
    zero local machine paths; explicit width, height, and viewBox; min font >= 10.5px.
  - Built-in box-fit and non-overlap geometry checks on every text element.

Usage:
  python3 -B tools/research/architecture_map.py          # write both SVGs
  python3 -B tools/research/architecture_map.py --check  # verify files match generator
"""
from __future__ import annotations

import argparse
from dataclasses import dataclass
from pathlib import Path
import sys
from xml.sax.saxutils import escape

ROOT = Path(__file__).resolve().parents[2]
OUT_PATHS = {
    'en': ROOT / 'theories' / 'becoming' / 'results' / 'architecture.svg',
    'zh': ROOT / 'theories' / 'becoming' / 'results' / 'architecture.zh.svg',
}

W = 1200
MIN_FONT_PX = 10.5
PAPER = '#fcfcfb'
WHITE = '#ffffff'
SAND = '#f5f3ef'
SAND_ALT = '#f5f5f4'
INK = '#1c1917'
MUTED = '#57534e'
FAINT = '#a8a29e'
BORDER = '#d6d3d1'
CRIMSON = '#8c2f1e'
CRIMSON_TINT = '#fdf6f5'

FONT = {
    'en': 'Helvetica, Arial, sans-serif',
    'zh': "'PingFang SC', 'Hiragino Sans GB', 'Noto Sans CJK SC', 'Microsoft YaHei', sans-serif",
}


def fnum(x: float) -> str:
    return f'{x:.1f}'.rstrip('0').rstrip('.')


def conservative_text_width(body: str, size: float, bold: bool = False) -> float:
    """Conservative glyph-width upper bound (in px) to prevent box overflow across fonts."""
    w = 0.0
    for ch in body:
        if ord(ch) > 0x2E80:
            w += 1.06
        elif ch in "iljI.,;:!|'’·()[]{}/ ":
            w += 0.36
        elif ch in 'mwMW@#%&':
            w += 0.92
        elif ch.isupper() or ch.isdigit():
            w += 0.68
        else:
            w += 0.58
    return w * size * (1.08 if bold else 1.0)


@dataclass(frozen=True)
class Box:
    x: float
    y: float
    w: float
    h: float


class SvgBuilder:
    """Deterministic SVG collector with strict font-size, box-fit, and overlap checks."""

    def __init__(self, width: int, lang: str, title: str, desc: str) -> None:
        self.width = width
        self.lang = lang
        self.title = title
        self.desc = desc
        self.elements: list[str] = []
        self.text_checks: list[tuple[str, float, float, str, float, bool, Box | None, float]] = []
        self.peer_groups: dict[str, list[tuple[str, Box]]] = {}
        self.parent_checks: list[tuple[str, Box, Box]] = []

    def rect(
        self,
        x: float,
        y: float,
        w: float,
        h: float,
        *,
        rx: float = 6,
        fill: str = WHITE,
        stroke: str = BORDER,
        stroke_width: float = 1.0,
        dash: str = '',
        peer_group: str | None = None,
        box_name: str | None = None,
        parent: Box | None = None,
    ) -> Box:
        dash_attr = f' stroke-dasharray="{dash}"' if dash else ''
        self.elements.append(
            f'<rect x="{fnum(x)}" y="{fnum(y)}" width="{fnum(w)}" height="{fnum(h)}" '
            f'rx="{fnum(rx)}" fill="{fill}" stroke="{stroke}" stroke-width="{fnum(stroke_width)}"{dash_attr}/>'
        )
        b = Box(x, y, w, h)
        if peer_group is not None:
            self.peer_groups.setdefault(peer_group, []).append((box_name or f'box_{len(self.elements)}', b))
        if parent is not None:
            self.parent_checks.append((box_name or f'box_{len(self.elements)}', b, parent))
        return b

    def line(
        self,
        x1: float,
        y1: float,
        x2: float,
        y2: float,
        *,
        stroke: str = MUTED,
        stroke_width: float = 1.4,
        dash: str = '',
        marker_end: str = '',
    ) -> None:
        dash_attr = f' stroke-dasharray="{dash}"' if dash else ''
        end_attr = f' marker-end="url(#{marker_end})"' if marker_end else ''
        self.elements.append(
            f'<line x1="{fnum(x1)}" y1="{fnum(y1)}" x2="{fnum(x2)}" y2="{fnum(y2)}" '
            f'stroke="{stroke}" stroke-width="{fnum(stroke_width)}"{dash_attr}{end_attr}/>'
        )

    def text(
        self,
        x: float,
        y: float,
        body: str,
        *,
        size: float = 12,
        bold: bool = False,
        anchor: str = 'start',
        fill: str = INK,
        box: Box | None = None,
        pad_x: float = 8.0,
    ) -> None:
        weight_attr = ' font-weight="bold"' if bold else ''
        self.elements.append(
            f'<text x="{fnum(x)}" y="{fnum(y)}" font-size="{fnum(size)}"{weight_attr} '
            f'text-anchor="{anchor}" fill="{fill}">{escape(body)}</text>'
        )
        self.text_checks.append((body, x, y, anchor, size, bold, box, pad_x))

    def validate(self, total_height: int) -> list[str]:
        errors: list[str] = []
        # 1. Verify minimum font size and conservative container bounds
        for body, x, y, anchor, size, bold, box, pad_x in self.text_checks:
            if size < MIN_FONT_PX - 1e-6:
                errors.append(f'[{self.lang}] font-size {size} < {MIN_FONT_PX}: {body!r}')
            tw = conservative_text_width(body, size, bold)
            if anchor == 'start':
                left, right = x, x + tw
            elif anchor == 'middle':
                left, right = x - tw / 2, x + tw / 2
            else:
                left, right = x - tw, x
            if box is not None:
                if left < box.x + pad_x - 0.5 or right > box.x + box.w - pad_x + 0.5:
                    errors.append(
                        f'[{self.lang}] text overflows box X: {body!r} '
                        f'[{left:.1f}..{right:.1f}] vs box [{box.x + pad_x:.1f}..{box.x + box.w - pad_x:.1f}]'
                    )
                if y - size * 0.85 < box.y + 1.0 or y + size * 0.2 > box.y + box.h - 1.0:
                    errors.append(
                        f'[{self.lang}] text overflows box Y: {body!r} '
                        f'baseline {y:.1f} vs box [{box.y:.1f}..{box.y + box.h:.1f}]'
                    )
            else:
                if left < 12 or right > self.width - 12:
                    errors.append(
                        f'[{self.lang}] text overflows canvas X: {body!r} [{left:.1f}..{right:.1f}]'
                    )
                if y < 12 or y > total_height - 8:
                    errors.append(
                        f'[{self.lang}] text overflows canvas Y: {body!r} y={y:.1f}'
                    )
        # 2. Verify no two sibling boxes in the same peer group overlap
        for group_name, items in self.peer_groups.items():
            for i, (n1, b1) in enumerate(items):
                for n2, b2 in items[i + 1:]:
                    if not (
                        b1.x + b1.w <= b2.x + 0.5
                        or b2.x + b2.w <= b1.x + 0.5
                        or b1.y + b1.h <= b2.y + 0.5
                        or b2.y + b2.h <= b1.y + 0.5
                    ):
                        errors.append(f'[{self.lang}] {group_name} boxes overlap: {n1} and {n2}')
        # 3. Verify every child box sits strictly inside its parent container
        for cname, child, parent in self.parent_checks:
            if (
                child.x < parent.x + 2.0
                or child.y < parent.y + 2.0
                or child.x + child.w > parent.x + parent.w - 2.0
                or child.y + child.h > parent.y + parent.h - 2.0
            ):
                errors.append(f'[{self.lang}] child box {cname} escapes parent container')
        return errors

    def render(self, total_height: int) -> str:
        errors = self.validate(total_height)
        if errors:
            raise ValueError('\n'.join(errors))
        header = [
            f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {self.width} {total_height}" '
            f'width="{self.width}" height="{total_height}" role="img" '
            f'aria-labelledby="arch-title arch-desc" font-family="{escape(FONT[self.lang])}">',
            f'<title id="arch-title">{escape(self.title)}</title>',
            f'<desc id="arch-desc">{escape(self.desc)}</desc>',
            '<defs>',
            f'<marker id="arrow-ink" viewBox="0 0 10 10" refX="8.5" refY="5" markerWidth="7" markerHeight="7" orient="auto">'
            f'<path d="M0,1 L9,5 L0,9 z" fill="{INK}"/></marker>',
            f'<marker id="arrow-muted" viewBox="0 0 10 10" refX="8.5" refY="5" markerWidth="7" markerHeight="7" orient="auto">'
            f'<path d="M0,1 L9,5 L0,9 z" fill="{MUTED}"/></marker>',
            f'<marker id="arrow-crimson" viewBox="0 0 10 10" refX="8.5" refY="5" markerWidth="7" markerHeight="7" orient="auto">'
            f'<path d="M0,1 L9,5 L0,9 z" fill="{CRIMSON}"/></marker>',
            '</defs>',
            f'<rect x="0.5" y="0.5" width="{self.width - 1}" height="{total_height - 1}" rx="10" fill="{PAPER}" stroke="{BORDER}"/>',
        ]
        return '\n'.join(header + self.elements + ['</svg>']) + '\n'


SPEC = {
    'en': {
        'title': 'Theory of Becoming — Verification Stack (Tiers A–D) & Epistemic Boundaries',
        'desc': (
            'Four-tier verification stack supporting the three cooperating layers of Becoming: '
            'Tier A 0-axiom relational core (439 closure, 418 core modules, 31,170 decls, 22,056 thms, 0 axioms) '
            'from one relational root through 5 shared laws and 6 alignment pillars to AlignmentSpine, MasterSpine, and SharpnessSuite; '
            'Tier B isolated 16-module periphery (14 Mathlib v4.30.0-rc2 + 2 non-Mathlib v4.29.1, 0 stale) centered on FiniteProbKrylov '
            'plus 0-axiom standalone tracks (BecomingSpec 26 targets, EncounterEntry 35 thms, RelSpanEncounterAdapter 7 thms) and Mathlib-backed ConsequenceDuality tracks; '
            'Rule 2 model-to-world gap; '
            'Tier C stylised 6-test runtime (AI-authored hand-set flags) and empirical/stress walls with failures first '
            '(MQ3, UE31b, VD1, MQ7, EM1, IN1, LA2, B4 25-50% collapses, B5 4/11 failures P8-P11, Wave 2 B1/B2 bounds, 15/15 replay); '
            'dashed crimson not_entails firewall (no satisfiable dynamics-only law entails Unrestricted for every significance); '
            'Tier D Layer 3 ethics of 生生, 1,183 wisdom crosswalk entries, and human cold-read boundary.'
        ),
        'subtitle': 'Four verification tiers supporting 3 layers: (1) Coupled adaptive alignment · (2) 0-axiom ledger & 16-mod periphery · (3) 生生 ethics & wisdom',
        'metrics_1': '439 closure (418 core) · 31,170 decls · 22,056 thms · 0 axioms (v4.29.1, run 20261124T195858.526167Z) · 598 results (567 checked)',
        'metrics_2': '16 periphery (14 Mathlib + 2 non-Mathlib, 0 stale) · 220 dynamics (8 families) · 66 bound tests · 4 situations · 1,183 crosswalk',
        'l1a_head': 'TIER A  ·  0-AXIOM RELATIONAL CORE (Supports Layers 1 & 2 · Init-only, 0 sorry, no Mathlib)',
        'root_title': 'One Relational Root: Condition (缘) · Class (类) · Continuation (续)',
        'root_sub': 'Grammar · World · Web · Flow · WayUnderARule — what persists is re-made step by step',
        'laws_label': '5 Shared Laws (GrammarLaws)',
        'laws': [
            ('1. Closure', 'WithinClosure · blindness'),
            ('2. Balance', 'Flow.balances (not derived)'),
            ('3. Finite Runs', 'Lossless · rests · ends'),
            ('4. Lumping', 'GoAlikeUnder · causal map'),
            ('5. Widening', 'Web.Widens · pos. weights'),
        ],
        'pillars_label': '6 Structural Alignment Pillars (L0–L5 & Frontiers 1–2)',
        'pillars': [
            ('1. Blindness & Optimum Drain', 'Selection · Optimum · UnifiedDrawdown'),
            ('2. Capture & Detection Race', 'ClosedCapture · EndogenousEmergence · DetectionRace'),
            ('3. Cadence–Margin Deadlines', 'PacedStock · AdaptiveLoops · ActiveInquiryLoop'),
            ('4. Open / Poly / Epoch Composition', 'OpenComposition · PolyComposition · OpenEndedComposition'),
            ('5. RelSpan / Oplax & Causal', 'RelSpan (Span chi/BC) · OplaxHistory · DoubleKernel · Causal'),
            ('6. Endogenous Order & Scope', 'EndogenousOrder · ScopeDynamics · EvolutionaryDrawdown'),
        ],
        'spine_title': 'AlignmentSpine (L5)  &  MasterSpine (L2 WholeArchitecture)',
        'spine_sub1': 'whole_becoming_master_theorem lifts all 5 shared laws across modules',
        'spine_sub2': 'MultiScaleViability · TransformativeViability · StockFlowBridge',
        'sharp_title': 'SharpnessSuite (Failure Witnesses)',
        'sharp_sub1': 'CE01–CE10, CE14, WaterTank, slackDist',
        'sharp_sub2': 'separate countermodels dropping individual safeguards',
        'bridge_note': 'downstream imports only — 0-axiom core stays isolated',
        'l1b_head': 'TIER B  ·  ISOLATED 16-MODULE PERIPHERY (14 Mathlib + 2 non-Mathlib, 0 stale) & STANDALONE TRACKS',
        'periph_leaf_title': 'Shared Mathlib Leaf: FiniteProbKrylov (v4.30.0-rc2)',
        'periph_leaf_sub': 'FinDist · TV metric · Krylov rank stabilization · FiberLumpable B1–B2 join',
        'periph_boxes': [
            ('ObservationalFidelity', 'TV floor, Dobrushin, 0-TV split'),
            ('SurvivalDistinguishability', 'All mode words <= |S|-1'),
            ('QuantitativeTransfer', 'Rank-1 drift, aliasing, lag tube'),
            ('AlignmentReals & BecomingReals', 'CE12/13, MetricLaxSim, 9 reals modules'),
            ('RenewalBridge & FallibleInquiry', '2 non-Mathlib bridges (v4.29.1)'),
        ],
        'standalone_title': 'Standalone Checked Tracks',
        'standalone_lines': [
            '0-ax: BecomingSpec (26) & Adapter (7)',
            '0-ax: EncounterEntry (35 thms)',
            'Mathlib-backed: ConsequenceDuality',
            '  + DualityBridges + DualityLifting',
            '  + TrackBKrylovBridge -> Krylov',
        ],
        'rule2_pill': 'RULE 2 RECOGNITION GAP  —  Lean proves: if premises hold, conclusion holds; matching real systems stays fallible',
        'l2_head': 'TIER C  ·  STYLISED 6-TEST RUNTIME & EMPIRICAL STRESS WALLS (Rule 2 Gap — Failures First)',
        'rt_title': 'guarded-alignment-runtime (6-Test Proposal Grammar)',
        'rt_sub': 'Stylised AI specs (hand-set flags; exact Fraction -> GUARDED / OBSTRUCTED; 28 tests)',
        'rt_checks': [
            '1. coupling_closure',
            '2. self_refit_lock',
            '3. zero_tv_fiber_split',
            '4. pace_margin_deadline',
            '5. concurrent_reserve',
            '6. survival_distinguishability',
        ],
        'rt_foot': 'Mirrors DoubleKernel, OplaxHistory (RelSpan chi/BC), ObservationalFidelity & Krylov',
        'emp_title': 'Empirical Contact & Stress Walls (Failures First)',
        'emp_lines': [
            ('66 bound tests (4 fail · 20 mix · 5 pass · 37 other): MQ3, UE31b (T2), VD1, MQ7', True),
            ('Broken bridges: EM1 (FA leak) · IN1 (0/10 unseen; 1/10 vs 8/10 seen) · LA2 (1/9)', True),
            ('B4 full_guarded crashes 25–50% (drift 0.50, lag 0.45[luck], lr 0.25/0.70, alias 0.25)', False),
            ('B5: 4/11 failed (P8–P11; lag=8 marginal) · Wave 2 B1/B2 bounds · 15/15 replay', False),
        ],
        'firewall_l1': 'not_entails FIREWALL  —  No satisfiable law reading only the dynamics entails',
        'firewall_l2': 'the continuation condition (Unrestricted) for every significance assignment (free parameter)',
        'l3_head': 'TIER D  ·  BEYOND FIREWALL: LAYER 3 ETHICS OF 生生, WISDOM & AUDIT BOUNDARY',
        'l3_cards': [
            (
                'Layer 3: Ethics of 生生 (Beside Dynamics)',
                'Step of invariance · T8 lens: draw, end, bear',
                'Unrestricted & order enter only as hypotheses',
            ),
            (
                'Wisdom Crosswalk (1,183 Entries)',
                '28 groups · 248 Ch.06 classical passages',
                'AI-read agreements & gaps; speaks for no tradition',
            ),
            (
                'Human Cold Read & Rule 7 Boundary',
                'No independent human review recorded yet',
                '1-hr Audit Guide · 6 Dossiers · Mac-local hold',
            ),
        ],
        'footer': 'Generated deterministically by tools/research/architecture_map.py (stdlib only, zero scripts, zero external URLs). Synced to main receipt 20261124T195858.526167Z.',
    },
    'zh': {
        'title': '生灭变化之论——核验层级（A–D）与认知边界',
        'desc': (
            '支撑生灭变化之论三协同层的四重核验层级图：'
            '层级 A 为零公理关系核心（439 闭包、418 核心模块、31,170 声明、22,056 定理、0 公理），'
            '由单一关系之根经五条共律与六大结构支柱汇入 AlignmentSpine、MasterSpine 与 SharpnessSuite；'
            '层级 B 为隔离的 16 模块外围（14 个 Mathlib v4.30.0-rc2 + 2 个非 Mathlib v4.29.1，0 过期），'
            '锚定共享基叶 FiniteProbKrylov，并列零公理独立轨 BecomingSpec（26 目标）、EncounterEntry（35 定理）与 RelSpanEncounterAdapter（7 定理）及 Mathlib 支撑的对偶轨；'
            '规则二（Rule 2）识别边界；层级 C 为拟制 6 项守卫对齐运行时（AI 拟制手设旗标自评）与失败先报的经验/压力壁垒'
            '（66 绑定检验中 4 败 20 混 5 过 37 其他、B4 25–50% 崩溃、B5 4/11 预测失败、Wave 2 B1/B2 边界、15/15 证据重放）；'
            '虚线深红 not_entails 防火墙；层级 D 为第 3 层“生生”伦理、1,183 条智慧对照表与待人工冷读边界。'
        ),
        'subtitle': '四重核验层级支撑三协同层：(1) 耦合自适应对齐 · (2) 零公理台账与 16 外围模块 · (3) 智慧与“生生”伦理',
        'metrics_1': '核心：439 闭包（418 核心）· 31,170 声明 · 22,056 定理 · 0 公理（v4.29.1，回执 20261124T195858.526167Z）· 598 登记（567 已核）',
        'metrics_2': '16 外围（14 Mathlib + 2 非 Mathlib，0 过期）· 220 条动态（8 族）· 66 项绑定检验 · 4 情境 · 1,183 条智慧对照',
        'l1a_head': '层级 A  ·  零公理关系核心（支撑第 1–2 层 · 仅引入 Init，0 sorry，不含 Mathlib）',
        'root_title': '单一关系之根：缘（条件）· 类（同）· 续（延续）',
        'root_sub': 'Grammar · World · Web · Flow · WayUnderARule —— 凡持久者皆随步复造',
        'laws_label': '五条共律（GrammarLaws）',
        'laws': [
            ('1. 闭包', 'WithinClosure · 盲区边界'),
            ('2. 平衡', 'Flow.balances（表示，非推导）'),
            ('3. 有限运行', '无损复归 · 静止 · 终结'),
            ('4. 归并', 'GoAlikeUnder · 因果归并'),
            ('5. 扩大', 'Web.Widens · 正权重一致'),
        ],
        'pillars_label': '六大结构对齐支柱（L0–L5 与前沿 1–2）',
        'pillars': [
            ('1. 耦合外盲区与最优化耗竭', 'Selection · Optimum · UnifiedDrawdown'),
            ('2. 闭合捕获与内生检测竞速', 'ClosedCapture · EndogenousEmergence · DetectionRace'),
            ('3. 步调–余裕截止期与警报竞速', 'PacedStock · AdaptiveLoops · ActiveInquiryLoop'),
            ('4. 开放 / 多项式 / 跨代界面组合', 'OpenComposition · PolyComposition · OpenEndedComposition'),
            ('5. RelSpan / Oplax 与因果抽象', 'RelSpan (Span chi/BC) · OplaxHistory · DoubleKernel · Causal'),
            ('6. 内生次序与范围共生', 'EndogenousOrder · ScopeDynamics · EvolutionaryDrawdown'),
        ],
        'spine_title': 'AlignmentSpine (L5)  与  MasterSpine (L2 WholeArchitecture)',
        'spine_sub1': 'whole_becoming_master_theorem 跨模块提升全部五条共律',
        'spine_sub2': 'MultiScaleViability · TransformativeViability · StockFlowBridge',
        'sharp_title': 'SharpnessSuite（反模型 witnesses）',
        'sharp_sub1': 'CE01–CE10、CE14、WaterTank、slackDist',
        'sharp_sub2': '逐条拆去前提之分立具象反模型',
        'bridge_note': '仅向下游单向引入 —— 零公理核心保持严格隔离',
        'l1b_head': '层级 B  ·  孤立的 16 模块外围（14 Mathlib + 2 非 Mathlib，0 过期）与独立核验轨',
        'periph_leaf_title': '共享 Mathlib 基叶：FiniteProbKrylov（v4.30.0-rc2）',
        'periph_leaf_sub': 'FinDist · TV 度量 · Krylov 秩稳定 · FiberLumpable B1–B2 汇合',
        'periph_boxes': [
            ('ObservationalFidelity', 'TV 下界、Dobrushin、零TV分裂'),
            ('SurvivalDistinguishability', '长度 <= |S|-1 之全部模态词'),
            ('QuantitativeTransfer', '秩1漂移、混叠、滞后、信任管'),
            ('AlignmentReals & BecomingReals', 'CE12/13、MetricLaxSim、9 实数模块'),
            ('RenewalBridge & FallibleInquiry', '2 非 Mathlib 桥（v4.29.1）'),
        ],
        'standalone_title': '独立核验轨',
        'standalone_lines': [
            '零公理：BecomingSpec (26) / 适配器 (7)',
            '零公理：EncounterEntry (35 定理)',
            'Mathlib 支撑：ConsequenceDuality',
            '  + DualityBridges + DualityLifting',
            '  + TrackBKrylovBridge -> Krylov',
        ],
        'rule2_pill': '规则二边界 — Lean 只核验：前提成立则结论成立；实际系统是否满足前提，是可错的辨识（规则 2）',
        'l2_head': '层级 C  ·  拟制 6 项守卫对齐运行时与经验壁垒（规则二鸿沟 · 失败先报）',
        'rt_title': '守卫对齐运行时（6 项提案审计文法）',
        'rt_sub': 'AI 拟制示例规格（手设旗标自评；精确分数 -> GUARDED/OBSTRUCTED；28 单测）',
        'rt_checks': [
            '1. 耦合闭包 coupling_closure',
            '2. 自重拟合锁 self_refit_lock',
            '3. 零TV纤维分裂 fiber_split',
            '4. 步调余裕截止 pace_margin',
            '5. 并发共享耗竭 concurrent',
            '6. 生存可辨识 survival',
        ],
        'rt_foot': '对应 DoubleKernel、OplaxHistory (RelSpan chi/BC)、ObservationalFidelity 与 Krylov',
        'emp_title': '经验检验与神经对齐压力实验室（失败先报）',
        'emp_lines': [
            ('66 绑定检验（4 败 · 20 混 · 5 过 · 37 其他）：MQ3、UE31b(T2)、VD1、MQ7', True),
            ('断桥：EM1 (FA泄漏) · IN1 (不可见0/10；可见1/10对8/10) · LA2 (1/9批注翻转)', True),
            ('B4 full_guarded 崩溃 25–50%（漂移 0.50、滞后 0.45(含运)、lr 0.25/0.70、混叠 0.25）', False),
            ('B5：4/11 失败（P8–P11；lag=8 非净壁垒）· Wave 2 B1/B2 边界 · 15/15 重放', False),
        ],
        'firewall_l1': 'not_entails 防火墙  —  任何只读取动力学且可满足的律，都不蕴涵',
        'firewall_l2': '对一切意义赋值都成立的延续条件（Unrestricted），由自由参数构造成立',
        'l3_head': '层级 D  ·  防火墙之外：第 3 层“生生”伦理、智慧对照表与人工审查边界',
        'l3_cards': [
            (
                '第 3 层：“生生”伦理（并置非强推）',
                '不变之步 · T8 视角：取用、关闭与承担',
                'Unrestricted 与次序仅作显式假设引入',
            ),
            (
                '智慧对照表（1,183 条）',
                '28 组对照 · 第六章 248 段古文',
                'AI 试读之相合与分歧；不代表各传统发言',
            ),
            (
                '人工冷读与规则七边界',
                '尚无独立人工审查记录',
                '人工审计指南 · 六份审阅材料 · Mac 本地留存',
            ),
        ],
        'footer': '由 tools/research/architecture_map.py 确定性生成（仅用 Python 标准库，不含脚本，无外部链接）。图内中文为 AI 所写，英文与核心回执以 20261124T195858.526167Z 为准。',
    },
}


def build_svg(lang: str) -> str:
    s = SPEC[lang]
    svg = SvgBuilder(W, lang, s['title'], s['desc'])
    mx = 24
    inner_w = W - 2 * mx

    # Header
    svg.text(mx, 36, s['title'], size=20.5, bold=True, fill=INK)
    svg.text(mx, 58, s['subtitle'], size=12.0, fill=MUTED)

    m_box = svg.rect(mx, 72, inner_w, 48, rx=6, fill=SAND, stroke=BORDER)
    svg.text(W / 2, 92, s['metrics_1'], size=11.5, bold=True, anchor='middle', fill=INK, box=m_box)
    svg.text(W / 2, 111, s['metrics_2'], size=11.2, anchor='middle', fill=MUTED, box=m_box)

    # TIER A (0-Axiom Relational Core)
    l1a_y = 134
    l1a_h = 414
    l1a_box = svg.rect(mx, l1a_y, inner_w, l1a_h, rx=8, fill=SAND, stroke=BORDER, stroke_width=1.2, peer_group='tiers', box_name='tier_a')
    svg.text(mx + 14, l1a_y + 21, s['l1a_head'], size=12.2, bold=True, fill=INK, box=l1a_box)

    # Root box
    root_w = 760
    root_x = (W - root_w) / 2
    root_box = svg.rect(root_x, l1a_y + 32, root_w, 46, rx=6, fill=WHITE, stroke=INK, stroke_width=1.5, parent=l1a_box, box_name='root')
    svg.text(W / 2, root_box.y + 19, s['root_title'], size=13.0, bold=True, anchor='middle', fill=INK, box=root_box)
    svg.text(W / 2, root_box.y + 37, s['root_sub'], size=11.0, anchor='middle', fill=MUTED, box=root_box)

    # Root -> 5 Shared Laws connector
    laws_y = l1a_y + 98
    svg.line(W / 2, root_box.y + root_box.h, W / 2, laws_y - 2, stroke=INK, stroke_width=1.4, marker_end='arrow-ink')
    svg.text(W / 2 + 12, laws_y - 6, s['laws_label'], size=10.8, bold=True, fill=MUTED, box=l1a_box)

    # 5 Shared Laws row
    law_gap = 10
    law_pad = 14
    law_w = (inner_w - 2 * law_pad - 4 * law_gap) / 5
    law_h = 48
    for idx, (lname, lsub) in enumerate(s['laws']):
        lx = mx + law_pad + idx * (law_w + law_gap)
        lb = svg.rect(lx, laws_y, law_w, law_h, rx=5, fill=WHITE, stroke=MUTED, stroke_width=1.0, peer_group='laws', parent=l1a_box, box_name=f'law_{idx}')
        svg.text(lx + law_w / 2, laws_y + 19, lname, size=11.6, bold=True, anchor='middle', fill=INK, box=lb, pad_x=6)
        svg.text(lx + law_w / 2, laws_y + 37, lsub, size=10.5, anchor='middle', fill=MUTED, box=lb, pad_x=6)

    # Connector to 6 Pillars
    pil_label_y = laws_y + law_h + 17
    svg.text(mx + 14, pil_label_y, s['pillars_label'], size=10.8, bold=True, fill=MUTED, box=l1a_box)
    svg.line(W / 2, laws_y + law_h, W / 2, pil_label_y + 6, stroke=MUTED, stroke_width=1.2, marker_end='arrow-muted')

    # 6 Structural Alignment Pillars (3x2 grid)
    pil_y0 = pil_label_y + 10
    pil_gap_x = 12
    pil_gap_y = 10
    pil_w = (inner_w - 2 * law_pad - 2 * pil_gap_x) / 3
    pil_h = 48
    for idx, (ptitle, psub) in enumerate(s['pillars']):
        row, col = divmod(idx, 3)
        px = mx + law_pad + col * (pil_w + pil_gap_x)
        py = pil_y0 + row * (pil_h + pil_gap_y)
        pb = svg.rect(px, py, pil_w, pil_h, rx=5, fill=WHITE, stroke=MUTED, stroke_width=1.0, peer_group='pillars', parent=l1a_box, box_name=f'pillar_{idx}')
        svg.text(px + 10, py + 19, ptitle, size=11.5, bold=True, fill=INK, box=pb, pad_x=6)
        svg.text(px + 10, py + 37, psub, size=10.5, fill=MUTED, box=pb, pad_x=6)

    # Connectors down to AlignmentSpine/MasterSpine & SharpnessSuite
    spine_y = pil_y0 + 2 * pil_h + pil_gap_y + 16
    spine_w = 680
    sharp_w = inner_w - 2 * law_pad - spine_w - 12
    spine_x = mx + law_pad
    sharp_x = spine_x + spine_w + 12

    svg.line(spine_x + spine_w / 2, pil_y0 + 2 * pil_h + pil_gap_y, spine_x + spine_w / 2, spine_y - 2,
             stroke=INK, stroke_width=1.4, marker_end='arrow-ink')
    svg.line(sharp_x + sharp_w / 2, pil_y0 + 2 * pil_h + pil_gap_y, sharp_x + sharp_w / 2, spine_y - 2,
             stroke=CRIMSON, stroke_width=1.3, marker_end='arrow-crimson')

    spine_box = svg.rect(spine_x, spine_y, spine_w, 68, rx=6, fill=WHITE, stroke=INK, stroke_width=1.5, peer_group='spine_row', parent=l1a_box, box_name='spine_box')
    svg.text(spine_x + spine_w / 2, spine_y + 20, s['spine_title'], size=12.4, bold=True, anchor='middle', fill=INK, box=spine_box)
    svg.text(spine_x + spine_w / 2, spine_y + 39, s['spine_sub1'], size=10.6, anchor='middle', fill=MUTED, box=spine_box)
    svg.text(spine_x + spine_w / 2, spine_y + 56, s['spine_sub2'], size=10.5, anchor='middle', fill=MUTED, box=spine_box)

    sharp_box = svg.rect(sharp_x, spine_y, sharp_w, 68, rx=6, fill=CRIMSON_TINT, stroke=CRIMSON, stroke_width=1.3, peer_group='spine_row', parent=l1a_box, box_name='sharp_box')
    svg.text(sharp_x + sharp_w / 2, spine_y + 20, s['sharp_title'], size=12.2, bold=True, anchor='middle', fill=CRIMSON, box=sharp_box)
    svg.text(sharp_x + sharp_w / 2, spine_y + 39, s['sharp_sub1'], size=10.6, anchor='middle', fill=INK, box=sharp_box)
    svg.text(sharp_x + sharp_w / 2, spine_y + 56, s['sharp_sub2'], size=10.5, anchor='middle', fill=MUTED, box=sharp_box)

    # Tier A -> Tier B bridge
    l1b_y = l1a_y + l1a_h + 26
    svg.line(380, l1a_y + l1a_h, 380, l1b_y - 2, stroke=MUTED, stroke_width=1.4, dash='4 3', marker_end='arrow-muted')
    svg.text(394, l1a_y + l1a_h + 16, s['bridge_note'], size=10.8, fill=MUTED)

    # TIER B
    l1b_h = 190
    l1b_box = svg.rect(mx, l1b_y, inner_w, l1b_h, rx=8, fill=WHITE, stroke=FAINT, stroke_width=1.3, dash='6 4', peer_group='tiers', box_name='tier_b')
    svg.text(mx + 14, l1b_y + 21, s['l1b_head'], size=12.2, bold=True, fill=INK, box=l1b_box)

    # Left subpanel: 16-module periphery
    periph_x = mx + law_pad
    periph_w = 720
    stand_x = periph_x + periph_w + 12
    stand_w = inner_w - 2 * law_pad - periph_w - 12
    sub_y = l1b_y + 30
    sub_h = 148

    periph_panel = svg.rect(periph_x, sub_y, periph_w, sub_h, rx=6, fill=SAND_ALT, stroke=BORDER, peer_group='l1b_cols', parent=l1b_box, box_name='periph_panel')
    leaf_box = svg.rect(periph_x + 10, sub_y + 8, periph_w - 20, 42, rx=5, fill=WHITE, stroke=INK, stroke_width=1.2, peer_group='periph_rows', parent=periph_panel, box_name='leaf_box')
    svg.text(periph_x + periph_w / 2, sub_y + 24, s['periph_leaf_title'], size=11.5, bold=True, anchor='middle', fill=INK, box=leaf_box)
    svg.text(periph_x + periph_w / 2, sub_y + 41, s['periph_leaf_sub'], size=10.5, anchor='middle', fill=MUTED, box=leaf_box)

    # 5 periphery boxes below FiniteProbKrylov (top 3 + bottom 2)
    pb_y1 = sub_y + 57
    pb_gap = 8
    pb_w3 = (periph_w - 20 - 2 * pb_gap) / 3
    pb_h = 38
    for i, (ptitle, psub) in enumerate(s['periph_boxes'][:3]):
        bx = periph_x + 10 + i * (pb_w3 + pb_gap)
        b = svg.rect(bx, pb_y1, pb_w3, pb_h, rx=4, fill=WHITE, stroke=MUTED, stroke_width=0.9, peer_group='periph_cards', parent=periph_panel, box_name=f'periph_top_{i}')
        svg.text(bx + pb_w3 / 2, pb_y1 + 15, ptitle, size=10.6, bold=True, anchor='middle', fill=INK, box=b, pad_x=5)
        svg.text(bx + pb_w3 / 2, pb_y1 + 31, psub, size=10.5, anchor='middle', fill=MUTED, box=b, pad_x=5)

    pb_y2 = pb_y1 + pb_h + 7
    pb_w2 = (periph_w - 20 - pb_gap) / 2
    for i, (ptitle, psub) in enumerate(s['periph_boxes'][3:]):
        bx = periph_x + 10 + i * (pb_w2 + pb_gap)
        b = svg.rect(bx, pb_y2, pb_w2, pb_h, rx=4, fill=WHITE, stroke=MUTED, stroke_width=0.9, peer_group='periph_cards', parent=periph_panel, box_name=f'periph_bot_{i}')
        svg.text(bx + pb_w2 / 2, pb_y2 + 15, ptitle, size=10.6, bold=True, anchor='middle', fill=INK, box=b, pad_x=5)
        svg.text(bx + pb_w2 / 2, pb_y2 + 31, psub, size=10.5, anchor='middle', fill=MUTED, box=b, pad_x=5)

    # Right subpanel: Standalone Tracks
    stand_panel = svg.rect(stand_x, sub_y, stand_w, sub_h, rx=6, fill=SAND_ALT, stroke=BORDER, peer_group='l1b_cols', parent=l1b_box, box_name='stand_panel')
    svg.text(stand_x + 12, sub_y + 22, s['standalone_title'], size=11.5, bold=True, fill=INK, box=stand_panel)
    for i, line in enumerate(s['standalone_lines']):
        svg.text(stand_x + 12, sub_y + 44 + i * 22, line, size=10.5, fill=MUTED, box=stand_panel)

    # Rule 2 Recognition Gap Divider
    r2_y = l1b_y + l1b_h + 28
    svg.line(mx, r2_y, W - mx, r2_y, stroke=CRIMSON, stroke_width=1.4, dash='5 4')
    r2_w = 960
    r2_box = svg.rect((W - r2_w) / 2, r2_y - 15, r2_w, 30, rx=15, fill=CRIMSON_TINT, stroke=CRIMSON, stroke_width=1.2, peer_group='dividers', box_name='rule2')
    svg.text(W / 2, r2_y + 4, s['rule2_pill'], size=10.8, bold=True, anchor='middle', fill=CRIMSON, box=r2_box)

    # TIER C (Stylised Runtime & Empirical Stress)
    l2_y = r2_y + 28
    l2_h = 204
    l2_box = svg.rect(mx, l2_y, inner_w, l2_h, rx=8, fill=SAND, stroke=BORDER, stroke_width=1.2, peer_group='tiers', box_name='tier_c')
    svg.text(mx + 14, l2_y + 21, s['l2_head'], size=12.2, bold=True, fill=INK, box=l2_box)

    rt_x = mx + law_pad
    rt_w = 514
    emp_x = rt_x + rt_w + 12
    emp_w = inner_w - 2 * law_pad - rt_w - 12
    l2_sub_y = l2_y + 30
    l2_sub_h = 160

    rt_box = svg.rect(rt_x, l2_sub_y, rt_w, l2_sub_h, rx=6, fill=WHITE, stroke=INK, stroke_width=1.3, peer_group='l2_cols', parent=l2_box, box_name='rt_box')
    svg.text(rt_x + 12, l2_sub_y + 21, s['rt_title'], size=11.8, bold=True, fill=INK, box=rt_box)
    svg.text(rt_x + 12, l2_sub_y + 39, s['rt_sub'], size=10.5, fill=MUTED, box=rt_box)

    chk_gap_x = 8
    chk_gap_y = 7
    chk_w = (rt_w - 24 - chk_gap_x) / 2
    chk_h = 25
    for idx, label in enumerate(s['rt_checks']):
        col, row = divmod(idx, 3)
        cx = rt_x + 12 + col * (chk_w + chk_gap_x)
        cy = l2_sub_y + 49 + row * (chk_h + chk_gap_y)
        cb = svg.rect(cx, cy, chk_w, chk_h, rx=4, fill=SAND_ALT, stroke=BORDER, stroke_width=0.9, peer_group='rt_checks', parent=rt_box, box_name=f'rt_chk_{idx}')
        svg.text(cx + 8, cy + 16, label, size=10.5, bold=True, fill=INK, box=cb, pad_x=5)
    svg.text(rt_x + 12, l2_sub_y + 150, s['rt_foot'], size=10.5, fill=MUTED, box=rt_box)

    emp_box = svg.rect(emp_x, l2_sub_y, emp_w, l2_sub_h, rx=6, fill=CRIMSON_TINT, stroke=CRIMSON, stroke_width=1.4, peer_group='l2_cols', parent=l2_box, box_name='emp_box')
    svg.text(emp_x + 12, l2_sub_y + 21, s['emp_title'], size=11.8, bold=True, fill=CRIMSON, box=emp_box)
    for idx, (line, is_crimson) in enumerate(s['emp_lines']):
        ly = l2_sub_y + 52 + idx * 28
        svg.text(emp_x + 12, ly, line, size=10.5, bold=is_crimson, fill=CRIMSON if is_crimson else INK, box=emp_box)

    # Dashed Crimson not_entails Firewall (2 lines inside banner)
    fw_y = l2_y + l2_h + 34
    svg.line(mx, fw_y, W - mx, fw_y, stroke=CRIMSON, stroke_width=2.2, dash='9 5')
    fw_w = 940
    fw_box = svg.rect((W - fw_w) / 2, fw_y - 22, fw_w, 44, rx=22, fill=CRIMSON_TINT, stroke=CRIMSON, stroke_width=1.6, peer_group='dividers', box_name='firewall')
    svg.text(W / 2, fw_y - 4, s['firewall_l1'], size=10.8, bold=True, anchor='middle', fill=CRIMSON, box=fw_box)
    svg.text(W / 2, fw_y + 13, s['firewall_l2'], size=10.8, bold=True, anchor='middle', fill=CRIMSON, box=fw_box)

    # TIER D (Layer 3 Ethics, Wisdom & Audit Boundary)
    l3_y = fw_y + 36
    l3_h = 124
    l3_box = svg.rect(mx, l3_y, inner_w, l3_h, rx=8, fill=WHITE, stroke=MUTED, stroke_width=1.3, peer_group='tiers', box_name='tier_d')
    svg.text(mx + 14, l3_y + 21, s['l3_head'], size=12.2, bold=True, fill=INK, box=l3_box)

    c3_gap = 12
    c3_w = (inner_w - 2 * law_pad - 2 * c3_gap) / 3
    c3_h = 80
    c3_y = l3_y + 31
    for idx, (ctitle, cline1, cline2) in enumerate(s['l3_cards']):
        cx = mx + law_pad + idx * (c3_w + c3_gap)
        cb = svg.rect(cx, c3_y, c3_w, c3_h, rx=6, fill=SAND_ALT, stroke=BORDER, stroke_width=1.0, peer_group='l3_cards', parent=l3_box, box_name=f'l3_card_{idx}')
        svg.text(cx + c3_w / 2, c3_y + 21, ctitle, size=11.5, bold=True, anchor='middle', fill=INK, box=cb)
        svg.text(cx + c3_w / 2, c3_y + 44, cline1, size=10.5, anchor='middle', fill=MUTED, box=cb)
        svg.text(cx + c3_w / 2, c3_y + 65, cline2, size=10.5, anchor='middle', fill=MUTED, box=cb)

    # Footer
    footer_y = l3_y + l3_h + 24
    svg.text(mx, footer_y, s['footer'], size=10.5, fill=MUTED)
    total_height = footer_y + 18
    return svg.render(total_height)


def check_or_write(check_only: bool) -> int:
    errors: list[str] = []
    for lang, path in OUT_PATHS.items():
        rendered = build_svg(lang)
        if check_only:
            if not path.is_file():
                errors.append(f'missing generated SVG: {path}')
            else:
                current = path.read_text(encoding='utf-8')
                if current != rendered:
                    errors.append(f'out-of-date SVG: {path} (run python3 -B tools/research/architecture_map.py)')
        else:
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(rendered, encoding='utf-8')
            print(f'wrote {path.relative_to(ROOT)} ({len(rendered)} bytes)')
    if errors:
        for err in errors:
            print(err, file=sys.stderr)
        return 1
    if check_only:
        print('architecture_map.py --check: OK (both SVGs match generator)')
    return 0


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description='Generate or check bilingual Becoming architecture SVGs.')
    parser.add_argument('--check', action='store_true', help='verify existing SVGs match deterministic output')
    args = parser.parse_args(argv)
    return check_or_write(args.check)


if __name__ == '__main__':
    raise SystemExit(main())
