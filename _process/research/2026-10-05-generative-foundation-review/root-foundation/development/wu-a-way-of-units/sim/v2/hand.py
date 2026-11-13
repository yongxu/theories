from w2 import *
t = [0, 1, 2, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0] + [0] * 30
g = mk(t)
for (y2, lab) in [(2, 'drop Meets'), (11, 'drop Short')]:
    p = W2prem(g, 10, 1, 1, 2, 10, y2, 12, 12)
    print(lab, {k: v for k, v in p.items() if not v}, 'm=10:', unending(g, ([(10, 1), (1, 2)], 12))[0], 'm=13:', unending(g, ([(13, 1), (1, 2)], 12))[0])
print(unending(g, ([(13, 1), (1, 2)], 12))[1])
