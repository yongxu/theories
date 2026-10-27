import re, sys
from pathlib import Path
root = Path(sys.argv[1])
dossier = (root / 'theories/becoming/review/PHILOSOPHY.md').read_text(encoding='utf-8')
# whole file and P-20 section
start = dossier.index('<a id="p-20"></a>')
end = dossier.index('<a id="p-21"></a>')
sec = dossier[start:end]
pat = re.compile(r'Quote \[([^\]]+)\]: "((?:[^"\\]|\\.)*?)"')
bad = 0
for name, text in (('P-20', sec), ('whole', dossier)):
    n = 0
    for m in pat.finditer(text):
        n += 1
        path, q = m.group(1), m.group(2)
        src = (root / path).read_text(encoding='utf-8')
        if q not in src:
            bad += 1
            print('MISSING in', path, '::', q[:150])
    print(name, 'quotes checked:', n)
print('bad', bad)
