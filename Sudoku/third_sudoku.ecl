:- lib(ic).
:- lib(ic_global).

solve(SudokuBoard, ThirdViewBoard) :-
  dim(ThirdViewBoard,[9,9,9]),
  ThirdViewBoard[1..9,1..9,1..9] :: 0..1,
  doubleListToArray(SudokuBoard,TempBoard),
  array_list(StandardViewBoard, TempBoard),
  convertSudokuBoardToNewBoard(StandardViewBoard,ThirdViewBoard),
  checkConstraints(ThirdViewBoard),
  labeling(ThirdViewBoard),
  convertThirdViewBoardToSudokuBoard(ThirdViewBoard,Result),
  %printThirdViewBoard(ThirdViewBoard),
  printSudokuBoard(Result).

convertSudokuBoardToNewBoard(StandardViewBoard,ThirdViewBoard) :-
  multifor([I,J],1,9,1), param(StandardViewBoard,ThirdViewBoard)
  do
  K is I,
  L is J,
  Element is StandardViewBoard[K,L],
  (number(Element)
  ->
    Y is ThirdViewBoard[K,L,Element],
    Y #= 1
  ;
    true
  ).

convertThirdViewBoardToSudokuBoard(ThirdViewBoard,SudokuBoard) :-
  dim(SudokuBoard,[9,9]),
  SudokuBoard[1..9,1..9] :: 0..9,
  (multifor([I,J,K],1,9,1), param(ThirdViewBoard,SudokuBoard)
  do
    R is I,
    S is J,
    T is K,
    Element is ThirdViewBoard[R,S,T],
    (Element == 1
    -> 
      SudokuElement is SudokuBoard[R,S],
      SudokuElement #= T
    ;
      true
    )
  ).

checkConstraints(ThirdViewBoard) :-
  checkTotalNumbers(ThirdViewBoard),
  checkBlocks(ThirdViewBoard),
  checkRowsAndColums(ThirdViewBoard),
  checkElements(ThirdViewBoard).

checkTotalNumbers(ThirdViewBoard) :-
  ListBoard is ThirdViewBoard[1..9,1..9,1..9],
  flatten(ListBoard,List),
  occurrences(1,List,81).

checkBlocks(ThirdViewBoard) :-
  (for(I,1,9), param(ThirdViewBoard)
  do
  K is I,
    (multifor([J,Q],1,9,[3,3]),param(ThirdViewBoard,K)
    do
    L is J,
    S is Q,
    Block is ThirdViewBoard[L..L+2,S..S+2,K],
    flatten(Block,List),
    occurrences(1,List,1)
    )
  ).

checkRowsAndColums(ThirdViewBoard) :-
  (for(I,1,9), param(ThirdViewBoard)
  do
  K is I,
    (for(J,1,9), param(ThirdViewBoard,K)
    do
    L is J,
    Row is ThirdViewBoard[K,1..9,L],
    Column is ThirdViewBoard[1..9,K,L],
    flatten(Row,List1),
    flatten(Column,List2),
    occurrences(1,List1,1),
    occurrences(1,List2,1)
    )
  ).

checkElements(ThirdViewBoard) :-
  (multifor([I,J],1,9), param(ThirdViewBoard)
  do
    K is I,
    L is J,
    Elementen is ThirdViewBoard[K,L,1..9],
    flatten(Elementen,List),
    occurrences(1,List,1)
  ).

doubleListToArray([],[]).
doubleListToArray([A|As],[B|Bs]) :-
      array_list(B,A),
      doubleListToArray(As,Bs).

printThirdViewBoard(Board) :-
  writeln("begin"),
  (for(I,1,9), param(Board)
    do
    K is I,
    (for(J,1,9), param(Board,K)
    do
      L is J,
      (for(U,1,9), param(Board,K,L)
        do
        S is U,
        Element is Board[K,S,L],
        (number(Element)
          ->
          write(Element)
          ;
          write("?")
        )
      ),
      write("     ")
    ),
    writeln("  ")
  ),
  writeln("end").

printSudokuBoard(Board) :-
  writeln("begin"),
  (for(I,1,9), param(Board)
  do
  K is I,
  (for(U,1,9), param(Board,K)
    do
    S is U,
    Element is Board[K,S],
    (number(Element)
      ->
      write(Element)
      ;
      write("?")
      )
    ),
  writeln("  ")
  ),
  writeln("end").

