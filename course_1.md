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
