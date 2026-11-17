"""Extract the first /-! ... -/ block of every .lean file in Becoming/ into one text file.
Reading only; writes under search/sweep/."""
import os, re, sys
SRC = "/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming"
OUT = "/Users/ren/theories/tmp/r7/one-model/check/round16/search/sweep/accounts.txt"
names = sorted(f for f in os.listdir(SRC) if f.endswith(".lean"))
rows = []
with open(OUT, "w") as out:
    for f in names:
        txt = open(os.path.join(SRC, f), encoding="utf-8").read()
        nlines = txt.count("\n") + 1
        i = txt.find("/-!")
        if i < 0:
            block = "(no /-! block)"
            start = 0
        else:
            j = txt.find("-/", i)
            block = txt[i:j+2] if j >= 0 else txt[i:]
            start = txt[:i].count("\n") + 1
        imports = re.findall(r"^import\s+(\S+)", txt, flags=re.M)
        out.write("=" * 100 + "\n")
        out.write(f"MODULE {f}  (file lines: {nlines}; account starts line {start}; account lines: {block.count(chr(10))+1})\n")
        out.write("imports: " + " ".join(imports) + "\n")
        out.write(block + "\n")
        rows.append((f, nlines, block.count("\n") + 1))
print(len(rows), "modules")
print("total account lines", sum(r[2] for r in rows))
print("total file lines", sum(r[1] for r in rows))
