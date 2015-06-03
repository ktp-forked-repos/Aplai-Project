:- lib(ic).
:- lib(ic_global).

solve(TipsArr, RowCountList, ColCountList, Solution) :-
  array_list(RowCountArr, RowCountList),
  array_list(ColCountArr, ColCountList),
  dim(Grid, [12,12,2]),
  Grid[1..12,1..12,1] :: 0..1,
  Grid[1..12,1..12,2] :: 0..4,
  dim(Ladder,[10,10,4,3]),
  Ladder[1..10,1..10,1..4,1..3] :: 0..1,
  (foreach((X,Y,Tip), TipsArr), param(Grid)
    do
    getElementValue(Tip, _, Value, Occupied),
    convertHint(Tip, Occupied,Value,X,Y,Grid)
  ),
  tallyConstraint(Grid,RowCountArr,ColCountArr),
  cardinalityConstraint(Grid),
  borderConstraints(Grid),
  ladderConstraint(Grid,Ladder),
  %allTheSingleLadiesConstraint(Grid),
  onzeFkNConstraintG(Grid),
  occupiedConstraint(Grid),
  channelingConstraint(Grid),
  %term_variables(Grid, Variables),
  %labeling(Grid),
  search(Grid,0,largest,indomain_max,complete,[backtrack(B)]),
  printf("Solution found after %d bachtracks%n", [B]),
  X is Ladder[1,1,1, 1],
  writeln("final result"),
  printboard(Grid),
  Solution = Grid.

convertHint(Hint, Occupied,Value,X,Y,Grid) :-
  GridXcoor is X + 1,
  GridYcoor is Y + 1,
  S is Grid[GridXcoor,GridYcoor,1],
  T is Grid[GridXcoor,GridYcoor,2],
  T #:: Value,
  S is Occupied,
  effectsOfHint(Hint,GridXcoor,GridYcoor,Grid).

effectsOfHint(circle,_,_,_).
effectsOfHint(water,_,_,_).
effectsOfHint(left,X,Y,Grid) :-
  S1 is Grid[X-1,Y,1],
  S2 is Grid[X+1,Y,1],
  S3 is Grid[X,Y-1,1],
  S4 is Grid[X,Y+1,1],
  T4 is Grid[X,Y+1,2],
  S1 #= S2,
  S2 #= S3,
  S1 #= 0,
  S4 #= 1,
  T4 :: 2..4.
effectsOfHint(right,X,Y,Grid) :-
  S1 is Grid[X-1,Y,1],
  S2 is Grid[X+1,Y,1],
  S3 is Grid[X,Y-1,1],
  T3 is Grid[X,Y-1,2],
  S4 is Grid[X,Y+1,1],
  S1 #= S2,
  S2 #= S4,
  S1 #= 0,
  S3 #= 1,
  T3 :: 2..4.
effectsOfHint(top,X,Y,Grid) :-
  S1 is Grid[X-1,Y,1],
  S2 is Grid[X+1,Y,1],
  T2 is Grid[X+1,Y,2],
  S3 is Grid[X,Y-1,1],
  S4 is Grid[X,Y+1,1],
  S1 #= S3,
  S3 #= S4,
  S1 #= 0,
  S2 #= 1,
  T2 :: 2..4.
effectsOfHint(bottom,X,Y,Grid) :-
  S1 is Grid[X-1,Y,1],
  T1 is Grid[X-1,Y,2],
  S2 is Grid[X+1,Y,1],
  S3 is Grid[X,Y-1,1],
  S4 is Grid[X,Y+1,1],
  S4 #= S2,
  S2 #= S3,
  S4 #= 0,
  S1 #= 1,
  T1 :: 2..4.
