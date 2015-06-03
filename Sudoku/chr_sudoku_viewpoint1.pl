:- module(chr_sudoku_viewpoint1,[]).
:- use_module(library(chr)).

:- chr_option(optimize, full).

:- chr_type list(T) ---> [] ; [T | list(T)].
:- chr_type xvalue == natural.
:- chr_type yvalue == natural.
:- chr_type position ---> (xvalue,yvalue).
:- chr_type listOfPossibilities ---> [natural | list(natural)].

:- chr_constraint posElement(+position,+listOfPossibilities).
:- chr_constraint eliminatePos/0.
:- chr_constraint element(+position,+natural).
:- chr_constraint printBoard(+natural,+natural).
:- chr_constraint findSmallestDomain(+natural).

solve(SudokuBoard) :-
        makeBoardDomain(SudokuBoard,1),
        eliminatePos,
        printBoard(1,1).

makeBoardDomain([],_).
makeBoardDomain([Row|Board],RowNumber) :-
        makeRowDomain(Row,RowNumber,1),
        RowNumberNext is RowNumber + 1,
        makeBoardDomain(Board,RowNumberNext).

makeRowDomain([],_,_).
makeRowDomain([Element|RestRow],RowNumber,ColumnNumber) :-
        var(Element),
        posElement((RowNumber,ColumnNumber), [1,2,3,4,5,6,7,8,9]),
        Column2 is ColumnNumber + 1,
        makeRowDomain(RestRow,RowNumber,Column2).
makeRowDomain([],_,_).
makeRowDomain([Element|RestRow],RowNumber,ColumnNumber) :-
        nonvar(Element),
        element((RowNumber,ColumnNumber), Element),
        Column2 is ColumnNumber + 1,
        makeRowDomain(RestRow,RowNumber,Column2).

rowConstraint @ element((X,Y1),A), element((X,Y2),A) <=> Y1 == Y2.

columnConstraint @ element((X1,Y),A), element((X2,Y),A) <=> X1 == X2.

blockconstraint @ element((X1,Y1),A), element((X2,Y2),A) <=> checkBox(X1,X2,Y1,Y2) | false.

posElement((X,Y),[Value]) <=> element((X,Y),Value).

% waarden van Rijen gaan beperken
eliminatePos, element((X,Y2),AssignedValue) \ posElement((X,Y1),ListPos) <=> Y1 \= Y2, select(AssignedValue,ListPos,NListPos) | posElement((X,Y1),NListPos). 

eliminatePos, element((X1,Y),AssignedValue) \ posElement((X2,Y),ListPos) <=> X1 \= X2, select(AssignedValue,ListPos,NListPos) | posElement((X2,Y),NListPos). 

eliminatePos, element((X1,Y1),AssignedValue) \ posElement((X2,Y2),ListPos) <=> checkBox(X1,X2,Y1,Y2), select(AssignedValue,ListPos,NListPos) | posElement((X2,Y2),NListPos). 

% Kies een volgende waarde voor het PosElement met de kleinste aantal mogelijkheden.

%-------- Eerste Search
eliminatePos <=> findSmallestDomain(2). 

findSmallestDomain(DomainLength), posElement((X,Y),PosList) <=> length(PosList,LengthList), DomainLength == LengthList | member(K,PosList), element((X,Y),K), eliminatePos. 

findSmallestDomain(9) <=> true.
findSmallestDomain(DomainLength) <=> NewDomainLength is DomainLength + 1, findSmallestDomain(NewDomainLength). 

%----- Tweede search

eliminatePos <=> findSmallestDomain(9). 

findSmallestDomain(DomainLength), posElement((X,Y),PosList) <=> length(PosList,LengthList), DomainLength == LengthList | member(K,PosList), element((X,Y),K), eliminatePos. 

findSmallestDomain(1) <=> true.
findSmallestDomain(DomainLength) <=> NewDomainLength is DomainLength - 1, findSmallestDomain(NewDomainLength). 

%blockconstraint @ element((X1,Y1),A), element((X2,Y2),A) <=> checkBox(X1,X2,Y1,Y2) | false.

checkBox(X1,X2,Y1,Y2) :-
        Block1 is (3*((X1-1) // 3)) + ((Y1-1) // 3) + 1,
        Block2 is (3*((X2-1) // 3)) + ((Y2-1) // 3) + 1,
        Block1 == Block2.

printBoard(9,9), element((9,9),A) <=> writeln(A).
printBoard(K,9), element((K,9),A) <=> writeln(A), K1 is K + 1, printBoard(K1,1).
printBoard(K,L), element((K,L),A) <=> write(A), Y is L + 1, printBoard(K,Y).
