:- lib(ic).

% In elk van de alldifferent constraints wordt er een bijectie gemaakt
% van de 9 mogelijke domein waarden naar de 9 variabelen
% de standaard viewpoint stelt dat deze 9 variabelen elk een verschillende domein waarde
% moeten krijgen.

solve(ListBoard, Result) :-
    doubleListToArray(ListBoard,TempBoard),
    array_list(StandardViewBoard, TempBoard),
    channelBoardVPOneToBoardVPTwo(StandardViewBoard, AlternativeViewBoard),
    checkConstraints(AlternativeViewBoard),
    term_variables(AlternativeViewBoard, Variables),
   	labeling(Variables),
    channelBoardVPTwotoBoardVPOne(AlternativeViewBoard, Result).

channelBoardVPOneToBoardVPTwo(ViewBoard, AltViewBoard) :-
      dim(AltViewBoard,[9,9]),
    	AltViewBoard::1..81,
    	%a position can only be used for one number
    	alldifferent(AltViewBoard),
    	(multifor([I, J], 1, 9, [1,1]), param(ViewBoard, AltViewBoard)
      do
        K is I,
        L is J,
        Element is ViewBoard[K, L],
        IndexValue is (((K - 1)* 9) + L),
    		number(Element)
        ->
          getFirstFreeVariableInRow(AltViewBoard, Element, 1, Y),
          X is AltViewBoard[Element, Y],
          X is IndexValue
        ;
          true
      ).

channelBoardVPTwotoBoardVPOne(AlternativeViewBoard, Board) :-
  dim(Board, [9,9]),
  Board::1..9,
  (multifor([I,J], 1, 9, [1,1]), param(AlternativeViewBoard, Board)
  do
    Value is I,
    L is J,
    Plaats is AlternativeViewBoard[Value,L],
    Col:: 0..8,
    Row:: 0..8,
    Row * 9 + Col #= (Plaats - 1),
    IDXR #= Row + 1,
    IDXC #= Col + 1,
    Thingy is Board[IDXR , IDXC],
    Thingy #= Value
  ).

getFirstFreeVariableInRow(Board, Row, Count, Dobby) :-
    K is Row,
    L is Count,
    Element is Board[K, L],
    number(Element) ->
    J is L + 1,
    getFirstFreeVariableInRow(Board, K, J, Dobby);
    Dobby is Count.

checkConstraints(Board) :-
    (foreacharg(Row,Board), param(Board)
    do
      checkNbForCol(Row),
      checkNbForBlock(Row),
      checkNbForRow(Row)
    ).

checkNbForCol(Row) :-
    dim(Lijst, [9]),
    Lijst::0..8,
    alldifferent(Lijst),
    (for(I,1,9), param(Row, Lijst)
      do
      K is I,
      El is Row[K],
      X is Lijst[K],
      Q :: 0..9,
      Q*9 + X #= El
    ).

checkNbForRow(Row) :-
  dim(Lijst, [9]),
  Lijst::0..8,
  alldifferent(Lijst),
  (for(I,1,9), param(Row, Lijst)
    do
    K is I,
    El is Row[K],
    X is Lijst[K],
    Rest :: 0..8,
    X*9 + Rest #= El-1
  ).

checkNbForBlock(Row) :-
  dim(Lijst, [9]),
  Lijst::0..8,
  alldifferent(Lijst),
  (for(I,1,9), param(Row, Lijst)
    do
   	K is I,
    Cell is Row[K],
    X is Lijst[K],
    Rest1 :: 0..26,
    Quotient :: 0..8,
    ColumNumber :: 0..2,
    Quotient2 :: 0..2,
    ColumNumber :: 0..2,
    RowNumber * 27 + Rest1 #=  Cell - 1,
    Quotient * 9 + (Quotient2 * 3 + ColumNumber) #=  Cell - 1,
    X #= 3 * RowNumber + Quotient2
  ).

doubleListToArray([],[]).
doubleListToArray([A|As],[B|Bs]) :-
    	array_list(B,A),
    	doubleListToArray(As,Bs).
