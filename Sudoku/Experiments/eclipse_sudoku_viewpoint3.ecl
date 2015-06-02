:- lib(ic).
:- lib(ic_global).

solve(SudokuBoard, ThirdViewBoard) :-
  dim(ThirdViewBoard,[9,9,9]),
  ThirdViewBoard[1..9,1..9,1..9] :: 0..1,
  doubleListToArray(SudokuBoard,TempBoard),
  array_list(StandardViewBoard, TempBoard),
  convertSudokuBoardToNewBoard(StandardViewBoard,ThirdViewBoard),
  checkConstraints(ThirdViewBoard),
  %term_variables(ThirdViewBoard, Variables),
  %labelingWithCount(Variables),
  search(ThirdViewBoard, 0, first_fail, indomain, complete, [backtrack(B)]),
  printf("Solution found after %d bachtracks%n", [B]),
  convertThirdViewBoardToSudokuBoard(ThirdViewBoard,Result),
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
  checkBlocks(ThirdViewBoard),
  checkRowsAndColums(ThirdViewBoard),
  checkElements(ThirdViewBoard).

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

labelingWithCount(AllVars) :-
    init_backtracks,
    ( foreach(Var, AllVars) do
        count_backtracks,       % insert this before choice!
        indomain(Var)
    ),
    get_backtracks(B),
    printf("Solution found after %d backtracks%n", [B]).

:- local variable(backtracks), variable(deep_fail).

init_backtracks :-
        setval(backtracks,0).

get_backtracks(B) :-
        getval(backtracks,B).

count_backtracks :-
        setval(deep_fail,false).
count_backtracks :-
        getval(deep_fail,false),        % may fail
        setval(deep_fail,true),
        incval(backtracks),
        fail.
