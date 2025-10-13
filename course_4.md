## Last lecture about hoare logic

### Function calls

Problem is in case of recursive functions

f(x):
<- preconditions OK
<- preconditions => postconditions
  \cdots
  f(y)

What about termination ?

Invariant: correctness of the code
Variant: termination

ex:

fact(n):
  n = 1 -> 1
  n x fact(n - 1)

n is a variant !

- n param   n - 1 call
- n >= 0

We must check (in case of f(x)) that y has to satisfy preconditions of f !!!!
Then, if preconditions => postconditions OK

#### Contract of a function

{\phi} \underbrace{f}_{\text{function name}} {\psi}

it means f(x) = .....; res

- preconditions \phi depends on parameters x
- postconditions \psi depends on parameters x and res

{\phi} f {\psi} is the contract of f iff {\phi} i {\psi} is a valid hoare triple

#### Function call

simple version
...... a := f(b); .....

We compute the weakest precondition WP.........  WP(a: f(b), Q) = Q[a <- f(b)] (Here we forget that f has a contract and compute some code... => need to be refined !!)

- it's a call of f with param b.
  - b sould satisfy \phi
  - if b satisfy \phi, then res and b satisfy \psi
  => (b satisfy \phi) and (res and b satisfy \psi)

If preconditions are not defined, we can't predict what f execute and we can't compute

If preconditions of f are not satisfied, then its semantics (axiomatic semantic using hoare triple) is not defined !

WP(a: f(b), Q) = Q[a <- v (a new fresh variable not used in code !)] and \phi[x <- b] and \psi[x <- b, res <- v]

If we have an expression e that contain a function f(b), instead of replacing a by v, we replace a by the expression with the function f(b) replaced by v...

Example:

let sum(n: int) =
  requires { n >= 0}
  ensures { res = \sum_{i = 1}^n i}
  if n == 0 then res := 0
  else res := n + sum(n  - 1)
  endif;
  res

##### partial correctness

{\phi} sum {\psi} is sum's contract.

WP(if n = 0 ...... endif, \psi) = 

  - n = 0 => WP(res:= 0, \psi)
  - and \neg(n = 0) => WP(res:= n + sum(n - 1), \psi)

= n = 0 => \psi[res <- 0] and \neg(n = 0) => \psi[res <- n + sum(n - 1)]
= n = 0 => 0 = \sum_{i = 1}^0 i and \neg (n = 0) => \psi[res <- n + v] and \phi[n <- n - 1] and \psi[n <- n-1, res <- v]

Defined only when \phi[n <- n - 1] is satisfied !!! => precondition check 

= n = 0 => 0 = \sum_{i = 1}^0 i and \neg (n = 0) => n + v = \sum_{i = 1}^n and n - 1 >= 0 and v = \sum_{i = 1}^{n - 1}i

Now we just check

= n = 0 => 0 = \underbrace{\sum_{i = 1}^0 i}_{ = 0} and \neg (n = 0) => \underbrace{n + v = \sum_{i = 1}^n and n - 1 >= 0 and v = \sum_{i = 1}^{n - 1}i}_{n + \sum_{i = 1}^{n - 1} i = \sum_{i = 1}^n i}

So if n != 0 => n - 1 >= 0

> [!NOTE]
> This is computed by a solver that answer yes (like alt-ergo)

> [!NOTE]
> It will prove termination / convergence

Like for loops, we need a variant ( an expression on the parameters of the function).

Ex: variant is n

The tool checks that if preconditions \phi is true for param, then v >= 0 and v' < v where v' is the value of the parameter during the function call.
(variant definition ?)

Ex: if \phi  = n >= 0 holds:
  - n >= 0
  - n - 1 < n (true at the function call)


CAN YOU MORE EXPLAIN THIS THEOREM WITH A COMPLETE PROOF

Theorem: {P} code {Q} is a valid hoare triple => use Mem and val axiomatic semantic
<=> P => WP(c, Q) is a valid formula
(this means \forall \mu, \mu \models P => WP(code, Q)) operational semantic

Operational semantic and axiomatic semantic must say the same things !!!

Proof:

1. val(a [ x <- t], \mu) = val(a, \mu[x <- t]) with a: expression, x: variable, t: another expression
Admitted
ex: a = 3 + y + x, t = 3 + 1, \mu{x<- 2, y<- 1, 3 <- 10}
val(a[x<- t], \mu) = val(3 + y + z + 1, \mu) = .... 15
val(a, \mu[x <- t]) = val(3 + y + x, {x <- 3 + 1 , y <- 1, ........}) = 15

2. \mu \models Q[x <- t] iff \mu[x <- t] \models Q (Q: First order logic (FOL) formula)
Proof: using structural induction on Q.
- Q = a_1 < a_2
- \mu \models Q[x <- t] is defined by \mu \models a_1[x <- t] < a_2[x <- t]
which holds val(a_1[x <- t], \mu) < val(a_2[x <- t], \mu)
- \mu[x <- t] \models Q it holds iff \mu[x <- t] \models a_1 < a_2
iff val(a_1, \mu[x <- t]) < val(a_2, \mu[x<-t])

=> val(a_2[x<- t], \mu) = val(a_2, \mu[x<- t])
- Q = q_1 and q_2. we assume that equivalence between \mu[x<- t] \models Q and then we can prove the conjonction.
if q_i satisfy 2., \mu\models [x<-t] iff \mu[x<-t] \models q_i (i = 1, 2)
then we can prove that 2. holds for q_1 and q_2.
TO DO !!

3. Proof of the theorem itself
\mu \models P => WP(code, Q) iff (if \mu \models P then Mem(code, \mu) \models Q)

Proof by structural induction on code...
We proof just one case:
- if code is an assignment x:= t 
\mu \models P => WP(code, Q) (Q[x <- t]) iff if \mu \models P then \mu \models Q[x <- t]
At the end, I want that it's equivalent to if \mu \models P then Mem(x:= t, \mu)(= \mu[x <- t]) \models Q
(Equivalence is obtained by using 2.)

- code = if b then c_1 else c_2 endif
I assume that theorem holds on c_1 and c_2 => we can prove theorem on code.
TO DO !!

We make the proof on all kind of expressions of our language and then we proof theorem....

