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
