# Software Modeling and Verification

Is my *computer based system* / *program* / *software* correct ???

- big: internet
- small: embedded systems, IoT

- algorithms -> programs
- data_types
- protocols

## Program

Sequence of characters -> compiler (respect syntax)

> [!WARNING]
> Compiler only check that syntax is correct !!!

Sequence of characters -> model of the program ( = abstraction that represents (=~ models / formal models) the semantics of the program)

> [!NOTE]
> Semantic: meaning of the syntax... Ex: x++ -> sem: x is incremented by 1

formal models (mathematical)

- Answer should be (at least partly) automatized

Useful for complex systems !!!

> [!NOTE]
> If we have formal mathematical for systems, we can program it !!!

## Correct ??

### Non functional properties

time, ergonomy, security, .... -> quality of service

### Functional properties

What the program is meant to compute !!!
Ex: qsort(T) -> T is sorted

#### Specifications

Written in natural language

- annotations in the program (comments)
- asserts (defensive programming / detects errors during the executions) -> unit testing

Using formal specifications using logic predicates
Ex: t is sorted "$\forall i \in \{0, \dots, n - 2\}, t[i] \leq t[i + 1]$"


Is my program correct ?

```{.plantuml}
@startuml
[Computer based system / programs] -model-> [Program]
[Specifications] -model-> [spec]
[Program] --> [Correct ?]
[spec] --> [Correct ?]
@enduml
```

Why failure ????

**The problem is undecidable**

Ex: Halting problem: does program terminates ???? -> resources issues (memory / time)

**semi-decidable problems** -> yes -> fail (infinite loop)

- Yes: program **satisfies** / verifies / checks / is a model spec (program **|=** spec)

Verification -> building methods and tools to answer the "correct" box from graph #correct

## Part 2 course

### Deductive reasoning 

pgm: piece of code
spec: predicates in Hoare Logic
 - preconditions
 - postconditions

SMT Solving

```{plantuml}
@startuml
[Logic predicates] --> tools
tools --> yes
tools --> fail
tools --> no
@enduml
```
- Abstract interpretation

```{plantuml}
@startuml
pgm --> [modeled as an "Automation"] as A
A --> [tool (computes a superset of reachable values)]
@enduml
```

- Model Checking

```{plantuml}
@startuml
[pgm/system] -model-> [tool (computes the *exact* set of reachable values)] as tool
spec -model-> tool
@enduml
```
  model: restrictions with computability

- Assigned proof

```{plantuml}
@startuml
pgm -model-> [formal / code / pgm + semantics] as A
A --> prover
spec -model-> [form predicate] as B
B --> prover
@enduml
```

  - proof is machine checked
  - with interaction
    - user provide a proof
    - pgm |= spec


# Chapter 1: deductive reasoning & Hoare Logic

- introduce a small programming language
  restriction:
    - boolean / integer
    - while / if
    - function calls
    - no memory management !
