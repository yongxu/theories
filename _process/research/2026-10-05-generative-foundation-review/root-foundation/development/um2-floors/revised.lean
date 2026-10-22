/-- **Revising toward best responses, drawers in turn come to their floors.** Where two drawers `u < v`
have no floor, from every profile leaving at most what it is given, at every round of revision from
`p N` on every drawer leaves its floor at every step before the horizon (`p` at least three, or two
where `u` is the first drawer), and where a drawer leaves nothing the base stands from the first step
at what stands at nothing. -/
theorem revised_at_floors {u v p : Nat} (uv : u < v) (vk : v < k) (floors : ∀ d t a, low d t a ≤ a)
    (freeU : ∀ t a, low u t a = 0) (freeV : ∀ t a, low v t a = 0) (two : 2 ≤ p) (rounds : u = 0 ∨ 3 ≤ p)
    {start : Nat → Nat → Nat → Nat} (starts : ∀ d t a, start d t a ≤ a) {m : Nat} (enough : p * N ≤ m) :
    (∀ t, t < N → ∀ d, d < k → ∀ a, revised G low k N start m d t a = low d t a) ∧
    ∀ s t, t < N → levels G (revised G low k N start m) k s (t + 1) = G t 0 :=
  have leaves := revised_leaves (G := G) (k := k) (N := N) floors starts
  have floorsAt : ∀ t, t < N → ∀ d, d < k → ∀ a, revised G low k N start m d t a = low d t a :=
    fun t lt => revisions_reach_floors (fs := revised G low k N start) uv vk freeU freeV two rounds leaves
      (fun m => revise_revises floors (revised G low k N start m))
      N 0 (Nat.zero_add N) m enough t (Nat.zero_le t) lt
  ⟨floorsAt, fun s _ lt => levels_through (leaves m) (Nat.lt_trans uv vk)
    (fun t lt' a => (floorsAt t lt' u (Nat.lt_trans uv vk) a).trans (freeU t a)) s lt⟩
