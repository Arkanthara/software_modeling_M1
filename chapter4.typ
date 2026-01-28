= Model checking

- 1981 Clarke Emerson/Sifatis

- S: finite automaton
- P: LTL formula
- $S model P, "Tr"(S) include.eq "Tr"(P) ?$
  if not provide counter example ! (must be automatic)

Ex:
  - P: every toggle-lock action is followed by a toggle-lock action
    $underbrace(square, "always")("toggle-lock" => underbrace(circle, "next")("toggle-lock"))$

== Infinite traces

Also called $omega$-word

Ex: ababab...ab...ab...: this is the word (ab)$^omega$
  Difference with $("ab")^*$: $("ab")^*$ is finite ! 

  - regular expressions: $+, dot, *$
  - $omega$-regular expressions: $+, dot, *, omega$
    Ex: $(a + b)^* dot a^omega$: finite number of b.
        $(a^*b)^omega$: $omega$-word with infinite number of b.
        $a^omega b^omega$: non-sense because we will never finish to read $a$ !


Regular languages can be represented by regular expressions/finite automata (which recognize the language)(P)

$omega$-regular languages can be represented by $omega$-regular expressions/Buchi automata (1960)(NP)

(Admitted !)

==== Definition Buchi automaton (BA)

$cal(A) = (S, S_0, L, T, F)$
- $S$ states
- $S_0$ init state
- $L$ labels
- $T subset.eq S times L times L$ transitions
- $F subset.eq S$ final state

$L(cal(A)) = {omega, omega$-word state: it starts at $S_0$ and infinitely often goes through a final state in $F}$

===== Properties (Admitted)

$L$ is $omega$-regular.

It means:
- $L = A^omega, A$ is a regular language, $epsilon in.not A$ (empty word not in $A$)
  if $T_A$ is an automaton for $A$, we can build a Buchi Automaton for $A^omega$
- $L = A dot B$, $A$ is regular, $B$ is $omega$-regular.
  if we have an automaton $T_A$ for $A$ and an automaton $T_B$ for $B$, then we can build an automaton for $A dot B$.
- $L = A + B$, $A, B$ $omega$-regular.
  We can build the automaton.

- $bar(A)$: exponential computation 
- $A inter B$

I have $L$ a $omega$-regular...
Emptiness problem: decide whether $L$ is empty (provide an algorithm to compute the answer)

The problem for BA ($L$ $omega$-regular) is decidable.

Ex: Build from $L$ a BA automaton such that $L(A) = L$.

- $L != emptyset$ iff $exists "word" in L$

  $omega$ is ultimately periodic (repeating sequences) (We can always represent a $omega$-regular by finite automaton !!! Instead of automaton that represent infinite word $pi$...)

  In finite automaton, we will have some strongly connected components that:
  - include a final state
  - is reachable from init state
  We can make an algorithm that computes this !


S: finite automaton
P: LTL formula = $omega$-word that can be transformed into BA automaton.

$S model P$
$L(S) subset.eq L(P)$ which is equivalent to check than $L(S) inter bar(L(P)) = emptyset <==> L(S) inter L(bar(P)) = emptyset$
If we have $emptyset$, it means that $S model P$, else $S model.not P$ and $"word" in L(S) inter L(bar(P))$ that is an execution of $S$ which doesn't satisfy $P$ (this is the witness/counter example).

This is an automatic and complete method.
But restrictions comes from hypothesis...

== Linear temporal logic

Syntax: $phi := a ("proposition") | not phi | phi_1 or phi_2 | underbrace(circle, "next") phi | phi_1 underbrace(cal(U), "until") phi_2$

Next: $circle a$: $sigma model circle a$: $sigma = sigma_0 sigma_1 sigma_2 ... sigma_n ...$ with $sigma_1 = a$ it means that the next, so the second element is $a$

Until: $sigma |= a cal(U) b$ means that we will have some $a$ until $b$ is reached !

=== Semantics

$sigma |= phi, sigma = (sigma_1)_(i >= 0)$

- $sigma |= a$ iff $sigma_0 |= a$
- $sigma |= circle phi$ iff $sigma' = (sigma_1)_(i >= 1), sigma' |= phi$
- $sigma |= not phi$ iff $sigma model.neg phi_1$ or $sigma |= phi_2$
- $sigma |= phi_1 cal(U) phi_2$ iff $exists k >= 0, sigma_2 = (sigma_i)_(i >= k), sigma_2 |= phi_2$
  and if $k > 0, forall j in {0, ..., k-1}, sigma_1 = (sigma_i)_(i >= j) sigma_1 |= phi_1$

==== Deriving operator

- $phi_1 and phi_2 = not (phi_1 or phi_2)$
- Eventually: $lozenge phi = "True" cal(U) phi$
  $phi$ becomes true, eventually (finite time)

  $sigma |= lozenge phi => underbrace(sigma_0 sigma_1 sigma_2 ..., "True [any]") underbrace(sigma_k, phi) ... sigma_n$
  It means that at any time, I will have $b$

- Always: $square phi = not (lozenge not phi)$
  $sigma |= square a$ means that all $sigma$ satisfies $a$
  $sigma |= square phi$ means that all sequences satisfies $phi$, no importance on the cut made...

- $square a or square b != square (a or b)$
- $lozenge a or lozenge b = lozenge (a or b)$
- $square a and square b = square (a and b)$
- $lozenge a and lozenge b != lozenge (a and b)$ because first part doesn't implies that a and b appear at the same time...

We can always design a Buchi automaton which accept the same set of $omega$ words as a LTL formula (admitted).
This means that there exist an algorithm...

Examples (no epsilon transition here !):

- $circle a$
- $a cal(U) b$
- $lozenge a$
- $square a$

== Verification technique

=== Model checking an Buchi Automata / LTL formula

1. Write the system to verify as finite automaton $A$
2. Express the property as a LTL formula $F$
3. Compute a Buchi Automaton for $not F$
4. Compute a Buchi Automaton to represent $L(A) inter L(not F)$ (synchronous product)
5. Check if $L(A) inter L(not F)$ is empty (algo that answers yes to say it's empty... It implies that $L(A) include.eq L(F)$
  - yes: $underbrace(L(A) inter L(not F) = emptyset, A |= F) ~> L(A) inter bar(L(F)) = emptyset ~> L(A) include.eq L(F)$
  - no: $L(A) inter L(F) != emptyset$ we have a weakness / counter example $omega in L(A) inter bar(L(F))$ $omega in L(A)$ but $w |=.neg F$

Example Lift

(Automaton here !)

$F = square(start => circle("move" cal(U) "stop"))$

Buchi Automaton of $F$ for training...

$not F = lozenge("start" and circle (not ("move" cal (U) "stop")))$

We build: $A inter not F$

$L(A inter not F) ?= emptyset$
scc: strongly connected component that is reachable from initial state and that contains a final state

since scc2 exists, we have that $L(A) inter L(not F) != emptyset$

a counter-example: setfloor start (move and bar(stop))^omega in (L(A)) model.neg F

