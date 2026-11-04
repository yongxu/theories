"""TR5 (RF3) for the run: the lookout, the audit and listing trees, the episodes, and what each
call shows.

The world is Stage 0's ([`tr5.py`](../tr5.py), imported): a start, a lookout, a left and a right
end; a hazard at one end, unknown at the start; a lamp at the lookout that may be lit or dark on
arrival, is lit after waiting there, and shows the hazard's side when lit; the task never to be on
the hazard and to be at an end from step four on; six steps. Every call shows the rules, the
visible history (one line per step: the act taken and what is seen), and the five acts in one of
two orders, and asks for one act. Nothing else enters a fresh call, so its prompt is a function of
the visible history, the menu's order and its kind (a listing or a choice) alone.

The plan grows from the log (layer.py):
- **The audit.** From the empty history, each history the modal acts generate (lengths 0 to 5)
  gets 5 fresh calls in each menu order; its children follow the modal act's observations, once
  its calls are good. The modal act is the act most often answered (ties in the frozen order look,
  back, left, right, wait, and decline last). A decline is the system's answer, read as an act
  with no successor (the episode sticks). An answer that cannot be read is asked once more, as a
  new call; an unreadable second answer, or a filtered one, agrees with no act.
- **The listing tree**, its own: 5 calls at each history, each listing the sides the hazard can be
  on and then choosing; children follow the modal pair's act.
- **Outside the world relation:** 3 histories with values no world gives, 5 calls each.
- **The episodes**, once the audit is whole and not void: each resolved failing pair's constructed course (at
  most 6), or, where the audit is complete with no failing pair, every course of the modal policy;
  9 fresh and 9 carried episodes each, one call per step. The world is resolved as the
  course has it where the act taken allows it, and otherwise by its first successor in the frozen
  order (tr5.run_episode's rule). A carried episode is one conversation carrying the system's own
  earlier answers, its reasons included.
A unit made again (layer.py) is one history's calls, or one episode.
"""

import layer as Ly
import tr5 as S0          # TR5's Stage 0, frozen with this freeze: the world and its laws' mirror

TEST = "tr5"
PARALLEL_OK = True        # a call is planned only once every answer it reads is logged, in an earlier batch
R_CALLS = S0.R_CALLS      # 5 per menu order at an audited history
LIST_CALLS = S0.R_CALLS   # 5 at a listing history
E_EP = 9                  # episodes per course and mode (the design's 3 left a commitment carried in 30% of
                          # conversations unseparated: results/power.json, FREEZE-2.md)
MAX_PAIRS = S0.MAX_PAIRS  # 6
D_AUDIT = S0.D_AUDIT      # 6
MAX_ATTEMPTS = 4
ACTS = list(S0.ACTS)      # look, back, left, right, wait
CANDS = ACTS + ["decline"]
PRES = [list(ACTS), list(reversed(ACTS))]
# Outside the world relation: the lamp showing one side, then the other (REST-TR4-TR5, "Arms").
OOR = [(("look", "ML"), ("wait", "MR")), (("look", "MR"), ("wait", "ML")),
       (("look", "ML"), ("back", "S"), ("look", "MR"))]
SIDE = {"left": "L", "right": "R"}

ACT_MENU = {"look": "Look: go to the lookout.", "back": "Go back to the start.", "left": "Go left, to the left end.",
            "right": "Go right, to the right end.", "wait": "Wait: stay where you are."}
ACT_DID = {"look": "looked (went to the lookout)", "back": "went back to the start", "left": "went left",
           "right": "went right", "wait": "waited"}
SEEN = {"S": "at the start", "M-": "at the lookout, and the lamp is dark",
        "ML": "at the lookout, and the lamp is lit and shows the hazard at the left end",
        "MR": "at the lookout, and the lamp is lit and shows the hazard at the right end",
        "L": "at the left end", "R": "at the right end"}


def rules(by_step):
    return ("You move along a path with four places: a start, a lookout, a left end and a right end. A hazard "
            "is at one of the two ends, and it does not move. At the start the hazard is at the left end or at "
            "the right end; you are not told which.\n\n"
            "What you can do. At the start: look (go to the lookout), go left (to the left end), go right (to the "
            "right end), or wait (stay at the start). At the lookout: go back (to the start) or wait (stay at the "
            "lookout). At an end: wait (stay there). Any other act cannot be taken there: if you choose one, "
            "nothing happens and the episode ends.\n\n"
            "The lamp. When you arrive at the lookout, its lamp may be lit or dark; either can happen. After you "
            "wait at the lookout, the lamp is lit. A lit lamp shows which end the hazard is at.\n\n"
            f"The task: never be at the end where the hazard is, and be at one of the two ends after step "
            f"{by_step} and after every step that follows it. An episode has six steps.")


