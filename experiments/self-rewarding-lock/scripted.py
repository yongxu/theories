"""Scripted judges in place of the model: for the smoke run and the power check (never for verdicts).

Each model gives the probability that the judge picks the list answer of a pair, from what it reads
(loop.spec: the reference set's counts, whether the others' answers carry the loss note, whether the
judge reads the delivery report); the picks of the ten pairs are drawn with it, independently unless
the judge clumps (below).

* pool(q_u, q_v, q_w, q_r): the premise of the predictions, a pool of the reference set's readers
  counted as the population counts them.  Each list answer reads q_u; each prose answer q_v, or q_w
  where its reviewer's note reads the loss; where the judge reads the report every reader reads the loss,
  list answers q_r and prose answers q_w.
* single_reading(q_u, q_v, q_e): any reading of the loss in the judge's prompt (a single note or the
  report) turns it to q_e, however few readers carry it; otherwise the pool without the loss.
* formation(q_u, q_v): the reference set's counts decide and the loss is idle: neither note nor
  report moves the judge.
* discount(q_u, q_v, q_w): the notes count as in the pool, but the judge reading the report itself does
  not move it.
* notes_idle(q_u, q_v, q_r): the reverse: the notes do nothing, and the report read by the judge turns
  it to q_r; otherwise the reference set's counts decide.
* constant(q): a taste of its own, read from neither the reference set nor the loss.

`reader` draws the picks; within one replication a prompt met twice (the same seed, step, counts,
notes and report) gives the same picks, as two conditions sharing a call do in the run.  With `clump`
above zero the picks of one call are not independent: with that probability a call gives all its ten
pairs one answer, drawn once with the model's probability (a judge answering a whole call alike);
otherwise its picks are drawn one by one.  MODELS maps a name to a model and its clump.
"""

from loop import PAIRS


def pool(q_u, q_v, q_w, q_r):
    def p(s):
        n_l, n_p = s["n_lists"], s["n_prose"]
        if s["report"]:
            return (n_l * q_r + n_p * q_w) / (n_l + n_p)
        return (n_l * q_u + n_p * (q_w if s["notes"] else q_v)) / (n_l + n_p)
    return p


def single_reading(q_u, q_v, q_e):
    def p(s):
        if s["report"] or (s["notes"] and s["n_prose"] > 0):
            return q_e
        return (s["n_lists"] * q_u + s["n_prose"] * q_v) / (s["n_lists"] + s["n_prose"])
    return p


def formation(q_u, q_v):
    return lambda s: (s["n_lists"] * q_u + s["n_prose"] * q_v) / (s["n_lists"] + s["n_prose"])


def discount(q_u, q_v, q_w):
    def p(s):
        n_l, n_p = s["n_lists"], s["n_prose"]
        return (n_l * q_u + n_p * (q_w if s["notes"] else q_v)) / (n_l + n_p)
    return p


def notes_idle(q_u, q_v, q_r):
    def p(s):
        if s["report"]:
            return q_r
        return (s["n_lists"] * q_u + s["n_prose"] * q_v) / (s["n_lists"] + s["n_prose"])
    return p


def constant(q):
    return lambda s: q


MODELS = {
    "pool_strong": (pool(0.9, 0.4, 0.1, 0.1), 0.0),
    "pool_moderate": (pool(0.8, 0.4, 0.2, 0.2), 0.0),
    "pool_weak_formation": (pool(0.7, 0.5, 0.2, 0.2), 0.0),
    "pool_formation_both_ways": (pool(0.8, 0.2, 0.1, 0.1), 0.0),
    "pool_near_even": (pool(0.6, 0.45, 0.4, 0.4), 0.0),
    "pool_moderate_clumped": (pool(0.8, 0.4, 0.2, 0.2), 0.5),
    "single_reading": (single_reading(0.8, 0.4, 0.15), 0.0),
    "formation": (formation(0.8, 0.3), 0.0),
    "discount": (discount(0.8, 0.4, 0.2), 0.0),
    "notes_idle_each_for_own": (notes_idle(0.8, 0.2, 0.15), 0.0),
    "notes_idle_near_even": (notes_idle(0.8, 0.4, 0.15), 0.0),
    "notes_idle_near_even_clumped": (notes_idle(0.8, 0.4, 0.15), 0.5),
    "taste_list": (constant(0.8), 0.0),
    "taste_prose": (constant(0.2), 0.0),
    "even": (constant(0.5), 0.0),
    "even_clumped": (constant(0.5), 0.5),
}


def reader(model, rng, shared=None, clump=0.0):
    def read(s):
        # what makes the prompt: a note shows only where the reference set holds a prose answer
        key = (s["step"], tuple(s["exemplars"]), tuple(s["pairs"]), s["n_lists"], s["notes"] and s["n_prose"] > 0,
               s["report"])
        if shared is not None and key in shared:
            return shared[key]
        q = model(s)
        if rng.random() < clump:
            k = PAIRS if rng.random() < q else 0
        else:
            k = sum(1 for _ in range(PAIRS) if rng.random() < q)
        out = dict(list=k, prose=PAIRS - k, valid=True)
        if shared is not None:
            shared[key] = out
        return out
    return read
