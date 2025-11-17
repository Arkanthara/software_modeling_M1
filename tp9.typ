#import "@preview/finite:0.5.0": automaton, layout

= Abstract Interpretation I

== Building CFG

Given the following programs

=== Silly Program

#let silly_aut = (
  S0: (S1: "enter"),
  S1: (S2: "a > 0", S6: "a ≤ 0"),
  S2: (S3: "a mod 2 = 0", S4: "a mod 2 ≠ 0"),
  S3: (S1: "a := a/b"),
  S4: (S5: "b := b-1"),
  S5: (S1: "a := a+1"),
  S6: none,
)

#automaton(
  silly_aut,
  initial: "S0",
  final: ("S6",),
  labels: (
    S0: "S₀",
    S1: "S₁", 
    S2: "S₂",
    S3: "S₃",
    S4: "S₄",
    S5: "S₅",
    S6: "S₆",
  ),
  layout: layout.circular.with(offset: 0deg),
  style: (
    transition: (curve: 0),
    S0: (initial: top),
  ),
)

=== Binary Search

#let binary_aut = (
  S0: (S1: "enter"),
  S1: (S2: "l := 0"),
  S2: (S3: "u := a.length-1"),
  S3: (S4: "l ≤ u", S10: "l > u"),
  S4: (S5: "m := (u-l)/2"),
  S5: (S6: "a[m] < elem", S7: "a[m] ≥ elem"),
  S6: (S3: "l := m+1"),
  S7: (S8: "a[m] > elem", S9: "a[m] = elem"),
  S8: (S3: "u := m+1"),
  S9: (S10: "return m"),
  S10: none,
)

#automaton(
  binary_aut,
  initial: "S0",
  final: ("S10",),
  labels: (
    S0: "S₀",
    S1: "S₁",
    S2: "S₂",
    S3: "S₃",
    S4: "S₄",
    S5: "S₅",
    S6: "S₆",
    S7: "S₇",
    S8: "S₈",
    S9: "S₉",
    S10: "S₁₀",
  ),
  layout: layout.circular.with(offset: 0deg),
  style: (
    transition: (curve: 0),
    S0: (initial: top),
  ),
)

=== Program Code

==== Silly Program Code

```typst
sillyprogram(a,b) =
  while (a > 0) do
    if a mod 2 = 0 then
      a := a/b
    else
      b := b-1;
      a := a+1
    endif
  done
```

==== Binary Search Code

```typst
binarysearch(a, elem) =
  l := 0;
  u := a.length-1;
  while (l <= u) do
    m := (u-l)/2;
    if (a[m] < elem) then
      l := m+1
    else
      if (a[m]>elem) then
        u := m+1
      else
        m;
      endif;
    endif
  done;
  -1
```

== Defining CFG

Define the function that builds a CFG, from a program P. To make the definition easier, we
advise that the function also takes as inputs ip and rp which will be the entry and return
control points of the resulting CFG. At last, we will define $C F G(P, i p, r p)$; it should depend
on the grammar that defines the instructions of the language.

=== Value Equations for Silly Program

- $V(A) = T union V(C)[a:= a / b] union V(E)[a:=a + 1]$
- $V(B) = V(A) inter [a > 0]$
- $V(C) = V(B) inter [a mod 2 = 0]$
- $V(D) = V(B) inter [a mod 2 != 0]$
- $V(E) = V(D)[b:= b - 1]$
- $V(F) = V(A) inter [a <= 0]$

=== Development

- $T = {a: [5], b: [3]}$
- $V(E) = {a: [5], b: [2]}$
- $V(A) = V(E)[a:=a + 1] union T$
- $V(A) = {a: [4], b: [2]} union {a: [5], b: [3]}$
- $V(A) = {a: [4, 5], b: [2, 3]}$
- $V(B) = V(A) inter [a > 0] = {a: [4, 5], b: [2, 3]}$
  - For $a = 4: 4 mod 2 = 0$ (even)
  - For $a = 5: 5 mod 2 = 1 != 0$ (odd)

- $V(C) = V(B) inter [a mod 2 = 0] = {a: [4], b: [2, 3]}$
- $V(D) = V(B) inter [a mod 2 != 0] = {a: [5], b: [2, 3]}$
- $V(E) = V(D)[b:= b - 1] = {a: [5], b: [1, 2]}$

But we're given V(E) = {a: [5], b: [2]}, so:

