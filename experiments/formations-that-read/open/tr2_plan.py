"""TR2 Stage B, the plan: what each checkpoint's run is made of, a pure function of the conditions (no
answer moves it, the pilot's included).

A run goes in phases, each a list of groups; a group is one content's passes of one kind, made one
after another in a seeded order of its arms, then written as one record (tr2_run.py):
- smoke: the first smoke content of each family, its six choice arms, its five recognition arms and
  the two pilot arms (52 passes);
- pilot: the 400 pilot contents, the pilot cue down and up (800 passes);
- main: the 1,600 main contents (N_B, fixed: tr2_rule.PAIRS), each content's six arms (base, F1 to F4,
  identical); the states of the first 400 are kept;
- recognition: the 400 state contents, five arms each (base, F1 to F4), the recognition prompt.
The groups of a phase are made in an order seeded by their identity alone, so no answer moves it,
and the arms of a group in another such order, so time and drift fall on every arm alike.
The shared draw u of a content (one value in [0, 1), from its identity and kind) is the same in every
arm of it: a sampled act is a function of the pass's distribution and u (tr2_rule.sampled).
"""

import hashlib

import tr2_conditions as C

PHASES = ("smoke", "pilot", "main", "recognition")


def digest(*parts):
    return hashlib.sha256("|".join(map(str, (C.SEED,) + parts)).encode()).hexdigest()


def shared_u(content_index, kind):
    """The content's shared draw in [0, 1), 53 bits from its identity and kind."""
    return int(digest("u", kind, content_index)[:14], 16) / 16 ** 14


def group(phase, content, kind, arms, keep_state=False):
    gid = f"{phase}/{kind}/{content['index']}"
    order = sorted(arms, key=lambda a: digest("arm-order", gid, a))
    return {"id": gid, "phase": phase, "content": content["index"], "kind": kind, "arms": order,
            "keep_state": keep_state}


def phase_groups(phase):
    if phase == "smoke":
        cs = C.SMOKE[:len(C.FAMILIES)]
        gs = [group("smoke", c, "choice", C.ARMS) for c in cs]
        gs += [group("smoke", c, "recognition", C.RECOGNITION_ARMS) for c in cs]
        gs += [group("smoke", c, "pilot", C.PILOT_ARMS) for c in cs]
    elif phase == "pilot":
        gs = [group("pilot", c, "pilot", C.PILOT_ARMS) for c in C.PILOT]
    elif phase == "main":
        gs = [group("main", c, "choice", C.ARMS, keep_state=i < C.STATE_N) for i, c in enumerate(C.MAIN)]
    elif phase == "recognition":
        gs = [group("recognition", c, "recognition", C.RECOGNITION_ARMS) for c in C.MAIN[:C.STATE_N]]
    else:
        raise ValueError(phase)
    return sorted(gs, key=lambda g: digest("group-order", g["id"]))


def prompt_of(g, arm, role):
    """The prompt a pass shows: the pilot's kind is a choice under the pilot's arms."""
    content = C.CONTENTS[g["content"]]
    kind = "choice" if g["kind"] == "pilot" else g["kind"]
    return C.prompt(content, arm, kind, role)


def letters_of(g):
    return C.LETTERS["recognition" if g["kind"] == "recognition" else "choice"]


def passes(phase):
    return sum(len(g["arms"]) for g in phase_groups(phase))
