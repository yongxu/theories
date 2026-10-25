"""Exact values of LA2 (computed before the freeze; no model).

    python3 values.py      # writes results/values.json

1. The loop's arithmetic is MA2's: with the readers of the Lean witnesses in place of the judge (a pool
   of readers counted as the population counts them, the carriers reading `hi`, the others `oneToOne`
   until the loss reaches its bound and `lo` from then on, one more loss a step, a reading at every
   step), loop.select and the pool reproduce the numbers in the statements of
   `ClosedCapture.Thinned.inTime_majority`, `inTime_turned`, `late_majority` and `late_kept`.
2. LA2's course before the judge reads: from one list answer to eight prose answers under `hi`, the
   shares at steps 0 to 4, and the reference set counted from each.
3. The loss recorded at each step.
"""

import json
import os

from loop import CONDITIONS, HI, LOSS_PER_STEP, REF, START, T, favours, le, loss, ref_lists, select

HERE = os.path.dirname(os.path.abspath(__file__))
LO, ONE = (1, 4), (1, 1)          # RuleCapture.lo, Second.oneToOne


def pool(u, v, x):
    """`ClosedCapture.Drawn.pool`: each carrier among the readers reads u, each other v, counted by x."""
    return (x[0] * u[0] + x[1] * v[0], x[0] * u[1] + x[1] * v[1])


def witness(N, steps):
    """The course of `Thinned.course Beyond.lossStep hi oneToOne lo N (fun _ => true) ((fewCarriers, 0), hi)`."""
    x, b, g = START, 0, HI
    out = [(x, g)]
    for _ in range(steps):
        read = pool(HI, ONE, x) if b < N else pool(HI, LO, x)
        x, b, g = select(x, g), b + 1, read
        out.append((x, g))
    return out


def check_witness():
    it = witness(0, 3)            # Thinned.inTime
    assert it[1][0] == (4, 8) and it[1][1] == (12, 33)                    # inTime_majority: 4 < 8, 12 <= 33
    assert pool(HI, LO, it[1][0]) == (24, 36)                             # ... and 24 <= 36
    assert it[2][0] == (48, 264) and it[3][0] == (1152, 9504)             # inTime_turned: not 48*9504 <= 1152*264
    assert not le(it[2][0], it[3][0])
    lt_ = witness(3, 4)           # Thinned.late
    assert lt_[3][0] == (1152, 864) and lt_[3][1] == (264, 120)           # late_majority: 864 < 1152, 120 <= 264
    assert pool(HI, LO, lt_[3][0]) == (5472, 4608)                        # ... and 4608 <= 5472
    assert favours(lt_[4][1]) and le(lt_[4][0], select(lt_[4][0], lt_[4][1]))
    return dict(inTime=[dict(share=x, rule=g) for x, g in it], late=[dict(share=x, rule=g) for x, g in lt_])


def main():
    out = dict(witness=check_witness(), start=START, rule_before_reading=HI, ref=REF, steps=T,
               loss_per_step=LOSS_PER_STEP, losses=[loss(t) for t in range(T + 1)], established=[],
               conditions=CONDITIONS)
    x = START
    for t in range(5):
        out["established"].append(dict(step=t, share=x, lists_in_reference_set=ref_lists(x)))
        x = select(x, HI)
    for e in out["established"]:
        print(f"step {e['step']}: share {e['share'][0]}:{e['share'][1]}, reference set "
              f"{e['lists_in_reference_set']} list and {REF - e['lists_in_reference_set']} prose answers")
    print("losses", out["losses"])
    print("witness inTime", out["witness"]["inTime"])
    print("witness late", out["witness"]["late"])
    os.makedirs(os.path.join(HERE, "results"), exist_ok=True)
    json.dump(out, open(os.path.join(HERE, "results", "values.json"), "w"), indent=1)


if __name__ == "__main__":
    main()
