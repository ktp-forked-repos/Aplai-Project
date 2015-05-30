:- module(chr_sudoku_viewpoint1,[]).
:- use_module(library(chr)).

:- chr_type list(T) ---> [] ; [T | list(T)].
:- chr_type xvalue == natural.
:- chr_type yvalue == natural.
:- chr_type matrixvalue == natural.
:- chr_type position ---> (natural,natural).
:- chr_type listOfPossibilities ---> [natural | list(natural)].
% matrix represents the matrix of the places for the given value.

:- chr_constraint posElement(+matrixvalue,+position,+listOfPossibilities).
:- chr_constraint choiceNumber/0.
:- chr_constraint element(+matrixvalue,+position,+natural).
:- chr_constraint printBoard(+natural,+natural).

solve(SudokuBoard) :- 
        makeBoardDomain(SudokuBoard,1).
        %choiceNumber.
        %printBoard(1,1).

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
        posElement(MatrixNumber,(RowNumber,ColumnNumber), [0,1]),
        NextMatrixNumber is MatrixNumber + 1,
        makeVarElement(RowNumber,ColumnNumber,NextMatrixNumber).

%rowConstraint @ element(K,(X,Y1),1)

%columnConstraint @ element((X1,Y),A), element((X2,Y),A) <=> X1 == X2.

%blockconstraint @ element((X1,Y1),A), element((X2,Y2),A) <=> checkBox(X1,X2,Y1,Y2) | false.

%checkBox(X1,X2,Y1,Y2) :-
%        Block1 is (3*((X1-1) // 3)) + ((Y1-1) // 3) + 1,
%        Block2 is (3*((X2-1) // 3)) + ((Y2-1) // 3) + 1,
%        Block1 == Block2.

%printBoard(9,9), element((9,9),A) <=> writeln(A).
%printBoard(K,9), element((K,9),A) <=> writeln(A), K1 is K + 1, printBoard(K1,1).
%printBoard(K,L), element((K,L),A) <=> write(A), Y is L + 1, printBoard(K,Y).



