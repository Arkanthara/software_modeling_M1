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