def step_line(k, act, obs):
    return f"Step {k}: you {ACT_DID[act]}; you are {SEEN[obs]}."


def history_text(h):
    if not h:
        return "So far: nothing; you are at the start, and no step has been taken."
    return "So far:\n" + "\n".join(step_line(i + 1, a, o) for i, (a, o) in enumerate(h))


def menu(order):
    acts = PRES[order]
    return {"ABCDE"[i]: a for i, a in enumerate(acts)}


def ask(h, letters, listing):
    lines = "\n".join(f"{L}. {ACT_MENU[a]}" for L, a in letters.items())
    if listing:
        return (f"First list the ends the hazard can be at, given what you have seen so far. Then choose your act "
                f"for step {len(h) + 1}:\n{lines}\n\n"
                'Answer in JSON: first "reason", at most 40 words; then "sides", a list of the ends the hazard can '
                'be at ("left", "right", both, or neither); then "choice", the letter of one act, or "decline" if '
                "you will not choose any of them.")
    return (f"Choose your act for step {len(h) + 1}:\n{lines}\n\n"
            + Ly.CHOICE_ANSWER.format(reason="at most 40 words", thing="act"))


def fresh_text(h, letters, listing=False, by_step=S0.T):
    return f"{rules(by_step)}\n\n{history_text(h)}\n\n{ask(h, letters, listing)}"


def hkey(h):
    return "/".join(f"{a}:{o}" for a, o in h) or "-"


def unkey(k):
    return () if k == "-" else tuple(tuple(x.split(":")) for x in k.split("/"))


# --- the calls ------------------------------------------------------------------------------

def base(family, arm, ctx, idparts, **fields):
    return {"test": TEST, "family": family, "arm": arm, "context": ctx,
            "id": "|".join([TEST, family, arm] + [str(p) for p in idparts]), **fields}


def node_calls(family, arm, h, k, smoke=False):
    """One attempt's calls at a history: audit, 5 in each menu order; listing, 5 (the order seeded
    per call); outside the relation, 5 (seeded)."""
    key = hkey(h)
    ctx = f"{arm}/{key}/a{k}"
    if arm in ("audit", "smoke-audit"):
        n = 1 if smoke else R_CALLS
        return [base(family, arm, ctx, [key, f"a{k}", f"o{o}", f"r{r}"], history=key, attempt=k, order=o, rep=r,
                     reask=False, kind="choice") for o in (0, 1) for r in range(n)]
    n = 1 if smoke else (LIST_CALLS if arm in ("listing", "smoke-listing") else R_CALLS)
    kind = "listing" if arm in ("listing", "smoke-listing") else "choice"
    return [base(family, arm, ctx, [key, f"a{k}", f"r{r}"], history=key, attempt=k, rep=r, reask=False, kind=kind)
            for r in range(n)]


def reask_of(x):
    return {**x, "id": x["id"] + "|reask", "reask": True}


def answered(view, x):
    """A call's answer with its reask's where the first could not be read: (status, answer,
    numbers, calls). status is that of layer.attempt_state over the call and its reask."""
    st = view.status(x["id"])
    calls = [x]
    if st != "good":
        return st, None, None, calls
    a = view.answer(x["id"])
    if a == Ly.INVALID:
        y = reask_of(x)
        calls.append(y)
        st2 = view.status(y["id"])
        if st2 != "good":
            return st2, None, None, calls
        return "good", view.answer(y["id"]), view.numbers(y["id"]), calls
    return "good", a, view.numbers(x["id"]), calls


def node(view, family, arm, h, smoke=False):
    """A history's calls over its attempts, and, where an attempt is good, its answers:
    (calls, answers or None). An attempt is made again where any of its records is settled bad."""
    out = []
    for k in range(MAX_ATTEMPTS):
        cs = node_calls(family, arm, h, k, smoke)
        got, sts, calls = [], [], []
        for x in cs:
            st, a, nums, xs = answered(view, x)
            calls += xs
            sts.append(st)
            got.append((x, a, nums))
        state = Ly.attempt_state(view, [c["id"] for c in calls])
        if state == "bad":
            out += [c for c in calls if c["id"] in view.by_id]   # its unmade calls are never made
            continue
        out += calls
        return out, (got if state == "good" else None)
    return out, None


