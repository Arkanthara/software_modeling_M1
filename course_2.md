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
