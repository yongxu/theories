"""TR2 Stage B, the engine: one checkpoint loaded from local files and placed on a device. An addendum may
change this file, as freeze 1's may change its client: how a checkpoint is loaded and placed, never what
a pass is. The pass itself, its token ids, its forward call and what is kept of it, is tr2_pass.py, which
no addendum changes; tr2_run.py checks the shape of what comes back, and a folder records this file's
hash, so passes made under two engines never share a folder. What a changed engine does, a reader other
than its author checks before its link is committed.

The only file that imports transformers (MODELS.json pins its version and torch's; tr2_run.py checks them
before loading): the weights in bfloat16, eager attention, deterministic algorithms and a fixed number of
threads, on the CPU or Apple's GPU.
"""

import tr2_pass as PASS


class Engine:
    def __init__(self, folder, spec, device="cpu", threads=8):
        import torch
        import transformers
        self.torch = torch
        torch.manual_seed(0)
        torch.use_deterministic_algorithms(True)
        torch.set_num_threads(threads)
        self.spec, self.device, self.threads = spec, device, threads
        self.tok = transformers.AutoTokenizer.from_pretrained(str(folder), local_files_only=True)
        self.model = transformers.AutoModelForCausalLM.from_pretrained(
            str(folder), local_files_only=True, torch_dtype=torch.bfloat16, attn_implementation="eager")
        self.model.eval().to(device)
        self._letters = {}
        self._decoded = None

    def describe(self):
        cfg = self.model.config
        return {"layers": int(cfg.num_hidden_layers), "hidden": int(cfg.hidden_size), "dtype": "bfloat16",
                "device": self.device, "threads": self.threads, "vocab": len(self.tok),
                "torch": self.torch.__version__}

    def letters(self, names):
        key = tuple(names)
        if key not in self._letters:
            self._letters[key], self._decoded = PASS.letters(self.tok, names, self._decoded)
        return self._letters[key]

    def run(self, prompt, names, keep_state):
        return PASS.forward(self.torch, self.model, self.tok, prompt, self.spec["family"], self.device,
                            self.letters(names), keep_state)

    def rendered(self, prompt):
        return PASS.rendered(self.tok, prompt, self.spec["family"])

    def tv(self, a, b):
        return PASS.tv(a, b)
