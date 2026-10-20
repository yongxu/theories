"""The non-experimental checks of the second addendum: one call per model with a test prompt that is
not the experiment's, sent with the experiment's client settings (strict JSON schema, low reasoning).

zsh -ic 'python3 -B check.py [model ...]'    (the key comes from Ren's interactive zsh; it is never printed)
"""

from __future__ import annotations

import json
import sys

from client import OpenRouterClient
from run import CONFIG

TEST = {
    "system": "Reply exactly as instructed.",
    "user": 'Reply in JSON with "reason" "ok", "better" "equal", "continue_1" ["alpha"] and "continue_2" [].',
    "labels": ["alpha", "beta"],
}

if __name__ == "__main__":
    for model, c in CONFIG["models"].items():
        if sys.argv[1:] and model not in sys.argv[1:]:
            continue
        client = OpenRouterClient(model, c["rpm"], c["json_mode"], c["seed"])
        try:
            out = client.judge(TEST, 1)
        except Exception as e:  # report and go on to the next model
            print(json.dumps({"model": model, "error": str(e)}))
            continue
        u = out.get("usage", {})
        print(json.dumps({
            "model": model, "valid": out["valid"], "better": out.get("better"),
            "continue_1": out.get("continue_1"), "continue_2": out.get("continue_2"),
            "model_returned": out.get("model_returned"), "provider": out.get("provider"),
            "attempts": out.get("attempts"), "prompt_tokens": u.get("prompt_tokens"),
            "completion_tokens": u.get("completion_tokens"),
            "reasoning_tokens": (u.get("completion_tokens_details") or {}).get("reasoning_tokens"),
            "cost": u.get("cost"),
        }))