effectsOfHint(middle,X,Y,Grid) :-
  T  is Grid[X,Y,2],
  SUp is Grid[X-1,Y,1],
  TUp is Grid[X-1,Y,2],
  SDown is Grid[X+1,Y,1],
  TDown is Grid[X+1,Y,2],
  SLeft is Grid[X,Y-1,1],
  TLeft is Grid[X,Y-1,2],
  SRight is Grid[X,Y+1,1],
  TRight is Grid[X,Y+1,2],
  T :: 3..4,
  SUp #= SDown,
  SRight #= SLeft,
  TLeft #= TRight,
  TUp #= TDown,
  TRight #:: [0,3..4],
  TDown #:: [0,3..4].


% Hoekjes constraint
occupiedConstraint(Grid) :-
  (multifor([I,J],2,11,[1,1]),param(Grid)
  do
    K is I,
    L is J,
    El is Grid[K,L,1],
    El1 is Grid[K-1,L-1,1],
    El2 is Grid[K+1,L-1,1],
    El3 is Grid[K+1,L+1,1],
    El4 is Grid[K-1,L+1,1],
    =>(El #= 1, El1 #= 0,1),
    =>(El #= 1, El2 #= 0,1),
    =>(El #= 1, El3 #= 0,1),
    =>(El #= 1, El4 #= 0,1)
  ).

allTheSingleLadiesConstraint(Grid) :-
  (multifor([I,J],2,11,[1,1]),param(Grid)
  do
    K is I,
    L is J,
    Sij  is Grid[K, L,1],
    Tij is Grid[K, L, 2],
    SLeft is Grid[K, L-1,1],
    SRight is Grid[K, L+1,1],
    SDown is Grid[K+1, L,1],
    SUp is Grid[K-1, L,1],
    #=(Sij, 1, B),
    #=(SLeft, 0, C),
    #=(SRight, 0, D),
    #=(SDown, 0, E ),
    #=(SUp,0, F),
    and(C, D, G),
    and(E, F, H),
    and(G, H, WHUT),
    and(B, WHUT, WORK),
    #=(Tij, 1, WORK)
  ).


onzeFkNConstraintG(Grid) :-
  (multifor([I,J],2,11,[1,1]),param(Grid)
  do
  K is I,
  L is J,
  Tog is Grid[K, L, 2],
  Sog is Grid[K, L, 1],
  TUp is Grid[K - 1, L, 2],
  TDo is Grid[K + 1, L, 2],
  TLe is Grid[K, L + 1, 2],
  TRe is Grid[K, L - 1, 2],
  SUp is Grid[K - 1, L, 1],
  SDo is Grid[K + 1, L, 1],
  SLe is Grid[K, L + 1, 1],
  SRe is Grid[K, L - 1, 1],
  #=(Sog, SUp, B),
  #=(Sog, SDo, C),
  #=(Sog, SLe, D),
  #=(Sog, SRe, E),
  #=(Tog, TUp, B),
  #=(Tog, TDo, C),
  #=(Tog, TLe, D),
  #=(Tog, TRe, E)
  ).

channelingConstraint(Grid) :-
  (multifor([I,J],2,11,[1,1]),param(Grid)
  do
    K is I,
    L is J,
    El is Grid[K,L,1],
    TEl is Grid[K,L,2],
    #=(El,0,C),
    #=(TEl,0,C),
    #=(El, 1, B),
    #::(TEl, [1..4], B)
  ).

borderConstraints(Grid) :-
  SRij1 is Grid[1..12,1,1],
  SRij12 is Grid[1..12,12,1],
  SKolom1 is Grid[1,1..12,1],
  SKolom12 is Grid[12,1..12,1],
  TRij1 is Grid[1..12,1,2],
  TRij12 is Grid[1..12,12,2],
  TKolom1 is Grid[1,1..12,2],
  TKolom12 is Grid[12,1..12,2],
  (foreach(Element,SRij1) do Element #= 0),
  (foreach(Element,SRij12) do Element #= 0),
  (foreach(Element,SKolom1) do Element #= 0),
  (foreach(Element,SKolom12) do Element #= 0),
  (foreach(Element,TRij1) do Element #= 0),
  (foreach(Element,TRij12) do Element #= 0),
  (foreach(Element,TKolom1) do Element #= 0),
  (foreach(Element,TKolom12) do Element #= 0).

tallyConstraint(Grid,RowCountArr,ColCountArr) :-
  (for(I,2,11),param(Grid,RowCountArr,ColCountArr)
  do
    K is I,
    L is I - 1,
    LijstRow is Grid[K,2..11,1],
    LijstCol is Grid[2..11,K,1],
    CountRow is RowCountArr[L],
    CountCol is ColCountArr[L],
    sum(LijstRow) #= CountRow,
    sum(LijstCol) #= CountCol
  ).

cardinalityConstraint(Grid) :-
  GridArr is Grid[2..11,2..11,2],
  flatten(GridArr,List),
  % 4 subs
  occurrences(1,List,4),
  % 3 destroyers
  occurrences(2,List,6),
  % 2 cruisers
  occurrences(3,List,6),
  % 1 battle ship
  occurrences(4,List,4).

ladderConstraint(Grid,Ladder) :-
  (multifor([I,J],2,11,[1,1]),param(Grid,Ladder)
  do
    K is I,
    L is J,
    Tij is Grid[K,L,2],
    Sij is Grid[K,L,1],
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
    Tij #= Max + Sij
  ).

ladderRight(Grid, K, I, J,Ladder) :-
   K == 1,
   Sij is Grid[I, J, 1],
   Sijplus1 is Grid[I, J + 1, 1],
   Rij1 is Ladder[I-1, J-1, 1, K],
   aIffBAndC(Rij1, Sij, Sijplus1),
   #=(Rij1, 0, Truth),
   Rest is Ladder[I-1,J-1,1,1..3],
   (foreach(El, Rest),param(Truth) do =>(Truth #= 1, El #= 0, 1)),
   Next is K + 1,
   ladderRight(Grid, Next, I, J,Ladder).
ladderRight(Grid, K, I, J,Ladder) :-
   K > 1,
   3 >= K,
   10 >= J + K,
   Sijk is Grid[I, J + K , 1],
   Rijk is Ladder[I-1, J-1, 1, K],
   RijkMin1 is Ladder[I-1, J-1, 1, K-1],
   aIffBAndC(Rijk, Sijk, RijkMin1),
   #=(Rijk, 0, Truth),
   Rest is Ladder[I-1,J-1,1,K..3],
   (foreach(El, Rest),param(Truth) do =>(Truth #= 1, El #= 0, 1)),
   Next is K + 1,
   ladderRight(Grid, Next, I, J,Ladder).
ladderRight(_, _, _, _,_).

ladderLeft(Grid, K, I, J, Ladder) :-
  K == 1,
  Sij is Grid[I,J,1],
  SijMin1 is Grid[I,J - 1,1],
  Lij1 is Ladder[I-1,J-1,2,K],
  aIffBAndC(Lij1,Sij,SijMin1),
  #=(Lij1, 0, Truth),
  Rest is Ladder[I-1,J-1,2,1..3],
  (foreach(El, Rest),param(Truth) do =>(Truth #= 1, El #= 0, 1)),
  Next is K + 1,
  ladderLeft(Grid, Next, I, J,Ladder).
ladderLeft(Grid, K, I, J,Ladder) :-
  K > 1,
  3 >= K,
  J - K  > 0,
  Sijk is Grid[I,J - K ,1],
  Lijk is Ladder[I-1,J-1,2,K],
  LijkMin1 is Ladder[I-1,J-1,2,K-1],
  aIffBAndC(Lijk,Sijk,LijkMin1),
  #=(Lijk, 0, Truth),
  Rest is Ladder[I-1,J-1,2,K..3],
  (foreach(El, Rest),param(Truth) do =>(Truth #= 1, El #= 0, 1)),
  Next is K + 1,
  ladderLeft(Grid, Next, I, J,Ladder).
ladderLeft(_,_,_,_,_).

ladderUp(Grid, K, I, J, Ladder) :-
  K == 1,
  Sij is Grid[I,J,1],
  SijMin1 is Grid[I - 1,J,1],
  Uij1 is Ladder[I-1,J-1,3,K],
  aIffBAndC(Uij1, Sij, SijMin1),
  #=(Uij1, 0, Truth),
  Rest is Ladder[I-1,J-1,3,1..3],
  (foreach(El, Rest),param(Truth) do =>(Truth #= 1, El #= 0, 1)),
  Next is K + 1,
  ladderUp(Grid, Next, I, J,Ladder).
ladderUp(Grid, K, I, J, Ladder) :-
  K > 1,
  3 >= K,
  I - K > 0,
  Sijk is Grid[I - K,J ,1],
  Uijk is Ladder[I-1,J-1,3,K],
  UijkMin1 is Ladder[I-1,J-1,3,K-1],
  aIffBAndC(Uijk, Sijk, UijkMin1),
  #=(Uijk, 0, Truth),
  Rest is Ladder[I-1,J-1,3,K..3],
  (foreach(El, Rest),param(Truth) do =>(Truth #= 1, El #= 0, 1)),
  Next is K + 1,
  ladderUp(Grid, Next, I, J,Ladder).
ladderUp(_,_,_,_,_).

ladderDown(Grid, K, I, J,Ladder) :-
  K == 1,
  Sij is Grid[I,J,1],
  Sij1 is Grid[I + 1,J,1],
  Dij1 is Ladder[I-1,J-1,4,K],
  aIffBAndC(Dij1, Sij, Sij1),
  #=(Dij1, 0, Truth),
  Rest is Ladder[I-1,J-1,4,1..3],
  (foreach(El, Rest),param(Truth) do =>(Truth #= 1, El #= 0, 1)),
  Next is K + 1,
  ladderDown(Grid, Next, I, J,Ladder).
ladderDown(Grid, K, I, J, Ladder) :-
  K > 1,
  3 >= K,
  10 >= I + K,
  Sijk is Grid[I + K,J ,1],
  Dijk is Ladder[I-1,J-1,4,K],
  DijkMin1 is Ladder[I-1,J-1,4,K-1],
  aIffBAndC(Dijk,Sijk,DijkMin1),
  #=(Dijk, 0, Truth),
  Rest is Ladder[I-1,J-1,4,K..3],
  (foreach(El, Rest),param(Truth) do =>(Truth #= 1, El #= 0, 1)),
  Next is K + 1,
  ladderDown(Grid, Next, I, J,Ladder).
ladderDown(_, _, _, _, _).

% A <=> B AND C
% A <=> C AND B
% Rij1 <=> Sij en Sij1
% Rijk <=> RijkMin1 en Sijk
%A = 0, 1 <=> 1 & 0
%0 & 1 => A = 0
%1 & 0 => A = 0
%0 & 0 => A = 0
aIffBAndC(A,B,C) :-
  and(B, C, E),
  #=(E, 0, Q),
  #=(E, 1, D),
  #=(A, 1, D),
  #=(A, 0, Q).

  %((A #= 1, ((B #= 1) and (C#=1)) ,1).

printboard(Grid) :-
    (foreacharg(Row,Grid)
    do
      (foreacharg(El,Row)
        do
        Henk is El[1],
        (
          number(Henk)
        ->
          write(" "),
          write(Henk)
        ;
          write(" ?")
        )
      ),
      write("          "),
      (foreacharg(El,Row)
        do
        Henk is El[2],
        (
          number(Henk)
        ->
          write(" "),
          write(Henk)
        ;
          write(" ?")
        )
      ),
      writeln("  ")
    ).

getElementValue(water, '.', 0, 0).
getElementValue(circle, c, 1, 1).
getElementValue(top, t, 2..4, 1).
getElementValue(bottom, b, 2..4, 1).
getElementValue(left, l, 2..4, 1).
getElementValue(right, r, 2..4, 1).
getElementValue(middle, m, 3..4, 1).
