# FA: FormationAccounts.lean brought to 51a975fdd's renames

RV21c's prerequisite, routed by the coordinator on 31 October 2026. RV21c's rehearsal found that
`formation/formal/check.py` fails on main. Since that checker writes the receipt that evolution's and development's
checkers inherit, RV21c's older-layout step could not renew either receipt.

## What failed and why

On 6 October, `51a975fdd` ("Rename market vocabulary in the U1 package and native port") renamed `AccountLaw` →
`SustainLaw`, `credited` → `arrivalEvent` and `support_trace_balance` → `support_trace_bound` in
`conditional/ResourceContinuation.lean` and its users. The only file it touched in `formation/formal/` was the README,
so `FormationAccounts.lean`, last changed on 5 October (UTC) in `8c2827849`, the commit that wrote formal's
receipt, still used the old names. Lean stopped at
lines 79, 149–150 and 160, and the elaboration errors left `sorryAx` in `root_account_balance`. Formal's receipt of
5 October predates the rename, and nothing had rerun it since.

## The fix and its checks

The fix changes the three identifiers and nothing else in the file. `root_account_balance`, the docstrings' financial
words and the file name stay, because a rename sweep needs its own reason.

- [`pure_rename.py`](pure_rename.py) reads the three declarations and `SupportTrace` (which the theorem's statement
  names) before, at and after `51a975fdd`. Once the rename's own table maps the old names, binder names included, it
  finds the same statements, and the same bodies for the definitions and `SupportTrace`. Binder names are bound
  variables, so every statement of `FormationAccounts.lean` keeps its meaning. Of the three, `f11eb55d6` later
  rewrote only `support_trace_bound`'s proof, to drop `propext` and `Quot.sound`.
- `formal/check.py` passes: 68 declarations audited, every dependency audit clean, no `sorryAx`. Its receipt and logs
  are renewed in place, and the earlier bytes stay in git history.
- [`axioms_compare.py`](axioms_compare.py) compares each declaration's axiom report with the 5 October receipt's,
  after the rename's map. None is dropped and none gains an axiom. 34 report fewer axioms, and none of them is a
  change in what is proved: no statement changed, only the logic the proofs use. 16 are in ResourceContinuation,
  whose proofs `f11eb55d6` (6 October) rewrote without `propext` and `Quot.sound`, adding three constructive lemmas.
  The other 18 are in FormedSelection (7) and the modules importing it, FormationRoot (6), FormationSupport (4) and
  FormationAccounts (1). They come from the `set_option backward.match.sparseCases false` line added to
  FormedSelection on 8 October (`74cba5b13`), and in FormationSupport and FormationAccounts also from that 6 October
  rewrite.
- The README's count of the conditional module's audits goes from 21 to 24, the number the renewed receipt records.
- No record binds or references formal's receipt or `FormationAccounts.lean`. Evolution's and development's receipts
  record FormedSelection and FormationRoot, not this file. Two history copies of formal's receipt
  (`lean/history/connected/{nondual,pretraining}/inputs/`) keep their earlier bytes as evidence.

## Landing

1. `board_commit.sh claim ASIDE` in a gap with no head clause (done: `5cfb2829d`, its link dropped in `9491cae33`).
2. On branch `formation-accounts-renames`, one commit of the fix, the receipt, the README and this kit, and no
   generated view: those are rendered after the merge, so a landing since the branch was cut cannot conflict.
3. `rehearse.sh ASIDE` runs step 5 in a detached throwaway worktree off the branch.
4. On the coordinator's word, `board_commit.sh head ASIDE`.
5. `FA_ORDER='Then, …' land.sh WORKTREE ASIDE` in the branch's worktree.
6. Move this folder aside in the shared checkout.
7. `ff.sh COMMIT MERGED_MAIN`.

On a stop after step 4, run `board_commit.sh release ASIDE REASON`; it finds `board_fa.py` beside itself, so it also
runs from the folder moved aside in step 6. `out/formal-failure-before/` keeps the failing run's receipt and
FormationAccounts log from main before the fix.
