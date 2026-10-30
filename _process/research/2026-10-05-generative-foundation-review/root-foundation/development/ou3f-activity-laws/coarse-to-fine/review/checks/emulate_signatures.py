"""Check 5: what signatures_ctf.py will compute at landing, emulated on the review's builds (read-only): OU3b's parse()
on the checker's Signatures driver output for Persistence from main's build and from the tree's (sig-main.log,
sig-new.log, produced by `lean` on BecomingPersistenceSignatures.lean, the checker's driver text), and OU3b's
definitions() on main's and the tree's Persistence, with the kit's expectations (nothing changed, gone, added, moved;
no definition rewritten, gone or added)."""
import importlib.util, json, sys
from pathlib import Path
sys.dont_write_bytecode = True
ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location('s3b', ROOT / '_process/research/2026-10-05-generative-foundation-review/'
                                              'root-foundation/development/ou3b-master-laws-on-the-grammar/kit/signatures_ou3b.py')
s = importlib.util.module_from_spec(spec); spec.loader.exec_module(s)
old, new = s.parse((HERE / 'sig-main.log').read_text()), s.parse((HERE / 'sig-new.log').read_text())
src_old = (ROOT / s.PKG / 'Becoming/Persistence.lean').read_text(encoding='utf-8')
src_new = (HERE.parent.parent / 'tree/Becoming/Persistence.lean').read_text(encoding='utf-8')
do, dn = s.definitions(src_old), s.definitions(src_new)
report = {'declarations_old': len(old), 'declarations_new': len(new),
          'changed': sorted(n for n in old if n in new and old[n] != new[n]),
          'gone': sorted(set(old) - set(new)), 'added': sorted(set(new) - set(old)),
          'definitions': len(do), 'definitions_rewritten': sorted(n for n in do if n in dn and do[n] != dn[n]),
          'definitions_gone': sorted(set(do) - set(dn)), 'definitions_added': sorted(set(dn) - set(do))}
print(json.dumps(report, indent=1))
print('OK' if not any(report[k] for k in report if isinstance(report[k], list)) else 'UNEXPECTED')
