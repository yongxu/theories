"""Exact vector figures for v9; no generated imagery or external assets."""
from pathlib import Path
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib import font_manager
from matplotlib.patches import FancyArrowPatch, Ellipse

R=Path(__file__).resolve().parent
O=R/'figures';O.mkdir(exist_ok=True)
font='/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc'
font_manager.fontManager.addfont(font)
plt.rcParams.update({'font.family':font_manager.FontProperties(fname=font).get_name(),
                     'axes.unicode_minus':False,'svg.fonttype':'path','pdf.fonttype':3})
BLUE='#205878';TEAL='#15766B';ORANGE='#BA652B';GRAY='#64717D'


def save(fig,name):
    for ext in ('pdf','svg','png'):
        fig.savefig(O/(name+'.'+ext),dpi=180,bbox_inches='tight',facecolor='white')
    plt.close(fig)


fig,axs=plt.subplots(1,3,figsize=(10,3.4))
cases=[(1,1,{0:0},'完整对应','单射：是    满射：是'),
       (2,4,{0:0,1:3},'缺少整体历史','单射：是    满射：否'),
       (2,1,{0:0,1:0},'合并局部历史','单射：否    满射：是')]
for ax,(n,m,mp,title,foot) in zip(axs,cases):
    ax.set(xlim=(-.35,1.35),ylim=(-.25,1.3));ax.axis('off')
    ys=[.5] if n==1 else [1-i/(n-1) for i in range(n)]
    yt=[.5] if m==1 else [1-i/(m-1) for i in range(m)]
    for i,j in mp.items():
        ax.add_patch(FancyArrowPatch((.04,ys[i]),(.94,yt[j]),arrowstyle='-|>',
                     mutation_scale=12,lw=1.6,color=BLUE,connectionstyle='arc3,rad=0'))
    ax.scatter([0]*n,ys,s=90,color=BLUE,zorder=4)
    for j,y in enumerate(yt):
        covered=j in mp.values()
        ax.scatter([1],[y],s=90,facecolors=TEAL if covered else 'white',
                   edgecolors=TEAL if covered else ORANGE,linewidth=1.7,zorder=4)
    ax.text(.5,1.2,f'{n} → {m}  {title}',ha='center',fontsize=13,color=BLUE)
    ax.text(.5,-.18,foot,ha='center',fontsize=10,color=GRAY)
    ax.text(0,1.06,'局部',ha='center',fontsize=9,color=GRAY)
    ax.text(1,1.06,'整体',ha='center',fontsize=9,color=GRAY)
fig.suptitle('分组相干与信息完整是不同性质',fontsize=16,y=1.03,color=BLUE)
fig.tight_layout(w_pad=2)
save(fig,'v9_comparison_types')


fig,ax=plt.subplots(figsize=(9.2,3.8));ax.set(xlim=(0,10),ylim=(0,4));ax.axis('off')
for y,elems,label in [(2.8,'00   ↔   11','相同关系'),(1.25,'01   ↔   10','相反关系')]:
    ax.add_patch(Ellipse((2.6,y),3.6,1.0,fc='#EDF5F6',ec=BLUE,lw=1.4))
    ax.text(2.6,y,elems,ha='center',va='center',fontsize=17,color=BLUE)
    ax.text(.1,y,label,ha='left',va='center',fontsize=11,color=GRAY)
    ax.add_patch(FancyArrowPatch((4.45,y),(7.15,2.0),arrowstyle='-|>',mutation_scale=16,color=ORANGE,lw=1.5))
ax.scatter([7.35],[2.0],s=200,color=TEAL)
ax.text(7.75,2.0,'(*, *)',ha='left',va='center',fontsize=18,color=TEAL)
ax.text(5.6,2.22,r'$\chi$',fontsize=20,color=ORANGE)
ax.text(2.6,3.65,'先组合，再对共同翻转取轨道',ha='center',fontsize=12,color=BLUE)
ax.text(7.5,3.65,'各自取轨道，再组合',ha='center',fontsize=12,color=BLUE)
ax.text(2.6,.28,'保留两种相对关系',ha='center',fontsize=12,color=GRAY)
ax.text(7.5,.28,'两个来源都落在同一个整体结果',ha='center',fontsize=11,color=GRAY)
save(fig,'v9_c2_relative_information')


fig,ax=plt.subplots(figsize=(7.8,5.2));ax.set(xlim=(-.5,6.5),ylim=(-.3,5.3));ax.axis('off')
p={'P':(3,4.8),'B':(3,3.15),'W':(.7,1.8),'V':(5.3,1.8),'D':(3,.1)}
labels={'P':r'$Q(W\times_D V)$','B':r'$QW\times_{QD}QV$','W':r'$QW$','V':r'$QV$','D':r'$QD$'}
for k,(x,y) in p.items():
    ax.text(x,y,labels[k],ha='center',va='center',fontsize=18,
            bbox={'boxstyle':'round,pad=.3','fc':'white','ec':'none'},zorder=5,color=BLUE)
def ar(a,b,label,where,rad=0,color=BLUE):
    ax.add_patch(FancyArrowPatch(p[a],p[b],arrowstyle='-|>',mutation_scale=14,
                 lw=1.5,color=color,connectionstyle=f'arc3,rad={rad}',shrinkA=23,shrinkB=21))
    ax.text(*where,label,fontsize=14,color=color,ha='center',va='center')
ar('P','B',r'$\chi$',(3.35,4.0),color=ORANGE)
ar('B','W',r'$\pi_1$',(1.82,2.2))
ar('B','V',r'$\pi_2$',(4.16,2.2))
ar('P','W',r'$Qp$',(.8,3.7),.19)
ar('P','V',r'$Qq$',(5.2,3.7),-.19)
ar('W','D',r'$Qr$',(1.6,.8))
ar('V','D',r'$Qs$',(4.4,.8))
save(fig,'v9_comparison_universal_property')
print('created three exact figures in PDF, SVG and PNG')
