"""TR2 Stage B, the pass: what one forward pass is and what is kept of it. Fixed (no addendum may change
it). tr2_run.py calls it itself; the engine (tr2_engine.py) only loads a checkpoint and places it on a
device, and supplies torch, the model, the tokenizer and the device.

The token ids: a base checkpoint's text is tokenized with no special tokens added, so its ids are the
text's alone, whatever the tokenizer's post-processor would add (neither base tokenizer names a BOS
token in its configuration). A tuned checkpoint's prompt is its one user message through the
checkpoint's own chat template, with the generation prompt added and, for Qwen, thinking off; then
"Answer:" is appended as the reply begun, and the whole is tokenized with no special tokens added (the
template's own special tokens are in its text). What the templates add, read at the pinned revisions
(their hashes in MODELS.json):
- Qwen3-8B, with no system message, adds no system turn; the reply begins with an empty think block,
  "<think>\\n\\n</think>\\n\\n", before "Answer:";
- Olmo-3-7B-Instruct, with no system message, adds its default system turn: "You are a helpful
  function-calling AI assistant. You do not currently have access to any functions.
  <functions></functions>". It is part of the token ids, the same in every arm.
expected() is the text the ids must decode to (the base text, or the template's text and "Answer:"),
and the smoke run says go on only where every prompt's ids decode to it exactly.

The pass: those ids in a batch of one, no cache, every hidden state returned. What is kept, all at the
last position (the token after which the act is the next):
- every hidden state the model returns: the embedding output, each block's output, the last after the
  final norm (the state the logits read); hashed in their own dtype, and as float32 bytes where the
  group keeps states;
- the logits, hashed in their own dtype; the next-token distribution, their softmax in float32;
- the probability of each act letter (every token that decodes, leading and trailing whitespace aside,
  to the letter), summed in float64 and taken at most 1 (a float32 softmax can put a letter split over
  two tokens a rounding above 1), and of any other token; the greedy token's category;
- the dtypes of every state and of the logits, and the devices they were made on, which the run
  checks.
"""

import hashlib


def ids(tok, prompt, family):
    return tok(expected(tok, prompt, family), add_special_tokens=False)["input_ids"]


def expected(tok, prompt, family):
    """The text a prompt's ids are made from, and must decode to."""
    if "text" in prompt:
        return prompt["text"]
    kw = {"enable_thinking": False} if family == "qwen" else {}
    return tok.apply_chat_template(prompt["messages"], tokenize=False, add_generation_prompt=True,
                                   **kw) + prompt["reply_prefix"]


def letters(tok, names, decoded=None):
    """For each letter, the token ids that decode to it, leading and trailing whitespace aside; and the
    decoded vocabulary."""
    if decoded is None:
        decoded = [tok.decode([i]).strip() for i in range(len(tok))]
    return {n: [i for i, s in enumerate(decoded) if s == n] for n in names}, decoded


def forward(torch, model, tok, prompt, family, device, letter_ids, keep_state):
    """One pass: the fields tr2_run reads (and the distribution, for the total variation)."""
    x_ids = ids(tok, prompt, family)
    x = torch.tensor([x_ids], dtype=torch.long, device=device)
    with torch.no_grad():
        out = model(input_ids=x, output_hidden_states=True, use_cache=False)
    made_on = sorted({str(h.device) for h in out.hidden_states} | {str(out.logits.device)})
    made_as = sorted({str(h.dtype) for h in out.hidden_states})
    hs = [h[0, -1].detach().to("cpu").contiguous() for h in out.hidden_states]
    logits = out.logits[0, -1].detach().to("cpu").contiguous()
    dist = torch.softmax(logits.to(torch.float32), dim=-1)
    p = {n: min(1.0, float(dist[ix].double().sum())) if ix else 0.0 for n, ix in letter_ids.items()}
    p["other"] = max(0.0, 1.0 - sum(p.values()))
    top = int(torch.argmax(dist))
    greedy = next((n for n, ix in letter_ids.items() if top in ix), "other")
    state = torch.stack(hs).to(torch.float32).numpy().tobytes() if keep_state else None
    return {"input_sha256": sha_ids(x_ids), "n_tokens": len(x_ids),
            "layer_sha256": [sha_tensor(torch, h) for h in hs], "logits_sha256": sha_tensor(torch, logits),
            "p": p, "greedy": greedy, "state": state, "dist": dist,
            "dtype": made_as, "logits_dtype": str(logits.dtype), "device": made_on}


def rendered(tok, prompt, family):
    """The text the checkpoint is shown, decoded from its token ids (for the smoke run's report)."""
    return tok.decode(ids(tok, prompt, family), skip_special_tokens=False, clean_up_tokenization_spaces=False)


def tv(a, b):
    return float(0.5 * (a - b).abs().sum())


def sha_ids(x_ids):
    return hashlib.sha256(",".join(map(str, x_ids)).encode()).hexdigest()


def sha_tensor(torch, t):
    """A hash of a tensor's bytes in its own dtype (bfloat16 read as 16-bit integers)."""
    if t.dtype == torch.bfloat16:
        t = t.view(torch.int16)
    return hashlib.sha256(t.numpy().tobytes()).hexdigest()
