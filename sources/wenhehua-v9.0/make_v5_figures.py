from pathlib import Path
from PIL import Image,ImageDraw,ImageFont
R=Path(__file__).resolve().parent
p=R/'figures/合化比较_双路径.png'
W,H=1450,550
im=Image.new('RGB',(W,H),'#ffffff');d=ImageDraw.Draw(im)
font='/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc'
f=ImageFont.truetype(font,36);h=ImageFont.truetype(font,48);sub=ImageFont.truetype(font,27)
navy='#243347';jade='#087e7b';blue='#446aa4';light='#eff7f7';grey='#637586'
d.text((64,30),'合与化：同一生成结构中的两条路径',font=h,fill=navy)
def panel(x,y,w,ht,title,formula,desc,color):
    d.rounded_rectangle((x,y,x+w,y+ht),radius=24,fill=light if color==jade else '#f2f5fa',outline=color,width=3)
    d.text((x+32,y+23),title,font=f,fill=color)
    d.text((x+32,y+88),formula,font=f,fill=navy)
    d.text((x+32,y+152),desc,font=sub,fill=grey)
panel(67,148,585,246,'路径甲：局部先续，再沿界合','W(VH)  =  Pullback → Pushout','只记录各侧连续可接的见证',jade)
panel(798,148,585,246,'路径乙：先沿界合，再整体接续','W(HV)  =  Pushout → Pullback','允许经整体共享节点的形式接力',blue)
d.line((655,267,794,267),fill=navy,width=4)
d.polygon([(785,257),(798,267),(785,277)],fill=navy)
d.text((703,219),'χ',font=h,fill=navy)
d.text((102,435),'可成：两边都能构造',font=sub,fill=navy)
d.text((548,435),'可比：χ 保持首末端点',font=sub,fill=navy)
d.text((1055,435),'可同：χ 可逆',font=sub,fill=navy)
d.line((65,498,1380,498),fill='#c7d5d8',width=2)
d.text((65,510),'比较映射存在，不意味着普遍可逆；形式路径不自动构成物理因果。',font=sub,fill=grey)
im.save(p)
print(p,im.size)
