:- module(chr_sudoku_viewpoint3,[]).
:- use_module(library(chr)).
:- use_module(library(lists)).

:- chr_option(optimize,full).

:- chr_type list(T) ---> [] ; [T | list(T)].
:- chr_type xvalue == natural.
:- chr_type yvalue == natural.
:- chr_type matrixvalue == natural.
:- chr_type position ---> (natural,natural).
:- chr_type listOfPossibilities ---> [natural | list(natural)].
% matrix represents the matrix of the places for the given value.

:- chr_constraint posElement(+matrixvalue,+position,+listOfPossibilities).
:- chr_constraint eliminatePos/0.
:- chr_constraint checkColCount(+matrixvalue,+position,+natural).
:- chr_constraint element(+matrixvalue,+position,+natural).
:- chr_constraint printBoard(+natural,+natural,+natural).
:- chr_constraint findSmallestDomain(+natural).
:- chr_constraint matrixSom(+natural,+position, +natural).


solve(SudokuBoard) :-
        makeBoardDomain(SudokuBoard,1),
        eliminatePos,
        printBoard(1,1,1).

makeBoardDomain([],_).
makeBoardDomain([Row|Board],RowNumber) :-
        makeRowDomain(Row,RowNumber,1),
        RowNumberNext is RowNumber + 1,
        makeBoardDomain(Board,RowNumberNext).

makeRowDomain([],_,_).
makeRowDomain([Element|RestRow],RowNumber,ColumnNumber) :-
        var(Element),
        makeVarElement(RowNumber,ColumnNumber,1),
        Column2 is ColumnNumber + 1,
        makeRowDomain(RestRow,RowNumber,Column2).
makeRowDomain([],_,_).
makeRowDomain([Element|RestRow],RowNumber,ColumnNumber) :-
        nonvar(Element),
        makeNonVarElement(Element,RowNumber,ColumnNumber,1),
        Column2 is ColumnNumber + 1,
        makeRowDomain(RestRow,RowNumber,Column2).

makeNonVarElement(_,_,_,10).
makeNonVarElement(Element,RowNumber,ColumnNumber,Element) :-
        element(Element,(RowNumber,ColumnNumber), 1),
        NextMatrixCounter is Element + 1,
        makeNonVarElement(Element,RowNumber,ColumnNumber,NextMatrixCounter).
makeNonVarElement(Element,RowNumber,ColumnNumber,MatrixCounter) :-
        element(MatrixCounter,(RowNumber,ColumnNumber), 0),
        NextMatrixCounter is MatrixCounter + 1,
        makeNonVarElement(Element,RowNumber,ColumnNumber,NextMatrixCounter).

makeVarElement(_,_,10).
makeVarElement(RowNumber, ColumnNumber, MatrixNumber) :-
        posElement(MatrixNumber,(RowNumber,ColumnNumber), [1,0]),
        NextMatrixNumber is MatrixNumber + 1,
        makeVarElement(RowNumber,ColumnNumber,NextMatrixNumber).

makeMatrixValues(10).
makeMatrixValues(N) :-
        matrixSom(N,0),
        NN is N + 1,
        makeMatrixValues(NN).

checkBox(X1,X2,Y1,Y2) :-
        Block1 is (3*((X1-1) // 3)) + ((Y1-1) // 3) + 1,
        Block2 is (3*((X2-1) // 3)) + ((Y2-1) // 3) + 1,
        Block1 == Block2.

posElement(A,(X,Y),[Value]) <=> element(A,(X,Y),Value).

rowconstraint @ element(A,(X,Y1),1), element(A,(X,Y2),1) <=> Y1 == Y2.

columnConstraint @ element(A,(X1,Y),1), element(A,(X2,Y),1) <=> X1 == X2.

blockConstraint @ element(A,(X1,Y1),1), element(A,(X2,Y2),1) <=> checkBox(X1,X2,Y1,Y2) | false.

elementConstraint @ element(A,(X,Y),1), element(B,(X,Y),1) <=> A == B.
               
% zelfde matrix row
eliminatePos, element(A,(X,Y2),1) \ posElement(A,(X,Y1),ListPos) <=> Y1 \= Y2, select(1,ListPos,NListPos) | posElement(A,(X,Y1),NListPos). 

% zelfde matrix kolom
eliminatePos, element(A,(X1,Y),1) \ posElement(A,(X2,Y),ListPos) <=> X1 \= X2, select(1,ListPos,NListPos) | posElement(A,(X2,Y),NListPos).  

% zelfde matrix block
eliminatePos, element(A,(X1,Y1),1) \ posElement(A,(X2,Y2),ListPos) <=> checkBox(X1,X2,Y1,Y2), select(1,ListPos,NListPos) | posElement(A,(X2,Y2),NListPos). 

% zelfde element alle matrices
eliminatePos, element(A,(X,Y),1) \ posElement(B,(X,Y),ListPos) <=> A \= B, select(1,ListPos,NListPos) | posElement(B,(X,Y),NListPos). 

eliminatePos, posElement(A,(X,Y),PosList) <=> member(K,PosList), element(A,(X,Y),K),eliminatePos.

printBoard(9,9,9), element(9,(9,9),A) <=> writeln(A).
printBoard(9,L,9), element(9,(L,9),A) <=> writeln(A), L1 is L + 1, printBoard(1,L1,1).
printBoard(K,L,9), element(K,(L,9),A) <=> write(A + ""), K1 is K + 1, printBoard(K1,L,1).
printBoard(K,L,Y), element(K,(L,Y),A) <=> write(A), Y1 is Y + 1, printBoard(K,L,Y1).


