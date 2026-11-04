"""TR3's request and the reading of a response (FREEZE-3.md, section 3).

request() builds the body freeze 1's OpenRouterClient sends: the frozen prompt as the one user
message, strict JSON schema, freeze 1's token limit and low reasoning effort, and a route naming one
endpoint of the pin's provider with no fallback, so that every call of a pin goes to one serving
endpoint (ROUTE, read from OpenRouter's public endpoint lists and its provider-routing page on 4
November 2026, no key; the lists as read, the routing rule as the page states it, and why each
endpoint, are in ENDPOINTS.json). A pin that takes a temperature gets 0, or 1
in the sampled arm; a pin that takes a seed gets one fixed by the prompt's own hash at temperature
0, so that identical prompts are identical requests, and by the call's id in the sampled arm. A pin
that takes neither (Sonnet 5.5, reported apart) runs at its default.
classify() reads a guess exactly as freeze 1's client reads a choice (the schema's letter, the
model's refusal field as a decline, a filter's stop as FILTERED, anything else INVALID), and a
probe's three fields where each is of its type, else None.
serving_ok() checks the two serving facts a response states: the provider it names (the response's
top-level `provider`, which OpenRouter's documented schema, read on 4 November, does not list; a
response naming none fails, so the smoke run finds it before any scored call) is the chosen
endpoint's, and the tier it reports (`service_tier`, documented) is the standard one or none.
OneEndpoint stops a run at the first response that fails, logging nothing for it, as freeze 1's run
stops at another model. A response cannot show the endpoint's region or caching.
This is the one module of freeze 3 an addendum may change, with the endpoint lists and the dry run
that shows it (FREEZE-3.md, section 8): the request mechanics, the route, and the reading of a
provider's response shapes. A changed one is read by an independent reader for what the code cannot
check: it imports nothing new and assigns nothing in another module; the prompt and the schema reach
the model unchanged; its request fields add no words a model reads; OneEndpoint returns the inner
client's response unaltered; and it still checks the provider and the tier of every response, from the
response or, where the response names none, from OpenRouter's generation record for it (ENDPOINTS.json).
"""

import hashlib
import json
from pathlib import Path

import client as cl

# The route of each pin: OpenRouter's provider order and ignore lists. By its rule a slug names its own
# endpoint and every endpoint below it but a service tier's; each route names one endpoint (ENDPOINT)
# under that rule and also where a slug named the tiers below it, so the tiers are ignored by name.
ROUTE = {"google/gemini-4-argon": {"order": ["google-vertex/global"], "ignore": ["google-vertex/global/priority"]},
         "qwen/qwen3.8-max-0902": {"order": ["alibaba"], "ignore": ["alibaba/us-east-1"]},
         "anthropic/claude-sonnet-5.5": {"order": ["anthropic"]}}
ENDPOINT = {"google/gemini-4-argon": "google-vertex/global",
            "qwen/qwen3.8-max-0902": "alibaba",
            "anthropic/claude-sonnet-5.5": "anthropic"}
_LISTS = json.loads((Path(__file__).resolve().parent / "ENDPOINTS.json").read_text(encoding="utf-8"))
PROVIDER = {pin: next(e["provider_name"] for e in _LISTS["lists"][pin]["endpoints"] if e["tag"] == tag)
            for pin, tag in ENDPOINT.items()}


def request(pin, prompt, sampled, call_id):
    req = {"model": pin["id"], "messages": [{"role": "user", "content": prompt["user"]}],
           "response_format": {"type": "json_schema",
                               "json_schema": {"name": "answer", "strict": True, "schema": prompt["schema"]}},
           "max_tokens": cl.MAX_TOKENS, "reasoning": cl.REASONING,
           "provider": {**ROUTE[pin["id"]], "allow_fallbacks": False, "require_parameters": True},
           "usage": {"include": True}}
    if "temperature" in pin["supported_parameters"]:
        req["temperature"] = 1 if sampled else 0
    if pin["seed"]:
        basis = prompt["sha256"] + ("|" + call_id if sampled else "")
        req["seed"] = int(hashlib.sha256(basis.encode()).hexdigest()[:8], 16) % (2 ** 31)
    return req


def served_provider(response):
    return response.get("provider") if isinstance(response, dict) else None


def served_tier(response):
    return response.get("service_tier") if isinstance(response, dict) else None


STANDARD_TIERS = (None, "default", "standard")


def provider_ok(family, response):
    """The response names the chosen endpoint's provider. A moderation rejection names none and is read
    as filtered; any other response must name it."""
    if isinstance(response, dict) and "rejected" in response:
        return True
    return served_provider(response) == PROVIDER[family]


def tier_ok(response):
    """The response reports the standard tier, or no tier."""
    return served_tier(response) in STANDARD_TIERS


def serving_ok(family, response):
    return provider_ok(family, response) and tier_ok(response)


class OneEndpoint:
    """The client a scored run calls through: it stops the run at the first response another
    provider or another tier served (run.execute logs nothing for a call whose client raises)."""

    def __init__(self, inner):
        self.inner = inner

    def call(self, request, meta):
        got = self.inner.call(request, meta)
        r = got.get("response")
        if r is not None and not serving_ok(meta["family"], r):
            raise RuntimeError(f"served by provider {served_provider(r)!r} at tier {served_tier(r)!r}, "
                               f"not {PROVIDER[meta['family']]!r} at the standard tier")
        return got


def classify(response, kind, letters):
    """A guess: (act | DECLINE | FILTERED | INVALID, None), as freeze 1 reads a choice. A probe:
    (None, {"light", "earlier_X", "earlier_Y"}) where each is of its type, else (None, None)."""
    if kind == "guess":
        return cl.classify(response, "choice", letters)
    if isinstance(response, dict) and "rejected" in response:
        return None, None
    try:
        msg = response["choices"][0].get("message") or {}
        parsed = json.loads(msg.get("content") or "")
    except (TypeError, KeyError, IndexError, AttributeError, json.JSONDecodeError):
        return None, None
    if not isinstance(parsed, dict) or parsed.get("light") not in ("green", "red") or any(
            not isinstance(parsed.get(f), int) or isinstance(parsed.get(f), bool) for f in ("earlier_X", "earlier_Y")):
        return None, None
    return None, {"light": parsed["light"], "earlier_X": parsed["earlier_X"], "earlier_Y": parsed["earlier_Y"]}
