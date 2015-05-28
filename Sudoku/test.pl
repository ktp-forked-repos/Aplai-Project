:- use_module(library(chr)).

:- chr_constraint piggy/1,generate/1,value/1.

piggy(I), piggy(J) <=> K is I + J, piggy(K).

generate(N) <=> N > 0 | value(N),
                        M is N - 1, generate(M).

%value(I),value(J) <=> K is I + J, value(K).
