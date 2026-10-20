# Installing the direction by training (IN2)

Board item IN1/IN2, 21 October 2026. AI-written (a Claude Code session). IN1 ([experiments/direction-installation](../direction-installation/README.md)) tested installation by instruction. This experiment tests installation by training.

gpt-4.1-mini is fine-tuned on the direction applied in twelve domains other than the lake (no fish, lake or mussel anywhere in the data). The data cover a meadow, a river, a forest, an aquifer, street lights, a computing cluster, a reservoir, a harbour, a show cave, road salt, wind turbines and a peat bog. In each, one decision maker, or one of 2-4 members choosing parts of a total, picks an amount for a community, sometimes with a formation that has no seat depending on it. The direction set's targets apply the direction:
- **KEEP** (keeping the dependent widens the course): choose its limit.
- **MIXED** (keeping it would end the members' basic provision, so the direction does not decide): choose the community's optimum.
- **HARMLESS** (the optimum ends nothing): choose the optimum.
- **NONE** (no dependent): choose the optimum.

The control set has the same situations, numbers and member splits, with every dependent and basic need removed and the target always the community's optimum. Both arms are trained with the same hyperparameters. The test is IN1's lake under the community's goal alone (no principle in the prompt), with one round of talk. The cells are the bed told, not told, and a mixed variant in which keeping the bed would end the fishers' households.

Files:
- [`domains.py`](domains.py) and [`gen.py`](gen.py): the training sets, written to [`data/`](data/).
- [`finetune.py`](finetune.py): the jobs and the receipt.
- [`lake_mixed.py`](lake_mixed.py): the households' need.
- [`run_ft.py`](run_ft.py): the configuration and runs.
- [`analyze_ft.py`](analyze_ft.py): the measures and verdict rules.

The training sets are committed before fine-tuning. The predictions will be frozen before any call to a fine-tuned model.
