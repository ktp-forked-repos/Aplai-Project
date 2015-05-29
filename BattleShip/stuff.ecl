ladderConstraint(Grid,Ladder) :-
  (multifor([I,J],2,11,[1,1]),param(Grid,Ladder)
  do
    K is I,
    L is J,
    Tij is Grid[K,L,2],
    ladderRight(Grid, 1, K, L,Ladder),
    ladderLeft(Grid, 1, K, L, Ladder),
    ladderUp(Grid, 1, K, L, Ladder),
    ladderDown(Grid, 1, K, L, Ladder),
    RI is Ladder[I - 1, J - 1, 1, 1..3],
    LL is Ladder[I - 1, J - 1, 2, 1..3],
    UP is Ladder[I - 1, J - 1, 3, 1..3],
    DO is Ladder[I - 1, J - 1, 4, 1..3],
    SumA #= sum(RI) + sum(LL),
    SumB #= sum(UP) + sum(DO),
    Max #= max(SumA, SumB),
    Tij #= Max
  ).

ladderRight(Grid, K, I, J,Ladder) :-
   K == 1,
   % Sij
   Sij is Grid[I,J,1],
   % Sij + 1
   Sijplus1 is Grid[I,J + 1,1],
   % Access the Rij1
   Rij1 is Ladder[I-1,J-1,1,K],
   aIffBAndC(Rij1, Sij, Sijplus1),
   Next is K + 1,
   ladderRight(Grid, Next, I, J,Ladder).
ladderRight(Grid, K, I, J,Ladder) :-
   K > 1,
   3 >= K,
   10 >= J + K,
   % Sij update
   Sijk is Grid[I,J + K ,1],
   Rijk is Ladder[I-1,J-1,1,K],
   RijkMin1 is Ladder[I-1,J-1,1,K-1],
   aIffBAndC(Rijk, Sijk, RijkMin1),
   Next is K + 1,
   ladderRight(Grid, Next, I, J,Ladder).
ladderRight(_, _, _, _,_).

ladderLeft(Grid, K, I, J, Ladder) :-
  K == 1,
  J - K > 0,
  % Sij
  Sij is Grid[I,J,1],
  % Sij + 1
  Sij1 is Grid[I,J - 1,1],
  % Access the Rij1
  Lij1 is Ladder[I-1,J-1,2,K],
  aIffBAndC(Rij1,El,Nel),
  Next is K + 1,
  ladderLeft(Grid, Next, I, J,Ladder).
ladderLeft(Grid, K, I, J,Ladder) :-
  K > 1,
  3 >= K,
  J - K  > 0,
  El is Grid[I,J - K ,1],
  Rijk is Ladder[I-1,J-1,2,K],
  RijkMin1 is Ladder[I-1,J-1,2,K-1],
  aIffBAndC(Rijk,El,RijkMin1),
  Next is K + 1,
  ladderLeft(Grid, Next, I, J,Ladder).
ladderLeft(_,_,_,_,_).

ladderUp(Grid, K, I, J, Ladder) :-
  K == 1,
  I - K > 0,
  % Sij
  El is Grid[I,J,1],
  % Sij + 1
  Nel is Grid[I - 1,J,1],
  % Access the Rij1
  Rij1 is Ladder[I-1,J-1,3,K],
  aIffBAndC(Rij1, El, Nel),
  Next is K + 1,
  ladderUp(Grid, Next, I, J,Ladder).
ladderUp(Grid, K, I, J, Ladder) :-
  K > 1,
  3 >= K,
  I - K > 0,
  El is Grid[I - K,J ,1],
  Rijk is Ladder[I-1,J-1,3,K],
  RijkMin1 is Ladder[I-1,J-1,3,K-1],
  aIffBAndC(Rijk, El, RijkMin1),
  Next is K + 1,
  ladderUp(Grid, Next, I, J,Ladder).
ladderUp(_,_,_,_,_).

ladderDown(Grid, K, I, J,Ladder) :-
  K == 1,
  10 >= I + K,
  % Sij
  El is Grid[I,J,1],
  % Sij + 1
  Nel is Grid[I + 1,J,1],
  % Access the Rij1
  Rij1 is Ladder[I-1,J-1,4,K],
  aIffBAndC(Rij1, El, Nel),
  Next is K + 1,
  ladderDown(Grid, Next, I, J,Ladder).
ladderDown(Grid, K, I, J, Ladder) :-
  K > 1,
  3 >= K,
  10 >= I + K,
  El is Grid[I + K,J ,1],
  Rijk is Ladder[I-1,J-1,4,K],
  RijkMin1 is Ladder[I-1,J-1,4,K-1],
  aIffBAndC(Rijk,El,RijkMin1),
  Next is K + 1,
  ladderRight(Grid, Next, I, J,Ladder).
ladderDown(_, _, _, _, _).
