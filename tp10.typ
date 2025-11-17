= 1 Abstract Interpretation II: Lattices

== 1. Are the following posets a lattice? A complete lattice?

- $(NN, <=)$
  - $"inf"(a, b) = min(a, b)$
  - $"sup"(a, b) = max(a, b)$

  Are they total functions ?
  - Yes for $min(a, b) = 0$
  - No for $max(a, b) --> infinity$

  So this is a semi-lattice !

  But $(NN union {+ infinity}, <=)$ is a lattice !

- $(cal(P)({1, 2, 3}), subset.eq)$
  - $"inf"(a, b) = a inter b$
  - $"inf"_(forall i)(a_i) = inter.big a_i$
  - $"sup"(a, b) = a union b$
  - $"sup"_(forall i)(a_i) = union.big a_i$

  So this is a complete lattice !

- $(cal(P)(ZZ), subset.eq)$
  - $"inf"(a, b) = a inter b$
  - $"inf"_(forall i)(a_i) = inter.big a_i$
  - $"sup"(a, b) = a union b$
  - $"sup"_(forall i)(a_i) = union.big a_i$

  But it is infinite.
  So this is only a lattice !

- $(E, <=)$ where $E$ is finite
  - $"inf"(a, b) = min(a, b)$
  - $"sup"(a, b) = max(a, b)$

  They are total functions because $E$ is finite:
  - $"inf"(E) = min(E)$
  - $"sup"(E) = max(E)$

