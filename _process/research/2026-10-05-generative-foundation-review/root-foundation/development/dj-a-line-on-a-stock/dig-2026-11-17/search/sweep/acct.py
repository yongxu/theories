import sys,os
SRC="/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming"
skip=int(os.environ.get("SKIP","13"))
for n in sys.argv[1:]:
    txt=open(os.path.join(SRC,n+".lean"),encoding="utf-8").read()
    i=txt.find("/-!"); j=txt.find("-/",i)
    lines=txt[i:j+2].split("\n")
    start=txt[:i].count("\n")+1
    print(f"##### {n} (account lines {start+skip}..{start+len(lines)-1})")
    print("\n".join(lines[skip:]))
