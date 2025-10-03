# Exercice 1

- while DO
- done; res



val(abs(3, 9), m)
= val(code; res, m)
= val(res, Mem(code, m))

Mem(code, m)
=Mem(res:=0; rest of code, m)
=Mem(rest of code, Mem(res:=0, m))

Mem(res:=0, m)=m $$res <- Val(0, m)$$
=m'={a <-3, b <- 9, res <- 0}

Mem(rest of code, m')
=Mem(if a < b then res = b - a else res = a - b; rest of code, m')
=Mem(rest of code, Mem(i_2, m'))

Mem(i21, m') if Val(a < b, m')=true
Mem(i22, m') otherwise

Val(a, m')<Val(b, m') -> m'(a) < m'(b) -> 3 < 9 = true

Mem(res:= b - a, m') = m'[res <- Val(b - a, m')] 

Val(b - a, m') = Val(b, m') - Val(a, m') = m'(b) - m'(a) = 9 - 3 = 6

m''=$$a <- 3, b <- 9, res <- 6$$


$$
\textbf{Program:} \quad
\texttt{abs(a,b) =} \\
\quad \texttt{res := 0;} \\
\quad \texttt{if (a < b) then} \\
\quad\quad \texttt{res := b - a} \\
\quad \texttt{else} \\
\quad\quad \texttt{res := a - b} \\
\quad \texttt{endif;} \\
\quad \texttt{res}
$$

\bigskip

$$
\begin{aligned}
\text{val}(\texttt{abs(3, 9)}, m) 
&= \text{val}(\texttt{code; res}, m) \\
&= \text{val}(\texttt{res}, \text{Mem}(\texttt{code}, m)) 
\end{aligned}
$$

$$
\begin{aligned}
\text{Mem}(\texttt{code}, m) 
&= \text{Mem}(\texttt{res := 0; if (a < b) then res := b - a else res := a - b}, m) \\
&= \text{Mem}(\texttt{if (a < b) then res := b - a else res := a - b}, \text{Mem}(\texttt{res := 0}, m)).
\end{aligned}
$$

$$
\begin{aligned}
\text{Mem}(\texttt{res := 0}, m) 
&= m[\texttt{res} \leftarrow \text{Val}(0, m)] \\
&= m' = \{ a \mapsto 3,\ b \mapsto 9,\ \texttt{res} \mapsto 0 \}.
\end{aligned}
$$

$$
\begin{aligned}
\text{Mem}(\texttt{if (a < b) then res := b - a else res := a - b}, m') 
&=
\begin{cases}
\text{Mem}(\texttt{res := b - a}, m') & \text{if } \text{Val}(a < b, m') = \text{true},\\[6pt]
\text{Mem}(\texttt{res := a - b}, m') & \text{otherwise}.
\end{cases}
\end{aligned}
$$

$$
\begin{aligned}
\text{Val}(a < b, m') 
&= \text{Val}(a, m') < \text{Val}(b, m') \\
&= m'(a) < m'(b) \\
&= 3 < 9 \\
&= \text{true}.
\end{aligned}
$$

So we take the **then-branch**:

$$
\begin{aligned}
\text{Mem}(\texttt{res := b - a}, m') 
&= m'[\texttt{res} \leftarrow \text{Val}(b - a, m')] \\
\text{Val}(b - a, m') 
&= \text{Val}(b, m') - \text{Val}(a, m') \\
&= m'(b) - m'(a) = 9 - 3 = 6.
\end{aligned}
$$

$$
\text{Mem}(\texttt{res := b - a}, m') 
= m'' = \{ a \mapsto 3,\ b \mapsto 9,\ \texttt{res} \mapsto 6 \}.
$$

$$
\begin{aligned}
\text{val}(\texttt{abs(3, 9)}, m) 
&= \text{val}(\texttt{res}, m'') \\
&= \text{Val}(\texttt{res}, m'') \\
&= m''(\texttt{res}) = 6.
\end{aligned}
$$

$$
\boxed{\text{val}(\texttt{abs(3, 9)}, m) = 6}
$$