- define semantics (operational)
- alternative semantic using Hoare Logic
- How do we answer [it](#correct)

> [!NOTE]
> Context Free Grammar tool

```{code}
min(a, b) =
  if a < b
  then
    res := a
  else
    res := b
  endif;
  res

add(a, b) =
  res := a;
  aux := b;
  while aux > 0 do
    res := rest + 1;
    aux := aux - 1;
  done;
  res

sum(n) =
  if n = 0
  then
    res := 0
  else
    res := sum(n - 1) + n
  endif;
  res
```

**CF Grammar** + implicit contextual verification

Assumption: "every program is syntactically correct"

Is the program syntactically correct ??? -> syntax
What the program compute ??? -> semantics !!!!

specifications
- preconditions (parameters have some constraints...)
- postconditions (returns, ...)

postconditions =(program execution)=> preconditions

specifications -> user defined/design
# Chap Hoare Logic

programming Language -> semantic (meaning of the language)

- operational semantics (defines how memory changes depending on instructions)
- denotational semantics (how the memory will be transform) (it's more in a mathematical way) (not important)
- axiomatic semantics (transform logic predicates according to the instructions)

## Operational semantic of the language

### Definition

- $\mu$: state of memory of the program during execution

  $\mu: Var \longrightarrow \mathbb{Z} \cup {tt, ff}$

  $x \in Var$, $c$ a constant $c \in \mathbb{Z} \cup {tt, ff}$
  
  $\mu\[x \leftarrow c\] \underbrace{=}_{def} \mu'$
- $Val$ function takes an expression and a $\mu$: $Val(e, \mu)$ and return a value in $\mathbb{Z} \cup {tt, ff}$, the value of expression $e$ in $\mu$.
- $Mem$: function takes as parameter an instruction, and a $\mu$.
  $Mem(c, \mu)$ returns a new state of memory $\mu'$ obtained after executing $c$ from $\mu$. Ex: $Mem(y:=0, \mu) = \mu\[y \leftarrow 0\]$.


Hoare Triples (Teny Hoare -> quick sort. 1934 Turing award structured programming language block {...} -> ALGOL programming language)

We define a new logic

- define axiomatic semantic
- write specifications/contracts
- reason about

Hoare Triples usualy returns ${P} c \ \text{(a piece of code)} \ {Q}$ (it's the contract of $c$ !)
$P$ and $Q$ are predicates, first order logic.
variables: variable of the code

#### Meaning

If the variables satisfies $P$ before executing $c$, then the variables satisfies $Q$ afterwards

$P$: preconditions (why3: requires)
$Q$: postconditions (why3: returns / ensures)

### Definition

A triple is VALID iff $\forall \mu$ (every state of memory), if $\mu \models P$ ($\mu$ satisfies $P$) then $Mem(code, \mu) \models Q$

#### Remarks

If I have {false predicate} code ${Q}$, it's always valid !!!

When ${P}$ code ${Q}$ is valid, the definition assume that $Mem(code, \mu)$ is defined (which may not be the case because of infinite loops)

${P}$ code ${Q}$ is valid implies that $\forall \mu, \mu \models P,\ Mem(code, \mu)$ is defined hence $code$ terminates on $\mu$ (PARTIAL CORRECTNESS)

### Def of WP(code, Q)

- If code is just an assignment: $code = \underbrace{x}_{var}:=\underbrace{t}_{expression(term)}$
    
    - $WP(x:=t, Q) = Q[x \leftarrow t]$
    - $WP(i_1; i_2, Q) = WP(i_1, WP(i_2, Q))$
    - $WP(\text{if b then i else i_2}) \text{give us} (b \Rightarrow WP (i_1, Q)) \& (\neg b \Rightarrow WP (i_2, Q))$
# Chapter Deductive Reasoning Hoare Logic

Theorem: P and Q first order logic (FOL) formulas, c a piece of code, with no loop or function call
{P} c {Q} is a valid Hoare triple iff P => WP(c, Q).
Mamely, $\forall m$, $m \models P \Longrightarrow WP(c, Q)$

### Adding loops ???

If we add loops, if we are able to compute WP(code, Q), we can solve the halting problem, which is the most famous undecidable problem...
But WP(code, Q) can't be computed (exactly)

-> the user has to help ! He has to provide a loop INVARIANT

#### Definition

Piece of code: while b do c done

I is a loop invariant of this piece of code iff {I /\ b} c {I} is a valid Hoare tripl is a valid Hoare triple

Just before evaluating b, I is a precondition of the code that is true.

schema:

I is true
while b do
\vdots \longleftarrow I is true
code
\vdots \longleftarrow I is true
done

So I is true at the begining and at the end of the loop

when I evalutate b, I must have no side effect !

#### Definition WP for loop program

WP is no more a weakest precundition (when an invariant is provided)

WP(while b do code done, Q) = I (FOL formula)
if
  - I is an invariant of (while b do code done) [inside the loop ]
  - $\forall m$, $m \models \neg b /\ I \Longrightarrow Q$ [exiting the loop]

Example:

```{why3}
add(a, b) = 
  requires {b >= 0}
  ensure {res:=a + b}
  res:=a;
  aux := b;
  while aux > 0 do
    res:=res + 1;
    aux:=aux - 1;
  done
  res
```

We have to propose an invariant for the while part:

I = res + aux = a + b

Is I a loop invariant ? {I /\ aux > 0}(res ++; aux --;){I}.

- WP(res ++; aux --, I) = WP(res ++, I\[aux--\]) = I\[aux--\]\[res++\] = res + 1 + aux - 1 = a + b
- (aux > 0) /\ I => WP(..., I) \Longleftrightarrow aux > 0 /\ (res + aux = a + b) \Longrightarrow res + 1 + aux - 1 = a + b Check it ???

  -> question is delegated to a SMT Solver answer YES

WP(while aux > 0 do ... done, res = a + b) = I if I is invariant and $\neg(aux > 0) /\ I \Longrightarrow res = a + b \Longleftrightarrow \neg(aux > 0 /\ res + aux = a + b \Longrightarrow res = a + b$ it's false !!
So we must to reinforce the invariant

WP(add, res = a + b) = WP(res:= a; aux := b; while ... ; res, res = a + b) = WP(res:= a; aux := b, WP(while ... ; res, res = a + b))

If we add aux >= 0 to the invariant, the proposition is correct...The new invariant is I'. So we have:

WP(add, res = a + b) = WP(res:= a; aux := b; while ... ; res, res = a + b) = WP(res:= a; aux := b, WP(while ... ; res, res = a + b))
=WP(res:= a; aux := b, I') = WP(res:=a, I'\[aux \longleftarrow b\]) = I'\[aux \longleftarrow b\]\[res \longleftarrow a\]

\Longleftrightarrow WP(add, res = a + b) = I'\[aux \longleftarrow b\]\[res \longleftarrow a\] \Longleftrightarrow a + b = a + b /\ b \geq 0 

check that {b \geq 0} add {res = a + b} is valid.

b \geq 0 \Longrightarrow WP(add, res = a + b)
b \geq 0 \Longrightarrow a + b = a + b /\ b \geq 0

Solver responds YES

We proved that {b \geq 0} add {res:= a + b} is valid.

=> if the function add terminates, then if b \geq 0 then add returns a + b

This is called partial correctness...

To complete the proof, we need to prove termination.
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

