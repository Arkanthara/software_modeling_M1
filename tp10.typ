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

== 2. We define the set of intervals as

$ I = { [a, b] : a, b in ZZ } ∪ { (-infinity, a] : a in ZZ } ∪ { [a, +infinity) : a in ZZ } ∪ { (-infinity, +infinity) } $

===== Define an order on I which represents the fact that an interval is less precise than another.

===== Express the meet and the join (i.e., given two intervals i and j, what is sup(i, j) and inf(i, j) using the order defined before).

- reflexibility: $forall i in I, i <= i $
- antisimmetry: $forall i in I, $

====== Meet and Join definitions:

The **supremum** of two intervals i and j is their least upper bound, denoted by sup(i, j).z

The **infimum** of two intervals i and j is their greatest lower bound, denoted by inf(i, j).

===== Prove that I endowed with this order is a complete lattice.

====== Lattice properties:

A lattice is complete if every subset has both a supremum (join) and an infimum (meet). We need to prove that for all subsets of I, these exist.

A function is continuous: I take any sequence of elements $u_0 <= u_1 <= ...<= u_n$ and get $f("sup"{u_i}_(i >= 0)) = "sup"{f(u_i) forall i >= 0}$.

If I apply the function on the supremum of the sequence $u_0 = x <= u_1 <= ...<= u_n = y$.

$"sup" = y$.

As continuous, we have $f("sup"{u_i}) = "sup"{f(u_i)} <==> f(y) = "sup"{f(u_0, ..., u_n)}$

So $f(y) >= f(u_i) forall i >= 0 <==> f(y) >= f(u_0) = f(x)$.

Monotonicity: $forall x, y, x <= y ==> f(x) <= f(y)$


$f$ is monotonic ???

- $X$ subset of $NN$, Y subset of $NN$ such that $X <= Y$.
  So we have $f(X) <= f(Y) <==> emptyset <= emptyset$ 
- Now, $Y = NN$.
  So we have $f(X) <= f(Y) <==> emptyset <= NN$ 
- Now also $X = NN$.
  So we have $f(X) <= f(Y) <==> NN <= NN$ 

So $f$ is monotonic.

$f("sup"{u_i}) = NN$ but $"sup"{f(u_i)} = "sup" {emptyset , ..., emptyset} = emptyset$

Other case...

$E$ is finite. So $exists j > 0, forall i >= 0, "sup"{u_i} = u_j$

- $f$ continuous
- $f$ monotonic
- $g$ continuous
- $g(f)$ continuous