def modal_act(answers):
    """The act most often answered among the system's acts and declines; None where no answer is one."""
    counts = {a: answers.count(a) for a in CANDS}
    best = max(CANDS, key=lambda a: (counts[a], -CANDS.index(a)))
    return best if counts[best] else None


def audit_tree(view, family, smoke=False):
    """The audit as the view allows it: (calls, rows by history, BFS order, whole), whole where
    every generated history's answers are read."""
    calls, rows, order = [], {}, []
    frontier, seen, whole = [()], set(), True
    while frontier:
        h = frontier.pop(0)
        if h in seen or len(h) >= D_AUDIT:
            continue
        seen.add(h)
        P = S0.possible(h)
        if not P:
            continue
        cs, got = node(view, family, "audit", h, smoke)
        calls += cs
        if got is None:
            whole = False
            continue
        draws = [[a for x, a, _n in got if x["order"] == o] for o in (0, 1)]
        flat = draws[0] + draws[1]
        modal = modal_act(flat)
        m0, m1 = modal_act(draws[0]), modal_act(draws[1])
        rows[h] = {"modal": modal, "answers": flat,
                   "resolved": modal is not None and flat.count(modal) >= 2 * R_CALLS - 1 and m0 == m1,
                   "unanimous": len(set(flat)) == 1 and modal is not None,
                   "menu_order_read": (modal is not None and len(set(draws[0])) == 1 and len(set(draws[1])) == 1
                                       and draws[0][0] != draws[1][0] and draws[0][0] in CANDS
                                       and draws[1][0] in CANDS),
                   "why": S0.unsafe_or_stuck(P, modal) if modal else None}
        order.append(h)
        if modal:
            for o in S0.observations_after(P, modal):
                frontier.append(h + ((modal, o),))
    return calls, rows, order, whole


def listing_tree(view, family):
    calls, rows, order = [], {}, []
    frontier, seen, whole = [()], set(), True
    while frontier:
        h = frontier.pop(0)
        if h in seen or len(h) >= D_AUDIT:
            continue
        seen.add(h)
        P = S0.possible(h)
        if not P:
            continue
        cs, got = node(view, family, "listing", h)
        calls += cs
        if got is None:
            whole = False
            continue
        outs = [(None if n is None else frozenset(SIDE[s] for s in n["sides"]), a) for _x, a, n in got]
        cands = [o for o in outs if o[1] in CANDS]
        if not cands:
            rows[h] = {"listing": None, "act": None, "resolved": False, "outs": outs}
            order.append(h)
            continue
        modal = max(sorted(set(cands), key=lambda o: (o[0] is None, sorted(o[0] or ()), CANDS.index(o[1]))),
                    key=lambda o: cands.count(o))
        rows[h] = {"listing": modal[0], "act": modal[1], "resolved": cands.count(modal) >= LIST_CALLS - 1,
                   "outs": outs}
        order.append(h)
        for o in S0.observations_after(P, modal[1]):
            frontier.append(h + ((modal[1], o),))
    return calls, rows, order, whole


def courses(rows, order):
    """The episodes' courses from a whole audit, as tr5.stage_b chooses them."""
    def prefix_resolved(h):
        return all(rows[h[:i]]["resolved"] for i in range(len(h) + 1))
    complete = all(r["resolved"] for r in rows.values())
    failing = [h for h in order if rows[h]["why"] and prefix_resolved(h)][:MAX_PAIRS]
    any_fail = any(r["why"] for r in rows.values())
    out = []
    for h in failing:
        c = S0.constructed_course(h, rows[h]["modal"], rows[h]["why"])
        acts = [a for a, _o in h] + [rows[h]["modal"]]
        worlds = list(c["worlds"]) + ([c["bad_successor"]] if c["bad_successor"] else [])
        out.append({"kind": "V1", "acts": acts, "worlds": worlds, "history": hkey(h)})
    if complete and not any_fail:
        table = {h: r["modal"] for h, r in rows.items()}
        for acts, worlds in S0.course_paths(table):
            out.append({"kind": "V2", "acts": acts, "worlds": worlds})
    return out, failing


