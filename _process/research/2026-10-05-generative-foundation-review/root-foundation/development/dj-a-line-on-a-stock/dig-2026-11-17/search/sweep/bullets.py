import sys,os,re
SRC="/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming"
W=int(os.environ.get("W","230"))
for n in sys.argv[1:]:
    txt=open(os.path.join(SRC,n+".lean"),encoding="utf-8").read()
    i=txt.find("/-!"); j=txt.find("-/",i)
    b=txt[i:j+2]
    # split into bullets
    parts=re.split(r"\n(?=\* \*\*|\*\*[A-Z])",b)
    print(f"##### {n}")
    for p in parts[1:]:
        p=" ".join(p.split())
        print("  "+p[:W])
