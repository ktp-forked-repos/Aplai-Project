test(X) :-
 X == 1.
test(X) :-
  write("Succes").

testXor(R, Z) :-
  =>(R #= 10,Z #= -1,1).

test2(A, B , C) :-
  #=(A, 1, D),
  and(B, C, E),
  #=(E, 1, D).
