from w2 import *
g = mk([0, 5, 6, 0, 4] + [0] * 40)
m, n, h, H2, h2, H22, y1, y2, y22, hi, x = 12, 4, 1, 6, 2, 5, 5, 2, 1, 6, 11
p = W2prem(g, m, h, n, H2, y1, y2, hi, x)
p.update(short_=Short(g, H22, y22), meets_=Meets(g, H22, y22, hi), keeps_=Keeps(g, H22, hi), within_=n <= H22 + y22, sum=h + H2 == h2 + H22, more=h <= h2)
print('W4 drop high: failing', [k for k in p if not p[k]])
print(unending(g, ([(m, h), (n, H2)], x)), unending(g, ([(m, h2), (n, H22)], x)))
