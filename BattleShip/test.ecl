:- lib(ic).

aIffBAndC(A,B,C) :-
  #=(A, 1, D),
  and(B, C, E),
  #=(E, 1, D),
  #=( E, 0, Q),
  #=(A, 0, Q).

test(X) :-
  X :: 2..4,
  #=(El, 1, 1),
  #::(X, [1..4], 1)
