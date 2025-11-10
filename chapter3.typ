= Abstract Interpretation

Is my program correct ?
- Hoare Logic (axiomatic semantic)
  - Deductive reasoning
  - SMT Solving
- Abstract interpretation

Semantic importance example

C_program:
```C
int i, a;
a = 5;
for (i = 0; i < a; i++) {
  a--;
  printf("i = %d", i)
}
```
will return i = 0, i = 1, i = 2

Ada:
```Ada
A: integer:
begin
  a:=S;
  for I in 0..A loop
    A:= A - 1;
    Pat("i=");Pat(I);
  end loop;
end;
```
will return i = 0, i = 1, i = 2, i = 3, i = 4, i = 5 (because it works with a copy of A)

In this chapter, we will use some kind of automata to define the correctness of our program ??

Semantics:
- use automata
(give here an example of automata for the C_program and the Ada program given according to copy of A in for loop)

Example

Java:
```java
{
  int a;
  for (int i = 0; i <= a;, i++){
    // blablabla
  }
}
```
Compiler
- refuses to compile the file
- emits a strong warning: "Variable 'a' might not have been initialized"
- So is not sure !

#symb.arrow.r.double.long Problem of detecting non-initialized variable is not decidable (not computable) !

The Java compiler gives an approximation
- this is an 'over' approximation
(graph here with [programs: non initialized variable] in a circle, inside a circle with [programs rejected by the compiler] !)
The set of rejected programs is bigger than the one with accurate answers !
It's a conservative approximation
- if the program is not rejected, we are sure there is no problem on it
- otherwise we don't know
Abstract #symb.approx Abstraction

== Collecting Semantics (Hoare 69, Floyd 67)

On this chapter, we will focus on a small language that is the same as before except function calls.
Contains:
- integers/boolean/variables/expressions
- if ..., while...

We have seen the operational semantic (quick recall here on operational semantic, especially on Mem and Val)

The compiler compile the program and build a data structure which is called the Abstract Syntax Tree (AST) which represents the program
In fact, we can implement Mem and Val directly on the AST, which is called Interpreter
Execution: execution of the program step by step

Here we will use other data-structure to represent the program, like automaton which is called the Control Flow Graph (CFG) of the program.

CFG: we take a probram and we create interpreted automation of the program
$(S, T, s_0, V)$
- $S$: set of states (finite)
- $T$: transitions $T subset.eq S times (A(V) union C(V)) times S$
- $s_0$: initial state s_0 #symb.in S
- $V$: set of variables (finite) of the program
- $A(V)$: assignments
  - $x:= text(Exp)$ with $x in V, text(Exp on) V$
- $C(V)$: conditions
  - boolean expression
  - build on $V$

Give an example here !
```
a = 5;
while i <= a do
  i = i + 1;
  a = a - 1;
done
```
Build automata graph of the given program here !

==== Collecting semantics
We will take a program, build the CFG and then express the semantics on the CFG

State of the CFG is usually called the Control Point (CP)

We will define (Try to clarify here the definition !!!):
$alpha: CP, V(alpha) arrow forall x in text(Variable) V(alpha)(x)$ is the set of every possible value of reached while executing the program at #symb.alpha

Example with the automata that you must build just before the ====...:
- $V(A)(i) = V(A)(a) = text(every possible value) ZZ$
- $V(B)(i) = {0}, V(B)(a) = text(every possible value) ZZ$
- $V(C)(i) = {0, 1, 2, 3}$
- $V(C)(a) = {5, 4, 3, 2}$
- $V(F)(i) = {3}$
- $V(F)(a) = {2}$
- $V(D)(i) = {0, 1, 2}$
- $V(D)(a) = {5, 4, 3}$
- $V(E)(i) = {0, 1, 2}$
- $V(E)(a) = {4, 3, 2}$

==== Computation of $V$

If I have a transition with an assignment, I just look at what's happen on $x$:
- $V(B)(x) = V(A)[x:=expr]$
- $V(B)(y) = V(A)(y), y eq.not x$

If I have a transition with a boolean expression, we compute intersection with previous
- $V(B) = V(A)union [x > 10]$
  - $V(B)(x) arrow.l text(update)$
  - $V(B)(y) = V(A)(y)$ Particular case if condition is respected
- $V(B)$ may have several changes

If we merge state #symb.A and #symb.B in state #symb.C, we will have:
- $X_A = V(A)[x:= y + 1]$ First we compute the effect of the assignment #symb.A
- $X_B = V(B) inter [x < y]$ We do the same for the second transition
- $V(C) = X_A union X_B$ Then we compute the union of the two

Now, we come back to the example
We obtain that
- $V(A) = T (ToP)$
- $V(B) = V(A)[i := 0]$
- $V(C) = V(B)[a:=5] union V(E)[i := i + 1]$ Here it introduces a loop because we need to compute $V(E)$ that needs $V(D)$ that needs $V(C)$ that we try to compute !!! (Make a small graph here that show the loop, please)
- $V(D) = V(C) inter [i <= a]$
- $V(E) = V(D)[a := a - 1]$
- $V(F) = V(C) inter [i > a]$
We obtain a system of equations

==== Fixed-point equation system

Equation where we try to solve it when it depends on itself
$V = phi(V)$
We are interested to know
- fixed-point defined ?
- can we compute it ?
