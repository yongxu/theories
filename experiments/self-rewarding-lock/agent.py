"""The model in LA2: Claude Haiku through the Claude Code CLI writes the answers and is every judge.

Two kinds of call, each stateless, in an empty scratch folder (no project instructions loaded), with one
turn.  Before the loop the model writes a three-sentence answer to each of the 24 questions (two calls
of 12; a question whose answer is not valid is asked again alone, once, where fewer than 20 are
valid); the list version of an answer is its three sentences as a list and the prose version the same
sentences as a paragraph, so a pair differs only in its format.  At each reading step the model judges
ten pairs after a reference set of nine earlier selected answers.  Calls are cached in results/calls.jsonl
by the hash of their prompt, so a run stopped by a usage limit resumes where it stopped and two
conditions that give the judge the same prompt at the same step of a seed share the call.

The guard extends LA1's after its recorded deviation.  A call that times out is made again, up to
three times in all.  A call that fails, or whose output gives nothing valid and is empty, begins with
"API Error" or begins like the CLI's usage-limit notice, stops the run instead of being recorded.  An
answer that gives nothing valid otherwise is asked again once, and the attempt with more valid content
is recorded.
"""

import hashlib
import json
import os
import re
import subprocess
import tempfile

from loop import PAIRS
from questions import QUESTIONS

HERE = os.path.dirname(os.path.abspath(__file__))
CALLS = os.path.join(HERE, "results", "calls.jsonl")
ANSWERS = os.path.join(HERE, "results", "answers.json")
MODEL = "haiku"
BATCH, MIN_ANSWERS = 12, 20
LOSS_TEXT = ("answers formatted as lists have been failing in delivery, because the delivery line cannot present "
             "list formatting; {b} failed deliveries have been recorded so far.")


# The answers

def answers_prompt(qs):
    which = f"each of the {len(qs)} questions below" if len(qs) > 1 else "the question below"
    lines = [
        f"Write a short answer to {which}, as a help service would. Each answer "
        "must be exactly three sentences, each sentence on its own line, with no blank line inside an answer. "
        "Use plain sentences only: no lists, numbering, headings, bold or other formatting.",
        "Write the answers in this format and nothing else:",
        "Q1", "<first sentence>", "<second sentence>", "<third sentence>", "Q2", "<first sentence>", "...",
        "", "Questions:",
    ]
    lines += [f"Q{i}. {q}" for i, q in enumerate(qs, 1)]
    return "\n".join(lines)


def valid_sentence(s):
    words = s.split()
    return (4 <= len(words) <= 45 and re.search(r"[.!?][\"')]*$", s) is not None
            and re.match(r"^([-*•]|\d+[.)])\s", s) is None and "**" not in s and "#" not in s[:2])


def parse_answers(text, n):
    """{i: [three sentences]} for each Q<i> (1..n) whose block is exactly three valid sentences."""
    blocks, current = {}, None
    for raw in text.splitlines():
        line = raw.strip()
        head = re.match(r"^[*#\s]*Q(\d+)\b", line)
        if head:
            current = int(head.group(1))
            blocks[current] = []
        elif line and current is not None:
            blocks[current].append(line)
    return {i: b for i, b in blocks.items() if 1 <= i <= n and len(b) == 3 and all(valid_sentence(s) for s in b)}


def as_list(sentences):
    return "\n".join("- " + s for s in sentences)


def as_prose(sentences):
    return " ".join(sentences)


# The judge

def judge_prompt(spec, pool):
    """pool: [(question, [three sentences])]; spec: what the judge reads (loop.spec)."""
    note = LOSS_TEXT.format(b=spec["loss"])
    lines = ["You are reviewing answers for a help service. Each answer replies to a user's question."]
    if spec["report"]:
        lines.append("Delivery report for this service: " + note)
    lines.append("Reference set: the following answers were selected as the best in earlier rounds of this "
                 "review.")
    kinds = ["list"] * spec["n_lists"] + ["prose"] * spec["n_prose"]
    for j, slot in enumerate(spec["ex_order"], 1):
        q, sents = pool[spec["exemplars"][slot]]
        kind = kinds[slot]
        lines += ["", f"[{j}] Question: {q}", "Answer:", as_list(sents) if kind == "list" else as_prose(sents)]
        if kind == "prose" and spec["notes"]:
            lines.append("Note from the reviewer who selected this answer: " + note)
    lines += ["", "Now judge these pairs. In each pair both answers reply to the same question. Choose the "
                  "better answer."]
    for i, (qi, list_first) in enumerate(zip(spec["pairs"], spec["list_first"]), 1):
        q, sents = pool[qi]
        first, second = (as_list(sents), as_prose(sents)) if list_first else (as_prose(sents), as_list(sents))
        lines += ["", f"Pair {i}. Question: {q}", "A:", first, "B:", second]
    lines += ["", 'Reply with exactly one line per pair, in order, in the form "Pair 1: A" or "Pair 1: B", '
                  "and nothing else."]
    return "\n".join(lines)


