from pathlib import Path
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch, FancyArrowPatch
from matplotlib.font_manager import FontProperties
R=Path(__file__).resolve().parent/'figures'
R.mkdir(exist_ok=True)
font=FontProperties(fname='/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc')

fig,ax=plt.subplots(figsize=(11,5.3),dpi=190)
fig.patch.set_facecolor('white');ax.set_facecolor('white');ax.set_xlim(0,11);ax.set_ylim(0,5.3);ax.axis('off')

def box(x,y,title,sub,color):
    ax.add_patch(FancyBboxPatch((x,y),3,1.25,boxstyle='round,pad=0.13,rounding_size=0.18',
                               linewidth=1.8,edgecolor=color,facecolor='#f7fbfa'))
    ax.text(x+1.5,y+.81,title,fontproperties=font,ha='center',va='center',fontsize=15,color=color)
    ax.text(x+1.5,y+.39,sub,fontproperties=font,ha='center',va='center',fontsize=10.5,color='#3a4a55')
box(.55,3.45,'左系统 A0','输入 1 · 接缝 1','#126b63')
box(7.45,3.45,'右系统 B0','接缝 1 · 输出 1','#126b63')
box(.55,.65,'左系统 A1','输入 2 · 接缝 1','#2366a8')
box(7.45,.65,'右系统 B1','接缝 1 · 输出 2','#2366a8')
for y,tag in [(4.06,'旧接缝 J0'),(1.26,'新接缝 J1')]:
    ax.add_patch(FancyArrowPatch((3.7,y),(7.4,y),arrowstyle='-|>',mutation_scale=15,lw=2,color='#788392'))
    ax.text(5.5,y+.32,tag,fontproperties=font,ha='center',fontsize=11,color='#46566d')
for x in (2.05,8.95):
    ax.add_patch(FancyArrowPatch((x,3.41),(x,1.96),arrowstyle='-|>',mutation_scale=18,lw=1.9,color='#a66b35'))
ax.text(5.5,2.7,'接缝身份完整延续；外部接口允许改变',fontproperties=font,ha='center',fontsize=12,color='#263842')
ax.text(5.5,.1,'有限模型的水平相容条件：共享处须有一致的持续身份迹',fontproperties=font,ha='center',fontsize=10,color='#536375')
for ext in ('png','svg'):
    fig.savefig(R/f'界变稳定接缝.{ext}',bbox_inches='tight',pad_inches=.17)
plt.close(fig)

fig,ax=plt.subplots(figsize=(10.5,4.9),dpi=190)
fig.patch.set_facecolor('white');ax.set_facecolor('white');ax.set_xlim(0,10.5);ax.set_ylim(0,4.9);ax.axis('off')
def mini(x,y,title,sub,edge):
    ax.add_patch(FancyBboxPatch((x,y),3.15,1.45,boxstyle='round,pad=0.13,rounding_size=.2',
                               linewidth=1.8,facecolor='#f9fbfb',edgecolor=edge))
    ax.text(x+1.575,y+.94,title,fontproperties=font,ha='center',fontsize=13.5,color=edge)
    ax.text(x+1.575,y+.42,sub,fontproperties=font,ha='center',fontsize=11,color='#3a4a55')
mini(.4,2.7,'微态 x0','接口：温度','#126b63')
mini(6.95,2.7,'微态 x1','接口：温度、湿度','#126b63')
for x in (1.95,8.55):
    ax.add_patch(FancyArrowPatch((x,2.63),(5.25,1.5),arrowstyle='-|>',mutation_scale=16,lw=1.8,color='#64748b') if x<5 else FancyArrowPatch((x,2.63),(5.25,1.5),arrowstyle='-|>',mutation_scale=16,lw=1.8,color='#64748b'))
mini(3.65,.22,'宏态 X','映射相同，但严格接口不保真','#b45a43')
ax.text(5.25,1.82,'α(x0) = α(x1)',ha='center',fontsize=12,color='#354756')
ax.text(5.25,4.62,'观守反例：同一宏观标签 ≠ 相同可交互方式',fontproperties=font,ha='center',fontsize=14,color='#263842')
for ext in ('png','svg'):
    fig.savefig(R/f'观守接口反例.{ext}',bbox_inches='tight',pad_inches=.17)
plt.close(fig)
print('figures built')