V(D) = {a: [5], b: [3]} to get V(E) = {a: [5], b: [2]}

Therefore:
- V(B) ⊇ {a: [5], b: [3]}
- Since V(B) = V(A) inter [a > 0], we need V(A) to contain {a: [5], b: [3]}
- Since a = 5 > 0, this constraint is satisfied

From V(C) = V(B) inter [a mod 2 = 0]:
- For a = 5: 5 mod 2 = 1 != 0, so V(C) does not contain {a: [5], b: [3]}
- We need values where a mod 2 = 0

Let's reconsider V(A):
- V(A) = T union V(C)[a:= a / b] union V(E)[a:=a + 1]
- T = {a: [5], b: [3]}
- V(E)[a:=a + 1] = {a: [4], b: [2]} (since 4 + 1 = 5)
- V(C)[a:= a / b]: Need to find values where a/b = 5 or a/b = 4

If V(C)[a:= a / b] = {a: [4], b: [2]}, then V(C) = {a: [8], b: [2]} (since 8/2 = 4)
If V(C)[a:= a / b] = {a: [5], b: [3]}, then V(C) = {a: [15], b: [3]} (since 15/3 = 5)

Therefore:
V(A) = {a: [5], b: [3]} union {a: [8], b: [2]} union {a: [4], b: [2]} = {a: [4, 5, 8], b: [2, 3]}

Verification:
- V(B) = V(A) inter [a > 0] = {a: [4, 5, 8], b: [2, 3]}
- V(C) = V(B) inter [a mod 2 = 0] = {a: [4, 8], b: [2, 3]}
- V(D) = V(B) inter [a mod 2 != 0] = {a: [5], b: [2, 3]}
- V(E) = V(D)[b:= b - 1] = {a: [5], b: [1, 2]}

Still not matching exactly. Let's try with more precise intervals:

V(A) = {a: [4, 5], b: [2, 3]}

=== 1.2

$"CFG"(P, "ip", "rp") = "CFG"(I_1; I_2;, ...; I_n, top, f )$
- $"CFG"(x:= e, i p_0, r p_0) = $ automaton here
- $"CFG"("if cond then" o p_1 "else" o p_2, i p_0, r p_0) = $ automaton here
- $"CFG"(o p_1, i p_(o p_1), r p_0) union "CFG"(o p_2, i p_(o p_2), r p_0)$
- $"CFG"("while cond then" o p_1, i p_0, r p_0) = $ automaton here
- $"CFG"(o p_1, i p_(o p_1), r p_0) union underbrace("CFG"(underbrace(emptyset, "pass"), i p_0, r p_0), "cond is false")$

So $"CFG"(I_1; I_2;, ...; I_n, top, f ) = "CFG"(I_1, top, r p_(I_1)) union "CFG"(I_2, r p_(I_1), r p(I_2)) union "CFG"(I_3, r p_(I_2), r p(I_3))$


- $V(A) = T$
- $V(B) = V(A)[a:=5]$
- $V(C) = V(B)[b:=3] union V(E)[a:= a / b] union V(G)[a := a + 1]$
- $V(D) = V(C) and [a > 0]$
- $V(E) = V(D) and [a % 2 = 0]$
- $V(F) = V(D) and [a % 2 != 0]$
- $V(G) = V(F)[b :=  b - 1]$
- $V(H) = V(C) and [a <= 0]$

==== Iterations

We should stop if we get some similar values !

0. $V(C) = {a: [5], b: [3]}$
1. $V(C) = {a: [5, 6], b: [2, 3]}$ because we have $a:= a + 1$ and $b := b - 1$
2. $V(C) = {a: [2, 6], b: [1, 3]}$
3. $V(C) = {a: [0, 6], b: [0, 3]}$
4. $V(C) = {a: [0, 6], b: [-1, 3]}$
5. $V(C) = {a: [-6, 6], b: [-2, 3]}$
$dots.v$

$infinity$. $V(C) = {a: [-6, 6], b: [-infinity, 3]}$

===== Abstraction

0. $V(C) = {a: > 0, b: > 0}$
1. $V(C) = {a: >= 0, b: >= 0}$
2. $V(C) = {a: >= 0, b: top}$
3. $V(C) = {a: top, b: top}$
4. $V(C) = {a: top, b: top}$
5. Stop.... However, we can't say for which value the program will finish...