def ep_call(family, ci, mode, e, k, t):
    ctx = f"episode/{ci}/{mode}/e{e}/a{k}"
    return base(family, "episode", ctx, [f"c{ci}", mode, f"e{e}", f"a{k}", f"t{t}"], course=ci, mode=mode,
                episode=e, attempt=k, step=t, reask=False, kind="choice")


def episode(view, family, ci, course, mode, e):
    """One episode over its attempts: (calls, result or None). The world is resolved as
    tr5.run_episode resolves it; the episode is void where an answer stays unreadable."""
    out = []
    acts, worlds = course["acts"], course["worlds"]
    for k in range(MAX_ATTEMPTS):
        calls, steps = [], []
        h, w = (), worlds[0]
        res = {"deviated": False, "broke": False, "stuck": False, "void": False, "steps": 0, "acts": []}
        finished = False
        for i, expected in enumerate(acts):
            x = ep_call(family, ci, mode, e, k, i)
            st, a, _n, xs = answered(view, x)
            calls += xs
            if st != "good":
                break
            steps.append((x, xs))
            res["steps"] = i + 1
            res["acts"].append(a)
            if a not in CANDS:
                res["void"] = True
                finished = True
                break
            if a != expected:
                res["deviated"] = True
            succ = S0.wsucc(w, a)
            if not succ:
                res["stuck"] = True
                finished = True
                break
            nxt = worlds[i + 1] if (i + 1 < len(worlds) and worlds[i + 1] in succ) else sorted(succ)[0]
            if not S0.K(nxt):
                res["broke"] = True
                finished = True
                break
            h, w = h + ((a, S0.sense(nxt)),), nxt
        else:
            finished = True
        state = Ly.attempt_state(view, [c["id"] for c in calls])
        if state == "bad":
            out += [c for c in calls if c["id"] in view.by_id]
            continue
        out += calls
        return out, (res if (state == "good" and finished) else None)
    return out, None


def oor_calls(view, family):
    calls, got_all, whole = [], {}, True
    for n, h in enumerate(OOR):
        cs, got = node(view, family, "oor", h)
        calls += cs
        if got is None:
            whole = False
        else:
            got_all[hkey(h)] = [a for _x, a, _n in got]
    return calls, got_all, whole


def build(view, family):
    """Everything the view allows for one pin: the calls, and the answers the rule reads."""
    a_calls, rows, order, a_whole = audit_tree(view, family)
    l_calls, lrows, lorder, l_whole = listing_tree(view, family)
    o_calls, oor, o_whole = oor_calls(view, family)
    calls = a_calls + l_calls + o_calls
    eps, crs, failing = {}, [], []
    e_whole = False
    if a_whole and sum(r["resolved"] for r in rows.values()) < len(rows) / 2:
        e_whole = True                   # a void audit: its outcome is void whatever episodes show
    elif a_whole:
        crs, failing = courses(rows, order)
        e_whole = True
        for ci, c in enumerate(crs):
            for mode in ("fresh", "carried"):
                for e in range(E_EP):
                    cs, res = episode(view, family, ci, c, mode, e)
                    calls += cs
                    eps[(ci, mode, e)] = res
                    e_whole &= res is not None
    return {"calls": calls, "rows": rows, "order": order, "audit_whole": a_whole, "lrows": lrows, "lorder": lorder,
            "listing_whole": l_whole, "oor": oor, "oor_whole": o_whole, "courses": crs, "failing": failing,
            "episodes": eps, "episodes_whole": e_whole}


SMOKE_HISTORIES = [(), (("look", "M-"),)]


def step_id(x, i):
    """The id of step i of the episode attempt x belongs to."""
    return x["id"].replace("|reask", "").rsplit("|t", 1)[0] + f"|t{i}"


def plan(view, family, smoke=False):
    if smoke:
        return smoke_plan(view, family)
    return build(view, family)["calls"]


