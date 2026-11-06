# The report's pages that hold an image and little text, as first and last pages of runs.
import re, sys
t = open(sys.argv[1], encoding='utf-8', errors='replace').read().split('\f')
print(' '.join(str(k + 1) for k, pg in enumerate(t) if pg.count('￼') and len(pg.strip()) < 130))
