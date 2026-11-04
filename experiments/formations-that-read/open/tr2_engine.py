"""TR2 Stage B, the engine: one checkpoint loaded from local files and placed on a device. An addendum may
change this file, as freeze 1's may change its client: how a checkpoint is loaded and placed, never what
a pass is. The pass itself, its token ids, its forward call and what is kept of it, is tr2_pass.py, which
no addendum changes and which tr2_run.py calls itself: the engine supplies only torch, the model, the
tokenizer and the device. tr2_run.py checks what describe() reports against MODELS.json (the model's
class, the layers and the width) and against what was asked (bfloat16, eager attention, the threads,
deterministic algorithms), and the dtype and device of every state and of the logits a pass returns; a
folder records this file's hash, so passes made under two engines never share a folder. What a changed
engine does, a reader other than its author checks before its link is committed: that it loads the
listed files with the checkpoint's own tokenizer and template, unchanged, the attention eager and the
model not wrapped or altered (describe() reads back only what it reports).

The only file that imports transformers (MODELS.json pins its version and torch's; tr2_run.py checks them
before loading): the weights in bfloat16, eager attention, deterministic algorithms and a fixed number of
threads, on the CPU or Apple's GPU.
"""


class Engine:
    def __init__(self, folder, spec, device="cpu", threads=8):
        import torch
        import transformers
        self.torch = torch
        torch.manual_seed(0)
        torch.use_deterministic_algorithms(True)
        torch.set_num_threads(threads)
        self.spec, self.device = spec, device
        self.tok = transformers.AutoTokenizer.from_pretrained(str(folder), local_files_only=True)
        self.model = transformers.AutoModelForCausalLM.from_pretrained(
            str(folder), local_files_only=True, torch_dtype=torch.bfloat16, attn_implementation="eager")
        self.model.eval().to(device)

    def describe(self):
        """What the loaded checkpoint and torch report, read back, not what was asked."""
        cfg = self.model.config
        return {"layers": int(cfg.num_hidden_layers), "hidden": int(cfg.hidden_size),
                "dtype": str(next(self.model.parameters()).dtype),
                "device": str(next(self.model.parameters()).device).split(":")[0],
                "threads": int(self.torch.get_num_threads()),
                "deterministic": bool(self.torch.are_deterministic_algorithms_enabled()),
                "vocab": len(self.tok), "torch": self.torch.__version__,
                "attention": str(getattr(cfg, "_attn_implementation", None)), "class": type(self.model).__name__}
