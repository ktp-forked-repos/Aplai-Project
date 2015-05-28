:- lib(ic).
:- lib(ic_global).

% –   Sij = 1 if square (i, j) is occupied by a ship segment and 0 otherwise, for all∀i, j, 0 ≤ i, j ≤ n + 1.
% –   Tij = 0, if square (i, j) is unoccupied, or 1, 2, 3, 4 if the square is occupied by (part
%     of) a submarine, destroyer, cruiser or battleship, respectively, ∀i, j, 0 ≤ i, j ≤ n+1.
%     (Note that the type of a ship is the same as its length.)
%
%     The primary constraints on these variables are:
%     RandConstraintjes
% –   S0,j = Sn+1,j = si,0 = si,n+1, ∀i, j, 0 <= i, j ≤ n + 1.
%     Sommetje constraint
% –   Sumj(Si,j) = Ri, where Ri is the tally (number of occupied squares) for row i; similarly,
%     Sumi(Si,j) = Cj , where Cj is the tally for column j.
%     Blokkie constraint
% –   if Sij = 1, then si−1,j−1 = si−1,j+1 = si+1,j+1 = si+1,j−1 = 0.
%     DomainNaarOccupied constraint
% –   channelling constraints: Sij = (Tij > 0).
% –   a global cardinality constraint ensures that:
%     |{tij |tij = k, 1 ≤ i ≤ n, 1 ≤ j ≤ n}| = l
%     where l = 4, 6, 6, 4 when k = 1, 2, 3, 4 respectively, i.e. the number of squares
%     occupied by submarines is 4, the number of squares occupied by destroyers is 6,
%     and so on.
%
% The model is not yet complete, since there is nothing to ensure that Tij = p, p > 0 <=> the square (i, j) occurs in a run of exactly p occupied squares.
% Auxiliary ladder variables can be introduced to represent how far the stretch of occupied squares
% adjacent to an occupied square runs in each direction. The Boolean variables r ijk, 1 ≤
% k ≤ 4 indicate whether there is a run of occupied squares from (i, j) to (i, j + k). If
% rijk = 1, the square (i, j) is occupied by a ship that also occupies the square (i, j + k),
% and of course all intervening squares, if any.
% The constraints on the ladder variables are:
% – rij1 = 1 iff sij = 1 and si,j+1 = 1.
% – rij,k+1 = 1 iff rijk = 1 and si,j+k+1 = 1 for 1 ≤ k ≤ 3 and j + k ≤ n.
% There are similar sets of ladder variables lijk, uijk, dijk, 1 ≤ k ≤ 4, for the squares
% to the right, above and below the square (i, j), and the constraint ensuring the correct
% value of tij is then:
% tij = max(
% k
% rijk +
% k
% lijk,
%
% k
% uijk +
% k
% dijk)
% An initial hint relating to a square (i, j) is represented as constraints as follows:
% – water: sij = 0.
% – circle: si−1,j = si+1,j = si,j−1 = si,j+1 = 0.
% – left; si−1,j = si+1,j = si,j−1 = 0, si,j+1 = 1 (and similarly for right, top and
% bottom hints).
% – middle: tij ≥ 3 and either si−1,j = si+1,j = 0 and si,j−1 = si,j+1 = 1 or
% si−1,j = si+1,j = 0 and si,j−1 = si,j+1 = 1.
% 3

% Element van Grid ziet er als volgt uit: [S,T,R,L,U,D]
solve(TipsArr, RowCountList, ColCountList, Solution) :-
  array_list(RowCountArr, RowCountList),
  array_list(ColCountArr, ColCountList),
  dim(Grid, [12,12,2]),
  Grid[1..12,1..12,1] :: 0..1,
  Grid[1..12,1..12,2] :: 0..4,
  dim(Ladder,[10,10,4,4]),
  Ladder[1..10,1..10,1..4,1..4] :: 0..1,
  (foreach((X,Y,Tip), TipsArr), param(Grid, TipsArr)
    do
    getElementValue(Tip, EncValue, Value, Occupied),
    convertHint(Tip, Occupied,Value,X,Y,Grid)
  ),
  cardinalityConstraint(Grid),
  printboard(Grid),
  ladderConstraint(Grid,Ladder),
  printboard(Grid),
  borderConstraints(Grid),
  printboard(Grid),
  occupiedConstraint(Grid),
  printboard(Grid),
  channelingConstraint(Grid),
  printboard(Grid),
  tallyConstraint(Grid,RowCountArr,ColCountArr),
  printboard(Grid),
  term_variables(Grid, Variables),
  labeling(Variables),
  printboard(Grid).

convertHint(Hint, Occupied,Value,X,Y,Grid) :-
  GridXcoor is X + 1,
  GridYcoor is Y + 1,
  S is Grid[GridXcoor,GridYcoor,1],
  T is Grid[GridXcoor,GridYcoor,2],
  T :: Value,
  S is Occupied,
  affectsOfHint(Hint,GridXcoor,GridYcoor,Grid).