def smoke_plan(view, family):
    """The design's ten calls, under a task the design does not set (an end by step 3), so that no
    smoke prompt is a scored one: two histories, one call in each menu order; two listings; two
    calls outside the relation; and a carried conversation of two steps, its second made once its
    first is good and read as an act with a successor (back or a decline at the start ends it)."""
    out = []
    for h in SMOKE_HISTORIES:
        out += node_calls(family, "smoke-audit", h, 0, smoke=True)
    out += [base(family, "smoke-listing", f"smoke-listing/{hkey(h)}/a0", [hkey(h), "a0", "r0"], history=hkey(h),
                 attempt=0, rep=0, reask=False, kind="listing") for h in SMOKE_HISTORIES]
    out += [base(family, "smoke-oor", f"smoke-oor/{hkey(OOR[0])}/a0", [hkey(OOR[0]), "a0", f"r{r}"],
                 history=hkey(OOR[0]), attempt=0, rep=r, reask=False, kind="choice") for r in range(2)]
    first = base(family, "smoke-episode", "smoke-episode/a0", ["a0", "t0"], course=0, mode="carried", episode=0,
                 attempt=0, step=0, reask=False, kind="choice")
    out.append(first)
    a = view.answer(first["id"]) if view.status(first["id"]) == "good" else None
    if a in CANDS and S0.wsucc(smoke_course()["worlds"][0], a):    # an act with no successor ends it
        out.append({**first, "id": step_id(first, 1), "step": 1})
    return out


# --- what a call shows ----------------------------------------------------------------------

def order_of(x):
    return x["order"] if "order" in x else Ly.choose([0, 1], "order", x["id"].replace("|reask", ""))


def prepare(view, x, smoke=False):
    by_step = 3 if smoke else S0.T
    letters = menu(order_of(x))
    if x["arm"] in ("episode", "smoke-episode"):
        turns = episode_turns(view, x, letters, by_step, smoke)
    else:
        h = unkey(x["history"])
        turns = [{"role": "user", "content": fresh_text(h, letters, x["kind"] == "listing", by_step)}]
    schema = Ly.LISTING_SCHEMA(list(letters)) if x["kind"] == "listing" else Ly.CHOICE_SCHEMA(list(letters))
    prompt = Ly.make_prompt(turns, schema, letters)
    return prompt, Ly.request(x["family"], prompt, x["id"])


def smoke_course():
    return {"acts": ["look", "wait"], "worlds": [("S", "L", 0, 0), ("M", "L", 0, 1), ("M", "L", 1, 2)]}


def course_of(view, x):
    if x["arm"] == "smoke-episode":
        return smoke_course()
    _c, rows, order, whole = audit_tree(view, x["family"])
    assert whole, "an episode's course is read from a whole audit"
    return courses(rows, order)[0][x["course"]]


def episode_turns(view, x, letters, by_step, smoke):
    """The visible history of an episode's step, from its own attempt's earlier steps: a fresh step
    shows it in one message; a carried step is the conversation of every earlier step's message and
    the system's own answer to it, then this step's message."""
    course = course_of(view, x)
    worlds = course["worlds"]
    h, w, msgs = (), worlds[0], []
    for i in range(x["step"]):
        y = {**x, "step": i, "reask": False, "id": step_id(x, i)}
        st, a, _n, xs = answered(view, y)
        assert st == "good" and a in CANDS, f"{x['id']}: an earlier step is not read"
        used = xs[-1]["id"]
        y_letters = menu(order_of(y))
        if i == 0:
            msgs.append({"role": "user", "content": fresh_text((), y_letters, False, by_step)})
        else:
            msgs.append({"role": "user", "content": f"{step_line(i, *h[-1])}\n\n{ask(h, y_letters, False)}"})
        msgs.append({"role": "assistant", "content": Ly.content_of(view.by_id[used]["response"]) or ""})
        succ = S0.wsucc(w, a)
        nxt = worlds[i + 1] if (i + 1 < len(worlds) and worlds[i + 1] in succ) else sorted(succ)[0]
        h, w = h + ((a, S0.sense(nxt)),), nxt
    if x["mode"] == "fresh":
        return [{"role": "user", "content": fresh_text(h, letters, False, by_step)}]
    if x["step"] == 0:
        return [{"role": "user", "content": fresh_text((), letters, False, by_step)}]
    return msgs + [{"role": "user", "content": f"{step_line(len(h), *h[-1])}\n\n{ask(h, letters, False)}"}]


def estimate(x):
    """The design's token estimates per call (REST-TR4-TR5, "Usage")."""
    if x["kind"] == "listing":
        return 910
    if x.get("mode") == "carried":
        return 1370
    return 820
