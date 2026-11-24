from pathlib import Path
import cairosvg
R=Path(__file__).resolve().parent; f=R/'figures';f.mkdir(exist_ok=True)
SVG1='''<svg xmlns="http://www.w3.org/2000/svg" width="1000" height="310" viewBox="0 0 1000 310">
<rect width="1000" height="310" fill="#fff"/>
<text x="250" y="34" text-anchor="middle" font-family="Noto Sans CJK SC" font-size="22" fill="#132b35" font-weight="bold">旧阶段 · 一条共享接缝</text>
<text x="750" y="34" text-anchor="middle" font-family="Noto Sans CJK SC" font-size="22" fill="#132b35" font-weight="bold">新阶段 · 接缝新增通道</text>
<g stroke="#1e6a6b" stroke-width="3" fill="#eef8f7"><rect x="55" y="75" width="145" height="180" rx="15"/><rect x="300" y="75" width="145" height="180" rx="15"/>
<rect x="555" y="75" width="145" height="180" rx="15"/><rect x="800" y="75" width="145" height="180" rx="15"/></g>
<g font-family="Noto Sans CJK SC" font-size="24" fill="#153439" text-anchor="middle"><text x="127" y="165">A₀</text><text x="373" y="165">B₀</text><text x="628" y="165">A₁</text><text x="873" y="165">B₁</text></g>
<g stroke="#257f82" stroke-width="5" fill="none"><path d="M200 150H300"/><path d="M700 125H800"/></g>
<path d="M700 202H800" stroke="#d17a33" stroke-width="5"/>
<g font-family="Noto Sans CJK SC" fill="#15585a" font-size="15" text-anchor="middle"><text x="250" y="139">原有 N 通道</text><text x="750" y="111">持续的 N</text></g>
<text x="750" y="225" text-anchor="middle" font-family="Noto Sans CJK SC" font-size="16" fill="#ba6f2d">新生 T 通道</text>
<path d="M466 165H534" stroke="#64748b" stroke-width="3" stroke-dasharray="7,6"/>
<path d="M528 158L537 165L528 172" fill="none" stroke="#64748b" stroke-width="3"/>
<text x="500" y="289" text-anchor="middle" font-family="Noto Sans CJK SC" font-size="18" fill="#344b53">τ: 旧 0 ↦ 新 0；新增通道不宣称来自旧接口</text>
</svg>'''
SVG2='''<svg xmlns="http://www.w3.org/2000/svg" width="1000" height="285" viewBox="0 0 1000 285">
<rect width="1000" height="285" fill="white"/>
<g font-family="Noto Sans CJK SC" text-anchor="middle" fill="#16343c" font-size="21"><text x="165" y="32">初 · 两个独立身份</text><text x="500" y="32">中 · 暂时共同接缝</text><text x="835" y="32">末 · 再次分离</text></g>
<g stroke="#246c70" stroke-width="3" fill="#edf6f5"><rect x="45" y="74" width="100" height="90" rx="12"/><rect x="185" y="74" width="100" height="90" rx="12"/><rect x="377" y="74" width="100" height="90" rx="12"/><rect x="517" y="74" width="100" height="90" rx="12"/><rect x="710" y="74" width="100" height="90" rx="12"/><rect x="850" y="74" width="100" height="90" rx="12"/></g>
<g font-size="26" font-family="Noto Sans CJK SC" text-anchor="middle" fill="#16343c"><text x="95" y="127">a</text><text x="235" y="127">b</text><text x="427" y="127">a</text><text x="567" y="127">b</text><text x="760" y="127">a</text><text x="900" y="127">b</text></g>
<path d="M477 120H517" stroke="#d17a33" stroke-width="6"/><circle cx="497" cy="120" r="11" fill="#d17a33"/>
<g stroke="#627a86" stroke-width="2.5" fill="none"><path d="M294 119H365"/><path d="M358 112L367 119L358 126"/><path d="M630 119H698"/><path d="M691 112L700 119L691 126"/></g>
<g font-family="Noto Sans CJK SC" text-anchor="middle" font-size="17" fill="#6b4b2c"><text x="495" y="187">a 与 b 在整体推积中发生识别</text><text x="500" y="225" fill="#284a54">“连接”不是“两个互异身份均持续”的证明</text><text x="500" y="258" fill="#546773">逐步保守弱化会遗失部分可追溯信息</text></g>
</svg>'''
for name,svg in [('共界新生',SVG1),('暂合复分_身份冲突',SVG2)]:
    (f/(name+'.svg')).write_text(svg,encoding='utf-8')
    cairosvg.svg2png(bytestring=svg.encode('utf-8'),write_to=str(f/(name+'.png')),output_width=1800)
    print(name)
