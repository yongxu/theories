# AI-written (Opus reader), 13 November 2026. Exhaustive search for small hi, with t1_sim's
# definitions, of greater_need (T1) and more_use_on_first (T2) with every premise, or with
# FromNothing dropped (g 0 free). With x <= hi and Keeps at the second unit's use, every level stays
# within hi and giving is read only at 0..hi - H (H the second unit's use in T1, H2' in T2), so g is
# enumerated there with g e <= hi - e at e <= hi - H (Keeps), and set to 0 above.
import importlib.util, itertools, sys
spec = importlib.util.spec_from_file_location('t', '/Users/ren/theories/tmp/r7/wu2/readers/t1_sim.py')
t = importlib.util.module_from_spec(spec); spec.loader.exec_module(t)
HI = int(sys.argv[1]); which = sys.argv[2]; dropnothing = sys.argv[3] == 'drop'
cases = bad = 0
for hi in range(0, HI + 1):
  for H in range(0, hi + 1):
    span = hi - H
    for vals in itertools.product(*[range(0, hi - e + 1) for e in range(span + 1)]):
      tab = list(vals) + [0] * (hi + 2 - len(vals))
      g = t.mkg(tab, 0)
      if not t.keeps(g, H, hi): continue
      if t.fromnothing(g) == dropnothing: continue
      ys = [y for y in range(0, hi + 2) if t.short(g, H, y) and t.meets(g, H, y, hi)]
      if not ys: continue
      memo = {}
      def U(s):
        if s not in memo: memo[s] = t.unending(g, s)
        return memo[s]
      for n in range(1, hi + 2):
        for m in range(n, hi + 2):
          for x in range(0, hi + 1):
            if which == 'T1':
              for h in range(0, hi + 1):
                if not U((((m, h), (n, H)), x)): continue
                for m2 in range(m, hi + 3):
                  cases += 1
                  if not U((((m2, h), (n, H)), x)):
                    bad += 1
                    if bad <= 3: print('T1 COUNTEREXAMPLE', dict(tab=tab, hi=hi, H2=H, ys=ys, m=m, m2=m2, h=h, n=n, x=x))
            else:
              for hp in range(0, hi + 1):
                for h in range(0, hp + 1):
                  H2 = hp + H - h
                  if not U((((m, h), (n, H2)), x)): continue
                  cases += 1
                  if not U((((m, hp), (n, H)), x)):
                    bad += 1
                    if bad <= 3: print('T2 COUNTEREXAMPLE', dict(tab=tab, hi=hi, H2=H2, h=h, hp=hp, H2p=H, ys=ys, m=m, n=n, x=x))
print(which, 'nothing dropped' if dropnothing else 'every premise', 'hi <=', HI, ': cases', cases, 'counterexamples', bad, flush=True)