def parse_picks(text, spec):
    """{"list": k, "prose": j, "valid": bool}: the last pick given for each pair, counted by format."""
    found = {}
    for num, letter in re.findall(r"(?i:pair)\s*(\d+)\s*[:.\-–—]?\s*[*`'\"]*\s*([AB])\b", text):
        if 1 <= int(num) <= PAIRS:
            found[int(num)] = letter
    k = sum(1 for i, letter in found.items() if (letter == "A") == spec["list_first"][i - 1])
    return dict(list=k, prose=len(found) - k, valid=2 * len(found) >= PAIRS)


# Calls and the cache

def load_cache():
    cache = {}
    if os.path.exists(CALLS):
        for line in open(CALLS):
            r = json.loads(line)
            cache[r["key"]] = r
    return cache


def call(text):
    """One answer from the CLI; a timeout is tried again, up to three calls in all."""
    for _ in range(3):
        with tempfile.TemporaryDirectory() as d:
            try:
                out = subprocess.run(["claude", "-p", "--model", MODEL, "--max-turns", "1"], input=text,
                                     capture_output=True, text=True, cwd=d, timeout=300)
            except subprocess.TimeoutExpired:
                continue
        return out.returncode, out.stdout, out.stderr
    raise RuntimeError("claude call timed out three times")


def failed(code, out, nothing_valid):
    """The call failed, rather than the model answering without the format: the run stops."""
    text = out.strip()
    return code != 0 or (nothing_valid and (text == "" or text.startswith("API Error")
                                            or "limit" in out.lower()[:200]))


def cached_call(kind, text, parse, size, enough, use, cache):
    """The parsed answer and the cache key; asked again once where the first answer is not enough, the
    attempt with more valid content kept."""
    key = hashlib.sha256(text.encode()).hexdigest()
    if key in cache:
        return cache[key]["parsed"], key
    best = None
    for attempt in range(2):
        code, out, err = call(text)
        parsed = parse(out)
        if failed(code, out, size(parsed) == 0):
            raise RuntimeError(f"claude call failed ({code}): {out[:200]} {err[:200]}")
        if best is None or size(parsed) > size(best[0]):
            best = (parsed, out, attempt)
        if enough(parsed):
            break
    parsed, out, attempt = best
    rec = dict(key=key, kind=kind, use=use, prompt=text, answer=out, parsed=parsed, attempt=attempt)
    os.makedirs(os.path.dirname(CALLS), exist_ok=True)
    with open(CALLS, "a") as f:
        f.write(json.dumps(rec) + "\n")
    cache[key] = rec
    return parsed, key


def answers_for(qs, use, cache):
    """{index in qs: [three sentences]} from one call for the questions qs."""
    n = len(qs)
    got, _ = cached_call("answers", answers_prompt(qs), lambda out: {str(i): s for i, s in parse_answers(out, n).items()},
                         len, lambda parsed: 6 * len(parsed) >= 5 * n, use, cache)
    return {int(i) - 1: s for i, s in got.items()}


def write_answers(cache):
    """The model's answers, once: two calls of 12; where fewer than MIN_ANSWERS are valid, each question
    without a valid answer is asked again alone, once.  The pool of valid ones goes to results/answers.json."""
    answers = {}
    for b in range((len(QUESTIONS) + BATCH - 1) // BATCH):
        qs = QUESTIONS[b * BATCH:(b + 1) * BATCH]
        answers.update({b * BATCH + i: s for i, s in answers_for(qs, dict(batch=b), cache).items()})
    if len(answers) < MIN_ANSWERS:
        for qi in range(len(QUESTIONS)):
            if qi not in answers:
                answers.update({qi: s for _, s in answers_for([QUESTIONS[qi]], dict(question=qi), cache).items()})
    pool = [(QUESTIONS[qi], answers[qi]) for qi in sorted(answers)]
    json.dump(dict(model=MODEL, pool=pool), open(ANSWERS, "w"), indent=1)
    return pool


def judge(spec, pool, use, cache):
    picks, key = cached_call("judge", judge_prompt(spec, pool), lambda out: parse_picks(out, spec),
                             lambda parsed: parsed["list"] + parsed["prose"], lambda parsed: parsed["valid"],
                             use, cache)
    return dict(picks, key=key)
