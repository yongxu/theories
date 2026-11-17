import sys, re
# Print docstring + signature (up to the := that ends the statement) of each declaration, with line numbers.
path = sys.argv[1]
lo = int(sys.argv[2]) if len(sys.argv) > 2 else 1
hi = int(sys.argv[3]) if len(sys.argv) > 3 else 10**9
lines = open(path).read().split('\n')
kw = re.compile(r'^(private |protected |noncomputable )*(theorem|def|abbrev|structure|inductive|instance|class|namespace|section|end|variable|open)\b')
i = 0
n = len(lines)
out = []
while i < n:
    l = lines[i]
    if l.startswith('/--') or l.startswith('/-!'):
        j = i
        while j < n and '-/' not in lines[j]:
            j += 1
        if lo <= i+1 <= hi:
            for k in range(i, j+1):
                out.append(f"{k+1}\t{lines[k]}")
        i = j + 1
        continue
    if kw.match(l):
        j = i
        m = re.match(r'^(private |protected |noncomputable )*(\w+)', l)
        word = m.group(2)
        if word in ('namespace','section','end','variable','open'):
            if lo <= i+1 <= hi: out.append(f"{i+1}\t{l}")
            i += 1
            continue
        # signature: until a line containing ':=' or a line starting with '  |' or 'where'
        while j < n:
            s = lines[j]
            if j > i and re.match(r'^\s*\|', s):
                j -= 1
                break
            if ':=' in s or s.rstrip().endswith(' where') or (j>i and s.strip()=='' ):
                break
            j += 1
        if lo <= i+1 <= hi:
            for k in range(i, min(j, n-1)+1):
                s = lines[k]
                if ':=' in s:
                    s = s[:s.index(':=')+2]
                out.append(f"{k+1}\t{s}")
            out.append("")
        i = j + 1
        continue
    i += 1
print('\n'.join(out))