affectsOfHint(circle,X,Y,Grid).
affectsOfHint(water,X,Y,Grid).
affectsOfHint(left,X,Y,Grid) :-
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
affectsOfHint(right,X,Y,Grid) :-
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
affectsOfHint(top,X,Y,Grid) :-
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
affectsOfHint(bottom,X,Y,Grid) :-
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
affectsOfHint(middle,X,Y,Grid) :-
  T is Grid[X,Y,2],
  S1 is Grid[X-1,Y,1],
  S2 is Grid[X+1,Y,1],
  S3 is Grid[X,Y-1,1],
  S4 is Grid[X,Y+1,1],
  T :: 3..4,
  S1 #= S2,
  S3 #= S4.

% Hoekjes constraint + channeling constraint.
occupiedConstraint(Grid) :-
  (multifor([I,J],2,11,[1,1]),param(Grid)
  do
    K is I,
    L is J,
    El is Grid[K,L,1],
    TEl is Grid[K,L,2],
    El1 is Grid[K-1,L-1,1],
    El2 is Grid[K+1,L-1,1],
    El3 is Grid[K+1,L+1,1],
    El4 is Grid[K-1,L+1,1],
    =>(El #= 1, El1 #= 0,1),
    =>(El #= 1, El2 #= 0,1),
    =>(El #= 1, El3 #= 0,1),
    =>(El #= 1, El4 #= 0,1)
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
    =>(TEl #:: 1..4,El #= 1,1)
  ).

borderConstraints(Grid) :-
  (multifor([I,J],[1,1],[11,12],[1,11]),param(Grid)
  do
  L is J,
  K is I,
  K1 is I +1,
  S1 is Grid[L,K,1],
  S2 is Grid[L,K1,1],
  S3 is Grid[K,L,1],
  S4 is Grid[K1,L,1],
  S1 #= S2,
  S2 #= S3,
  S3 #= S4
  ).

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
  occurrences(1,List,4),
  occurrences(2,List,6),
  occurrences(3,List,6),
  occurrences(4,List,4).

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
    R is Ladder[I - 1, J - 1, 1, 1..4],
    LL is Ladder[I - 1, J - 1, 2, 1..4],
    U is Ladder[I - 1, J - 1, 3, 1..4],
    D is Ladder[I - 1, J - 1, 4, 1..4],
    SumA #= sum(R) + sum(LL),
    SumB #= sum(U) + sum(D),
    X #= (SumA or SumB),
    max(SumA, Max),
    Tij #= Max
  ).

ladderRight(Grid, K, I, J,Ladder) :-
   K == 1,
   10 >= J + K,
   % Sij
   El is Grid[I,J,1],
   % Sij + 1
   Nel is Grid[I,J + 1,1],
   % Access the Rij1
   Rij1 is Ladder[I-1,J-1,1,K],
   aIffBAndC(Rij1, El, Nel),
   Next is K + 1,
   ladderRight(Grid, Next, I, J,Ladder).
ladderRight(Grid, K, I, J,Ladder) :-
   K > 1,
   4 >= K,
   10 >= J + K,
   % Sij update
   El is Grid[I,J + K ,1],
   Rijk is Ladder[I-1,J-1,1,K],
   RijkMin1 is Ladder[I-1,J-1,1,K-1],
   aIffBAndC(Rijk, El, RijkMin1),
   Next is K + 1,
   ladderRight(Grid, Next, I, J,Ladder).
ladderRight(_, _, _, _,_).

ladderLeft(Grid, K, I, J, Ladder) :-
  K == 1,
  J - K > 0,
  % Sij
  El is Grid[I,J,1],
  % Sij + 1
  Nel is Grid[I,J - 1,1],
  % Access the Rij1
  Rij1 is Ladder[I-1,J-1,2,K],
  aIffBAndC(Rij1,El,Nel),
  Next is K + 1,
  ladderLeft(Grid, Next, I, J,Ladder).
ladderLeft(Grid, K, I, J,Ladder) :-
  K > 1,
  4 >= K,
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
  4 >= K,
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
  4 >= K,
  10 >= I + K,
  El is Grid[I + K,J ,1],
  Rijk is Ladder[I-1,J-1,4,K],
  RijkMin1 is Ladder[I-1,J-1,4,K-1],
  aIffBAndC(Rijk,El,RijkMin1),
  Next is K + 1,
  ladderRight(Grid, Next, I, J,Ladder).
ladderDown(_, _, _, _, _).

%% checkLadder(El,Nel,_,_,_,Min3) :-
%%   Min3 == 1,
%%   El #= 1,
%%   Nel #= 1.
%% checkLadder(_,_,Rij1,Min1,Min2,_) :-
%%     Min1 == 1,
%%     Min2 == 1,
%%     Rij1 #= 1.
%% checkLadder(_,_,_,_,_,_).

aIffBAndC(A,B,C) :-
  #=(A, 1, D),
  and(B, C, E),
  #=(E, 1, D).
  %((A #= 1, ((B #= 1) and (C#=1)) ,1).

printboard(Grid) :-
    (foreacharg(Row,Grid), param(Grid)
    do
      (foreacharg(El,Row), param(Row)
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
      (foreacharg(El,Row), param(Row)
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
    ),
    writeln("WOW").

getElementValue(water, '.', 0, 0).
getElementValue(circle, c, 1, 1).
getElementValue(top, t, 2..4, 1).
getElementValue(bottom, b, 2..4, 1).
getElementValue(left, l, 2..4, 1).
getElementValue(right, r, 2..4, 1).
getElementValue(middle, m, 3..4, 1).
